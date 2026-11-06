"""drop_users_is_maintainer_and_assign_platform_roles

Revision ID: 40828213d71d
Revises: 1c0083c0e3c1
Create Date: 2026-11-06 10:37:13.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '40828213d71d'
down_revision: Union[str, None] = '1c0083c0e3c1'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Backfill platform roles:
    #    - user 2 -> Owner (membership_roles) & Platform Admin (platform_user_roles)
    #    - user 7 -> Curriculum Lead (platform_user_roles) & Instructor (membership_roles)
    #    - All users who had is_maintainer = true -> Platform Admin (if not already assigned)
    op.execute("""
        DO $$
        DECLARE
            plat_id INTEGER;
            owner_role_id INTEGER;
            admin_role_id INTEGER;
            instructor_role_id INTEGER;
            plat_admin_role_id INTEGER;
            curriculum_lead_role_id INTEGER;
            mem_id_2 INTEGER;
            mem_id_7 INTEGER;
        BEGIN
            SELECT id INTO plat_id FROM organizations WHERE is_platform = true LIMIT 1;
            SELECT id INTO owner_role_id FROM roles WHERE slug = 'owner' LIMIT 1;
            SELECT id INTO admin_role_id FROM roles WHERE slug = 'admin' LIMIT 1;
            SELECT id INTO instructor_role_id FROM roles WHERE slug = 'instructor' LIMIT 1;
            SELECT id INTO plat_admin_role_id FROM platform_roles WHERE slug = 'platform_admin' LIMIT 1;
            SELECT id INTO curriculum_lead_role_id FROM platform_roles WHERE slug = 'curriculum_lead' LIMIT 1;

            -- Migrate anyone who had is_maintainer = true into platform_admin
            IF plat_admin_role_id IS NOT NULL THEN
                INSERT INTO platform_user_roles (user_id, platform_role_id, assigned_at)
                SELECT u.id, plat_admin_role_id, NOW()
                FROM users u
                WHERE u.is_maintainer = true
                ON CONFLICT (user_id, platform_role_id) DO NOTHING;
            END IF;

            -- Explicit assignment for User 2 (Owner & Platform Admin)
            IF EXISTS (SELECT 1 FROM users WHERE id = 2) AND plat_id IS NOT NULL THEN
                IF NOT EXISTS (SELECT 1 FROM organization_memberships WHERE organization_id = plat_id AND user_id = 2) THEN
                    INSERT INTO organization_memberships (organization_id, user_id, status, total_xp, unverified_xp, joined_at)
                    VALUES (plat_id, 2, 'active', 0, 0, NOW());
                END IF;

                SELECT id INTO mem_id_2 FROM organization_memberships WHERE organization_id = plat_id AND user_id = 2;

                IF mem_id_2 IS NOT NULL THEN
                    IF owner_role_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM membership_roles WHERE membership_id = mem_id_2 AND role_id = owner_role_id) THEN
                        INSERT INTO membership_roles (membership_id, role_id) VALUES (mem_id_2, owner_role_id);
                    END IF;
                    IF admin_role_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM membership_roles WHERE membership_id = mem_id_2 AND role_id = admin_role_id) THEN
                        INSERT INTO membership_roles (membership_id, role_id) VALUES (mem_id_2, admin_role_id);
                    END IF;
                END IF;

                IF plat_admin_role_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM platform_user_roles WHERE user_id = 2 AND platform_role_id = plat_admin_role_id) THEN
                    INSERT INTO platform_user_roles (user_id, platform_role_id, assigned_at) VALUES (2, plat_admin_role_id, NOW());
                END IF;
            END IF;

            -- Explicit assignment for User 7 (Curriculum Lead / Lower Staff position & Instructor)
            IF EXISTS (SELECT 1 FROM users WHERE id = 7) AND plat_id IS NOT NULL THEN
                IF NOT EXISTS (SELECT 1 FROM organization_memberships WHERE organization_id = plat_id AND user_id = 7) THEN
                    INSERT INTO organization_memberships (organization_id, user_id, status, total_xp, unverified_xp, joined_at)
                    VALUES (plat_id, 7, 'active', 0, 0, NOW());
                END IF;

                SELECT id INTO mem_id_7 FROM organization_memberships WHERE organization_id = plat_id AND user_id = 7;

                IF mem_id_7 IS NOT NULL THEN
                    IF instructor_role_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM membership_roles WHERE membership_id = mem_id_7 AND role_id = instructor_role_id) THEN
                        INSERT INTO membership_roles (membership_id, role_id) VALUES (mem_id_7, instructor_role_id);
                    END IF;
                END IF;

                IF curriculum_lead_role_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM platform_user_roles WHERE user_id = 7 AND platform_role_id = curriculum_lead_role_id) THEN
                    INSERT INTO platform_user_roles (user_id, platform_role_id, assigned_at) VALUES (7, curriculum_lead_role_id, NOW());
                END IF;
            END IF;
        END $$;
    """)

    # 2. Drop legacy is_maintainer column from users table
    op.drop_column('users', 'is_maintainer')


def downgrade() -> None:
    op.add_column('users', sa.Column('is_maintainer', sa.Boolean(), server_default='false', nullable=False))
    op.execute("""
        UPDATE users u
        SET is_maintainer = true
        WHERE EXISTS (
            SELECT 1 FROM platform_user_roles pur WHERE pur.user_id = u.id
        );
    """)
