"""add_cleanup_script_to_labs

Revision ID: a1b2c3d4e5f6
Revises: 0d8d015dff70
Create Date: 2026-07-18 08:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'a1b2c3d4e5f6'
down_revision: Union[str, None] = '5b6ad6394f67'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add cleanup_script column to labs table
    op.add_column('labs', sa.Column('cleanup_script', sa.Text(), nullable=True))


def downgrade() -> None:
    op.drop_column('labs', 'cleanup_script')
