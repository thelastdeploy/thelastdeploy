"""drop organizations is_platform column and update unique index on type

Revision ID: 75d6fd68120c
Revises: 40828213d71d
Create Date: 2026-11-06 11:18:40.477628

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '75d6fd68120c'
down_revision: Union[str, None] = '40828213d71d'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Ensure any organization that was is_platform = true has type = 'platform'
    op.execute("UPDATE organizations SET type = 'platform' WHERE is_platform = true")

    # 2. Drop the old unique index on is_platform
    op.drop_index('uq_single_platform_org', table_name='organizations')

    # 3. Create the new unique partial index on type = 'platform'
    op.create_index(
        'uq_single_platform_org',
        'organizations',
        ['type'],
        unique=True,
        postgresql_where=sa.text("type = 'platform'")
    )

    # 4. Drop the redundant is_platform column
    op.drop_column('organizations', 'is_platform')


def downgrade() -> None:
    # 1. Re-add is_platform column
    op.add_column('organizations', sa.Column('is_platform', sa.Boolean(), server_default=sa.text('false'), nullable=False))

    # 2. Backfill is_platform from type = 'platform'
    op.execute("UPDATE organizations SET is_platform = true WHERE type = 'platform'")

    # 3. Drop the type-based index
    op.drop_index('uq_single_platform_org', table_name='organizations')

    # 4. Re-create the is_platform-based unique index
    op.create_index(
        'uq_single_platform_org',
        'organizations',
        ['is_platform'],
        unique=True,
        postgresql_where=sa.text('is_platform = true')
    )
