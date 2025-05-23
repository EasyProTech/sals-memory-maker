# Frontend Architecture

This document details the frontend architecture of Sal's Memory Maker, built with Next.js and React.

## Directory Structure

```
frontend/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   └── register/
│   │   ├── (dashboard)/
│   │   │   ├── books/
│   │   │   └── profile/
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── components/
│   │   ├── common/
│   │   │   ├── Button/
│   │   │   ├── Input/
│   │   │   └── Modal/
│   │   ├── books/
│   │   │   ├── BookCard/
│   │   │   └── BookForm/
│   │   └── layout/
│   │       ├── Header/
│   │       └── Footer/
│   ├── hooks/
│   │   ├── useAuth.ts
│   │   ├── useBooks.ts
│   │   └── usePayment.ts
│   ├── services/
│   │   ├── api.ts
│   │   ├── auth.ts
│   │   └── books.ts
│   ├── styles/
│   │   ├── globals.css
│   │   └── tailwind.config.js
│   ├── types/
│   │   ├── book.ts
│   │   ├── user.ts
│   │   └── payment.ts
│   └── utils/
│       ├── constants.ts
│       ├── helpers.ts
│       └── validation.ts
├── public/
│   ├── images/
│   └── fonts/
├── tests/
│   ├── components/
│   └── pages/
└── package.json
```

## Core Components

### 1. Pages (`src/app/`)
- Next.js 13+ App Router
- Server and client components
- Route groups
- Layout management
- Dynamic routes

### 2. Components (`src/components/`)
- Reusable UI components
- Atomic design principles
- Component composition
- State management
- Props validation

### 3. Hooks (`src/hooks/`)
- Custom React hooks
- State management
- Data fetching
- Form handling
- Authentication

### 4. Services (`src/services/`)
- API integration
- Authentication
- Data fetching
- Error handling
- Type safety

### 5. Styles (`src/styles/`)
- Tailwind CSS
- Global styles
- Theme configuration
- Responsive design
- Dark mode

### 6. Types (`src/types/`)
- TypeScript interfaces
- Type definitions
- API types
- Component props
- State types

### 7. Utils (`src/utils/`)
- Helper functions
- Constants
- Validation
- Formatting
- Error handling

## Component Architecture

### 1. Common Components

```typescript
// Button Component
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'outline';
  size: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
}

const Button: React.FC<ButtonProps> = ({
  variant,
  size,
  children,
  onClick,
  disabled
}) => {
  return (
    <button
      className={`btn btn-${variant} btn-${size}`}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </button>
  );
};
```

### 2. Book Components

```typescript
// BookCard Component
interface BookCardProps {
  book: Book;
  onEdit?: (book: Book) => void;
  onDelete?: (book: Book) => void;
}

const BookCard: React.FC<BookCardProps> = ({
  book,
  onEdit,
  onDelete
}) => {
  return (
    <div className="book-card">
      <h3>{book.title}</h3>
      <p>{book.description}</p>
      <div className="actions">
        <Button onClick={() => onEdit?.(book)}>Edit</Button>
        <Button onClick={() => onDelete?.(book)}>Delete</Button>
      </div>
    </div>
  );
};
```

## State Management

### 1. Authentication State

```typescript
// useAuth Hook
const useAuth = () => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  const login = async (credentials: LoginCredentials) => {
    try {
      const response = await authService.login(credentials);
      setUser(response.user);
      return response;
    } catch (error) {
      throw error;
    }
  };

  const logout = async () => {
    await authService.logout();
    setUser(null);
  };

  return { user, loading, login, logout };
};
```

### 2. Book State

```typescript
// useBooks Hook
const useBooks = () => {
  const [books, setBooks] = useState<Book[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchBooks = async () => {
    setLoading(true);
    try {
      const response = await bookService.getBooks();
      setBooks(response.data);
    } catch (error) {
      throw error;
    } finally {
      setLoading(false);
    }
  };

  return { books, loading, fetchBooks };
};
```

## API Integration

### 1. API Client

```typescript
// api.ts
const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
    }
    return Promise.reject(error);
  }
);
```

### 2. Service Layer

```typescript
// books.ts
export const bookService = {
  getBooks: async () => {
    const response = await api.get('/books');
    return response.data;
  },

  createBook: async (book: BookCreate) => {
    const response = await api.post('/books', book);
    return response.data;
  },

  updateBook: async (id: string, book: BookUpdate) => {
    const response = await api.put(`/books/${id}`, book);
    return response.data;
  },

  deleteBook: async (id: string) => {
    await api.delete(`/books/${id}`);
  },
};
```

## Form Handling

### 1. Book Form

```typescript
// BookForm Component
const BookForm: React.FC<BookFormProps> = ({ onSubmit, initialData }) => {
  const form = useForm<BookFormData>({
    defaultValues: initialData,
  });

  const handleSubmit = async (data: BookFormData) => {
    try {
      await onSubmit(data);
    } catch (error) {
      // Handle error
    }
  };

  return (
    <form onSubmit={form.handleSubmit(handleSubmit)}>
      <Input
        label="Title"
        {...form.register('title', { required: true })}
      />
      <TextArea
        label="Description"
        {...form.register('description')}
      />
      <Button type="submit">Save</Button>
    </form>
  );
};
```

## Routing

### 1. App Router

```typescript
// app/layout.tsx
export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <Header />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  );
}

// app/page.tsx
export default function Home() {
  return (
    <div>
      <h1>Welcome to Sal's Memory Maker</h1>
      <BookList />
    </div>
  );
}
```

## Testing

### 1. Component Tests

```typescript
// BookCard.test.tsx
describe('BookCard', () => {
  it('renders book information correctly', () => {
    const book = {
      id: '1',
      title: 'Test Book',
      description: 'Test Description',
    };

    render(<BookCard book={book} />);

    expect(screen.getByText('Test Book')).toBeInTheDocument();
    expect(screen.getByText('Test Description')).toBeInTheDocument();
  });

  it('calls onEdit when edit button is clicked', () => {
    const onEdit = jest.fn();
    const book = {
      id: '1',
      title: 'Test Book',
      description: 'Test Description',
    };

    render(<BookCard book={book} onEdit={onEdit} />);
    fireEvent.click(screen.getByText('Edit'));

    expect(onEdit).toHaveBeenCalledWith(book);
  });
});
```

## Performance Optimization

### 1. Code Splitting

```typescript
// Dynamic imports
const BookEditor = dynamic(() => import('@/components/books/BookEditor'), {
  loading: () => <LoadingSpinner />,
});
```

### 2. Image Optimization

```typescript
// Next.js Image component
import Image from 'next/image';

const BookCover: React.FC<BookCoverProps> = ({ src, alt }) => {
  return (
    <Image
      src={src}
      alt={alt}
      width={300}
      height={400}
      loading="lazy"
      placeholder="blur"
    />
  );
};
```

## Error Handling

### 1. Error Boundary

```typescript
// ErrorBoundary component
class ErrorBoundary extends React.Component<
  { children: React.ReactNode },
  { hasError: boolean }
> {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  render() {
    if (this.state.hasError) {
      return <ErrorFallback />;
    }

    return this.props.children;
  }
}
```

### 2. Error Handling Hook

```typescript
// useError hook
const useError = () => {
  const [error, setError] = useState<Error | null>(null);

  const handleError = (error: Error) => {
    setError(error);
    // Log error to monitoring service
  };

  return { error, handleError };
};
```

## Accessibility

### 1. ARIA Attributes

```typescript
// Accessible Button
const AccessibleButton: React.FC<ButtonProps> = ({
  ariaLabel,
  children,
  ...props
}) => {
  return (
    <button
      aria-label={ariaLabel}
      role="button"
      {...props}
    >
      {children}
    </button>
  );
};
```

### 2. Keyboard Navigation

```typescript
// Keyboard Navigation Hook
const useKeyboardNavigation = (onEnter: () => void) => {
  const handleKeyPress = (event: KeyboardEvent) => {
    if (event.key === 'Enter') {
      onEnter();
    }
  };

  useEffect(() => {
    document.addEventListener('keypress', handleKeyPress);
    return () => {
      document.removeEventListener('keypress', handleKeyPress);
    };
  }, [onEnter]);
};
```

For more detailed information about specific components or implementation details, please refer to the respective documentation sections or the source code. 