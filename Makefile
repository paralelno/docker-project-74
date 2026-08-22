.PHONY: test dev up run-setup

test:
	docker-compose -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

dev:
	docker-compose up

up:
	docker-compose up

run-setup:
	docker-compose run --rm app make setup
