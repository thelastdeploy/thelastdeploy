# web/backend/app/database.py

from urllib.parse import urlparse, parse_qs, urlencode, urlunparse
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase
from app.config import settings

# Parameters not supported by asyncpg driver — must be stripped from connection URL
_ASYNCPG_UNSUPPORTED_PARAMS = frozenset({
    "channel_binding",
    "connect_timeout",
    "application_name",
    "options",
    "gssencmode",
    "target_session_attrs",
})

def _normalize_db_url(raw_url: str) -> str:
    url = raw_url.strip()
    # Strip accidental variable assignment prefix
    if url.startswith("DATABASE_URL="):
        url = url[len("DATABASE_URL="):].strip()
    # Strip surrounding quotes (single or double)
    url = url.strip("\'\"\'").strip()

    # Normalize driver scheme for asyncpg
    if url.startswith("postgres://"):
        url = url.replace("postgres://", "postgresql+asyncpg://", 1)
    elif url.startswith("postgresql://"):
        url = url.replace("postgresql://", "postgresql+asyncpg://", 1)

    # asyncpg expects ssl= instead of sslmode=
    if "sslmode=" in url:
        url = url.replace("sslmode=", "ssl=")

    # Strip query parameters not understood by asyncpg
    parsed = urlparse(url)
    if parsed.query:
        params = parse_qs(parsed.query, keep_blank_values=True)
        filtered = {k: v for k, v in params.items() if k not in _ASYNCPG_UNSUPPORTED_PARAMS}
        new_query = urlencode({k: v[0] for k, v in filtered.items()})
        url = urlunparse(parsed._replace(query=new_query))

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
