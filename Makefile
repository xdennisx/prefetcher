CFLAGS = -msse2 --std gnu99 -O0 -Wall -Wextra

GIT_HOOKS := .git/hooks/applied
EXEC := naive_transpose \
				sse_transpose sse_prefetch_transpose

all: $(GIT_HOOKS) $(EXEC)

%_transpose: main.c
	$(CC) $(CFLAGS) -D$(subst _transpose,,$@) -o $@ main.c

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

run:
	./naive_transpose
	./sse_transpose
	./sse_prefetch_transpose

clean:
	$(RM) $(EXEC)
