'use client';

import { useState } from 'react';
import Link from 'next/link';

export default function Home() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <main className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
      {/* Navigation */}
      <nav className="bg-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex">
              <div className="flex-shrink-0 flex items-center">
                <h1 className="text-2xl font-bold text-blue-600">Memory Maker</h1>
              </div>
            </div>
            <div className="hidden sm:ml-6 sm:flex sm:items-center">
              <Link href="/login" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium">
                Login
              </Link>
              <Link href="/register" className="bg-blue-600 text-white hover:bg-blue-700 px-4 py-2 rounded-md text-sm font-medium">
                Register
              </Link>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="text-center">
          <h2 className="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl md:text-6xl">
            <span className="block">Create Your</span>
            <span className="block text-blue-600">Personalized Book</span>
          </h2>
          <p className="mt-3 max-w-md mx-auto text-base text-gray-500 sm:text-lg md:mt-5 md:text-xl md:max-w-3xl">
            Transform your ideas into beautiful, personalized books with AI-generated content, images, and narration.
          </p>
          <div className="mt-5 max-w-md mx-auto sm:flex sm:justify-center md:mt-8">
            <div className="rounded-md shadow">
              <Link href="/create" className="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 md:py-4 md:text-lg md:px-10">
                Start Creating
              </Link>
            </div>
          </div>
        </div>
      </div>

      {/* Book Types Section */}
      <div className="bg-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h2 className="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Choose Your Book Type
            </h2>
            <p className="mt-4 text-lg text-gray-500">
              Select from our variety of book types to create your perfect story
            </p>
          </div>

          <div className="mt-10">
            <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
              {/* Children's Story Card */}
              <div className="bg-white overflow-hidden shadow rounded-lg">
                <div className="px-4 py-5 sm:p-6">
                  <h3 className="text-lg font-medium text-gray-900">Children's Bedtime Story</h3>
                  <p className="mt-2 text-sm text-gray-500">
                    Create a magical bedtime story personalized for your child
                  </p>
                  <div className="mt-4">
                    <Link href="/create/children-story" className="text-blue-600 hover:text-blue-500">
                      Create Now →
                    </Link>
                  </div>
                </div>
              </div>

              {/* Spouse Roasting Card */}
              <div className="bg-white overflow-hidden shadow rounded-lg">
                <div className="px-4 py-5 sm:p-6">
                  <h3 className="text-lg font-medium text-gray-900">Spouse Roasting Book</h3>
                  <p className="mt-2 text-sm text-gray-500">
                    Create a fun, personalized roasting book for your significant other
                  </p>
                  <div className="mt-4">
                    <Link href="/create/spouse-roasting" className="text-blue-600 hover:text-blue-500">
                      Create Now →
                    </Link>
                  </div>
                </div>
              </div>

              {/* More Book Types Coming Soon */}
              <div className="bg-white overflow-hidden shadow rounded-lg">
                <div className="px-4 py-5 sm:p-6">
                  <h3 className="text-lg font-medium text-gray-900">More Coming Soon</h3>
                  <p className="mt-2 text-sm text-gray-500">
                    We're constantly adding new book types. Stay tuned for more options!
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="bg-gray-50">
        <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <p className="text-base text-gray-400">
              © 2024 Memory Maker. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </main>
  );
} 