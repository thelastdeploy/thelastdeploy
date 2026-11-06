"""add_organization_settings_and_availability

Revision ID: 8ad0f26328cc
Revises: 2b2a957123de
Create Date: 2026-11-06 09:00:50.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = '8ad0f26328cc'
down_revision: Union[str, None] = '2b2a957123de'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. organization_setting_availability
    op.create_table(
        'organization_setting_availability',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('setting_key', sa.String(length=100), nullable=False),
        sa.Column('is_enabled', sa.Boolean(), server_default='true', nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('organization_id', 'setting_key', name='uq_org_setting_avail')
    )
    op.create_index('idx_org_setting_avail_org', 'organization_setting_availability', ['organization_id'], unique=False)

    # 2. organization_settings
    op.create_table(
        'organization_settings',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('setting_key', sa.String(length=100), nullable=False),
        sa.Column('value', postgresql.JSONB(astext_type=sa.Text()), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('organization_id', 'setting_key', name='uq_org_settings')
    )
    op.create_index('idx_org_settings_org', 'organization_settings', ['organization_id'], unique=False)


def downgrade() -> None:
    op.drop_index('idx_org_settings_org', table_name='organization_settings')
    op.drop_table('organization_settings')
    op.drop_index('idx_org_setting_avail_org', table_name='organization_setting_availability')
    op.drop_table('organization_setting_availability')
