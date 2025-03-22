include .env
-include .env.local
export

.SILENT:
SHELL = /bin/bash

define help-targets
	awk -F ':|## ' '/^[^\t]+\s*:[^#]*## / {printf "    \033[36m%-30s\033[0m %s\n", $$1, $$NF}' $(1)
endef

define help-admins
	awk -F ':|### ' '/^[^\t]+\s*:[^#]*### / {printf "  * \033[36m%-30s\033[0m %s\n", $$1, $$NF}' $(1)
endef

define HELPTEXT

usage: help <command>
endef

define ADMINTEXT

Note: % stands for a service name, one of: db db_admin db_migrations

Note: Administrative tasks are indicated with an '*' in front of them. These tasks are intended 
      for trouble shooting. Do not run them unless you undestand the task action and its impact.
endef

# Set USER_ID and GROUP_ID to current user's uid and gid
USER_ID ?= $(shell id -u)
GROUP_ID ?= $(shell id -g)

# task comments starting with double # will be part of the help list
# task comments starting with triple # will be part of the help_admin list

help: ## Show list and info on common tasks
	@echo "$$HELPTEXT"
	$(call help-targets, $(MAKEFILE_LIST))
	$(call help-admins, $(MAKEFILE_LIST))
	@echo "$$ADMINTEXT"

.PHONY: status
status: ## Show the status of the services
	docker compose ps

.PHONY: logs
logs: ## Show the logs of the services
	docker compose logs

.PHONY: logs-%
logs-%: ## Show the logs of a specific service
	docker compose logs $*

.PHONY: logf
logf: ## Show the logs of the services
	docker compose logs -f

.PHONY: logf-%
logf-%: ## Show the logs of a specific service
	docker compose logs -f $*

.PHONY: up ## Start services
up:
	docker compose up -d

.PHONY: up-%
up-%: ## Start a specific service
	docker compose up $* -d

.PHONY: down
down: ## Stop services
	docker compose down

.PHONY: down-%
down-%: ## Stop a specific service
	docker compose down $*

.PHONY: restart-%
restart-%: ## Restart a specific service
	docker compose restart $*

.PHONY: migrations
migrations: ## Run the database migrations
	docker compose run --rm db_tool rake db:migrate

.PHONY: seeds
seeds: ## Run the database seeds
	docker compose run --rm db_tool rake db:seed

.PHONY: test
test: ## Run the tests
	docker compose run --rm db_tool rake spec

.PHONY: tool
tool: ## Run the database tool
	docker compose run -it --rm db_tool irb

.PHONY: tool_shell
tool_shell: ## Run the database tool
	docker compose run -it --rm db_tool bash

.PHONY: force
FORCE:

.PHONY: bundle_install
bundle_install: ### Install gem dependencies
	cd gem && bundle install

.PHONY: bundle_update
bundle_update: ### Update gem dependencies
	cd gem && bundle update

.PHONY: all
all: build

.PHONY: build
build:
	docker build -t ${DOCKER_IMAGE}:$(shell git rev-parse --short HEAD) .		\
	&& docker tag ${DOCKER_IMAGE}:$(shell git rev-parse --short HEAD) ${DOCKER_IMAGE}:latest

.PHONY: push	
push: build	
	docker push ${DOCKER_IMAGE}:$(shell git rev-parse --short HEAD)		\	
	&& docker push ${DOCKER_IMAGE}:latest

.PHONY: clean ### Shut down the services and remove the database
clean: down
	docker volume prune --all -f --filter "label=be.libis.be.component=db"
	rm -fr db_data/pgdata

.PHONY: reset ### Recreate the database to initial content
reset: clean up migrations seeds

.PHONY: db_config ### Set up database certificates for SSL
db_config:
	mkdir -p db_data
	cd db_data && \
		openssl req -new -text -passout pass:$(CERT_PASS) -subj /CN=localhost -out server.req && \
		openssl rsa -in privkey.pem -passin pass:$(CERT_PASS) -out server.key && \
		openssl req -x509 -in server.req -text -key server.key -out server.crt && \
		chmod 600 server.key
