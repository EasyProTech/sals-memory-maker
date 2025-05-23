# Installation Guide

This guide provides detailed instructions for installing and setting up Sal's Memory Maker in different environments.

## Table of Contents
1. [Development Installation](#development-installation)
2. [Production Installation](#production-installation)
3. [Docker Installation](#docker-installation)
4. [Manual Installation](#manual-installation)
5. [Post-Installation Steps](#post-installation-steps)

## Development Installation

### Prerequisites
1. Install Python 3.8 or higher
2. Install Node.js 16.x or higher
3. Install Git
4. Install Docker and Docker Compose

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/sals-memory-maker.git
   cd sals-memory-maker
   ```

2. Create and activate a Python virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Install frontend dependencies:
   ```bash
   cd frontend
   npm install
   ```

5. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

6. Start the development servers:
   ```bash
   # Terminal 1 - Backend
   cd backend
   uvicorn main:app --reload

   # Terminal 2 - Frontend
   cd frontend
   npm run dev
   ```

## Production Installation

### Prerequisites
1. A server with Ubuntu 20.04 LTS or later
2. Domain name and SSL certificate
3. PostgreSQL 13 or higher
4. Redis 6 or higher
5. Nginx 1.18 or higher

### Steps

1. Update system packages:
   ```bash
   sudo apt update
   sudo apt upgrade -y
   ```

2. Install required system packages:
   ```bash
   sudo apt install -y python3.8 python3.8-venv python3.8-dev
   sudo apt install -y nodejs npm
   sudo apt install -y postgresql postgresql-contrib
   sudo apt install -y redis-server
   sudo apt install -y nginx
   ```

3. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/sals-memory-maker.git
   cd sals-memory-maker
   ```

4. Set up the Python environment:
   ```bash
   python3.8 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

5. Set up the frontend:
   ```bash
   cd frontend
   npm install
   npm run build
   ```

6. Configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with production settings
   ```

7. Set up the database:
   ```bash
   sudo -u postgres psql
   CREATE DATABASE sals_memory_maker;
   CREATE USER sals_user WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE sals_memory_maker TO sals_user;
   ```

8. Configure Nginx:
   ```bash
   sudo cp nginx/sals-memory-maker.conf /etc/nginx/sites-available/
   sudo ln -s /etc/nginx/sites-available/sals-memory-maker.conf /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

## Docker Installation

1. Install Docker and Docker Compose:
   ```bash
   # Follow Docker's official installation guide for your OS
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/sals-memory-maker.git
   cd sals-memory-maker
   ```

3. Configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

4. Start the containers:
   ```bash
   docker-compose up -d
   ```

## Manual Installation

If you prefer to install components manually:

1. Install PostgreSQL:
   ```bash
   sudo apt install postgresql postgresql-contrib
   ```

2. Install Redis:
   ```bash
   sudo apt install redis-server
   ```

3. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Install Node.js dependencies:
   ```bash
   cd frontend
   npm install
   ```

## Post-Installation Steps

1. Initialize the database:
   ```bash
   python manage.py db upgrade
   ```

2. Create an admin user:
   ```bash
   python manage.py create_admin
   ```

3. Verify the installation:
   - Access the frontend at http://localhost:3000
   - Access the API at http://localhost:8000
   - Check the API documentation at http://localhost:8000/docs

4. Set up monitoring:
   ```bash
   # Install monitoring tools
   pip install prometheus-client
   ```

5. Configure backups:
   ```bash
   # Set up automated database backups
   crontab -e
   # Add backup schedule
   ```

## Troubleshooting

If you encounter issues during installation:

1. Check the logs:
   ```bash
   # Backend logs
   tail -f backend/logs/app.log

   # Frontend logs
   tail -f frontend/logs/app.log
   ```

2. Verify service status:
   ```bash
   sudo systemctl status postgresql
   sudo systemctl status redis
   sudo systemctl status nginx
   ```

3. Check network connectivity:
   ```bash
   netstat -tulpn | grep LISTEN
   ```

4. Review configuration files:
   ```bash
   # Check Nginx configuration
   sudo nginx -t

   # Check PostgreSQL configuration
   sudo -u postgres psql -c "SHOW config_file;"
   ```

For additional help, please refer to the [Troubleshooting Guide](../troubleshooting/README.md) or create an issue on GitHub. 