"""merge organization domains into organizations

Revision ID: b6c7d8e9f0a1
Revises: a5b6c7d8e9f0
Create Date: 2026-11-06 10:25:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = 'b6c7d8e9f0a1'
down_revision: Union[str, None] = 'a5b6c7d8e9f0'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Add domains JSONB column to organizations
    op.add_column(
        'organizations',
        sa.Column('domains', postgresql.JSONB(astext_type=sa.Text()), server_default=sa.text("'[]'::jsonb"), nullable=False)
    )
    op.create_index('idx_organizations_domains', 'organizations', ['domains'], postgresql_using='gin')

    # 2. Backfill: Transfer any existing organization_domains rows into the jsonb array
    op.execute("""
        UPDATE organizations o
        SET domains = sub.domain_list
        FROM (
            SELECT organization_id, jsonb_agg(LOWER(domain)) AS domain_list
            FROM organization_domains
            GROUP BY organization_id
        ) sub
        WHERE o.id = sub.organization_id;
    """)

    # 3. Seed default domain policies:
    # Platform org allows all domains ('*'). Specific tenants allow their email domain.
    op.execute("""
        UPDATE organizations 
        SET domains = '["*"]'::jsonb 
        WHERE is_platform = TRUE AND (domains = '[]'::jsonb OR domains IS NULL)
    """)
    op.execute("""
        UPDATE organizations 
        SET domains = '["apex.edu"]'::jsonb 
        WHERE slug = 'apex-univ' AND (domains = '[]'::jsonb OR domains IS NULL)
    """)
    op.execute("""
        UPDATE organizations 
        SET domains = '["cloudscale.io"]'::jsonb 
        WHERE slug = 'cloudscale' AND (domains = '[]'::jsonb OR domains IS NULL)
    """)
    op.execute("""
        UPDATE organizations 
        SET domains = '["acme.edu"]'::jsonb 
        WHERE slug = 'acme-univ' AND (domains = '[]'::jsonb OR domains IS NULL)
    """)

    # 4. Drop the redundant organization_domains table
    op.drop_table('organization_domains')


def downgrade() -> None:
    # 1. Recreate organization_domains table
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

    # 2. Backfill back into organization_domains from organizations.domains
    op.execute("""
        INSERT INTO organization_domains (organization_id, domain, is_verified, created_at)
        SELECT 
            o.id, 
            elem.value, 
            true, 
            NOW()
        FROM organizations o,
        jsonb_array_elements_text(o.domains) AS elem(value)
        WHERE elem.value != '*'
        ON CONFLICT DO NOTHING;
    """)

    # 3. Drop index and column from organizations
    op.drop_index('idx_organizations_domains', table_name='organizations', postgresql_using='gin')
    op.drop_column('organizations', 'domains')
