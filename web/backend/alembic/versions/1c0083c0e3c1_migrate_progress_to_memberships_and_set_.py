"""migrate_progress_to_memberships_and_set_owner

Revision ID: 1c0083c0e3c1
Revises: 8ad0f26328cc
Create Date: 2026-11-06 10:10:35.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '1c0083c0e3c1'
down_revision: Union[str, None] = '8ad0f26328cc'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # -------------------------------------------------------------------------
    # 1. LAB PROGRESS: add organization_membership_id, backfill, drop legacy cols
    # -------------------------------------------------------------------------
    op.add_column('lab_progress', sa.Column('organization_membership_id', sa.Integer(), nullable=True))

    # Backfill lab_progress with the user's primary platform organization membership
    op.execute("""
        UPDATE lab_progress lp
        SET organization_membership_id = m.id
        FROM organization_memberships m
        JOIN organizations o ON o.id = m.organization_id
        WHERE lp.user_id = m.user_id AND o.is_platform = true;
    """)

    # Fallback backfill: if any user was not in platform org, pick their oldest membership
    op.execute("""
        UPDATE lab_progress lp
        SET organization_membership_id = sub.mid
        FROM (
            SELECT DISTINCT ON (user_id) user_id, id AS mid
            FROM organization_memberships
            ORDER BY user_id, joined_at ASC
        ) sub
        WHERE lp.user_id = sub.user_id AND lp.organization_membership_id IS NULL;
    """)

    # If any orphaned progress rows remain with no membership, create one in platform org
    op.execute("""
        DO $$
        DECLARE
            plat_id INTEGER;
        BEGIN
            SELECT id INTO plat_id FROM organizations WHERE is_platform = true LIMIT 1;
            IF plat_id IS NOT NULL THEN
                INSERT INTO organization_memberships (organization_id, user_id, status, total_xp, unverified_xp, joined_at)
                SELECT DISTINCT plat_id, lp.user_id, 'active', 0, 0, NOW()
                FROM lab_progress lp
                WHERE lp.organization_membership_id IS NULL
                ON CONFLICT DO NOTHING;

                UPDATE lab_progress lp
                SET organization_membership_id = m.id
                FROM organization_memberships m
                WHERE lp.user_id = m.user_id AND m.organization_id = plat_id
                  AND lp.organization_membership_id IS NULL;
            END IF;
        END $$;
    """)

    # Delete any duplicate completions before enforcing NOT NULL and UNIQUE constraint
    op.execute("""
        DELETE FROM lab_progress a USING lab_progress b
        WHERE a.id < b.id 
          AND a.organization_membership_id = b.organization_membership_id 
          AND a.lab_id = b.lab_id;
    """)

    # Set NOT NULL, create foreign key and unique constraint
    op.alter_column('lab_progress', 'organization_membership_id', nullable=False)
    op.create_index(op.f('ix_lab_progress_organization_membership_id'), 'lab_progress', ['organization_membership_id'], unique=False)
    op.create_foreign_key(
        'fk_lab_progress_org_membership',
        'lab_progress',
        'organization_memberships',
        ['organization_membership_id'],
        ['id'],
        ondelete='CASCADE'
    )
    op.drop_constraint('lab_progress_lab_id_fkey', 'lab_progress', type_='foreignkey')
    op.create_foreign_key(
        'lab_progress_lab_id_fkey',
        'lab_progress',
        'labs',
        ['lab_id'],
        ['id'],
        ondelete='CASCADE'
    )
    op.create_unique_constraint(
        'uq_lab_progress_membership_lab',
        'lab_progress',
        ['organization_membership_id', 'lab_id']
    )

    # Drop legacy columns and constraints from lab_progress
    op.drop_constraint('lab_progress_user_id_fkey', 'lab_progress', type_='foreignkey')
    op.drop_constraint('lab_progress_section_id_fkey', 'lab_progress', type_='foreignkey')
    op.drop_constraint('lab_progress_module_id_fkey', 'lab_progress', type_='foreignkey')
    op.drop_index('ix_lab_progress_user_id', table_name='lab_progress')
    op.drop_index('ix_lab_progress_section_id', table_name='lab_progress')
    op.drop_index('ix_lab_progress_module_id', table_name='lab_progress')
    op.drop_column('lab_progress', 'user_id')
    op.drop_column('lab_progress', 'section_id')
    op.drop_column('lab_progress', 'module_id')

    # -------------------------------------------------------------------------
    # 2. SECTION PROGRESS: add organization_membership_id, backfill, drop legacy cols
    # -------------------------------------------------------------------------
    op.add_column('section_progress', sa.Column('organization_membership_id', sa.Integer(), nullable=True))

    # Backfill section_progress with user's platform organization membership
    op.execute("""
        UPDATE section_progress sp
        SET organization_membership_id = m.id
        FROM organization_memberships m
        JOIN organizations o ON o.id = m.organization_id
        WHERE sp.user_id = m.user_id AND o.is_platform = true;
    """)

    # Fallback backfill
    op.execute("""
        UPDATE section_progress sp
        SET organization_membership_id = sub.mid
        FROM (
            SELECT DISTINCT ON (user_id) user_id, id AS mid
            FROM organization_memberships
            ORDER BY user_id, joined_at ASC
        ) sub
        WHERE sp.user_id = sub.user_id AND sp.organization_membership_id IS NULL;
    """)

    # Delete any duplicate completions before enforcing NOT NULL and UNIQUE constraint
    op.execute("""
        DELETE FROM section_progress a USING section_progress b
        WHERE a.id < b.id 
          AND a.organization_membership_id = b.organization_membership_id 
          AND a.section_id = b.section_id;
    """)

    # Set NOT NULL, create foreign key and unique constraint
    op.alter_column('section_progress', 'organization_membership_id', nullable=False)
    op.create_index(op.f('ix_section_progress_organization_membership_id'), 'section_progress', ['organization_membership_id'], unique=False)
    op.create_foreign_key(
        'fk_section_progress_org_membership',
        'section_progress',
        'organization_memberships',
        ['organization_membership_id'],
        ['id'],
        ondelete='CASCADE'
    )
    op.drop_constraint('section_progress_section_id_fkey', 'section_progress', type_='foreignkey')
    op.create_foreign_key(
        'section_progress_section_id_fkey',
        'section_progress',
        'sections',
        ['section_id'],
        ['id'],
        ondelete='CASCADE'
    )
    op.create_unique_constraint(
        'uq_section_progress_membership_section',
        'section_progress',
        ['organization_membership_id', 'section_id']
    )

    # Drop legacy columns and constraints from section_progress
    op.drop_constraint('section_progress_user_id_fkey', 'section_progress', type_='foreignkey')
    op.drop_constraint('section_progress_module_id_fkey', 'section_progress', type_='foreignkey')
    op.drop_index('ix_section_progress_user_id', table_name='section_progress')
    op.drop_index('ix_section_progress_module_id', table_name='section_progress')
    op.drop_column('section_progress', 'user_id')
    op.drop_column('section_progress', 'module_id')

    # -------------------------------------------------------------------------
    # 3. SET OWNER & PLATFORM ADMIN FOR USER ID 2
    # -------------------------------------------------------------------------
    op.execute("""
        DO $$
        DECLARE
            plat_id INTEGER;
            owner_role_id INTEGER;
            admin_role_id INTEGER;
            plat_admin_role_id INTEGER;
            mem_id INTEGER;
        BEGIN
            SELECT id INTO plat_id FROM organizations WHERE is_platform = true LIMIT 1;
            SELECT id INTO owner_role_id FROM roles WHERE slug = 'owner' LIMIT 1;
            SELECT id INTO admin_role_id FROM roles WHERE slug = 'admin' LIMIT 1;
            SELECT id INTO plat_admin_role_id FROM platform_roles WHERE slug = 'platform_admin' LIMIT 1;

            -- Check if user 2 exists
            IF EXISTS (SELECT 1 FROM users WHERE id = 2) AND plat_id IS NOT NULL THEN
                -- Ensure user 2 has an active membership in the platform org if not existing
                IF NOT EXISTS (SELECT 1 FROM organization_memberships WHERE organization_id = plat_id AND user_id = 2) THEN
                    INSERT INTO organization_memberships (organization_id, user_id, status, total_xp, unverified_xp, joined_at)
                    VALUES (plat_id, 2, 'active', 0, 0, NOW());
                END IF;

                SELECT id INTO mem_id FROM organization_memberships WHERE organization_id = plat_id AND user_id = 2;

                -- Assign owner and admin roles to user 2 in TLD platform org
                IF mem_id IS NOT NULL THEN
                    IF owner_role_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM membership_roles WHERE membership_id = mem_id AND role_id = owner_role_id) THEN
                        INSERT INTO membership_roles (membership_id, role_id) VALUES (mem_id, owner_role_id);
                    END IF;
                    IF admin_role_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM membership_roles WHERE membership_id = mem_id AND role_id = admin_role_id) THEN
                        INSERT INTO membership_roles (membership_id, role_id) VALUES (mem_id, admin_role_id);
                    END IF;
                END IF;

                -- Assign platform_admin to user 2
                IF plat_admin_role_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM platform_user_roles WHERE user_id = 2 AND platform_role_id = plat_admin_role_id) THEN
                    INSERT INTO platform_user_roles (user_id, platform_role_id) VALUES (2, plat_admin_role_id);
                END IF;

                -- Set is_maintainer for backwards compatibility
                UPDATE users SET is_maintainer = true WHERE id = 2;
            END IF;
        END $$;
    """)


def downgrade() -> None:
    # Downgrade omitted for irreversibly dropped redundant denormalized columns
    pass
