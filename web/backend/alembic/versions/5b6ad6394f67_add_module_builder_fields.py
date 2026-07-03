"""add_module_builder_fields

Revision ID: 5b6ad6394f67
Revises: 47b94550cfb9
Create Date: 2026-07-03 18:26:05.830258

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '5b6ad6394f67'
down_revision: Union[str, None] = '47b94550cfb9'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add status column to modules table, defaulting to 'verified' for existing ones
    op.add_column('modules', sa.Column('status', sa.String(length=20), server_default='verified', nullable=False))
    # Alter the server default of status column to 'draft' for future modules
    op.alter_column('modules', 'status', server_default='draft')
    # Add submitted_at to modules
    op.add_column('modules', sa.Column('submitted_at', sa.DateTime(timezone=True), nullable=True))
    # Add unverified_xp to users
    op.add_column('users', sa.Column('unverified_xp', sa.Integer(), server_default='0', nullable=False))
    # Add validator_script to labs
    op.add_column('labs', sa.Column('validator_script', sa.Text(), nullable=True))


def downgrade() -> None:
    op.drop_column('labs', 'validator_script')
    op.drop_column('users', 'unverified_xp')
    op.drop_column('modules', 'submitted_at')
    op.drop_column('modules', 'status')

