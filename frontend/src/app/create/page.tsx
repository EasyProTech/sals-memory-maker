'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function CreateBook() {
  const router = useRouter();
  const [bookType, setBookType] = useState('');
  const [formData, setFormData] = useState({
    title: '',
    name: '',
    age: '',
    interests: '',
    voiceType: 'friendly',
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    // TODO: Implement book creation logic
    console.log('Creating book with data:', { bookType, ...formData });
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="bg-white shadow rounded-lg p-6">
          <h1 className="text-2xl font-bold text-gray-900 mb-6">Create Your Book</h1>
          
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Book Type Selection */}
            <div>
              <label htmlFor="bookType" className="block text-sm font-medium text-gray-700">
                Book Type
              </label>
              <select
                id="bookType"
                value={bookType}
                onChange={(e) => setBookType(e.target.value)}
                className="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md"
                required
              >
                <option value="">Select a book type</option>
                <option value="children-story">Children's Bedtime Story</option>
                <option value="spouse-roasting">Spouse Roasting Book</option>
              </select>
            </div>

            {/* Title */}
            <div>
              <label htmlFor="title" className="block text-sm font-medium text-gray-700">
                Book Title
              </label>
              <input
                type="text"
                id="title"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                required
              />
            </div>

            {/* Name */}
            <div>
              <label htmlFor="name" className="block text-sm font-medium text-gray-700">
                Name
              </label>
              <input
                type="text"
                id="name"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                required
              />
            </div>

            {/* Age (for children's stories) */}
            {bookType === 'children-story' && (
              <div>
                <label htmlFor="age" className="block text-sm font-medium text-gray-700">
                  Child's Age
                </label>
                <input
                  type="number"
                  id="age"
                  value={formData.age}
                  onChange={(e) => setFormData({ ...formData, age: e.target.value })}
                  className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                  required
                />
              </div>
            )}

            {/* Interests */}
            <div>
              <label htmlFor="interests" className="block text-sm font-medium text-gray-700">
                Interests
              </label>
              <textarea
                id="interests"
                value={formData.interests}
                onChange={(e) => setFormData({ ...formData, interests: e.target.value })}
                rows={3}
                className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                placeholder="Enter interests, hobbies, or specific details to include in the story"
                required
              />
            </div>

            {/* Voice Type */}
            <div>
              <label htmlFor="voiceType" className="block text-sm font-medium text-gray-700">
                Voice Type
              </label>
              <select
                id="voiceType"
                value={formData.voiceType}
                onChange={(e) => setFormData({ ...formData, voiceType: e.target.value })}
                className="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md"
              >
                <option value="friendly">Friendly</option>
                <option value="professional">Professional</option>
                <option value="storyteller">Storyteller</option>
                <option value="humorous">Humorous</option>
              </select>
            </div>

            {/* Submit Button */}
            <div>
              <button
                type="submit"
                className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                Create Preview
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
} 