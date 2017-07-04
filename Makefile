all: cleartables.json sql/post/comments.sql

cleartables.json: cleartables.yaml wikidata.yaml yaml2json.py
	cat cleartables.yaml wikidata.yaml | ./yaml2json.py > cleartables.json || (rm -f cleartables.json && exit 1)

sql/post/comments.sql: cleartables.yaml wikidata.yaml createcomments.py
	mkdir -p sql/post && \
	cat cleartables.yaml wikidata.yaml | ./createcomments.py > sql/post/comments.sql || (rm -f sql/post/comments.sql && exit 1)

clean:
	rm -f cleartables.json sql/post/comments.sql

# Find a lua executable
find_lua = \
	lua=; \
	for x in lua52 lua lua51; do \
	  if type "$${x%% *}" > /dev/null 2>/dev/null; then lua=$$x; break; fi; \
	done; \
	if [ -z $$lua ]; then echo 1>&2 "Unable to find lua"; exit 2; fi;

check:
	$(find_lua) \
	$$lua test-util.lua && \
	$$lua test-common.lua && \
	$$lua test-generic.lua && \
	$$lua test-wikidata.lua && \
	$$lua test-water.lua && \
	$$lua test-wetland.lua && \
	$$lua test-wood.lua && \
	$$lua test-building.lua && \
	$$lua test-address.lua && \
	$$lua test-transportation.lua && \
	$$lua test-transit.lua && \
	$$lua test-admin.lua && \
	$$lua test-protected.lua && \
	$$lua test-aero.lua && \
	$$lua test-barrier.lua && \
	$$lua test-pier.lua && \
	$$lua test-landform.lua && \
	$$lua test-education.lua && \
	$$lua test-recreation.lua && \
	$$lua test-healthcare.lua && \
	$$lua test-place.lua && \
	$$lua test-landuse.lua
