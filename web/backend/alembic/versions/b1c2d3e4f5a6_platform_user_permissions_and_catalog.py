"""platform_user_permissions_and_catalog

Revision ID: b1c2d3e4f5a6
Revises: f8a9b0c1d2e3
Create Date: 2026-11-24 11:20:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa


revision: str = 'b1c2d3e4f5a6'
down_revision: Union[str, None] = 'f8a9b0c1d2e3'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


ALL_PERMISSIONS = [
    # RBAC & Delegation
    ('platform.permissions.manage', 'Configure Staff Permissions: Inspect and toggle granular permissions for any platform user'),
    ('platform.staff.manage', 'Manage Platform Staff: Add, list, or revoke platform operator access'),
    ('platform.users.view', 'View Global Users: Search and inspect global user profiles across the entire platform'),
    ('platform.users.manage', 'Administer Global Users: Reset passwords, verify emails, or suspend global user accounts'),
    
    # Tenant Organizations & Workspaces
    ('platform.organizations.view', 'View Tenant Organizations: View directory and metadata of all platform organizations'),
    ('platform.organizations.create', 'Provision Organization: Create and provision new tenant workspaces with custom domains'),
    ('platform.organizations.manage', 'Manage Org Metadata: Update tenant names, slugs, verified domains, and metadata'),
    ('platform.organizations.settings', 'Configure Org Settings & Defaults: Enable/disable setting availability and configure default/override values per tenant'),
    ('platform.organizations.suspend', 'Suspend / Reactivate Org: Deactivate or restore tenant organizations'),
    ('organization_settings.manage', 'Cross-Org Settings Override: Superadmin override for workspace configuration'),

    # Curriculum, Content & XP Governance
    ('platform.modules.view_all', 'Inspect All Curriculum: View all modules platform-wide (unverified, drafts, private)'),
    ('platform.modules.verify', 'Verify & Publish Curriculum: Officially verify modules and publish to official TLD status'),
    ('platform.modules.calibrate_xp', 'Calibrate Module XP: Adjust and calibrate section and lab XP reward weights'),
    ('platform.modules.reject', 'Reject Curriculum Submissions: Reject submitted modules with formal reviewer feedback'),
    ('platform.modules.delete', 'Deprecate / Delete Modules: Deprecate or remove modules platform-wide'),

    # Analytics & Intelligence
    ('platform.analytics.view', 'View Global Analytics: Access platform adoption metrics, KPI dashboards, and trend graphs'),
    ('platform.analytics.export', 'Export Platform Analytics: Export platform-wide organization performance data to CSV'),

    # Security, System & Audit
    ('platform.audit.view', 'View Global Security Audit: Access platform-wide security audit logs and administrative traces'),
    ('platform.system.maintenance', 'System Maintenance & Notices: Configure global platform maintenance modes or system announcements'),
]


def upgrade() -> None:
    # 1. Create platform_user_permissions table
    op.create_table(
        'platform_user_permissions',
        sa.Column('id', sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column('user_id', sa.Integer(), sa.ForeignKey('users.id', ondelete='CASCADE'), nullable=False),
        sa.Column('permission_id', sa.Integer(), sa.ForeignKey('platform_permissions.id', ondelete='CASCADE'), nullable=False),
        sa.Column('assigned_by', sa.Integer(), sa.ForeignKey('users.id', ondelete='SET NULL'), nullable=True),
        sa.Column('assigned_at', sa.DateTime(timezone=True), server_default=sa.text('now()'), nullable=False),
        sa.UniqueConstraint('user_id', 'permission_id', name='uq_platform_user_perms')
    )
    op.create_index('idx_platform_user_perms_user', 'platform_user_permissions', ['user_id'])

    # 2. Seed expanded permissions catalog
    conn = op.get_bind()
    for key, desc in ALL_PERMISSIONS:
        res = conn.execute(
            sa.text("SELECT id FROM platform_permissions WHERE key = :key"),
            {"key": key}
        ).fetchone()
        if not res:
            conn.execute(
                sa.text("INSERT INTO platform_permissions (key, description, created_at) VALUES (:key, :desc, now())"),
                {"key": key, "desc": desc}
            )


def downgrade() -> None:
    op.drop_index('idx_platform_user_perms_user', table_name='platform_user_permissions')
    op.drop_table('platform_user_permissions')
