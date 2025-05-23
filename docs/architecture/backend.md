# Backend Architecture

This document details the backend architecture of Sal's Memory Maker, built with FastAPI.

## Directory Structure

```
backend/
├── app/
│   ├── api/
│   │   ├── v1/
│   │   │   ├── endpoints/
│   │   │   │   ├── auth.py
│   │   │   │   ├── books.py
│   │   │   │   ├── users.py
│   │   │   │   └── payments.py
│   │   │   └── api.py
│   │   └── deps.py
│   ├── core/
│   │   ├── config.py
│   │   ├── security.py
│   │   └── logging.py
│   ├── db/
│   │   ├── base.py
│   │   └── session.py
│   ├── models/
│   │   ├── user.py
│   │   ├── book.py
│   │   └── payment.py
│   ├── schemas/
│   │   ├── user.py
│   │   ├── book.py
│   │   └── payment.py
│   ├── services/
│   │   ├── auth.py
│   │   ├── book.py
│   │   └── payment.py
│   └── utils/
│       ├── email.py
│       └── storage.py
├── tests/
│   ├── conftest.py
│   ├── test_api/
│   └── test_services/
├── alembic/
│   ├── versions/
│   └── env.py
├── main.py
└── requirements.txt
```

## Core Components

### 1. API Layer (`app/api/`)
- RESTful endpoints
- Request validation
- Response formatting
- Error handling
- Authentication middleware

### 2. Core Configuration (`app/core/`)
- Environment settings
- Security configurations
- Logging setup
- Database connections
- Cache settings

### 3. Database Layer (`app/db/`)
- Database connection management
- Session handling
- Migration support
- Query optimization
- Connection pooling

### 4. Models (`app/models/`)
- SQLAlchemy models
- Database relationships
- Data validation
- Index definitions
- Constraints

### 5. Schemas (`app/schemas/`)
- Pydantic models
- Request/response validation
- Data serialization
- Documentation
- Type hints

### 6. Services (`app/services/`)
- Business logic
- External API integration
- Background tasks
- Error handling
- Transaction management

### 7. Utilities (`app/utils/`)
- Helper functions
- Common utilities
- File handling
- Email sending
- Storage management

## API Endpoints

### Authentication
```python
POST /api/v1/auth/login
POST /api/v1/auth/register
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
```

### Users
```python
GET /api/v1/users/me
PUT /api/v1/users/me
GET /api/v1/users/{user_id}
```

### Books
```python
GET /api/v1/books
POST /api/v1/books
GET /api/v1/books/{book_id}
PUT /api/v1/books/{book_id}
DELETE /api/v1/books/{book_id}
```

### Payments
```python
POST /api/v1/payments/create-intent
POST /api/v1/payments/webhook
GET /api/v1/payments/history
```

## Database Models

### User Model
```python
class User(Base):
    __tablename__ = "users"
    
    id = Column(UUID, primary_key=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)
    is_superuser = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, onupdate=datetime.utcnow)
```

### Book Model
```python
class Book(Base):
    __tablename__ = "books"
    
    id = Column(UUID, primary_key=True)
    title = Column(String)
    content = Column(JSON)
    user_id = Column(UUID, ForeignKey("users.id"))
    status = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, onupdate=datetime.utcnow)
```

## Authentication Flow

1. **Registration**
   ```python
   @router.post("/register")
   async def register(user_in: UserCreate):
       user = await user_service.create_user(user_in)
       return user
   ```

2. **Login**
   ```python
   @router.post("/login")
   async def login(form_data: OAuth2PasswordRequestForm):
       user = await auth_service.authenticate_user(
           form_data.username, form_data.password
       )
       return auth_service.create_tokens(user)
   ```

3. **Token Refresh**
   ```python
   @router.post("/refresh")
   async def refresh_token(refresh_token: str):
       return auth_service.refresh_tokens(refresh_token)
   ```

## Background Tasks

1. **Book Generation**
   ```python
   @router.post("/books/generate")
   async def generate_book(book_in: BookGenerate):
       task = background_tasks.add_task(
           book_service.generate_book_content,
           book_in
       )
       return {"task_id": task.id}
   ```

2. **Email Notifications**
   ```python
   async def send_notification(user_id: UUID, message: str):
       user = await user_service.get_user(user_id)
       await email_service.send_email(
           user.email,
           "Notification",
           message
       )
   ```

## Error Handling

```python
class AppException(Exception):
    def __init__(
        self,
        status_code: int,
        message: str,
        error_code: str = None
    ):
        self.status_code = status_code
        self.message = message
        self.error_code = error_code
```

## Caching Strategy

1. **Redis Configuration**
   ```python
   redis = Redis(
       host=settings.REDIS_HOST,
       port=settings.REDIS_PORT,
       password=settings.REDIS_PASSWORD,
       decode_responses=True
   )
   ```

2. **Cache Decorator**
   ```python
   def cache(expire: int = 300):
       def decorator(func):
           async def wrapper(*args, **kwargs):
               key = f"{func.__name__}:{args}:{kwargs}"
               result = await redis.get(key)
               if result:
                   return json.loads(result)
               result = await func(*args, **kwargs)
               await redis.setex(key, expire, json.dumps(result))
               return result
           return wrapper
       return decorator
   ```

## Testing Strategy

1. **Unit Tests**
   ```python
   def test_create_user():
       user_in = UserCreate(
           email="test@example.com",
           password="password123"
       )
       user = user_service.create_user(user_in)
       assert user.email == user_in.email
   ```

2. **Integration Tests**
   ```python
   async def test_create_book(client, auth_headers):
       response = await client.post(
           "/api/v1/books",
           json={"title": "Test Book"},
           headers=auth_headers
       )
       assert response.status_code == 201
   ```

## Performance Optimization

1. **Database Indexing**
   ```python
   class Book(Base):
       __tablename__ = "books"
       __table_args__ = (
           Index("idx_books_user_id", "user_id"),
           Index("idx_books_status", "status"),
       )
   ```

2. **Query Optimization**
   ```python
   async def get_user_books(user_id: UUID):
       return await db.execute(
           select(Book)
           .options(joinedload(Book.user))
           .where(Book.user_id == user_id)
       )
   ```

## Security Measures

1. **Password Hashing**
   ```python
   def get_password_hash(password: str) -> str:
       return pwd_context.hash(password)
   ```

2. **JWT Token Generation**
   ```python
   def create_access_token(data: dict) -> str:
       return jwt.encode(
           data,
           settings.SECRET_KEY,
           algorithm=settings.ALGORITHM
       )
   ```

## Monitoring and Logging

1. **Logging Configuration**
   ```python
   logging.basicConfig(
       level=logging.INFO,
       format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
   )
   ```

2. **Performance Monitoring**
   ```python
   @app.middleware("http")
   async def add_process_time_header(request, call_next):
       start_time = time.time()
       response = await call_next(request)
       process_time = time.time() - start_time
       response.headers["X-Process-Time"] = str(process_time)
       return response
   ```

For more detailed information about specific components or implementation details, please refer to the respective documentation sections or the source code. 