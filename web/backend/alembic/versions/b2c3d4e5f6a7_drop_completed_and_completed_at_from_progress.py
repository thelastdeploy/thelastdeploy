"""drop completed and completed_at from progress tables

Revision ID: b2c3d4e5f6a7
Revises: f1a2b3c4d5e6
Create Date: 2026-11-05 15:45:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'b2c3d4e5f6a7'
down_revision: Union[str, None] = 'f1a2b3c4d5e6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_column('lab_progress', 'completed')
    op.drop_column('lab_progress', 'completed_at')
    op.drop_column('section_progress', 'completed')
    op.drop_column('section_progress', 'completed_at')


def downgrade() -> None:
    op.add_column('section_progress', sa.Column('completed_at', sa.DateTime(timezone=True), nullable=True))
    op.add_column('section_progress', sa.Column('completed', sa.Boolean(), server_default=sa.text('false'), nullable=False))
    op.add_column('lab_progress', sa.Column('completed_at', sa.DateTime(timezone=True), nullable=True))
    op.add_column('lab_progress', sa.Column('completed', sa.Boolean(), server_default=sa.text('false'), nullable=False))

