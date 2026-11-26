"""Replace membership_roles table with organization_memberships.role_id (single role per member).

Revision ID: b2c3d4e5f6a8
Revises: a1b2c3d4e5f7
Create Date: 2026-11-26 16:31:00.000000
"""

from alembic import op
import sqlalchemy as sa

revision = "b2c3d4e5f6a8"
down_revision = "a1b2c3d4e5f7"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "organization_memberships",
        sa.Column("role_id", sa.Integer(), sa.ForeignKey("roles.id", ondelete="RESTRICT"), nullable=True),
    )

    # Backfill role_id from membership_roles (prefer highest-privilege role if multiple existed)
    op.execute(
        """
        UPDATE organization_memberships om
        SET role_id = sub.role_id
        FROM (
            SELECT DISTINCT ON (mr.membership_id)
                mr.membership_id,
                mr.role_id
            FROM membership_roles mr
            JOIN roles r ON r.id = mr.role_id
            ORDER BY mr.membership_id,
                CASE r.slug
                    WHEN 'owner' THEN 1
                    WHEN 'admin' THEN 2
                    WHEN 'instructor' THEN 3
                    WHEN 'learner' THEN 4
                    ELSE 5
                END,
                mr.id ASC
        ) sub
        WHERE om.id = sub.membership_id
        """
    )

    # Fallback for any membership without a membership_roles row: assign org's lowest-privilege role
    op.execute(
        """
        UPDATE organization_memberships om
        SET role_id = (
            SELECT r.id
            FROM roles r
            WHERE r.organization_id = om.organization_id
            ORDER BY
                CASE r.slug
                    WHEN 'learner' THEN 1
                    WHEN 'instructor' THEN 2
                    WHEN 'admin' THEN 3
                    WHEN 'owner' THEN 4
                    ELSE 5
                END,
                r.id ASC
            LIMIT 1
        )
        WHERE om.role_id IS NULL
        """
    )

    op.alter_column("organization_memberships", "role_id", nullable=False)
    op.create_index("idx_org_memberships_role_id", "organization_memberships", ["role_id"])
    op.execute("DROP TABLE IF EXISTS membership_roles CASCADE")


def downgrade() -> None:
    raise NotImplementedError("Downgrade is not supported for b2c3d4e5f6a8.")

