"""initial migration

Revision ID: 001
Revises: 
Create Date: 2024-01-01 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '001'
down_revision = None
branch_labels = None
depends_on = None

def upgrade():
    # Create users table
    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('email', sa.String(), nullable=False),
        sa.Column('hashed_password', sa.String(), nullable=False),
        sa.Column('is_active', sa.Boolean(), nullable=False, default=True),
        sa.Column('is_admin', sa.Boolean(), nullable=False, default=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_users_email'), 'users', ['email'], unique=True)

    # Create book_types table
    op.create_table(
        'book_types',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('name', sa.String(), nullable=False),
        sa.Column('description', sa.String(), nullable=False),
        sa.Column('price', sa.Float(), nullable=False),
        sa.Column('preview_price', sa.Float(), nullable=False),
        sa.Column('prompts', postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column('is_active', sa.Boolean(), nullable=False, default=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_book_types_name'), 'book_types', ['name'], unique=True)

    # Create books table
    op.create_table(
        'books',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('title', sa.String(), nullable=False),
        sa.Column('content', postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column('pages', postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column('audio_url', sa.String(), nullable=True),
        sa.Column('status', sa.String(), nullable=False),
        sa.Column('price_paid', sa.Float(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=False),
        sa.Column('owner_id', sa.Integer(), nullable=True),
        sa.Column('book_type_id', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['book_type_id'], ['book_types.id'], ),
        sa.ForeignKeyConstraint(['owner_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_books_title'), 'books', ['title'], unique=False)

    # Create orders table
    op.create_table(
        'orders',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('stripe_payment_id', sa.String(), nullable=False),
        sa.Column('amount', sa.Float(), nullable=False),
        sa.Column('status', sa.String(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=True),
        sa.Column('book_id', sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(['book_id'], ['books.id'], ),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_orders_stripe_payment_id'), 'orders', ['stripe_payment_id'], unique=True)

def downgrade():
    op.drop_index(op.f('ix_orders_stripe_payment_id'), table_name='orders')
    op.drop_table('orders')
    op.drop_index(op.f('ix_books_title'), table_name='books')
    op.drop_table('books')
    op.drop_index(op.f('ix_book_types_name'), table_name='book_types')
    op.drop_table('book_types')
    op.drop_index(op.f('ix_users_email'), table_name='users')
    op.drop_table('users') 