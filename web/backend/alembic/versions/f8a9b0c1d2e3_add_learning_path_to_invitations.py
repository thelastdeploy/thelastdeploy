"""add_learning_path_to_invitations

Revision ID: f8a9b0c1d2e3
Revises: e7f8a9b0c1d2
Create Date: 2026-11-23 20:20:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa


revision: str = 'f8a9b0c1d2e3'
down_revision: Union[str, None] = 'e7f8a9b0c1d2'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        'organization_invitations',
        sa.Column('learning_path_id', sa.Integer(), nullable=True)
    )
    op.create_foreign_key(
        'organization_invitations_learning_path_id_fkey',
        'organization_invitations',
        'learning_paths',
        ['learning_path_id'],
        ['id'],
        ondelete='SET NULL'
    )


def downgrade() -> None:
    op.drop_constraint('organization_invitations_learning_path_id_fkey', 'organization_invitations', type_='foreignkey')
    op.drop_column('organization_invitations', 'learning_path_id')
