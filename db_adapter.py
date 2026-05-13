"""Database adapter skeleton for Trial Quality Intelligence Platform.

This module is introduced in V8 to prepare the project for a real SQLite/PostgreSQL
switch. Existing Streamlit apps still use the stable sqlite helpers in app_v4.py to
avoid breaking earlier versions. New modules can gradually migrate to this adapter.
"""

from __future__ import annotations

import os
import sqlite3
from contextlib import contextmanager
from pathlib import Path
from typing import Iterator

import pandas as pd

try:
    from sqlalchemy import create_engine, text
    from sqlalchemy.engine import Engine
except Exception:  # pragma: no cover
    create_engine = None
    text = None
    Engine = None

DEFAULT_SQLITE_PATH = Path(os.getenv("TQIP_DB_PATH", "trial_quality_v8.db"))


def get_database_url() -> str:
    """Return DATABASE_URL if configured, otherwise a local SQLite URL."""
    return os.getenv("DATABASE_URL") or f"sqlite:///{DEFAULT_SQLITE_PATH}"


def is_postgres() -> bool:
    return get_database_url().startswith(("postgres://", "postgresql://"))


def get_engine():
    """Return a SQLAlchemy engine when SQLAlchemy is available."""
    if create_engine is None:
        raise RuntimeError("SQLAlchemy is not installed. Install sqlalchemy and psycopg2-binary for PostgreSQL.")
    url = get_database_url()
    if url.startswith("postgres://"):
        url = url.replace("postgres://", "postgresql://", 1)
    return create_engine(url, pool_pre_ping=True, future=True)


@contextmanager
def sqlite_connection() -> Iterator[sqlite3.Connection]:
    conn = sqlite3.connect(DEFAULT_SQLITE_PATH, check_same_thread=False)
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()


def query_df(sql: str, params: dict | tuple | None = None) -> pd.DataFrame:
    """Query either SQLite or SQLAlchemy-backed DB into a DataFrame."""
    params = params or {}
    if create_engine is not None:
        engine = get_engine()
        with engine.connect() as conn:
            return pd.read_sql_query(text(sql) if text else sql, conn, params=params)
    with sqlite_connection() as conn:
        return pd.read_sql_query(sql, conn, params=params)


def execute(sql: str, params: dict | tuple | None = None) -> int | None:
    """Execute SQL and return lastrowid for SQLite when available."""
    params = params or {}
    if create_engine is not None:
        engine = get_engine()
        with engine.begin() as conn:
            result = conn.execute(text(sql) if text else sql, params)
            return getattr(result, "lastrowid", None)
    with sqlite_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, params)
        return cur.lastrowid


def healthcheck() -> dict:
    """Return a small healthcheck dictionary for UI and deployment checks."""
    url = get_database_url()
    safe_url = url
    if "@" in safe_url and "://" in safe_url:
        prefix, rest = safe_url.split("://", 1)
        safe_url = prefix + "://***@" + rest.split("@", 1)[-1]
    try:
        if create_engine is not None:
            engine = get_engine()
            with engine.connect() as conn:
                conn.execute(text("SELECT 1") if text else "SELECT 1")
        else:
            with sqlite_connection() as conn:
                conn.execute("SELECT 1")
        status = "ok"
        error = ""
    except Exception as exc:  # pragma: no cover
        status = "error"
        error = str(exc)
    return {"mode": "PostgreSQL" if is_postgres() else "SQLite", "database_url": safe_url, "status": status, "error": error}
