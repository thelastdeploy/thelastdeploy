"""Add granular organization permissions for roles, settings, invitations, analytics export, and audit.

Revision ID: 9c2d3e4f5a60
Revises: 8b1c2d3e4f50
Create Date: 2026-11-26 13:02:00.000000
"""

from alembic import op

revision = "9c2d3e4f5a60"
down_revision = "8b1c2d3e4f50"
branch_labels = None
depends_on = None


NEW_PERMISSIONS = [
    ("roles.assign", "Assign and revoke roles for organization members"),
    ("settings.view", "View enabled organization settings"),
    ("settings.manage", "Modify values of any enabled organization setting"),
    ("settings.cohorts.manage", "Modify cohort-related organization settings"),
    ("settings.content.manage", "Modify content-related organization settings"),
    ("settings.onboarding.manage", "Modify onboarding and invitation organization settings"),
    ("settings.security.manage", "Modify security organization settings"),
    ("invitations.manage", "Create, resend, and revoke organization invitations and access requests"),
    ("analytics.export", "Export organization learner progress and analytics CSV reports"),
    ("audit.view", "View organization-scoped audit logs"),
]


def upgrade() -> None:
    op.execute(
        """
        UPDATE permissions
        SET description = 'Create, rename, modify permissions, and delete custom roles within the organization'
        WHERE key = 'roles.manage'
        """
    )

    for key, desc in NEW_PERMISSIONS:
        op.execute(
            f"""
            INSERT INTO permissions (key, description)
            VALUES ('{key}', '{desc.replace("'", "''")}')
            ON CONFLICT (key) DO NOTHING
            """
        )

    # Grant all new permissions to every org's 'owner' role
    op.execute(
        """
        INSERT INTO role_permissions (role_id, permission_id)
        SELECT r.id, p.id
        FROM roles r
        CROSS JOIN permissions p
        WHERE r.slug = 'owner'
          AND p.key IN (
            'roles.assign', 'settings.view', 'settings.manage',
            'settings.cohorts.manage', 'settings.content.manage',
            'settings.onboarding.manage', 'settings.security.manage',
            'invitations.manage', 'analytics.export', 'audit.view'
          )
        ON CONFLICT (role_id, permission_id) DO NOTHING
        """
    )

    # Grant non-security/non-role-definition permissions to every org's 'admin' role
    op.execute(
        """
        INSERT INTO role_permissions (role_id, permission_id)
        SELECT r.id, p.id
        FROM roles r
        CROSS JOIN permissions p
        WHERE r.slug = 'admin'
          AND p.key IN (
            'roles.assign', 'settings.view', 'settings.manage',
            'settings.cohorts.manage', 'settings.content.manage',
            'settings.onboarding.manage', 'invitations.manage',
            'analytics.export', 'audit.view'
          )
        ON CONFLICT (role_id, permission_id) DO NOTHING
        """
    )


def downgrade() -> None:
    keys = ", ".join(f"'{k}'" for k, _ in NEW_PERMISSIONS)
    op.execute(f"DELETE FROM role_permissions WHERE permission_id IN (SELECT id FROM permissions WHERE key IN ({keys}))")
    op.execute(f"DELETE FROM permissions WHERE key IN ({keys})")

