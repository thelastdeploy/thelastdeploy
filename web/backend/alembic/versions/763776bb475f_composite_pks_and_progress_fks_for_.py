"""composite_pks_and_progress_fks_for_content

Revision ID: 763776bb475f
Revises: b1c2d3e4f5a6
Create Date: 2026-11-24 07:50:37.945528

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '763776bb475f'
down_revision: Union[str, None] = 'b1c2d3e4f5a6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Drop foreign key constraints on progress tables referencing single-column primary keys
    op.drop_constraint("section_progress_section_id_fkey", "section_progress", type_="foreignkey")
    op.drop_constraint("lab_progress_lab_id_fkey", "lab_progress", type_="foreignkey")

    # 2. Update Primary Key on modules to (id, owner_organization_id)
    op.drop_constraint("modules_pkey", "modules", type_="primary")
    op.create_primary_key("pk_modules", "modules", ["id", "owner_organization_id"])

    # 3. Update Primary Key on sections to (id, owner_organization_id)
    op.drop_constraint("sections_pkey", "sections", type_="primary")
    op.create_primary_key("pk_sections", "sections", ["id", "owner_organization_id"])

    # 4. Update Primary Key on labs to (id, owner_organization_id)
    op.drop_constraint("labs_pkey", "labs", type_="primary")
    op.create_primary_key("pk_labs", "labs", ["id", "owner_organization_id"])


def downgrade() -> None:
    op.drop_constraint("pk_labs", "labs", type_="primary")
    op.create_primary_key("labs_pkey", "labs", ["id"])

    op.drop_constraint("pk_sections", "sections", type_="primary")
    op.create_primary_key("sections_pkey", "sections", ["id"])

    op.drop_constraint("pk_modules", "modules", type_="primary")
    op.create_primary_key("modules_pkey", "modules", ["id"])

    op.create_foreign_key(
        "lab_progress_lab_id_fkey",
        "lab_progress",
        "labs",
        ["lab_id"],
        ["id"],
        ondelete="CASCADE",
    )
    op.create_foreign_key(
        "section_progress_section_id_fkey",
        "section_progress",
        "sections",
        ["section_id"],
        ["id"],
        ondelete="CASCADE",
    )
