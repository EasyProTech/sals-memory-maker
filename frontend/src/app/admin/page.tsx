'use client';

import { useState } from 'react';

interface BookType {
  id: number;
  name: string;
  description: string;
  price: number;
  preview_price: number;
  prompts: string[];
}

export default function AdminDashboard() {
  const [bookTypes, setBookTypes] = useState<BookType[]>([
    {
      id: 1,
      name: "Children's Bedtime Story",
      description: "Create a personalized bedtime story for your child",
      price: 19.99,
      preview_price: 0.00,
      prompts: ["Child's Name", "Age", "Interests", "Favorite Characters"]
    },
    {
      id: 2,
      name: "Spouse Roasting Book",
      description: "Create a fun, personalized roasting book for your significant other",
      price: 24.99,
      preview_price: 0.00,
      prompts: ["Partner's Name", "Inside Jokes", "Funny Stories", "Favorite Activities"]
    }
  ]);

  const [editingBookType, setEditingBookType] = useState<BookType | null>(null);

  const handleEdit = (bookType: BookType) => {
    setEditingBookType(bookType);
  };

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    if (editingBookType) {
      setBookTypes(bookTypes.map(bt => 
        bt.id === editingBookType.id ? editingBookType : bt
      ));
      setEditingBookType(null);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="bg-white shadow rounded-lg p-6">
          <h1 className="text-2xl font-bold text-gray-900 mb-6">Admin Dashboard</h1>

          {/* Book Types Management */}
          <div className="mb-8">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">Book Types</h2>
            <div className="space-y-4">
              {bookTypes.map((bookType) => (
                <div key={bookType.id} className="border rounded-lg p-4">
                  {editingBookType?.id === bookType.id ? (
                    <form onSubmit={handleSave} className="space-y-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700">Name</label>
                        <input
                          type="text"
                          value={editingBookType.name}
                          onChange={(e) => setEditingBookType({...editingBookType, name: e.target.value})}
                          className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">Description</label>
                        <textarea
                          value={editingBookType.description}
                          onChange={(e) => setEditingBookType({...editingBookType, description: e.target.value})}
                          className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700">Price</label>
                        <input
                          type="number"
                          step="0.01"
                          value={editingBookType.price}
                          onChange={(e) => setEditingBookType({...editingBookType, price: parseFloat(e.target.value)})}
                          className="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                        />
                      </div>
                      <div className="flex justify-end space-x-2">
                        <button
                          type="button"
                          onClick={() => setEditingBookType(null)}
                          className="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50"
                        >
                          Cancel
                        </button>
                        <button
                          type="submit"
                          className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
                        >
                          Save
                        </button>
                      </div>
                    </form>
                  ) : (
                    <div>
                      <div className="flex justify-between items-start">
                        <div>
                          <h3 className="text-lg font-medium text-gray-900">{bookType.name}</h3>
                          <p className="mt-1 text-sm text-gray-500">{bookType.description}</p>
                          <p className="mt-2 text-sm text-gray-700">Price: ${bookType.price}</p>
                          <p className="text-sm text-gray-700">Preview Price: ${bookType.preview_price}</p>
                        </div>
                        <button
                          onClick={() => handleEdit(bookType)}
                          className="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50"
                        >
                          Edit
                        </button>
                      </div>
                      <div className="mt-4">
                        <h4 className="text-sm font-medium text-gray-700">Required Prompts:</h4>
                        <ul className="mt-2 list-disc list-inside text-sm text-gray-500">
                          {bookType.prompts.map((prompt, index) => (
                            <li key={index}>{prompt}</li>
                          ))}
                        </ul>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>

          {/* Add New Book Type Button */}
          <div>
            <button
              className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
            >
              Add New Book Type
            </button>
          </div>
        </div>
      </div>
    </div>
  );
} 