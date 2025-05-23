.PHONY: install dev build start test lint format clean docker-build docker-up docker-down

install:
	cd backend && make install
	cd frontend && make install

dev:
	docker-compose up

build:
	cd backend && make build
	cd frontend && make build

start:
	docker-compose up -d

test:
	cd backend && make test
	cd frontend && make test

lint:
	cd backend && make lint
	cd frontend && make lint

format:
	cd backend && make format
	cd frontend && make format

clean:
	cd backend && make clean
	cd frontend && make clean
	docker-compose down -v

docker-build:
	docker-compose build

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down 