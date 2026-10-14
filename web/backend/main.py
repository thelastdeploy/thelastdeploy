# web/backend/main.py

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.analytics import analytics
from app.routers import auth, modules, results, users, builder, analytics as analytics_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    analytics.shutdown()


# Docs enabled in dev or if ENABLE_DOCS is True
docs_url = "/docs" if (settings.ENVIRONMENT == "development" or settings.ENABLE_DOCS) else None
redoc_url = "/redoc" if (settings.ENVIRONMENT == "development" or settings.ENABLE_DOCS) else None
openapi_url = "/openapi.json" if (settings.ENVIRONMENT == "development" or settings.ENABLE_DOCS) else None

app = FastAPI(
    title="The Last Deploy API",
    description="Backend for The Last Deploy DevOps practice platform (with privacy-first analytics)",
    version="0.3.1",
    docs_url=docs_url,
    redoc_url=redoc_url,
    openapi_url=openapi_url,
    lifespan=lifespan,
)

cors_origins = list({
    origin.strip().rstrip("/")
    for origin in [
        settings.FRONTEND_URL,
        "https://app.thelastdeploy.com",
        "https://thelastdeploy.com",
        "http://localhost:9000",
        "http://127.0.0.1:9000",
        "http://localhost:3000",
        "http://localhost:3001",
    ]
    if origin
})

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_origin_regex=r"^https://([a-zA-Z0-9-]+\.)*thelastdeploy\.com$|^https://([a-zA-Z0-9-]+\.)*vercel\.app$|^http://(localhost|127\.0\.0\.1)(:\d+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, tags=["auth"])
app.include_router(modules.router, tags=["modules"])   # includes /labs/:id too
app.include_router(results.router, tags=["results"])
app.include_router(users.router, tags=["users"])
app.include_router(builder.router, tags=["builder"])
app.include_router(analytics_router.router, tags=["analytics"])


@app.get("/")
async def root():
    return {
        "name": "The Last Deploy API",
        "status": "online",
        "version": "0.3.1",
        "health": "/health",
        "docs": docs_url,
    }


@app.api_route("/health", methods=["GET", "HEAD"])
async def health():
    return {"status": "ok"}


@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    from fastapi.responses import Response
    return Response(status_code=204)