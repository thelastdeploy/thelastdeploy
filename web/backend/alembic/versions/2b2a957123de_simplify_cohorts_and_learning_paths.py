"""simplify_cohorts_and_learning_paths

Revision ID: 2b2a957123de
Revises: c7d8e9f0a1b2
Create Date: 2026-11-06 08:14:02.535653

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = '2b2a957123de'
down_revision: Union[str, None] = 'c7d8e9f0a1b2'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Drop redundant mapping and assignment tables
    op.drop_table('learning_path_assignments')
    op.drop_table('learning_path_cohorts')
    op.drop_table('learning_path_modules')

    # 2. Add JSONB array columns to learning_paths and cohorts
    op.add_column(
        'learning_paths',
        sa.Column('modules', postgresql.JSONB(astext_type=sa.Text()), server_default='[]', nullable=False)
    )
    op.create_index(
        'idx_learning_paths_modules',
        'learning_paths',
        ['modules'],
        unique=False,
        postgresql_using='gin'
    )

    op.add_column(
        'cohorts',
        sa.Column('learning_paths', postgresql.JSONB(astext_type=sa.Text()), server_default='[]', nullable=False)
    )
    op.create_index(
        'idx_cohorts_learning_paths',
        'cohorts',
        ['learning_paths'],
        unique=False,
        postgresql_using='gin'
    )


def downgrade() -> None:
    op.drop_index('idx_cohorts_learning_paths', table_name='cohorts', postgresql_using='gin')
    op.drop_column('cohorts', 'learning_paths')

    op.drop_index('idx_learning_paths_modules', table_name='learning_paths', postgresql_using='gin')
    op.drop_column('learning_paths', 'modules')

    op.create_table(
        'learning_path_modules',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('learning_path_id', sa.Integer(), nullable=False),
        sa.Column('module_id', sa.String(length=100), nullable=False),
        sa.Column('order', sa.Integer(), server_default='0', nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['learning_path_id'], ['learning_paths.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['module_id'], ['modules.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('learning_path_id', 'module_id', name='uq_lp_module'),
        sa.UniqueConstraint('learning_path_id', 'order', name='uq_lp_module_order')
    )

    op.create_table(
        'learning_path_cohorts',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('learning_path_id', sa.Integer(), nullable=False),
        sa.Column('cohort_id', sa.Integer(), nullable=False),
        sa.Column('assigned_by', sa.Integer(), nullable=True),
        sa.Column('assigned_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['assigned_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['cohort_id', 'organization_id'], ['cohorts.id', 'cohorts.organization_id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['learning_path_id', 'organization_id'], ['learning_paths.id', 'learning_paths.organization_id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('learning_path_id', 'cohort_id', name='uq_lp_cohorts')
    )

    op.create_table(
        'learning_path_assignments',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('learning_path_id', sa.Integer(), nullable=False),
        sa.Column('organization_membership_id', sa.Integer(), nullable=False),
        sa.Column('assigned_by', sa.Integer(), nullable=True),
        sa.Column('assigned_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('expires_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('revoked_at', sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(['assigned_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['learning_path_id', 'organization_id'], ['learning_paths.id', 'learning_paths.organization_id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['organization_membership_id', 'organization_id'], ['organization_memberships.id', 'organization_memberships.organization_id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('learning_path_id', 'organization_membership_id', name='uq_lp_assignments')
    )
