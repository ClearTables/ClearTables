all: cleartables.json

cleartables.json:
	./yaml2json.py < cleartables.yaml > cleartables.json

clean:
	rm cleartables.json
