"""module c content hashes

Revision ID: e7f8a9b0c1d2
Revises: 38ce8be5bed8
Create Date: 2026-11-23 17:30:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e7f8a9b0c1d2'
down_revision: Union[str, None] = '38ce8be5bed8'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add content_hash column to modules, sections, and labs
    op.add_column('modules', sa.Column('content_hash', sa.String(length=64), nullable=True))
    op.add_column('sections', sa.Column('content_hash', sa.String(length=64), nullable=True))
    op.add_column('labs', sa.Column('content_hash', sa.String(length=64), nullable=True))


def downgrade() -> None:
    op.drop_column('labs', 'content_hash')
    op.drop_column('sections', 'content_hash')
    op.drop_column('modules', 'content_hash')

