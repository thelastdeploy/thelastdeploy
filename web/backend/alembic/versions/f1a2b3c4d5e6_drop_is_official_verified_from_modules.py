"""drop_is_official_verified_from_modules

Revision ID: f1a2b3c4d5e6
Revises: e4f1a2b3c4d5
Create Date: 2026-11-03 18:45:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'f1a2b3c4d5e6'
down_revision: Union[str, None] = 'e4f1a2b3c4d5'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_column('modules', 'is_official_verified')


def downgrade() -> None:
    op.add_column('modules', sa.Column('is_official_verified', sa.Boolean(), server_default=sa.text('false'), nullable=False))
