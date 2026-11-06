"""module c composable content

Revision ID: e3c4d5e6f7a8
Revises: d2b3c4d5e6f7
Create Date: 2026-11-05 20:53:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = 'e3c4d5e6f7a8'
down_revision: Union[str, None] = 'd2b3c4d5e6f7'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Alter modules table
    op.add_column('modules', sa.Column('owner_organization_id', sa.Integer(), nullable=True))
    op.add_column('modules', sa.Column('slug', sa.String(length=100), nullable=True))
    op.add_column('modules', sa.Column('updated_by', sa.Integer(), nullable=True))
    op.add_column('modules', sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False))
    op.add_column('modules', sa.Column('is_verified', sa.Boolean(), server_default=sa.text('false'), nullable=False))

    # Backfill owner_organization_id with platform org and slug with id
    op.execute("""
        UPDATE modules SET 
            owner_organization_id = (SELECT id FROM organizations WHERE is_platform = true LIMIT 1),
            slug = id,
            is_verified = CASE WHEN status = 'verified' THEN true ELSE false END;
    """)
    op.alter_column('modules', 'owner_organization_id', nullable=False)
    op.alter_column('modules', 'slug', nullable=False)
    op.create_foreign_key('fk_modules_owner_organization', 'modules', 'organizations', ['owner_organization_id'], ['id'], ondelete='CASCADE')
    op.create_foreign_key('fk_modules_updated_by', 'modules', 'users', ['updated_by'], ['id'], ondelete='SET NULL')
    op.create_unique_constraint('uq_modules_owner_slug', 'modules', ['owner_organization_id', 'slug'])
    op.create_index('idx_modules_slug', 'modules', ['slug'])
    op.create_index('idx_modules_owner', 'modules', ['owner_organization_id'])

    # 2. Alter sections table
    op.add_column('sections', sa.Column('owner_organization_id', sa.Integer(), nullable=True))
    op.add_column('sections', sa.Column('slug', sa.String(length=100), nullable=True))
    op.add_column('sections', sa.Column('created_by', sa.Integer(), nullable=True))
    op.add_column('sections', sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False))

    op.execute("""
        UPDATE sections SET 
            owner_organization_id = (SELECT id FROM organizations WHERE is_platform = true LIMIT 1),
            slug = id;
    """)
    op.alter_column('sections', 'owner_organization_id', nullable=False)
    op.alter_column('sections', 'slug', nullable=False)
    op.create_foreign_key('fk_sections_owner_organization', 'sections', 'organizations', ['owner_organization_id'], ['id'], ondelete='CASCADE')
    op.create_foreign_key('fk_sections_created_by', 'sections', 'users', ['created_by'], ['id'], ondelete='SET NULL')
    op.create_unique_constraint('uq_sections_owner_slug', 'sections', ['owner_organization_id', 'slug'])
    op.create_index('idx_sections_slug', 'sections', ['slug'])
    op.create_index('idx_sections_owner', 'sections', ['owner_organization_id'])

    # 3. Alter labs table
    op.add_column('labs', sa.Column('owner_organization_id', sa.Integer(), nullable=True))
    op.add_column('labs', sa.Column('slug', sa.String(length=100), nullable=True))
    op.add_column('labs', sa.Column('created_by', sa.Integer(), nullable=True))
    op.add_column('labs', sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False))

    op.execute("""
        UPDATE labs SET 
            owner_organization_id = (SELECT id FROM organizations WHERE is_platform = true LIMIT 1),
            slug = id;
    """)
    op.alter_column('labs', 'owner_organization_id', nullable=False)
    op.alter_column('labs', 'slug', nullable=False)
    op.create_foreign_key('fk_labs_owner_organization', 'labs', 'organizations', ['owner_organization_id'], ['id'], ondelete='CASCADE')
    op.create_foreign_key('fk_labs_created_by', 'labs', 'users', ['created_by'], ['id'], ondelete='SET NULL')
    op.create_unique_constraint('uq_labs_owner_slug', 'labs', ['owner_organization_id', 'slug'])
    op.create_index('idx_labs_slug', 'labs', ['slug'])
    op.create_index('idx_labs_owner', 'labs', ['owner_organization_id'])

    # 4. Create module_sections table
    op.create_table(
        'module_sections',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('module_id', sa.String(length=100), nullable=False),
        sa.Column('section_id', sa.String(length=100), nullable=False),
        sa.Column('position', sa.Integer(), server_default=sa.text('0'), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['module_id'], ['modules.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['section_id'], ['sections.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('module_id', 'section_id', name='uq_module_section'),
        sa.UniqueConstraint('module_id', 'position', name='uq_module_section_position')
    )
    op.create_index('idx_module_sections_lookup', 'module_sections', ['module_id', 'position'])

    # Backfill module_sections from existing sections.module_id and sections.order
    op.execute("""
        INSERT INTO module_sections (module_id, section_id, position)
        SELECT module_id, id, "order"
        FROM sections
        WHERE module_id IS NOT NULL
        ON CONFLICT DO NOTHING;
    """)

    # 5. Create section_labs table
    op.create_table(
        'section_labs',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('section_id', sa.String(length=100), nullable=False),
        sa.Column('lab_id', sa.String(length=100), nullable=False),
        sa.Column('position', sa.Integer(), server_default=sa.text('0'), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['lab_id'], ['labs.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['section_id'], ['sections.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('section_id', 'lab_id', name='uq_section_lab'),
        sa.UniqueConstraint('section_id', 'position', name='uq_section_lab_position')
    )
    op.create_index('idx_section_labs_lookup', 'section_labs', ['section_id', 'position'])

    # Backfill section_labs from existing labs.section_id and labs.order
    op.execute("""
        INSERT INTO section_labs (section_id, lab_id, position)
        SELECT section_id, id, "order"
        FROM labs
        WHERE section_id IS NOT NULL
        ON CONFLICT DO NOTHING;
    """)

    # 6. Create module_submissions table
    op.create_table(
        'module_submissions',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('module_id', sa.String(length=100), nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('submitted_by', sa.Integer(), nullable=False),
        sa.Column('reviewed_by', sa.Integer(), nullable=True),
        sa.Column('status', sa.String(length=20), server_default='pending', nullable=False),
        sa.Column('review_notes', sa.Text(), nullable=True),
        sa.Column('git_commit_sha', sa.String(length=40), nullable=True),
        sa.Column('content_snapshot', postgresql.JSONB(astext_type=sa.Text()), nullable=True),
        sa.Column('submitted_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('reviewed_at', sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(['module_id'], ['modules.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['reviewed_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['submitted_by'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(
        'uq_module_single_pending_sub',
        'module_submissions',
        ['module_id'],
        unique=True,
        postgresql_where=sa.text("status = 'pending'")
    )
    op.create_index('idx_module_submissions_org', 'module_submissions', ['organization_id', sa.text('submitted_at DESC')])
    op.create_index('idx_module_submissions_module', 'module_submissions', ['module_id', sa.text('submitted_at DESC')])

    # 7. PostgreSQL Tenant Isolation Trigger Function
    op.execute("""
        CREATE OR REPLACE FUNCTION check_content_reference_integrity() 
        RETURNS TRIGGER AS $$
        DECLARE
            parent_org_id INTEGER;
            child_org_id INTEGER;
            platform_org_id INTEGER;
        BEGIN
            SELECT id INTO platform_org_id FROM organizations WHERE is_platform = TRUE LIMIT 1;
            
            IF TG_TABLE_NAME = 'module_sections' THEN
                SELECT owner_organization_id INTO parent_org_id FROM modules WHERE id = NEW.module_id;
                SELECT owner_organization_id INTO child_org_id FROM sections WHERE id = NEW.section_id;
            ELSIF TG_TABLE_NAME = 'section_labs' THEN
                SELECT owner_organization_id INTO parent_org_id FROM sections WHERE id = NEW.section_id;
                SELECT owner_organization_id INTO child_org_id FROM labs WHERE id = NEW.lab_id;
            END IF;
            
            IF child_org_id != parent_org_id AND child_org_id != platform_org_id THEN
                RAISE EXCEPTION 'Tenant Isolation Violation: Content cannot reference private entities from another organization';
            END IF;
            
            RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;
    """)

    op.execute("""
        CREATE TRIGGER trg_module_sections_integrity
        BEFORE INSERT OR UPDATE ON module_sections
        FOR EACH ROW EXECUTE FUNCTION check_content_reference_integrity();
    """)

    op.execute("""
        CREATE TRIGGER trg_section_labs_integrity
        BEFORE INSERT OR UPDATE ON section_labs
        FOR EACH ROW EXECUTE FUNCTION check_content_reference_integrity();
    """)


def downgrade() -> None:
    # 1. Drop triggers and function
    op.execute("DROP TRIGGER IF EXISTS trg_section_labs_integrity ON section_labs;")
    op.execute("DROP TRIGGER IF EXISTS trg_module_sections_integrity ON module_sections;")
    op.execute("DROP FUNCTION IF EXISTS check_content_reference_integrity();")

    # 2. Drop module_submissions
    op.drop_table('module_submissions')

    # 3. Drop composable relationship tables
    op.drop_table('section_labs')
    op.drop_table('module_sections')

    # 4. Revert labs
    op.drop_index('idx_labs_owner', table_name='labs')
    op.drop_index('idx_labs_slug', table_name='labs')
    op.drop_constraint('uq_labs_owner_slug', 'labs', type_='unique')
    op.drop_constraint('fk_labs_created_by', 'labs', type_='foreignkey')
    op.drop_constraint('fk_labs_owner_organization', 'labs', type_='foreignkey')
    op.drop_column('labs', 'updated_at')
    op.drop_column('labs', 'created_by')
    op.drop_column('labs', 'slug')
    op.drop_column('labs', 'owner_organization_id')

    # 5. Revert sections
    op.drop_index('idx_sections_owner', table_name='sections')
    op.drop_index('idx_sections_slug', table_name='sections')
    op.drop_constraint('uq_sections_owner_slug', 'sections', type_='unique')
    op.drop_constraint('fk_sections_created_by', 'sections', type_='foreignkey')
    op.drop_constraint('fk_sections_owner_organization', 'sections', type_='foreignkey')
    op.drop_column('sections', 'updated_at')
    op.drop_column('sections', 'created_by')
    op.drop_column('sections', 'slug')
    op.drop_column('sections', 'owner_organization_id')

    # 6. Revert modules
    op.drop_index('idx_modules_owner', table_name='modules')
    op.drop_index('idx_modules_slug', table_name='modules')
    op.drop_constraint('uq_modules_owner_slug', 'modules', type_='unique')
    op.drop_constraint('fk_modules_updated_by', 'modules', type_='foreignkey')
    op.drop_constraint('fk_modules_owner_organization', 'modules', type_='foreignkey')
    op.drop_column('modules', 'is_verified')
    op.drop_column('modules', 'updated_at')
    op.drop_column('modules', 'updated_by')
    op.drop_column('modules', 'slug')
    op.drop_column('modules', 'owner_organization_id')

