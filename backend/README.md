# Memory Maker Backend

The backend service for the Memory Maker platform, built with FastAPI.

## Features

- RESTful API for book creation and management
- User authentication and authorization
- Book type management
- Payment processing with Stripe
- AI-powered content generation with OpenAI
- Physical book publishing integration
- Database migrations with Alembic

## Prerequisites

- Python 3.9+
- PostgreSQL 14+
- Docker and Docker Compose (optional)

## Installation

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -e ".[dev]"
```

3. Set up environment variables:
- Copy `.env.example` to `.env`
- Fill in the required environment variables

4. Set up the database:
```bash
# Create PostgreSQL database
createdb memorymaker

# Run migrations
alembic upgrade head

# Initialize database with default data
python scripts/init_db.py
```

## Running the Application

### Development

```bash
uvicorn main:app --reload
```

### Production

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

## API Documentation

Once the server is running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Development

### Database Migrations

To create a new migration:
```bash
alembic revision --autogenerate -m "description"
```

To apply migrations:
```bash
alembic upgrade head
```

### Testing

Run tests:
```bash
pytest
```

### Linting and Formatting

Run linters:
```bash
make lint
```

Format code:
```bash
make format
```

### Cleanup

Clean up generated files:
```bash
make clean
```

## Docker

Build the image:
```bash
docker build -t memory-maker-backend .
```

Run the container:
```bash
docker run -p 8000:8000 memory-maker-backend
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. 