
.PHONY: cqfd
cqfd:
	@git submodule update --init > /dev/null
	@./scripts/cqfd/cqfd init > /dev/null
	@./scripts/cqfd/cqfd run make tests

.PHONY: test tests
test tests:
	@-./scripts/run_tests
	@./scripts/print_cloc
