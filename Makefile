
REPORTER = dot

build:
	@echo "Building..."
	@./node_modules/.bin/browserify index.js -s ss > bundle.js
	@./node_modules/.bin/uglifyjs bundle.js --comments > socket.io-stream.js
	@rm -f bundle.js

install-0.9:
	@echo "Installing socket.io 0.9..."
	@npm install --cache-min 999999 socket.io@0.9
	@npm install --cache-min 999999 socket.io-client@0.9
	@rm -f test/support/socket.io.js
	@ln -s ../../node_modules/socket.io-client/dist/socket.io.js test/support/socket.io.js

install-1.0:
	@echo "Installing socket.io 1.0..."
	@npm install --cache-min 999999 socket.io@1.0.0-pre
	@npm install --cache-min 999999 socket.io-client@1.0.0-pre
	@rm -f test/support/socket.io.js
	@ln -s ../../node_modules/socket.io-client/socket.io.js test/support/socket.io.js

test-all:
	@$(MAKE) install-1.0
	@$(MAKE) test
	@$(MAKE) install-0.9
	@$(MAKE) test

test: test-unit test-acceptance test-browser

test-unit:
	@./node_modules/.bin/mocha --reporter $(REPORTER)

test-acceptance:
	@./node_modules/.bin/mocha --reporter $(REPORTER) --bail \
		--timeout 6000 \
		test/acceptance/*.js

test-browser: test-browser-unit

test-browser-unit: build
	@./node_modules/.bin/mocha-phantomjs --reporter $(REPORTER) test/index.html

clean:
	find ./test -name "*.tmp" -exec rm {} +

.PHONY: build test-all test test-unit test-acceptance test-browser test-browser-unit clean
