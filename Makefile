all: output/app.js

# Without TMPDIR, pulp can't rename the output file
# https://github.com/bodil/pulp/issues/252

output/app.js: bower_components src/Main.purs output
	TMPDIR=. pulp browserify --to output/app.js

bower_components: bower.json
	bower install

output:
	mkdir -p output

serve:
	TMPDIR=. pulp server

.PHONY: serve
