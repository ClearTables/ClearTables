#!/usr/bin/env python
import sys, yaml, json
try:
    json.dump(yaml.safe_load(sys.stdin), sys.stdout, indent=2, separators=(',', ': '))
except (yaml.YAMLError, yaml.composer.ComposerError) as e:
    sys.stderr.write("YAML error:\n%s\n" % e)
    sys.exit(1)
