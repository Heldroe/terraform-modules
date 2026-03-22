.PHONY: test test-all test-modified

# Hack to allow 'make test path/to/module' without Make complaining
ifeq (test,$(firstword $(MAKECMDGOALS)))
  MODULE_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # Turn the extracted arguments into dummy targets
  $(eval $(MODULE_ARGS):;@:)
endif

test:
ifeq ($(strip $(MODULE_ARGS)),)
	@$(MAKE) test-modified
else
	@./scripts/check.sh $(MODULE_ARGS)
endif

test-all:
	@echo "Testing all modules..."
	@MODS=$$(find . -type f -name "*.tf" -not -path "*/.terraform/*" -exec dirname {} \; | sort -u); \
	for mod in $$MODS; do \
		./scripts/check.sh $$mod; \
	done

test-modified:
	@echo "Testing modified modules..."
	@MODS=$$( \
		{ \
			git ls-files --others --modified --exclude-standard; \
			git diff --name-only --cached 2>/dev/null || true; \
			CURRENT_BRANCH=$$(git branch --show-current); \
			if [ "$$CURRENT_BRANCH" != "main" ] && [ "$$CURRENT_BRANCH" != "master" ]; then \
				git diff --name-only main...HEAD 2>/dev/null || git diff --name-only origin/main...HEAD 2>/dev/null || true; \
			fi; \
		} | grep '\.tf$$' | xargs -n1 dirname 2>/dev/null | sort -u \
	); \
	if [ -z "$$MODS" ]; then \
		echo "No modified Terraform modules found."; \
	else \
		for mod in $$MODS; do \
			./scripts/check.sh $$mod; \
		done \
	fi
