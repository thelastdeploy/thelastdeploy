"""drop users xp and backfill to organization_memberships

Revision ID: a5b6c7d8e9f0
Revises: f4a5b6c7d8e9
Create Date: 2026-11-06 10:15:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'a5b6c7d8e9f0'
down_revision: Union[str, None] = 'f4a5b6c7d8e9'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Backfill: Copy all existing users.xp and users.unverified_xp into the platform organization_membership
    op.execute("""
        DO $$
        DECLARE
            platform_id INTEGER;
        BEGIN
            SELECT id INTO platform_id FROM organizations WHERE is_platform = TRUE LIMIT 1;
            
            IF platform_id IS NOT NULL THEN
                -- A. Update existing memberships for the platform org
                UPDATE organization_memberships m
                SET 
                    total_xp = GREATEST(m.total_xp, u.xp),
                    unverified_xp = GREATEST(m.unverified_xp, u.unverified_xp)
                FROM users u
                WHERE m.user_id = u.id AND m.organization_id = platform_id;

                -- B. Create membership for any user lacking one in the platform org
                INSERT INTO organization_memberships (organization_id, user_id, status, total_xp, unverified_xp, joined_at, created_at, updated_at)
                SELECT 
                    platform_id,
                    u.id,
                    'active',
                    u.xp,
                    u.unverified_xp,
                    NOW(),
                    NOW(),
                    NOW()
                FROM users u
                WHERE NOT EXISTS (
                    SELECT 1 FROM organization_memberships m 
                    WHERE m.user_id = u.id AND m.organization_id = platform_id
                );
            END IF;
        END $$;
    """)

    # 2. Drop columns from users
    op.drop_column('users', 'xp')
    op.drop_column('users', 'unverified_xp')


def downgrade() -> None:
    op.add_column('users', sa.Column('xp', sa.Integer(), server_default='0', nullable=False))
    op.add_column('users', sa.Column('unverified_xp', sa.Integer(), server_default='0', nullable=False))

    op.execute("""
        UPDATE users u
        SET 
            xp = COALESCE((
                SELECT m.total_xp 
                FROM organization_memberships m 
                JOIN organizations o ON o.id = m.organization_id 
                WHERE m.user_id = u.id AND o.is_platform = TRUE
                LIMIT 1
            ), 0),
            unverified_xp = COALESCE((
                SELECT m.unverified_xp 
                FROM organization_memberships m 
                JOIN organizations o ON o.id = m.organization_id 
                WHERE m.user_id = u.id AND o.is_platform = TRUE
                LIMIT 1
            ), 0);
    """)

