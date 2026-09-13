# web/backend/app/database.py

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase
from app.config import settings

def _normalize_db_url(raw_url: str) -> str:
    url = raw_url.strip()
    # Strip accidental variable assignment prefix
    if url.startswith("DATABASE_URL="):
        url = url[len("DATABASE_URL="):].strip()
    # Strip quotes (single or double)
    url = url.strip('"\'').strip()

    # Normalize driver scheme for asyncpg
    if url.startswith("postgres://"):
        url = url.replace("postgres://", "postgresql+asyncpg://", 1)
    elif url.startswith("postgresql://"):
        url = url.replace("postgresql://", "postgresql+asyncpg://", 1)

    # asyncpg expects ssl= instead of sslmode=
    if "sslmode=" in url:
        url = url.replace("sslmode=", "ssl=")

    return url

db_url = _normalize_db_url(settings.DATABASE_URL)

engine = create_async_engine(
    db_url,
    echo=settings.ENVIRONMENT == "development",
    pool_size=5,
    max_overflow=10,
    pool_pre_ping=True,
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)

class Base(DeclarativeBase):
    pass