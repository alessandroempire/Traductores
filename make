# If the first argument is "run"...
ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

alex:
	alex -g Lexer.x

# Can be used as 'make run ../examples/sapphire/ejemplo.sp'
run:
	./trinity $(RUN_ARGS)

clean: @rm *.hi *.o 2> /dev/null || true
