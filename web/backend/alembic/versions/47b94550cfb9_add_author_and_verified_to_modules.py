"""add_author_and_verified_to_modules

Revision ID: 47b94550cfb9
Revises: d8c9fe39fcc5
Create Date: 2026-06-28 18:29:26.201992

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '47b94550cfb9'
down_revision: Union[str, None] = 'd8c9fe39fcc5'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # author_id: nullable FK to users(id) — NULL means official module
    op.add_column(
        "modules",
        sa.Column("author_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="SET NULL"), nullable=True),
    )
    # is_official_verified: boolean, default false
    op.add_column(
        "modules",
        sa.Column("is_official_verified", sa.Boolean(), nullable=False, server_default=sa.text("false")),
    )


def downgrade() -> None:
    op.drop_column("modules", "is_official_verified")
    op.drop_column("modules", "author_id")
