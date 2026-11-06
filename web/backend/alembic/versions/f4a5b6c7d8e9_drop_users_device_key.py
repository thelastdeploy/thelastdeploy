"""drop users device key

Revision ID: f4a5b6c7d8e9
Revises: e3c4d5e6f7a8
Create Date: 2026-11-06 00:25:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'f4a5b6c7d8e9'
down_revision: Union[str, None] = 'e3c4d5e6f7a8'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Backfill: ensure every user with a non-null device_key has a session in user_sessions
    op.execute("""
        INSERT INTO user_sessions (user_id, session_token_hash, device_key, client_type, expires_at, created_at, last_used_at)
        SELECT 
            u.id,
            encode(sha256(('migrated_legacy_session_' || u.id || '_' || u.device_key)::bytea), 'hex'),
            u.device_key,
            'cli',
            NOW() + INTERVAL '365 days',
            NOW(),
            NOW()
        FROM users u
        WHERE u.device_key IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM user_sessions s WHERE s.user_id = u.id AND s.device_key = u.device_key
          );
    """)

    # 2. Drop unique constraint and column from users
    op.drop_constraint('users_device_key_key', 'users', type_='unique')
    op.drop_column('users', 'device_key')


def downgrade() -> None:
    op.add_column('users', sa.Column('device_key', sa.String(length=64), nullable=True))
    op.execute("""
        UPDATE users u
        SET device_key = (
            SELECT s.device_key
            FROM user_sessions s
            WHERE s.user_id = u.id AND s.device_key IS NOT NULL
            ORDER BY s.created_at DESC
            LIMIT 1
        );
    """)
    op.create_unique_constraint('users_device_key_key', 'users', ['device_key'])

