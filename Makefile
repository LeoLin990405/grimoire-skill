.PHONY: test syntax help

help:
	@echo "make test     # offline test suite (no token/network/vault)"
	@echo "make syntax   # bash -n over every script"

test:
	@./tests/run.sh

syntax:
	@find scripts -name '*.sh' -print0 | xargs -0 -n1 bash -n && echo "syntax OK"
