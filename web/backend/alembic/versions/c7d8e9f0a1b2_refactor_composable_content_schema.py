"""refactor composable content schema

Revision ID: c7d8e9f0a1b2
Revises: b6c7d8e9f0a1
Create Date: 2026-11-06 11:55:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = 'c7d8e9f0a1b2'
down_revision: Union[str, None] = 'b6c7d8e9f0a1'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Drop licensing triggers and function if present
    op.execute("DROP TRIGGER IF EXISTS trg_module_sections_integrity ON module_sections;")
    op.execute("DROP TRIGGER IF EXISTS trg_section_labs_integrity ON section_labs;")
    op.execute("DROP FUNCTION IF EXISTS fn_enforce_content_licensing_integrity();")

    # 2. Add sections JSONB column to modules
    op.add_column(
        'modules',
        sa.Column('sections', postgresql.JSONB(astext_type=sa.Text()), server_default=sa.text("'[]'::jsonb"), nullable=False)
    )
    op.create_index('idx_modules_sections', 'modules', ['sections'], postgresql_using='gin')

    # 3. Add labs JSONB column to sections
    op.add_column(
        'sections',
        sa.Column('labs', postgresql.JSONB(astext_type=sa.Text()), server_default=sa.text("'[]'::jsonb"), nullable=False)
    )
    op.create_index('idx_sections_labs', 'sections', ['labs'], postgresql_using='gin')

    # 4. Backfill modules.sections from module_sections
    op.execute("""
        UPDATE modules m
        SET sections = sub.sec_list
        FROM (
            SELECT module_id, jsonb_agg(section_id ORDER BY position) AS sec_list
            FROM module_sections
            GROUP BY module_id
        ) sub
        WHERE m.id = sub.module_id;
    """)

    # Fallback backfill from sections.module_id if any module was not in module_sections
    op.execute("""
        UPDATE modules m
        SET sections = sub.sec_list
        FROM (
            SELECT module_id, jsonb_agg(id ORDER BY "order") AS sec_list
            FROM sections
            WHERE module_id IS NOT NULL
            GROUP BY module_id
        ) sub
        WHERE m.id = sub.module_id AND (m.sections = '[]'::jsonb OR m.sections IS NULL);
    """)

    # 5. Backfill sections.labs from section_labs
    op.execute("""
        UPDATE sections s
        SET labs = sub.lab_list
        FROM (
            SELECT section_id, jsonb_agg(lab_id ORDER BY position) AS lab_list
            FROM section_labs
            GROUP BY section_id
        ) sub
        WHERE s.id = sub.section_id;
    """)

    # Fallback backfill from labs.section_id if any section was not in section_labs
    op.execute("""
        UPDATE sections s
        SET labs = sub.lab_list
        FROM (
            SELECT section_id, jsonb_agg(id ORDER BY "order") AS lab_list
            FROM labs
            WHERE section_id IS NOT NULL
            GROUP BY section_id
        ) sub
        WHERE s.id = sub.section_id AND (s.labs = '[]'::jsonb OR s.labs IS NULL);
    """)

    # 6. Drop redundant junction and submission tables
    op.drop_table('module_submissions')
    op.drop_table('section_labs')
    op.drop_table('module_sections')

    # 7. Drop redundant columns and constraints from modules
    op.drop_index('idx_modules_slug', table_name='modules')
    op.drop_constraint('uq_modules_owner_slug', 'modules', type_='unique')
    op.drop_column('modules', 'slug')
    op.drop_column('modules', 'is_verified')
    op.drop_column('modules', 'total_sections')

    # 8. Drop redundant columns and constraints from sections
    op.drop_index('idx_sections_slug', table_name='sections')
    op.drop_constraint('uq_sections_owner_slug', 'sections', type_='unique')
    op.drop_constraint('sections_module_id_fkey', 'sections', type_='foreignkey')
    op.drop_index('ix_sections_module_id', table_name='sections')
    op.drop_column('sections', 'slug')
    op.drop_column('sections', 'module_id')
    op.drop_column('sections', 'order')

    # 9. Drop redundant columns and constraints from labs
    op.drop_index('idx_labs_slug', table_name='labs')
    op.drop_constraint('uq_labs_owner_slug', 'labs', type_='unique')
    op.drop_constraint('labs_module_id_fkey', 'labs', type_='foreignkey')
    op.drop_constraint('labs_section_id_fkey', 'labs', type_='foreignkey')
    op.drop_index('ix_labs_module_id', table_name='labs')
    op.drop_index('ix_labs_section_id', table_name='labs')
    op.drop_column('labs', 'slug')
    op.drop_column('labs', 'module_id')
    op.drop_column('labs', 'section_id')
    op.drop_column('labs', 'order')


def downgrade() -> None:
    # 1. Re-add dropped columns to labs
    op.add_column('labs', sa.Column('order', sa.INTEGER(), server_default=sa.text('0'), autoincrement=False, nullable=False))
    op.add_column('labs', sa.Column('section_id', sa.VARCHAR(length=100), autoincrement=False, nullable=True))
    op.add_column('labs', sa.Column('module_id', sa.VARCHAR(length=100), autoincrement=False, nullable=True))
    op.add_column('labs', sa.Column('slug', sa.VARCHAR(length=100), autoincrement=False, nullable=True))

    op.execute("UPDATE labs SET slug = id WHERE slug IS NULL;")
    op.alter_column('labs', 'slug', nullable=False)

    op.create_index('ix_labs_section_id', 'labs', ['section_id'])
    op.create_index('ix_labs_module_id', 'labs', ['module_id'])
    op.create_foreign_key('labs_section_id_fkey', 'labs', 'sections', ['section_id'], ['id'])
    op.create_foreign_key('labs_module_id_fkey', 'labs', 'modules', ['module_id'], ['id'])
    op.create_unique_constraint('uq_labs_owner_slug', 'labs', ['owner_organization_id', 'slug'])
    op.create_index('idx_labs_slug', 'labs', ['slug'])

    # 2. Re-add dropped columns to sections
    op.add_column('sections', sa.Column('order', sa.INTEGER(), autoincrement=False, nullable=True))
    op.add_column('sections', sa.Column('module_id', sa.VARCHAR(length=100), autoincrement=False, nullable=True))
    op.add_column('sections', sa.Column('slug', sa.VARCHAR(length=100), autoincrement=False, nullable=True))

    op.execute("UPDATE sections SET slug = id WHERE slug IS NULL;")
    op.alter_column('sections', 'slug', nullable=False)
    op.alter_column('sections', 'order', nullable=False)
    op.alter_column('sections', 'module_id', nullable=False)

    op.create_index('ix_sections_module_id', 'sections', ['module_id'])
    op.create_foreign_key('sections_module_id_fkey', 'sections', 'modules', ['module_id'], ['id'])
    op.create_unique_constraint('uq_sections_owner_slug', 'sections', ['owner_organization_id', 'slug'])
    op.create_index('idx_sections_slug', 'sections', ['slug'])

    # 3. Re-add dropped columns to modules
    op.add_column('modules', sa.Column('total_sections', sa.INTEGER(), server_default=sa.text('0'), autoincrement=False, nullable=False))
    op.add_column('modules', sa.Column('is_verified', sa.BOOLEAN(), server_default=sa.text('false'), autoincrement=False, nullable=False))
    op.add_column('modules', sa.Column('slug', sa.VARCHAR(length=100), autoincrement=False, nullable=True))

    op.execute("UPDATE modules SET slug = id WHERE slug IS NULL;")
    op.alter_column('modules', 'slug', nullable=False)
    op.create_unique_constraint('uq_modules_owner_slug', 'modules', ['owner_organization_id', 'slug'])
    op.create_index('idx_modules_slug', 'modules', ['slug'])

    # 4. Recreate module_sections, section_labs, module_submissions
    op.create_table(
        'module_sections',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('module_id', sa.VARCHAR(length=100), nullable=False),
        sa.Column('section_id', sa.VARCHAR(length=100), nullable=False),
        sa.Column('position', sa.INTEGER(), server_default=sa.text('0'), nullable=False),
        sa.Column('created_at', postgresql.TIMESTAMP(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['module_id'], ['modules.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['section_id'], ['sections.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('module_id', 'position', name='uq_module_section_position'),
        sa.UniqueConstraint('module_id', 'section_id', name='uq_module_section')
    )
    op.create_index('idx_module_sections_lookup', 'module_sections', ['module_id', 'position'])

    op.create_table(
        'section_labs',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('section_id', sa.VARCHAR(length=100), nullable=False),
        sa.Column('lab_id', sa.VARCHAR(length=100), nullable=False),
        sa.Column('position', sa.INTEGER(), server_default=sa.text('0'), nullable=False),
        sa.Column('created_at', postgresql.TIMESTAMP(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['lab_id'], ['labs.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['section_id'], ['sections.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('section_id', 'lab_id', name='uq_section_lab'),
        sa.UniqueConstraint('section_id', 'position', name='uq_section_lab_position')
    )
    op.create_index('idx_section_labs_lookup', 'section_labs', ['section_id', 'position'])

    op.create_table(
        'module_submissions',
        sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
        sa.Column('module_id', sa.VARCHAR(length=100), nullable=False),
        sa.Column('organization_id', sa.INTEGER(), nullable=False),
        sa.Column('submitted_by', sa.INTEGER(), nullable=False),
        sa.Column('reviewed_by', sa.INTEGER(), nullable=True),
        sa.Column('status', sa.VARCHAR(length=20), server_default=sa.text("'pending'::character varying"), nullable=False),
        sa.Column('review_notes', sa.TEXT(), nullable=True),
        sa.Column('git_commit_sha', sa.VARCHAR(length=40), nullable=True),
        sa.Column('content_snapshot', postgresql.JSONB(astext_type=sa.Text()), nullable=True),
        sa.Column('submitted_at', postgresql.TIMESTAMP(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('reviewed_at', postgresql.TIMESTAMP(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(['module_id'], ['modules.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['reviewed_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['submitted_by'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )

    # 5. Drop added indexes and columns
    op.drop_index('idx_sections_labs', table_name='sections', postgresql_using='gin')
    op.drop_column('sections', 'labs')
    op.drop_index('idx_modules_sections', table_name='modules', postgresql_using='gin')
    op.drop_column('modules', 'sections')

