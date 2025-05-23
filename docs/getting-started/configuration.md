# Configuration Guide

This guide explains how to configure Sal's Memory Maker for different environments and use cases.

## Table of Contents
1. [Environment Variables](#environment-variables)
2. [Database Configuration](#database-configuration)
3. [Frontend Configuration](#frontend-configuration)
4. [Backend Configuration](#backend-configuration)
5. [Security Configuration](#security-configuration)
6. [Email Configuration](#email-configuration)
7. [Storage Configuration](#storage-configuration)
8. [Payment Configuration](#payment-configuration)

## Environment Variables

The application uses environment variables for configuration. Copy `.env.example` to `.env` and modify the values:

```bash
# Application
APP_NAME=Sal's Memory Maker
APP_ENV=development  # development, staging, production
DEBUG=true
SECRET_KEY=your-secret-key
ALLOWED_HOSTS=localhost,127.0.0.1

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sals_memory_maker
DB_USER=sals_user
DB_PASSWORD=your-password

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
EMAIL_FROM=noreply@salsmemorymaker.com

# Storage
STORAGE_TYPE=local  # local, s3
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_STORAGE_BUCKET_NAME=your-bucket
AWS_REGION=us-east-1

# Payment
STRIPE_PUBLIC_KEY=your-stripe-public-key
STRIPE_SECRET_KEY=your-stripe-secret-key
STRIPE_WEBHOOK_SECRET=your-webhook-secret
```

## Database Configuration

### PostgreSQL Configuration

1. Basic Settings:
   ```ini
   # postgresql.conf
   max_connections = 100
   shared_buffers = 256MB
   effective_cache_size = 768MB
   maintenance_work_mem = 64MB
   checkpoint_completion_target = 0.9
   wal_buffers = 16MB
   default_statistics_target = 100
   random_page_cost = 1.1
   effective_io_concurrency = 200
   work_mem = 4MB
   min_wal_size = 1GB
   max_wal_size = 4GB
   ```

2. Connection Settings:
   ```ini
   # pg_hba.conf
   host    all             all             127.0.0.1/32            md5
   host    all             all             ::1/128                 md5
   ```

### Redis Configuration

1. Basic Settings:
   ```ini
   # redis.conf
   maxmemory 2gb
   maxmemory-policy allkeys-lru
   appendonly yes
   appendfilename "appendonly.aof"
   ```

## Frontend Configuration

### Next.js Configuration

1. `next.config.js`:
   ```javascript
   module.exports = {
     env: {
       NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL,
       NEXT_PUBLIC_APP_URL: process.env.NEXT_PUBLIC_APP_URL,
     },
     images: {
       domains: ['localhost', 'your-domain.com'],
     },
   }
   ```

2. API Configuration:
   ```typescript
   // frontend/src/config/api.ts
   export const API_CONFIG = {
     baseURL: process.env.NEXT_PUBLIC_API_URL,
     timeout: 5000,
     headers: {
       'Content-Type': 'application/json',
     },
   }
   ```

## Backend Configuration

### FastAPI Configuration

1. CORS Settings:
   ```python
   # backend/app/core/config.py
   CORS_ORIGINS = [
       "http://localhost:3000",
       "https://your-domain.com",
   ]
   ```

2. Rate Limiting:
   ```python
   # backend/app/core/config.py
   RATE_LIMIT = {
       "default": "100/minute",
       "auth": "10/minute",
   }
   ```

## Security Configuration

### JWT Configuration

1. Token Settings:
   ```python
   # backend/app/core/security.py
   JWT_CONFIG = {
       "algorithm": "HS256",
       "access_token_expire_minutes": 30,
       "refresh_token_expire_days": 7,
   }
   ```

2. Password Policy:
   ```python
   # backend/app/core/security.py
   PASSWORD_POLICY = {
       "min_length": 8,
       "require_uppercase": True,
       "require_lowercase": True,
       "require_numbers": True,
       "require_special_chars": True,
   }
   ```

## Email Configuration

### SMTP Settings

1. Gmail Configuration:
   ```python
   # backend/app/core/email.py
   SMTP_CONFIG = {
       "host": "smtp.gmail.com",
       "port": 587,
       "username": "your-email@gmail.com",
       "password": "your-app-password",
       "use_tls": True,
   }
   ```

2. Email Templates:
   ```python
   # backend/app/core/email.py
   EMAIL_TEMPLATES = {
       "welcome": "templates/email/welcome.html",
       "password_reset": "templates/email/password_reset.html",
       "order_confirmation": "templates/email/order_confirmation.html",
   }
   ```

## Storage Configuration

### Local Storage

1. File Upload Settings:
   ```python
   # backend/app/core/storage.py
   UPLOAD_CONFIG = {
       "max_size": 10 * 1024 * 1024,  # 10MB
       "allowed_types": ["image/jpeg", "image/png", "application/pdf"],
       "upload_dir": "uploads",
   }
   ```

### AWS S3 Configuration

1. S3 Settings:
   ```python
   # backend/app/core/storage.py
   S3_CONFIG = {
       "bucket_name": "your-bucket",
       "region": "us-east-1",
       "access_key": "your-access-key",
       "secret_key": "your-secret-key",
   }
   ```

## Payment Configuration

### Stripe Configuration

1. API Settings:
   ```python
   # backend/app/core/payment.py
   STRIPE_CONFIG = {
       "public_key": "your-stripe-public-key",
       "secret_key": "your-stripe-secret-key",
       "webhook_secret": "your-webhook-secret",
   }
   ```

2. Product Configuration:
   ```python
   # backend/app/core/payment.py
   PRODUCT_CONFIG = {
       "book_creation": {
           "price_id": "price_xxx",
           "name": "Book Creation",
           "description": "Create a personalized book",
       },
       "premium_features": {
           "price_id": "price_yyy",
           "name": "Premium Features",
           "description": "Access to premium features",
       },
   }
   ```

## Configuration Best Practices

1. Environment Separation:
   - Use different `.env` files for different environments
   - Never commit sensitive values to version control
   - Use environment-specific configuration files

2. Security:
   - Rotate secrets regularly
   - Use strong passwords
   - Enable SSL/TLS
   - Implement rate limiting
   - Use secure headers

3. Performance:
   - Configure caching appropriately
   - Optimize database settings
   - Use CDN for static assets
   - Implement proper logging

4. Monitoring:
   - Set up error tracking
   - Configure performance monitoring
   - Implement logging
   - Set up alerts

For additional configuration options or specific use cases, please refer to the [API Documentation](../development/api.md) or create an issue on GitHub. 