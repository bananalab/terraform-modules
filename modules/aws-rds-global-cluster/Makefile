.PHONY: test

test:
	pushd test; \
	go mod init "aws-rds-global-cluster"; \
	go mod tidy; \
	go test -v -tags integration -timeout 3600s; \
	popd
