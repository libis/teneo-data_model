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

Note: % stands for a service name, one of: dataverse db dbadmin proxy index

Note: Administrative tasks are indicated with an '*' in front of them. These tasks are intended 
      for trouble shooting. Do not run them unless you undestand the task action and its impact.
endef

help: ## Show list and info on common tasks
        @echo "$$HELPTEXT"
        $(call help-targets, $(MAKEFILE_LIST))
        $(call help-admins, $(MAKEFILE_LIST))
        @echo "$$ADMINTEXT"


.PHONY: all
all: build

.PHONY: build
build:
	docker build -t ${DOCKER_IMAGE}:$(shell git rev-parse --short HEAD) .		\
	&& docker tag ${DOCKER_IMAGE}:$(shell git rev-parse --short HEAD) ${DOCKER_IMAGE}:latest

.PHONY: push	
push:	build	
	docker push ${DOCKER_IMAGE}:$(shell git rev-parse --short HEAD)		\	
	&& docker push ${DOCKER_IMAGE}:latest

.PHONY: clean
clean:
	docker rm -f $(shell docker ps -aq)

.PHONY: run
run:
	docker run -p 8080:8080 -d ${DOCKER_IMAGE}:$(shell git rev-parse --short HEAD)

.PHONY: stop
stop:
	docker stop $(shell docker ps -aq)

.PHONY: test
test:
	go test -v $(shell go list ./... | grep -v vendor)

.PHONY: lint
lint:
	golangci-lint run

FORCE:
