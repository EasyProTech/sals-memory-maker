export interface Book {
  id: string;
  title: string;
  description: string;
  content: string;
  audioUrl: string;
  coverImageUrl?: string;
  createdAt: string;
  updatedAt: string;
  userId: string;
  templateId: string;
  status: 'draft' | 'published' | 'archived';
  isPublished: boolean;
} 