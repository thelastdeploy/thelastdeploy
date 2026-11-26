"""Merge organization_setting_availability into organization_settings, drop organization_role_availability, and scope roles to organization_id.

Revision ID: 8b1c2d3e4f50
Revises: 7a9e3b4c1d20
Create Date: 2026-11-26 12:12:00.000000
"""

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "8b1c2d3e4f50"
down_revision = "7a9e3b4c1d20"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ── 1. Merge organization_setting_availability into organization_settings ──
    op.add_column(
        "organization_settings",
        sa.Column("is_enabled", sa.Boolean(), server_default=sa.text("false"), nullable=False),
    )
    op.alter_column("organization_settings", "value", nullable=True)

    # Update existing organization_settings rows with is_enabled from availability
    op.execute(
        """
        UPDATE organization_settings os
        SET is_enabled = osa.is_enabled,
            updated_at = GREATEST(os.updated_at, osa.updated_at)
        FROM organization_setting_availability osa
        WHERE os.organization_id = osa.organization_id
          AND os.setting_key = osa.setting_key
        """
    )

    # Insert availability rows that have no corresponding organization_settings row yet
    op.execute(
        """
        INSERT INTO organization_settings (organization_id, setting_key, value, is_enabled, created_at, updated_at)
        SELECT osa.organization_id, osa.setting_key, NULL, osa.is_enabled, osa.created_at, osa.updated_at
        FROM organization_setting_availability osa
        WHERE NOT EXISTS (
            SELECT 1 FROM organization_settings os
            WHERE os.organization_id = osa.organization_id
              AND os.setting_key = osa.setting_key
        )
        """
    )

    op.execute("DROP TABLE IF EXISTS organization_setting_availability CASCADE")

    # ── 2. Drop organization_role_availability & scope roles to organization_id ──
    op.execute("DROP TABLE IF EXISTS organization_role_availability CASCADE")

    op.add_column(
        "roles",
        sa.Column("organization_id", sa.Integer(), sa.ForeignKey("organizations.id", ondelete="CASCADE"), nullable=True),
    )
    op.drop_constraint("uq_roles_slug", "roles", type_="unique")

    # Clone existing global template roles (organization_id IS NULL) for every existing organization
    # and remap membership_roles to the newly cloned org-scoped roles.
    op.execute(
        """
        DO $$
        DECLARE
            org_rec RECORD;
            tmpl_rec RECORD;
            new_role_id INTEGER;
        BEGIN
            FOR org_rec IN SELECT id FROM organizations LOOP
                FOR tmpl_rec IN SELECT id, name, slug, description, is_system, created_at FROM roles WHERE organization_id IS NULL LOOP
                    INSERT INTO roles (organization_id, name, slug, description, is_system, created_at)
                    VALUES (org_rec.id, tmpl_rec.name, tmpl_rec.slug, tmpl_rec.description, tmpl_rec.is_system, tmpl_rec.created_at)
                    RETURNING id INTO new_role_id;

                    -- Copy role_permissions for this cloned role
                    INSERT INTO role_permissions (role_id, permission_id)
                    SELECT new_role_id, rp.permission_id
                    FROM role_permissions rp
                    WHERE rp.role_id = tmpl_rec.id;

                    -- Remap membership_roles for memberships in this organization
                    UPDATE membership_roles mr
                    SET role_id = new_role_id
                    FROM organization_memberships om
                    WHERE mr.membership_id = om.id
                      AND om.organization_id = org_rec.id
                      AND mr.role_id = tmpl_rec.id;
                END LOOP;
            END LOOP;

            -- Delete any orphaned template role_permissions and template roles
            DELETE FROM role_permissions
            WHERE role_id IN (SELECT id FROM roles WHERE organization_id IS NULL);

            DELETE FROM roles
            WHERE organization_id IS NULL;
        END $$;
        """
    )

    op.alter_column("roles", "organization_id", nullable=False)
    op.create_unique_constraint("uq_roles_org_slug", "roles", ["organization_id", "slug"])
    op.create_index("idx_roles_org_id", "roles", ["organization_id"])


def downgrade() -> None:
    # Downgrade is intentionally minimal since template roles and availability tables were consolidated
    raise NotImplementedError("Downgrade is not supported for 8b1c2d3e4f50.")

