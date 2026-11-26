"""Drop obsolete is_system column from roles table.

Revision ID: a1b2c3d4e5f7
Revises: 9c2d3e4f5a60
Create Date: 2026-11-26 16:19:00.000000
"""

from alembic import op
import sqlalchemy as sa

revision = "a1b2c3d4e5f7"
down_revision = "9c2d3e4f5a60"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.drop_column("roles", "is_system")


def downgrade() -> None:
    op.add_column(
        "roles",
        sa.Column("is_system", sa.Boolean(), server_default=sa.text("true"), nullable=False),
    )

