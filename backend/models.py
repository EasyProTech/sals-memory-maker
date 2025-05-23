from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Float, DateTime, JSON
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)
    is_admin = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    books = relationship("Book", back_populates="owner")

class BookType(Base):
    __tablename__ = "book_types"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(String)
    price = Column(Float)
    preview_price = Column(Float)
    prompts = Column(JSON)  # Store the required prompts for this book type
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    books = relationship("Book", back_populates="book_type")

class Book(Base):
    __tablename__ = "books"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    content = Column(JSON)  # Store the generated content
    pages = Column(JSON)  # Store the generated pages with images
    audio_url = Column(String)  # URL to the generated audio file
    status = Column(String)  # preview, purchased, published
    price_paid = Column(Float)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Foreign keys
    owner_id = Column(Integer, ForeignKey("users.id"))
    book_type_id = Column(Integer, ForeignKey("book_types.id"))
    
    # Relationships
    owner = relationship("User", back_populates="books")
    book_type = relationship("BookType", back_populates="books")

class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    stripe_payment_id = Column(String, unique=True)
    amount = Column(Float)
    status = Column(String)  # pending, completed, failed
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Foreign keys
    user_id = Column(Integer, ForeignKey("users.id"))
    book_id = Column(Integer, ForeignKey("books.id")) 