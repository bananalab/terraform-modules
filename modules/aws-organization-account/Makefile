.PHONY: test

test:
	pushd test; \
	go mod init "aws-organization-account"; \
	go mod tidy; \
	go test -v -tags integration -timeout 3600s; \
	popd
