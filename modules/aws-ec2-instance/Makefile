SHELL := $(shell which bash)
.PHONY: test

test:
	pushd test; \
	go mod init "aws-ec2-instance"; \
	go mod tidy; \
	go test -v -tags integration -timeout 3600s; \
	popd
