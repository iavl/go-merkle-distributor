PROJECTNAME=$(shell basename "$(PWD)")
VERSION=-ldflags="-X main.Version=$(shell git describe --tags)"


.PHONY: help get build test clean
help: Makefile
	@echo
	@echo "Choose a make command to run in "$(PROJECTNAME)":"
	@echo
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo

get:
	@echo "  >  \033[32mDownloading & Installing all the modules...\033[0m "
	go mod tidy && go mod download

build:
	@echo "  >  \033[32mBuilding binary...\033[0m "
	go build -o build/go-merkle-distributor $(VERSION)

## Runs go test for all packages
test:
	@echo "  >  \033[32mRunning tests...\033[0m "
	go test -p 1 -coverprofile=cover.out -v `go list ./...

clean:
	rm -rf build/
