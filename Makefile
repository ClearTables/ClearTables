all: cleartables.json

cleartables.json: cleartables.yaml
	./yaml2json.py < cleartables.yaml > cleartables.json

clean:
	rm cleartables.json
