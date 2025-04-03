include .env
-include .env.local
export

UID ?= $(shell id -u)
GID ?= $(shell id -g)

IMAGE_VERSION := $(shell ruby -e 'require_relative "lib/teneo/data_model/version"; puts Teneo::DataModel::VERSION')

.SILENT:

install:
	bundle install

update:
	bundle update

release:
	git commit -am "Version bump: v$(IMAGE_VERSION)" || true
	git tag --force "v$(IMAGE_VERSION)"
	git push --force --tags
	bundle exec rake changelog
	git commit -a -m "Changelog update" || true
	git push --force
	bundle exec rake release

up:
	docker compose up -d

down:
	docker compose down

clear: down
	docker volume rm teneo_db_data || true

MIGRATIONS_DIR=./db/migrations
migrate: clear up
	docker compose run --rm -e MIGRATIONS_DIR=$(MIGRATIONS_DIR) db_tool rake -v -t db:migrate

test: up
	bundle exec rspec
