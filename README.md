# Docker Compose Hexlet Project

[![push](https://github.com/paralelno/docker-project-74/actions/workflows/push.yml/badge.svg)](https://github.com/paralelno/docker-project-74/actions/workflows/push.yml)

### Hexlet tests and linter status:
[![Actions Status](https://github.com/paralelno/docker-project-74/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/paralelno/docker-project-74/actions)

Проект «Упаковка в Docker Compose» (Hexlet): приложение **js-fastify-blog**
упаковано в Docker Compose — тесты, продакшен-образ, reverse-proxy (Caddy)
и база данных (PostgreSQL).

## Требования

- Docker Engine 20.10+ (или совместимый Podman)
- Docker Compose v2 (`docker compose`)
- Доступ в интернет (pull образов `node:26`, `caddy:2-alpine`, `postgres:latest`)
- ~2 ГБ свободного места под образы

## Образы и репозиторий

- Продакшен-образ публикуется на Docker Hub: **`paralelnodev/docker-project-74`**
  <https://hub.docker.com/r/paralelnodev/docker-project-74>
- Dev-образ собирается локально из `Dockerfile`, продакшен — из `Dockerfile.production`.
- Сборка/публикация образа происходят в CI (`.github/workflows/push.yml`) при push в `main`.

## Структура

| Файл | Назначение |
|---|---|
| `Dockerfile` | dev-образ (для разработки и отладки) |
| `Dockerfile.production` | продакшен-образ (собирается и пушится в CI) |
| `docker-compose.yml` | продакшен-состав: `app` (test) + `db` (postgres) |
| `docker-compose.override.yml` | dev-состав: `app` (dev, порт 8080) + `caddy` (reverse-proxy) |
| `services/caddy/Caddyfile` | конфиг Caddy: https, zstd, reverse_proxy → app:8080 |
| `Makefile` | команды `ci`, `test`, `dev`, `up`, `run-setup` |
| `app/` | клон `hexlet-components/js-fastify-blog` |

## Команды

```bash
# подготовка окружения (установить зависимости приложения)
make run-setup

# прогон тестов (продакшен-состав, app + postgres)
make test

# то же, что используется в CI
make ci

# запуск dev-состава (app + caddy) — http://localhost → https://localhost
make dev
# или
docker compose up
```

## Переменные окружения

Приложение конфигурируется через переменные окружения (см. `app/.env.example`).
Для PostgreSQL ключевые:

```
DATABASE_CLIENT=postgres
DATABASE_HOST=db
DATABASE_NAME=postgres
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=***
DATABASE_PORT=5432
```

`app/.env` (локальные значения, в том числе пароли) **не коммитится** — см. `.gitignore`.

## CI

- `hexlet-check` — линтеры и тесты Hexlet (бейдж выше).
- `push.yml` — при push в `main`: прогон тестов в Docker Compose, сборка
  продакшен-образа из `Dockerfile.production` и push в Docker Hub
  (`paralelnodev/docker-project-74`).

## Reverse proxy

Caddy (`services/caddy/Caddyfile`) стоит перед приложением:
- https (самоподписанный сертификат `tls internal`);
- компрессия `encode zstd`;
- все запросы проксируются в `app:8080`.
