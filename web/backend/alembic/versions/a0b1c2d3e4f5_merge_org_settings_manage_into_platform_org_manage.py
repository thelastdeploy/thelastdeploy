"""merge_org_settings_manage_into_platform_org_manage

Revision ID: a0b1c2d3e4f5
Revises: 9a0b1c2d3e4f
Create Date: 2026-11-24 16:50:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'a0b1c2d3e4f5'
down_revision: Union[str, None] = '9a0b1c2d3e4f'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Migrate any platform_user_permissions from organization_settings.manage to platform.organizations.manage
    op.execute("""
        INSERT INTO platform_user_permissions (user_id, permission_id, assigned_by)
        SELECT pup.user_id, target_p.id, pup.assigned_by
        FROM platform_user_permissions pup
        JOIN platform_permissions source_p ON source_p.id = pup.permission_id AND source_p.key = 'organization_settings.manage'
        CROSS JOIN platform_permissions target_p
        WHERE target_p.key = 'platform.organizations.manage'
        ON CONFLICT (user_id, permission_id) DO NOTHING;
    """)

    # 2. Delete assignments to organization_settings.manage
    op.execute("""
        DELETE FROM platform_user_permissions
        WHERE permission_id IN (
            SELECT id FROM platform_permissions WHERE key = 'organization_settings.manage'
        );
    """)
    op.execute("""
        DELETE FROM platform_role_permissions
        WHERE permission_id IN (
            SELECT id FROM platform_permissions WHERE key = 'organization_settings.manage'
        );
    """)

    # 3. Delete organization_settings.manage from platform_permissions
    op.execute("""
        DELETE FROM platform_permissions WHERE key = 'organization_settings.manage';
    """)

    # 4. Update description of platform.organizations.manage
    op.execute("""
        UPDATE platform_permissions
        SET description = 'Manage Tenant Workspaces: Administrative access to manage workspace curriculum, cohorts, settings, and members across any organization'
        WHERE key = 'platform.organizations.manage';
    """)


def downgrade() -> None:
    op.execute("""
        INSERT INTO platform_permissions (key, description)
        VALUES ('organization_settings.manage', 'Manage workspace and organization settings across all organizations')
        ON CONFLICT (key) DO NOTHING;
    """)
