#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Function to configure git
configure_git() {
    local install_dir="$1"
    echo "Configuring Git..."
    
    # Set default branch to main
    git config --global init.defaultBranch main
    
    # Configure Git user if not already set
    if [ -z "$(git config --global user.name)" ]; then
        read -p "Enter your name for Git commits: " git_name
        git config --global user.name "$git_name"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        read -p "Enter your email for Git commits: " git_email
        git config --global user.email "$git_email"
    fi
    
    # Configure GitHub credentials
    echo "GitHub Authentication Setup"
    echo "---------------------------"
    echo "To push to GitHub, you need to create a Personal Access Token (PAT):"
    echo "1. Go to GitHub.com → Settings → Developer Settings → Personal Access Tokens → Tokens (classic)"
    echo "2. Click 'Generate new token'"
    echo "3. Give it a name (e.g., 'Sal's Memory Maker')"
    echo "4. Select scopes: 'repo' (full control of private repositories)"
    echo "5. Click 'Generate token' and copy it"
    echo ""
    read -p "Enter your GitHub Personal Access Token: " github_token
    
    # Store the token in the git credential helper
    git config --global credential.helper store
    echo "https://${github_token}@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
    
    # Change to installation directory
    cd "$install_dir" || handle_error "Failed to change to installation directory"
    
    # Initialize git repository
    git init || handle_error "Failed to initialize git repository"
    
    # Create initial branch as main
    git branch -m main || handle_error "Failed to rename branch to main"
}

# Function to setup GitHub repository
setup_github_repo() {
    local install_dir="$1"
    local repo_name="sals-memory-maker"
    local org_name="EasyProTech"
    
    echo "Setting up GitHub repository..."
    
    # Check if repository already exists
    if curl -s -f "https://api.github.com/repos/${org_name}/${repo_name}" > /dev/null; then
        echo "Repository already exists on GitHub"
    else
        # Create new repository
        echo "Creating new repository on GitHub..."
        curl -X POST \
            -H "Authorization: token $(cat ~/.git-credentials | cut -d'@' -f1 | cut -d'/' -f3)" \
            -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/orgs/${org_name}/repos \
            -d "{\"name\":\"${repo_name}\",\"private\":false,\"auto_init\":false}" \
            || handle_error "Failed to create GitHub repository"
    fi
    
    # Add remote and push
    cd "$install_dir" || handle_error "Failed to change to installation directory"
    
    # Remove existing remote if it exists
    git remote remove origin 2>/dev/null
    
    # Add new remote with token
    local token=$(cat ~/.git-credentials | cut -d'@' -f1 | cut -d'/' -f3)
    git remote add origin "https://${token}@github.com/${org_name}/${repo_name}.git" || handle_error "Failed to add remote"
    
    # Check if remote has content
    echo "Checking remote repository..."
    git fetch origin || handle_error "Failed to fetch from remote"
    
    if git ls-remote --heads origin main | grep -q main; then
        echo "Remote repository has content. Handling merge..."
        
        # Create a temporary branch for the remote content
        git checkout -b temp_remote origin/main || handle_error "Failed to create temporary branch"
        
        # Switch back to main branch
        git checkout main || handle_error "Failed to switch back to main branch"
        
        # Reset to the state before the merge attempt
        git reset --hard HEAD || handle_error "Failed to reset to HEAD"
        
        # Force push local changes
        echo "Pushing local changes to GitHub..."
        git push -f origin main || handle_error "Failed to force push to GitHub"
        
        # Clean up temporary branch
        git branch -D temp_remote || handle_error "Failed to delete temporary branch"
    else
        # If no remote content, just push normally
        echo "Pushing changes to GitHub..."
        git push -u origin main || handle_error "Failed to push to GitHub"
    fi
    
    echo "GitHub repository setup complete!"
    echo "Repository URL: https://github.com/${org_name}/${repo_name}"
}

# Function to create project structure
create_project_structure() {
    local install_dir="/opt/sals-memory-maker"
    echo "Creating project structure..."
    
    # Create main directories if they don't exist
    mkdir -p "$install_dir"/{backend,frontend,docs}
    mkdir -p "$install_dir"/backend/{app,tests}
    mkdir -p "$install_dir"/frontend/{src,public}
    mkdir -p "$install_dir"/docs/{api,user-guide,admin-guide}

    # Only create these files if they don't exist
    if [ ! -f "$install_dir/backend/requirements.txt" ]; then
        cat > "$install_dir/backend/requirements.txt" << EOL
fastapi==0.104.1
uvicorn==0.24.0
sqlalchemy==2.0.23
alembic==1.12.1
psycopg2-binary==2.9.9
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
python-dotenv==1.0.0
openai==1.3.5
stripe==7.6.0
pillow==10.1.0
requests==2.31.0
pytest==7.4.3
httpx==0.25.2
EOL
    fi

    if [ ! -f "$install_dir/frontend/package.json" ]; then
        cat > "$install_dir/frontend/package.json" << EOL
{
  "name": "sals-memory-maker-frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "@emotion/react": "^11.11.0",
    "@emotion/styled": "^11.11.0",
    "@mui/icons-material": "^5.13.0",
    "@mui/material": "^5.13.0",
    "@stripe/stripe-js": "^2.2.0",
    "next": "13.4.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "axios": "^1.6.2",
    "qrcode.react": "^3.1.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "typescript": "^5.0.0",
    "eslint": "^8.39.0",
    "eslint-config-next": "13.4.0"
  }
}
EOL
    fi

    # Create docker-compose.yml if it doesn't exist
    if [ ! -f "$install_dir/docker-compose.yml" ]; then
        cat > "$install_dir/docker-compose.yml" << EOL
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://sals_user:your_secure_password@db:5432/sals_memory_maker
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:8000
    depends_on:
      - backend

  db:
    image: postgres:14
    environment:
      - POSTGRES_USER=sals_user
      - POSTGRES_PASSWORD=your_secure_password
      - POSTGRES_DB=sals_memory_maker
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:6
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
EOL
    fi

    # Create README.md if it doesn't exist
    if [ ! -f "$install_dir/README.md" ]; then
        cat > "$install_dir/README.md" << EOL
# Sal's Memory Maker

A personalized book creation platform that allows users to create custom memory books with various features including audio versions and QR code access.

## Features

- Multiple book types (Photo Books, Story Books, Memory Books)
- User registration and authentication
- Payment integration with Stripe
- Audio book generation
- QR code access to audio versions
- Admin dashboard
- Mobile-responsive design

## Getting Started

See the [Installation Guide](docs/installation.md) for setup instructions.

## Documentation

- [User Guide](docs/user-guide/README.md)
- [Admin Guide](docs/admin-guide/README.md)
- [API Documentation](docs/api/README.md)

## License

MIT License
EOL
    fi

    # Create .gitignore if it doesn't exist
    if [ ! -f "$install_dir/.gitignore" ]; then
        cat > "$install_dir/.gitignore" << EOL
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg
venv/

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.next/
out/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.idea/
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOL
    fi

    # Configure Git and create initial commit
    configure_git "$install_dir"
    
    # Add files and create initial commit
    git add . || handle_error "Failed to add files to git"
    git commit -m "Initial project structure" || handle_error "Failed to create initial commit"
    
    # Setup GitHub repository
    setup_github_repo "$install_dir"
}

# Function to handle existing installation
handle_existing_installation() {
    local install_dir="/opt/sals-memory-maker"
    if [ -d "$install_dir" ] && [ "$(ls -A $install_dir)" ]; then
        echo "Existing installation found at $install_dir"
        echo "Checking for existing files..."
        
        # Check if frontend and backend directories exist and have content
        if [ -d "$install_dir/frontend" ] && [ "$(ls -A $install_dir/frontend)" ]; then
            echo "Frontend files found - will preserve them"
        fi
        
        if [ -d "$install_dir/backend" ] && [ "$(ls -A $install_dir/backend)" ]; then
            echo "Backend files found - will preserve them"
        fi
        
        # Only update configuration files
        echo "Updating configuration files..."
        
        # Update docker-compose.yml if it exists
        if [ -f "$install_dir/docker-compose.yml" ]; then
            echo "Updating docker-compose.yml..."
            cp docker-compose.yml "$install_dir/docker-compose.yml.new"
            mv "$install_dir/docker-compose.yml.new" "$install_dir/docker-compose.yml"
        fi
        
        # Update .env file if it exists
        if [ -f "$install_dir/.env" ]; then
            echo "Updating .env file..."
            cp .env "$install_dir/.env.new"
            mv "$install_dir/.env.new" "$install_dir/.env"
        fi
        
        # Update systemd service if it exists
        if [ -f "/etc/systemd/system/sals-memory-maker.service" ]; then
            echo "Updating systemd service..."
            cp /etc/systemd/system/sals-memory-maker.service /etc/systemd/system/sals-memory-maker.service.new
            mv /etc/systemd/system/sals-memory-maker.service.new /etc/systemd/system/sals-memory-maker.service
        fi
        
        # Update Nginx configuration if it exists
        if [ -f "/etc/nginx/sites-available/sals-memory-maker" ]; then
            echo "Updating Nginx configuration..."
            cp /etc/nginx/sites-available/sals-memory-maker /etc/nginx/sites-available/sals-memory-maker.new
            mv /etc/nginx/sites-available/sals-memory-maker.new /etc/nginx/sites-available/sals-memory-maker
        fi
        
        echo "Configuration files updated successfully"
    else
        mkdir -p "$install_dir" || handle_error "Failed to create installation directory"
    fi
}

# Update system
echo "Updating system packages..."
apt update && apt upgrade -y || handle_error "Failed to update system packages"

# Install required packages
echo "Installing required packages..."
apt install -y \
    python3 \
    python3-venv \
    python3-pip \
    postgresql \
    postgresql-contrib \
    redis-server \
    nginx \
    git \
    curl \
    build-essential \
    libpq-dev \
    python3-dev || handle_error "Failed to install required packages"

# Install Node.js 20.x LTS
echo "Installing Node.js 20.x LTS..."
if ! command_exists node; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - || handle_error "Failed to setup Node.js repository"
    apt install -y nodejs || handle_error "Failed to install Node.js"
fi

# Install Docker and Docker Compose
echo "Installing Docker and Docker Compose..."
if ! command_exists docker; then
    curl -fsSL https://get.docker.com -o get-docker.sh || handle_error "Failed to download Docker installation script"
    sh get-docker.sh || handle_error "Failed to install Docker"
    rm get-docker.sh
fi

if ! command_exists docker-compose; then
    curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose || handle_error "Failed to download Docker Compose"
    chmod +x /usr/local/bin/docker-compose || handle_error "Failed to make Docker Compose executable"
fi

# Handle existing installation
echo "Checking for existing installation..."
handle_existing_installation

# Create project structure
create_project_structure

# Set up environment variables
echo "Setting up environment variables..."
cat > /opt/sals-memory-maker/.env << EOL
# Backend
DATABASE_URL=postgresql://sals_user:your_secure_password@localhost:5432/sals_memory_maker
REDIS_URL=redis://localhost:6379
SECRET_KEY=your_secret_key_here
ENVIRONMENT=production

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_STRIPE_PUBLIC_KEY=your_stripe_public_key

# Storage
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_BUCKET_NAME=your_bucket_name
EOL

# Set up PostgreSQL
echo "Setting up PostgreSQL..."
if ! command_exists psql; then
    handle_error "PostgreSQL is not installed"
fi

# Function to check if PostgreSQL user exists
check_postgres_user() {
    local username="$1"
    sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$username'" | grep -q 1
    return $?
}

# Function to check if PostgreSQL database exists
check_postgres_db() {
    local dbname="$1"
    sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$dbname'" | grep -q 1
    return $?
}

# Create PostgreSQL user if it doesn't exist
if ! check_postgres_user "sals_user"; then
    echo "Creating PostgreSQL user..."
    sudo -u postgres psql -c "CREATE USER sals_user WITH PASSWORD 'your_secure_password';" || handle_error "Failed to create PostgreSQL user"
else
    echo "PostgreSQL user 'sals_user' already exists"
    read -p "Do you want to update the password for 'sals_user'? (y/N): " update_password
    if [[ $update_password =~ ^[Yy]$ ]]; then
        sudo -u postgres psql -c "ALTER USER sals_user WITH PASSWORD 'your_secure_password';" || handle_error "Failed to update PostgreSQL user password"
    fi
fi

# Create PostgreSQL database if it doesn't exist
if ! check_postgres_db "sals_memory_maker"; then
    echo "Creating PostgreSQL database..."
    sudo -u postgres psql -c "CREATE DATABASE sals_memory_maker;" || handle_error "Failed to create PostgreSQL database"
else
    echo "PostgreSQL database 'sals_memory_maker' already exists"
    read -p "Do you want to recreate the database? This will delete all existing data! (y/N): " recreate_db
    if [[ $recreate_db =~ ^[Yy]$ ]]; then
        sudo -u postgres psql -c "DROP DATABASE sals_memory_maker;" || handle_error "Failed to drop existing database"
        sudo -u postgres psql -c "CREATE DATABASE sals_memory_maker;" || handle_error "Failed to create PostgreSQL database"
    fi
fi

# Grant privileges
echo "Granting database privileges..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sals_memory_maker TO sals_user;" || handle_error "Failed to grant database privileges"

# Set up Nginx
echo "Setting up Nginx..."
if ! command_exists nginx; then
    handle_error "Nginx is not installed"
fi

mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled || handle_error "Failed to create Nginx directories"

cat > /etc/nginx/sites-available/sals-memory-maker << EOL
server {
    listen 80;
    server_name your_domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /api {
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

ln -sf /etc/nginx/sites-available/sals-memory-maker /etc/nginx/sites-enabled/ || handle_error "Failed to create Nginx symlink"
nginx -t && systemctl restart nginx || handle_error "Failed to restart Nginx"

# Set up systemd service for the backend
echo "Setting up systemd service..."
cat > /etc/systemd/system/sals-memory-maker.service << EOL
[Unit]
Description=Sal's Memory Maker Backend
After=network.target

[Service]
User=root
WorkingDirectory=/opt/sals-memory-maker
Environment="PATH=/opt/sals-memory-maker/venv/bin"
ExecStart=/opt/sals-memory-maker/venv/bin/uvicorn backend.main:app --host 0.0.0.0 --port 8000
Restart=always

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload || handle_error "Failed to reload systemd"
systemctl enable sals-memory-maker || handle_error "Failed to enable service"
systemctl start sals-memory-maker || handle_error "Failed to start service"

echo "Installation complete!"
echo "Please update the following in the .env file:"
echo "1. Database password"
echo "2. Secret key"
echo "3. Stripe keys"
echo "4. AWS credentials"
echo "5. Domain name in Nginx configuration"
echo ""
echo "The application should now be running at:"
echo "Frontend: http://your_domain.com"
echo "Backend API: http://your_domain.com/api"
echo "API Documentation: http://your_domain.com/api/docs"

# Function to setup frontend
setup_frontend() {
    local install_dir="$1"
    echo "Setting up frontend..."
    
    cd "$install_dir/frontend" || handle_error "Failed to change to frontend directory"
    
    # Install dependencies
    echo "Installing frontend dependencies..."
    npm install || handle_error "Failed to install frontend dependencies"
    
    # Build frontend
    echo "Building frontend..."
    npm run build || handle_error "Failed to build frontend"
    
    # Create production environment file
    cat > .env.production << EOL
NEXT_PUBLIC_API_URL=https://your_domain.com/api
NEXT_PUBLIC_STRIPE_PUBLIC_KEY=your_stripe_public_key
EOL
}

# Function to setup backend
setup_backend() {
    local install_dir="$1"
    echo "Setting up backend..."
    
    cd "$install_dir/backend" || handle_error "Failed to change to backend directory"
    
    # Create Python virtual environment
    echo "Creating Python virtual environment..."
    python3 -m venv venv || handle_error "Failed to create virtual environment"
    
    # Activate virtual environment and install dependencies
    echo "Installing backend dependencies..."
    source venv/bin/activate || handle_error "Failed to activate virtual environment"
    pip install -r requirements.txt || handle_error "Failed to install backend dependencies"
    
    # Create production environment file
    cat > .env.production << EOL
DATABASE_URL=postgresql://sals_user:your_secure_password@localhost:5432/sals_memory_maker
REDIS_URL=redis://localhost:6379
SECRET_KEY=your_secret_key_here
ENVIRONMENT=production
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_BUCKET_NAME=your_bucket_name
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret
EOL
    
    # Run database migrations
    echo "Running database migrations..."
    alembic upgrade head || handle_error "Failed to run database migrations"
}

# Function to upload files
upload_files() {
    local install_dir="$1"
    echo "Uploading project files..."
    
    # Create necessary directories
    mkdir -p "$install_dir"/{frontend,backend}
    
    # Upload frontend files
    echo "Uploading frontend files..."
    rsync -av --exclude 'node_modules' --exclude '.next' --exclude '.git' ./frontend/ "$install_dir/frontend/" || handle_error "Failed to upload frontend files"
    
    # Upload backend files
    echo "Uploading backend files..."
    rsync -av --exclude 'venv' --exclude '__pycache__' --exclude '.git' ./backend/ "$install_dir/backend/" || handle_error "Failed to upload backend files"
    
    # Setup frontend and backend
    setup_frontend "$install_dir"
    setup_backend "$install_dir"
} 