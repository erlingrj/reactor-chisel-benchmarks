.phony: latency
latency:
	./scripts/latency.fish

.phony: resources
resources:
	./scripts/resources.fish
	./scripts/codesignResources.fish

.phony: thru
thru:
	./scripts/throughput.fish

.phony: all
all: latency resources thru 

.phony: clean
clean:
	rm -f results/**/*txt
	rm -f bin/*
	rm -f src-gen/*