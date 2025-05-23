<<<<<<< HEAD
# Memory Maker

A platform for creating personalized memory books with AI-powered content generation and physical book publishing.

## Features

- Create personalized memory books with AI assistance
- Multiple book types and themes
- Preview functionality
- Secure payment processing
- Physical book publishing
- Admin dashboard for book management
- User authentication and authorization

## Tech Stack

### Backend
- FastAPI (Python)
- PostgreSQL
- SQLAlchemy
- Alembic
- OpenAI API
- Stripe API
- JWT Authentication

### Frontend
- Next.js
- React
- TypeScript
- Tailwind CSS
- Stripe Elements
- Jest
- React Testing Library

## Prerequisites

- Python 3.9+
- Node.js 18+
- PostgreSQL 14+
- Docker and Docker Compose

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/yourusername/memory-maker.git
cd memory-maker
```

2. Set up environment variables:
- Copy `.env.example` to `.env`
- Fill in the required environment variables

3. Start the development environment:
```bash
make dev
```

This will start:
- Backend API at http://localhost:8000
- Frontend application at http://localhost:3000
- PostgreSQL database at localhost:5432

## Development

### Backend

See [backend/README.md](backend/README.md) for detailed instructions.

### Frontend

See [frontend/README.md](frontend/README.md) for detailed instructions.

## Testing

Run all tests:
```bash
make test
```

## Linting and Formatting

Run all linters:
```bash
make lint
```

Format all code:
```bash
make format
```

## Docker

Build all containers:
```bash
make docker-build
```

Start all services:
```bash
make docker-up
```

Stop all services:
```bash
make docker-down
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 
=======
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
>>>>>>> 5289e0916736ab6fb0062a2799ec12e3a9a432e6
