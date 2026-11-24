"""cleanup_permissions_and_update_users_manage

Revision ID: 89a0b1c2d3e4
Revises: 763776bb475f
Create Date: 2026-11-24 15:17:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '89a0b1c2d3e4'
down_revision: Union[str, None] = '763776bb475f'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Remove deleted permissions from platform_role_permissions and platform_user_permissions
    op.execute("""
        DELETE FROM platform_role_permissions 
        WHERE permission_id IN (
            SELECT id FROM platform_permissions 
            WHERE key IN ('platform.system.maintenance', 'platform.staff.manage')
        )
    """)
    op.execute("""
        DELETE FROM platform_user_permissions 
        WHERE permission_id IN (
            SELECT id FROM platform_permissions 
            WHERE key IN ('platform.system.maintenance', 'platform.staff.manage')
        )
    """)

    # 2. Delete the permissions from platform_permissions catalog
    op.execute("""
        DELETE FROM platform_permissions 
        WHERE key IN ('platform.system.maintenance', 'platform.staff.manage')
    """)

    # 3. Update descriptions for platform.users.manage and platform.users.view
    op.execute("""
        UPDATE platform_permissions 
        SET description = 'Add Platform Users: Provision new platform operators with default baseline permissions'
        WHERE key = 'platform.users.manage'
    """)
    op.execute("""
        UPDATE platform_permissions 
        SET description = 'View Platform Users: View directory and active permissions of platform operators'
        WHERE key = 'platform.users.view'
    """)


def downgrade() -> None:
    # Re-insert deleted permissions
    op.execute("""
        INSERT INTO platform_permissions (key, description)
        VALUES 
            ('platform.staff.manage', 'Manage Platform Staff: Add, list, or revoke platform operator access'),
            ('platform.system.maintenance', 'System Maintenance & Notices: Configure global platform maintenance modes or system announcements')
        ON CONFLICT (key) DO NOTHING
    """)
