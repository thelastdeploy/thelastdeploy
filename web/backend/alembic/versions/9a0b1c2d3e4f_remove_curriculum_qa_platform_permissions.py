"""remove_curriculum_qa_platform_permissions

Revision ID: 9a0b1c2d3e4f
Revises: 89a0b1c2d3e4
Create Date: 2026-11-24 16:08:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '9a0b1c2d3e4f'
down_revision: Union[str, None] = '89a0b1c2d3e4'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

CURRICULUM_PERMS = (
    'platform.modules.verify',
    'platform.modules.reject',
    'platform.modules.calibrate_xp',
    'platform.modules.delete',
    'platform.modules.view_all',
)


def upgrade() -> None:
    # 1. Remove deleted permissions from role and user assignment tables
    op.execute(f"""
        DELETE FROM platform_role_permissions 
        WHERE permission_id IN (
            SELECT id FROM platform_permissions 
            WHERE key IN {CURRICULUM_PERMS}
        )
    """)
    op.execute(f"""
        DELETE FROM platform_user_permissions 
        WHERE permission_id IN (
            SELECT id FROM platform_permissions 
            WHERE key IN {CURRICULUM_PERMS}
        )
    """)

    # 2. Delete the permissions from platform_permissions catalog
    op.execute(f"""
        DELETE FROM platform_permissions 
        WHERE key IN {CURRICULUM_PERMS}
    """)


def downgrade() -> None:
    op.execute("""
        INSERT INTO platform_permissions (key, description)
        VALUES 
            ('platform.modules.view_all', 'Inspect All Curriculum: View all modules platform-wide (unverified, drafts, private)'),
            ('platform.modules.verify', 'Officially verify published curriculum modules'),
            ('platform.modules.calibrate_xp', 'Calibrate Module XP: Adjust and calibrate section and lab XP reward weights'),
            ('platform.modules.reject', 'Reject Curriculum Submissions: Reject submitted modules with formal reviewer feedback'),
            ('platform.modules.delete', 'Deprecate / Delete Modules: Deprecate or remove modules platform-wide')
        ON CONFLICT (key) DO NOTHING
    """)

