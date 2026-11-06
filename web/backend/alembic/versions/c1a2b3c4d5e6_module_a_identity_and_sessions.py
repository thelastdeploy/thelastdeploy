"""module a identity and sessions

Revision ID: c1a2b3c4d5e6
Revises: b2c3d4e5f6a7
Create Date: 2026-11-05 20:25:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'c1a2b3c4d5e6'
down_revision: Union[str, None] = 'b2c3d4e5f6a7'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Alter users table
    op.add_column('users', sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False))
    op.add_column('users', sa.Column('last_login_at', sa.DateTime(timezone=True), nullable=True))
    op.add_column('users', sa.Column('verification_token_expires_at', sa.DateTime(timezone=True), nullable=True))

    op.create_index('uq_users_username_lower', 'users', [sa.text('LOWER(username)')], unique=True)
    op.create_index('uq_users_email_lower', 'users', [sa.text('LOWER(email)')], unique=True)

    # 2. Create user_sessions table
    op.create_table(
        'user_sessions',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('session_token_hash', sa.String(length=64), nullable=False),
        sa.Column('device_key', sa.String(length=64), nullable=True),
        sa.Column('client_type', sa.String(length=20), nullable=False),
        sa.Column('user_agent', sa.Text(), nullable=True),
        sa.Column('ip_address', sa.String(length=45), nullable=True),
        sa.Column('expires_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('revoked_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('last_used_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('session_token_hash', name='uq_user_sessions_session_token_hash')
    )
    op.create_index('idx_user_sessions_user_id', 'user_sessions', ['user_id'])
    op.create_index(
        'idx_user_sessions_lookup',
        'user_sessions',
        ['session_token_hash'],
        postgresql_where=sa.text('revoked_at IS NULL')
    )

    # 3. Alter cli_device_auths table
    op.add_column('cli_device_auths', sa.Column('device_code_hash', sa.String(length=64), nullable=True))
    op.execute("UPDATE cli_device_auths SET device_code_hash = encode(sha256(device_code::bytea), 'hex') WHERE device_code_hash IS NULL")
    op.alter_column('cli_device_auths', 'device_code_hash', nullable=False)
    op.create_unique_constraint('uq_cli_device_auths_device_code_hash', 'cli_device_auths', ['device_code_hash'])
    op.create_index('idx_cli_device_auths_polling', 'cli_device_auths', ['device_code_hash', 'status'])


def downgrade() -> None:
    # 1. Revert cli_device_auths
    op.drop_index('idx_cli_device_auths_polling', table_name='cli_device_auths')
    op.drop_constraint('uq_cli_device_auths_device_code_hash', 'cli_device_auths', type_='unique')
    op.drop_column('cli_device_auths', 'device_code_hash')

    # 2. Drop user_sessions
    op.drop_index('idx_user_sessions_lookup', table_name='user_sessions', postgresql_where=sa.text('revoked_at IS NULL'))
    op.drop_index('idx_user_sessions_user_id', table_name='user_sessions')
    op.drop_table('user_sessions')

    # 3. Revert users table
    op.drop_index('uq_users_email_lower', table_name='users')
    op.drop_index('uq_users_username_lower', table_name='users')
    op.drop_column('users', 'verification_token_expires_at')
    op.drop_column('users', 'last_login_at')
    op.drop_column('users', 'updated_at')

