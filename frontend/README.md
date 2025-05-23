# Memory Maker Frontend

The frontend application for the Memory Maker platform, built with Next.js and React.

## Features

- Modern, responsive user interface
- Book creation wizard
- Preview functionality
- Payment integration with Stripe
- Admin dashboard
- User authentication

## Prerequisites

- Node.js 18+
- npm or yarn
- Docker and Docker Compose (optional)

## Installation

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables:
- Copy `.env.example` to `.env`
- Fill in the required environment variables

## Running the Application

### Development

```bash
npm run dev
```

### Production

```bash
npm run build
npm start
```

## Development

### Testing

Run tests:
```bash
npm test
```

### Linting and Formatting

Run linters:
```bash
npm run lint
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
docker build -t memory-maker-frontend .
```

Run the container:
```bash
docker run -p 3000:3000 memory-maker-frontend
```

## Project Structure

```
src/
  ├── app/              # Next.js app directory
  ├── components/       # Reusable React components
  ├── hooks/           # Custom React hooks
  ├── services/        # API service functions
  ├── styles/          # Global styles and Tailwind config
  ├── types/           # TypeScript type definitions
  └── utils/           # Utility functions
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. 