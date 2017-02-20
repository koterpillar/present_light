all: bundle.js

bundle.js: output/app.js node_modules webpack.config.js
	$$(npm bin)/webpack

# Without TMPDIR, pulp can't rename the output file
# https://github.com/bodil/pulp/issues/252

output/app.js: bower_components node_modules src/Main.purs output
	TMPDIR=. pulp build --to output/app.js

bower_components: bower.json
	bower install
	touch bower_components

node_modules: package.json
	npm install
	touch node_modules

output:
	mkdir -p output

serve: all
	$$(npm bin)/live-server

.PHONY: serve
