all: cleartables.json sql/post/comments.sql

cleartables.json: cleartables.yaml
	./yaml2json.py < cleartables.yaml > cleartables.json

sql/post/comments.sql: cleartables.yaml
	mkdir -p sql/post && \
	./createcomments.py < cleartables.yaml > sql/post/comments.sql || rm -f sql/post/comments.sql

clean:
	rm cleartables.json

# Find a lua executable
find_lua = \
	lua=; \
	for x in lua52 lua lua51; do \
	  if type "$${x%% *}" > /dev/null 2>/dev/null; then lua=$$x; break; fi; \
	done; \
	if [ -z $$lua ]; then echo 1>&2 "Unable to find lua"; exit 2; fi;

check:
	$(find_lua) \
	$$lua test-common.lua && \
	$$lua test-water.lua && \
	$$lua test-building.lua && \
	$$lua test-address.lua && \
	$$lua test-transportation.lua && \
	$$lua test-admin.lua && \
	$$lua test-aero.lua
