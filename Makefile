# GRIT v8 Makefile
GRITC = bin/gritc
BOOTSTRAP = src/bootstrap.gr

.PHONY: test examples clean

# Run self-test suite
test:
	$(GRITC) run $(BOOTSTRAP) --self-test

# Compile all examples
examples: bin/hello bin/fibonacci bin/fizzbuzz bin/factorial bin/primes bin/gcd bin/power

bin/hello: examples/hello.gr
	$(GRITC) run $(BOOTSTRAP) $< -o $@

bin/fibonacci: examples/fibonacci.gr
	$(GRITC) run $(BOOTSTRAP) $< -o $@

bin/fizzbuzz: examples/fizzbuzz.gr
	$(GRITC) run $(BOOTSTRAP) $< -o $@

bin/factorial: examples/factorial.gr
	$(GRITC) run $(BOOTSTRAP) $< -o $@

bin/primes: examples/primes.gr
	$(GRITC) run $(BOOTSTRAP) $< -o $@

bin/gcd: examples/gcd.gr
	$(GRITC) run $(BOOTSTRAP) $< -o $@

bin/power: examples/power.gr
	$(GRITC) run $(BOOTSTRAP) $< -o $@

clean:
	rm -f bin/hello bin/fibonacci bin/fizzbuzz bin/factorial bin/primes bin/gcd bin/power
