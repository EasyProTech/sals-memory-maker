.PHONY: install dev build start test lint format clean

install:
	npm install

dev:
	npm run dev

build:
	npm run build

start:
	npm start

test:
	npm test

lint:
	npm run lint

format:
	npx prettier --write "src/**/*.{js,jsx,ts,tsx,json,css,scss,md}"

clean:
	rm -rf .next
	rm -rf node_modules
	rm -rf coverage
	find . -type f -name "*.log" -delete 