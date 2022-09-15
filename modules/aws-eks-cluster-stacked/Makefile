.PHONY: test

test:
	pushd test; \
	go mod init "aws-eks-cluster"; \
	go mod tidy; \
	go test -v -tags integration -timeout 3600s; \
	popd
