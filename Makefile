COMPOSE := docker compose

.PHONY: ci test dev up run-setup

ci:
	$(COMPOSE) -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

test:
	$(COMPOSE) -f docker-compose.yml up --abort-on-container-exit --exit-code-from app

dev:
	$(COMPOSE) up

up:
	$(COMPOSE) up

run-setup:
	$(COMPOSE) run --rm app make setup
