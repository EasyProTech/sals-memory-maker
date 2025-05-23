import os
import sys
from datetime import datetime
from sqlalchemy.orm import Session
from dotenv import load_dotenv

# Add the parent directory to the Python path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import SessionLocal
from models import BookType

# Load environment variables
load_dotenv()

def init_db():
    db = SessionLocal()
    try:
        # Check if we already have book types
        existing_types = db.query(BookType).count()
        if existing_types > 0:
            print("Book types already exist in the database.")
            return

        # Create default book types
        book_types = [
            BookType(
                name="Children's Bedtime Story",
                description="Create a personalized bedtime story for your child",
                price=19.99,
                preview_price=0.00,
                prompts=["Child's Name", "Age", "Interests", "Favorite Characters"],
                is_active=True,
                created_at=datetime.utcnow()
            ),
            BookType(
                name="Spouse Roasting Book",
                description="Create a fun, personalized roasting book for your significant other",
                price=24.99,
                preview_price=0.00,
                prompts=["Partner's Name", "Inside Jokes", "Funny Stories", "Favorite Activities"],
                is_active=True,
                created_at=datetime.utcnow()
            ),
            BookType(
                name="Family History Book",
                description="Create a personalized family history book with stories and memories",
                price=29.99,
                preview_price=0.00,
                prompts=["Family Name", "Key Events", "Family Members", "Special Memories"],
                is_active=True,
                created_at=datetime.utcnow()
            ),
            BookType(
                name="Pet Adventure Story",
                description="Create a fun adventure story featuring your pet as the main character",
                price=19.99,
                preview_price=0.00,
                prompts=["Pet's Name", "Pet's Species", "Pet's Personality", "Favorite Activities"],
                is_active=True,
                created_at=datetime.utcnow()
            )
        ]

        # Add book types to database
        for book_type in book_types:
            db.add(book_type)
        
        db.commit()
        print("Successfully initialized database with default book types.")
    
    except Exception as e:
        print(f"Error initializing database: {str(e)}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    init_db() 