from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from typing import List, Optional
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = FastAPI(title="Memory Maker API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# OAuth2 scheme for token authentication
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

@app.get("/")
async def root():
    return {"message": "Welcome to Memory Maker API"}

# Book types endpoints
@app.get("/book-types")
async def get_book_types():
    return {
        "book_types": [
            {
                "id": 1,
                "name": "Children's Bedtime Story",
                "description": "Create a personalized bedtime story for your child",
                "price": 19.99,
                "preview_price": 0.00
            },
            {
                "id": 2,
                "name": "Spouse Roasting Book",
                "description": "Create a fun, personalized roasting book for your significant other",
                "price": 24.99,
                "preview_price": 0.00
            }
        ]
    }

# User endpoints
@app.post("/users/register")
async def register_user():
    # TODO: Implement user registration
    pass

@app.post("/users/login")
async def login():
    # TODO: Implement user login
    pass

# Book creation endpoints
@app.post("/books/create")
async def create_book():
    # TODO: Implement book creation
    pass

@app.get("/books/{book_id}")
async def get_book(book_id: int):
    # TODO: Implement get book
    pass

# Admin endpoints
@app.post("/admin/book-types")
async def create_book_type():
    # TODO: Implement book type creation
    pass

@app.put("/admin/book-types/{book_type_id}")
async def update_book_type(book_type_id: int):
    # TODO: Implement book type update
    pass

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 