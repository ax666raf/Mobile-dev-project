import os
from pathlib import Path

basedir = Path(__file__).parent.resolve()

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-change-in-production'
    # SQLite URI with connection arguments for better concurrency
    database_path = basedir / "instance" / "mahsoul.db"
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        f'sqlite:///{database_path}?check_same_thread=False&timeout=20'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    CORS_ORIGINS = ['*']  # Allow all origins for development

