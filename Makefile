include .env
-include .env.local
export

.SILENT:
SHELL = /bin/bash

# Help text
include help.mk

# Set USER_ID and GROUP_ID to current user's uid and gid
USER_ID ?= $(shell id -u)
GROUP_ID ?= $(shell id -g)

GEM_VERSION := $(shell ruby -e 'require_relative "lib/teneo/data_model/version"; puts Teneo::DataModel::VERSION')

### GEM tasks

install: ## Install the gem dependencies
	docker compose run --rm gem bundle install

update: ## Update the gem dependencies
	docker compose run --rm gem bundle update

release: ## Release the gem
	git commit -am "Version bump: v$(GEM_VERSION)" || true
	git tag --force "v$(GEM_VERSION)"
	git push --force --tags
	bundle exec rake changelog
	git commit -a -m "Changelog update" || true
	git push --force
	bundle exec rake release

### DATABASE tasks

status: ## Show the status of the services
	docker compose ps

up: ## Start the database
	docker compose up -d

down: ## Stop the database
	docker compose down

clear: down ### Stop and remove the database
	rm -fr db_data/db/pgdata

reset: clear up migrate seed ### Recreate the database to initial content

migrate: up ## Run the database migrations
	docker compose run --rm gem rake teneo:data_model:migrate

seed: up ## Run the database seeds
	docker compose run --rm gem rake teneo:data_model:seed

test: up ## Run the test suite
	docker compose run --rm gem rake spec

console: up ## Start a console in the gem container
	docker compose run --rm gem console

gem: up ## Run a shell in the gem container
	docker compose run --rm gem bash
