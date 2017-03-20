CFLAGS = -msse2 -mavx -mavx2 --std gnu99 -O0 -Wall -Wextra

GIT_HOOKS := .git/hooks/applied
EXEC := naive_transpose \
				sse_transpose sse_prefetch_transpose \
				avx_transpose

all: $(GIT_HOOKS) $(EXEC)

%_transpose: main.c
	$(CC) $(CFLAGS) -D$(subst _transpose,,$@) -o $@ main.c

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

define APPEND
$(addsuffix $1,$(subst $2,,$3))
endef

run_%:
	perf stat --repeat 100 \
 		-e cache-misses,cache-references,instructions,cycles \
  	./$(call APPEND,_transpose,run_,$@)

test_cache_%:
	perf stat --repeat 100 \
 		-e L1-dcache-load-misses,L1-dcache-store-misses,L1-dcache-prefetch-misses,L1-icache-load-misses \
  	./$(call APPEND,_transpose,test_cache_,$@)

raw_counter_%:
	perf stat --repeat 100 \
		-e r024c \
		./$(call APPEND,_transpose,raw_counter_,$@)

clean:
	$(RM) $(EXEC)
