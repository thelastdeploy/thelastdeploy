# web/backend/alembic/versions/006_section_progress.py
"""
006_section_progress: add section_progress table.
Tracks reading + future question completion per section.
lab_progress stays for lab (tld check) completions only.

Revision ID: 006
Revises: 005
"""

from alembic import op
import sqlalchemy as sa

revision = "006"
down_revision = "005"
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "section_progress",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("user_id", sa.Integer, sa.ForeignKey("users.id"), nullable=False),
        sa.Column("module_id", sa.String(100), sa.ForeignKey("modules.id"), nullable=False),
        sa.Column("section_id", sa.String(100), sa.ForeignKey("sections.id"), nullable=False),
        sa.Column("completed", sa.Boolean, nullable=False, server_default="false"),
        sa.Column("xp_awarded", sa.Integer, nullable=False, server_default="0"),
        sa.Column("completed_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.text("now()")),
    )
    op.create_index(
        "ix_section_progress_user_section",
        "section_progress",
        ["user_id", "section_id"],
        unique=True,
    )


def downgrade():
    op.drop_index("ix_section_progress_user_section", "section_progress")
    op.drop_table("section_progress")