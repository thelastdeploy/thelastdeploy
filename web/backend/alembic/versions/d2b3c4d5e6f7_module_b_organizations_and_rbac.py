"""module b organizations and rbac

Revision ID: d2b3c4d5e6f7
Revises: c1a2b3c4d5e6
Create Date: 2026-11-05 20:35:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = 'd2b3c4d5e6f7'
down_revision: Union[str, None] = 'c1a2b3c4d5e6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Organizations
    op.create_table(
        'organizations',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('name', sa.String(length=255), nullable=False),
        sa.Column('slug', sa.String(length=100), nullable=False),
        sa.Column('type', sa.String(length=50), nullable=False),
        sa.Column('is_platform', sa.Boolean(), server_default=sa.text('false'), nullable=False),
        sa.Column('status', sa.String(length=50), server_default='active', nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('slug', name='uq_organizations_slug')
    )
    op.create_index(
        'uq_single_platform_org',
        'organizations',
        ['is_platform'],
        unique=True,
        postgresql_where=sa.text('is_platform = true')
    )

    # 2. Organization Domains
    op.create_table(
        'organization_domains',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('domain', sa.String(length=255), nullable=False),
        sa.Column('is_verified', sa.Boolean(), server_default=sa.text('false'), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('organization_id', 'domain', name='uq_organization_domains_org_domain')
    )
    op.create_index('uq_organization_domains_domain_lower', 'organization_domains', [sa.text('LOWER(domain)')], unique=True)

    # 3. Organization Memberships
    op.create_table(
        'organization_memberships',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('status', sa.String(length=50), server_default='active', nullable=False),
        sa.Column('total_xp', sa.BigInteger(), server_default=sa.text('0'), nullable=False),
        sa.Column('unverified_xp', sa.BigInteger(), server_default=sa.text('0'), nullable=False),
        sa.Column('joined_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('removed_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('id', 'organization_id', name='uq_organization_memberships_id_org')
    )
    op.create_index(
        'uq_org_active_membership',
        'organization_memberships',
        ['organization_id', 'user_id'],
        unique=True,
        postgresql_where=sa.text("status != 'removed'")
    )
    op.create_index('idx_org_memberships_user', 'organization_memberships', ['user_id'])

    # 4. Permissions Catalogue
    op.create_table(
        'permissions',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('key', sa.String(length=100), nullable=False),
        sa.Column('description', sa.Text(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('key', name='uq_permissions_key')
    )

    # 5. Roles
    op.create_table(
        'roles',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('name', sa.String(length=100), nullable=False),
        sa.Column('slug', sa.String(length=100), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('is_system', sa.Boolean(), server_default=sa.text('true'), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('slug', name='uq_roles_slug')
    )

    # 6. Role Permissions
    op.create_table(
        'role_permissions',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('role_id', sa.Integer(), nullable=False),
        sa.Column('permission_id', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['permission_id'], ['permissions.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['role_id'], ['roles.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('role_id', 'permission_id', name='uq_role_permissions_role_perm')
    )

    # 7. Organization Role Availability
    op.create_table(
        'organization_role_availability',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('role_id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['role_id'], ['roles.id'], ondelete='RESTRICT'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('organization_id', 'role_id', name='uq_org_role_avail')
    )

    # 8. Membership Roles
    op.create_table(
        'membership_roles',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('membership_id', sa.Integer(), nullable=False),
        sa.Column('role_id', sa.Integer(), nullable=False),
        sa.Column('assigned_by', sa.Integer(), nullable=True),
        sa.Column('assigned_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['assigned_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['membership_id'], ['organization_memberships.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['role_id'], ['roles.id'], ondelete='RESTRICT'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('membership_id', 'role_id', name='uq_membership_roles')
    )

    # 9. Platform Roles
    op.create_table(
        'platform_roles',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('name', sa.String(length=100), nullable=False),
        sa.Column('slug', sa.String(length=100), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('slug', name='uq_platform_roles_slug')
    )

    # 10. Platform Permissions
    op.create_table(
        'platform_permissions',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('key', sa.String(length=100), nullable=False),
        sa.Column('description', sa.Text(), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('key', name='uq_platform_permissions_key')
    )

    # 11. Platform Role Permissions
    op.create_table(
        'platform_role_permissions',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('platform_role_id', sa.Integer(), nullable=False),
        sa.Column('permission_id', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['permission_id'], ['platform_permissions.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['platform_role_id'], ['platform_roles.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('platform_role_id', 'permission_id', name='uq_platform_role_perms')
    )

    # 12. Platform User Roles
    op.create_table(
        'platform_user_roles',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('platform_role_id', sa.Integer(), nullable=False),
        sa.Column('assigned_by', sa.Integer(), nullable=True),
        sa.Column('assigned_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['assigned_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['platform_role_id'], ['platform_roles.id'], ondelete='RESTRICT'),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('user_id', 'platform_role_id', name='uq_platform_user_roles')
    )

    # 13. Cohorts
    op.create_table(
        'cohorts',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('name', sa.String(length=255), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('status', sa.String(length=50), server_default='active', nullable=False),
        sa.Column('starts_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('ends_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['created_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('id', 'organization_id', name='uq_cohorts_id_org')
    )

    # 14. Cohort Memberships (Enforces exact tenant isolation via composite FK)
    op.create_table(
        'cohort_memberships',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('cohort_id', sa.Integer(), nullable=False),
        sa.Column('organization_membership_id', sa.Integer(), nullable=False),
        sa.Column('joined_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('removed_at', sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(
            ['cohort_id', 'organization_id'],
            ['cohorts.id', 'cohorts.organization_id'],
            ondelete='CASCADE'
        ),
        sa.ForeignKeyConstraint(
            ['organization_membership_id', 'organization_id'],
            ['organization_memberships.id', 'organization_memberships.organization_id'],
            ondelete='CASCADE'
        ),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('cohort_id', 'organization_membership_id', name='uq_cohort_memberships')
    )

    # 15. Cohort Invites
    op.create_table(
        'cohort_invites',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('cohort_id', sa.Integer(), nullable=False),
        sa.Column('code_hash', sa.String(length=64), nullable=False),
        sa.Column('expires_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('max_uses', sa.Integer(), nullable=True),
        sa.Column('used_count', sa.Integer(), server_default=sa.text('0'), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('revoked_at', sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(['cohort_id'], ['cohorts.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['created_by'], ['users.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('code_hash', name='uq_cohort_invites_code_hash')
    )

    # 16. Learning Paths
    op.create_table(
        'learning_paths',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('name', sa.String(length=255), nullable=False),
        sa.Column('slug', sa.String(length=100), nullable=False),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('visibility', sa.String(length=20), server_default='public', nullable=False),
        sa.Column('status', sa.String(length=50), server_default='active', nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['created_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('organization_id', 'slug', name='uq_learning_paths_org_slug'),
        sa.UniqueConstraint('id', 'organization_id', name='uq_learning_paths_id_org')
    )

    # 17. Learning Path Modules
    op.create_table(
        'learning_path_modules',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('learning_path_id', sa.Integer(), nullable=False),
        sa.Column('module_id', sa.String(length=100), nullable=False),
        sa.Column('order', sa.Integer(), server_default=sa.text('0'), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['learning_path_id'], ['learning_paths.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['module_id'], ['modules.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('learning_path_id', 'module_id', name='uq_lp_module'),
        sa.UniqueConstraint('learning_path_id', 'order', name='uq_lp_module_order')
    )

    # 18. Learning Path Cohorts
    op.create_table(
        'learning_path_cohorts',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('learning_path_id', sa.Integer(), nullable=False),
        sa.Column('cohort_id', sa.Integer(), nullable=False),
        sa.Column('assigned_by', sa.Integer(), nullable=True),
        sa.Column('assigned_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['assigned_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(
            ['learning_path_id', 'organization_id'],
            ['learning_paths.id', 'learning_paths.organization_id'],
            ondelete='CASCADE'
        ),
        sa.ForeignKeyConstraint(
            ['cohort_id', 'organization_id'],
            ['cohorts.id', 'cohorts.organization_id'],
            ondelete='CASCADE'
        ),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('learning_path_id', 'cohort_id', name='uq_lp_cohorts')
    )

    # 19. Learning Path Individual Private Assignments
    op.create_table(
        'learning_path_assignments',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=False),
        sa.Column('learning_path_id', sa.Integer(), nullable=False),
        sa.Column('organization_membership_id', sa.Integer(), nullable=False),
        sa.Column('assigned_by', sa.Integer(), nullable=True),
        sa.Column('assigned_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column('expires_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('revoked_at', sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(['assigned_by'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(
            ['learning_path_id', 'organization_id'],
            ['learning_paths.id', 'learning_paths.organization_id'],
            ondelete='CASCADE'
        ),
        sa.ForeignKeyConstraint(
            ['organization_membership_id', 'organization_id'],
            ['organization_memberships.id', 'organization_memberships.organization_id'],
            ondelete='CASCADE'
        ),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('learning_path_id', 'organization_membership_id', name='uq_lp_assignments')
    )

    # 20. Audit Logs
    op.create_table(
        'audit_logs',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('organization_id', sa.Integer(), nullable=True),
        sa.Column('actor_user_id', sa.Integer(), nullable=True),
        sa.Column('action', sa.String(length=100), nullable=False),
        sa.Column('entity_type', sa.String(length=100), nullable=False),
        sa.Column('entity_id', sa.String(length=100), nullable=True),
        sa.Column('metadata', postgresql.JSONB(astext_type=sa.Text()), server_default=sa.text("'{}'::jsonb"), nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(['actor_user_id'], ['users.id'], ondelete='SET NULL'),
        sa.ForeignKeyConstraint(['organization_id'], ['organizations.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index('idx_audit_logs_org_created', 'audit_logs', ['organization_id', sa.text('created_at DESC')])
    op.create_index('idx_audit_logs_actor', 'audit_logs', ['actor_user_id', sa.text('created_at DESC')])

    # =========================================================================
    # DATA SEEDING & BACKFILL (Preserving all production state)
    # =========================================================================

    # A. Create TLD Platform Organization
    op.execute("""
        INSERT INTO organizations (name, slug, type, is_platform, status)
        VALUES ('The Last Deploy', 'tld', 'platform', true, 'active')
        ON CONFLICT (slug) DO NOTHING;
    """)

    # B. Seed Standard Permissions Catalogue
    op.execute("""
        INSERT INTO permissions (key, description) VALUES
        ('organization.manage', 'Manage organization settings, domains, and profile'),
        ('members.view', 'View members and their learning progress in the organization'),
        ('members.manage', 'Invite, add, remove, and manage organization members'),
        ('roles.manage', 'Assign and revoke member roles within the organization'),
        ('cohorts.manage', 'Create, update, and manage cohorts and cohort invitations'),
        ('learning_paths.manage', 'Create, update, and assign learning paths'),
        ('content.publish', 'Publish curriculum modules to the organization'),
        ('content.verify', 'Review and officially verify submitted curriculum modules'),
        ('analytics.view', 'View organization learning and cohort analytics')
        ON CONFLICT (key) DO NOTHING;
    """)

    # C. Seed Standard Roles
    op.execute("""
        INSERT INTO roles (name, slug, description, is_system) VALUES
        ('Owner', 'owner', 'Full administrative authority and ownership of the organization', true),
        ('Admin', 'admin', 'Organization administrator with management access', true),
        ('Instructor', 'instructor', 'Curriculum instructor who manages cohorts, learning paths, and reviews', true),
        ('Learner', 'learner', 'Student / learner who completes labs and courses', true)
        ON CONFLICT (slug) DO NOTHING;
    """)

    # D. Link Role Permissions
    op.execute("""
        INSERT INTO role_permissions (role_id, permission_id)
        SELECT r.id, p.id FROM roles r CROSS JOIN permissions p
        WHERE r.slug = 'owner'
        ON CONFLICT DO NOTHING;
    """)

    op.execute("""
        INSERT INTO role_permissions (role_id, permission_id)
        SELECT r.id, p.id FROM roles r JOIN permissions p ON p.key != 'roles.manage'
        WHERE r.slug = 'admin'
        ON CONFLICT DO NOTHING;
    """)

    op.execute("""
        INSERT INTO role_permissions (role_id, permission_id)
        SELECT r.id, p.id FROM roles r JOIN permissions p ON p.key IN (
            'members.view', 'cohorts.manage', 'learning_paths.manage', 'content.publish', 'analytics.view'
        )
        WHERE r.slug = 'instructor'
        ON CONFLICT DO NOTHING;
    """)

    op.execute("""
        INSERT INTO role_permissions (role_id, permission_id)
        SELECT r.id, p.id FROM roles r JOIN permissions p ON p.key = 'members.view'
        WHERE r.slug = 'learner'
        ON CONFLICT DO NOTHING;
    """)

    # E. Make All Standard Roles Available to TLD Organization
    op.execute("""
        INSERT INTO organization_role_availability (organization_id, role_id)
        SELECT o.id, r.id FROM organizations o CROSS JOIN roles r
        WHERE o.is_platform = true
        ON CONFLICT DO NOTHING;
    """)

    # F. Seed Platform Roles & Permissions
    op.execute("""
        INSERT INTO platform_roles (name, slug, description) VALUES
        ('Platform Admin', 'platform_admin', 'Full platform administrator with root access'),
        ('Curriculum Lead', 'curriculum_lead', 'Curriculum architect and content reviewer'),
        ('Support Staff', 'support_staff', 'User support and customer service operations')
        ON CONFLICT (slug) DO NOTHING;
    """)

    op.execute("""
        INSERT INTO platform_permissions (key, description) VALUES
        ('platform.organizations.create', 'Create and provision new organizations'),
        ('platform.organizations.manage', 'Update and configure organizations'),
        ('platform.organizations.suspend', 'Suspend or deactivate an organization'),
        ('platform.staff.manage', 'Manage platform staff roles and assignments'),
        ('platform.modules.verify', 'Officially verify published curriculum modules'),
        ('platform.audit.view', 'View platform-wide security audit logs')
        ON CONFLICT (key) DO NOTHING;
    """)

    op.execute("""
        INSERT INTO platform_role_permissions (platform_role_id, permission_id)
        SELECT pr.id, pp.id FROM platform_roles pr CROSS JOIN platform_permissions pp
        WHERE pr.slug = 'platform_admin'
        ON CONFLICT DO NOTHING;
    """)

    # G. Backfill Existing Users to TLD Memberships with their XP
    op.execute("""
        INSERT INTO organization_memberships (organization_id, user_id, status, total_xp, unverified_xp, joined_at)
        SELECT 
            (SELECT id FROM organizations WHERE is_platform = true LIMIT 1),
            u.id,
            'active',
            u.xp,
            u.unverified_xp,
            u.created_at
        FROM users u
        ON CONFLICT DO NOTHING;
    """)

    # H. Assign Default Roles (Dev User -> Owner, Others -> Learner)
    op.execute("""
        INSERT INTO membership_roles (membership_id, role_id)
        SELECT m.id, r.id
        FROM organization_memberships m
        CROSS JOIN roles r
        WHERE r.slug = CASE WHEN m.user_id = 1 THEN 'owner' ELSE 'learner' END
        ON CONFLICT DO NOTHING;
    """)

    # I. Migrate Existing Maintainers to Platform Admin
    op.execute("""
        INSERT INTO platform_user_roles (user_id, platform_role_id)
        SELECT 
            u.id,
            (SELECT id FROM platform_roles WHERE slug = 'platform_admin' LIMIT 1)
        FROM users u
        WHERE u.is_maintainer = true
        ON CONFLICT DO NOTHING;
    """)


def downgrade() -> None:
    # Drop tables in reverse order of creation
    op.drop_table('audit_logs')
    op.drop_table('learning_path_assignments')
    op.drop_table('learning_path_cohorts')
    op.drop_table('learning_path_modules')
    op.drop_table('learning_paths')
    op.drop_table('cohort_invites')
    op.drop_table('cohort_memberships')
    op.drop_table('cohorts')
    op.drop_table('platform_user_roles')
    op.drop_table('platform_role_permissions')
    op.drop_table('platform_permissions')
    op.drop_table('platform_roles')
    op.drop_table('membership_roles')
    op.drop_table('organization_role_availability')
    op.drop_table('role_permissions')
    op.drop_table('roles')
    op.drop_table('permissions')
    op.drop_table('organization_memberships')
    op.drop_table('organization_domains')
    op.drop_table('organizations')
