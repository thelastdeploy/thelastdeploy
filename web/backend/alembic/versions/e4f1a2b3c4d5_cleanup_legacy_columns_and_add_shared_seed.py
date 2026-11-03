"""cleanup_legacy_columns_and_add_shared_seed

Revision ID: e4f1a2b3c4d5
Revises: a86aa63eb011
Create Date: 2026-11-03 17:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e4f1a2b3c4d5'
down_revision: Union[str, None] = 'a86aa63eb011'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Clean users table
    op.drop_column('users', 'streak_days')
    op.drop_column('users', 'last_active')

    # 2. Clean modules table and add shared_seed
    op.drop_column('modules', 'tags')
    op.drop_column('modules', 'yaml_content')
    op.add_column('modules', sa.Column('shared_seed', sa.JSON(), nullable=True))

    # 3. Clean labs table and add environment_profile
    op.drop_column('labs', 'setup_type')
    op.drop_column('labs', 'cleanup_script')
    op.drop_column('labs', 'resource_limits_cpu')
    op.drop_column('labs', 'resource_limits_mem')
    op.drop_column('labs', 'yaml_content')
    op.add_column('labs', sa.Column('environment_profile', sa.String(length=50), nullable=False, server_default='tld-ubuntu'))


def downgrade() -> None:
    # 3. Restore labs columns
    op.drop_column('labs', 'environment_profile')
    op.add_column('labs', sa.Column('yaml_content', sa.Text(), nullable=True))
    op.add_column('labs', sa.Column('resource_limits_mem', sa.Integer(), nullable=True))
    op.add_column('labs', sa.Column('resource_limits_cpu', sa.Integer(), nullable=True))
    op.add_column('labs', sa.Column('cleanup_script', sa.Text(), nullable=True))
    op.add_column('labs', sa.Column('setup_type', sa.String(length=50), nullable=True))

    # 2. Restore modules columns
    op.drop_column('modules', 'shared_seed')
    op.add_column('modules', sa.Column('yaml_content', sa.Text(), nullable=False, server_default=''))
    op.add_column('modules', sa.Column('tags', sa.Text(), nullable=True))

    # 1. Restore users columns
    op.add_column('users', sa.Column('last_active', sa.DateTime(timezone=True), nullable=True))
    op.add_column('users', sa.Column('streak_days', sa.Integer(), server_default='0', nullable=False))

