BIN = forego
SRC = $(shell find . -name '*.go' -not -path './vendor/*')

.PHONY: all build clean lint release test

all: build

build: $(BIN)

clean:
	rm -f $(BIN)

lint: $(SRC)
	go fmt

release:
	bin/release

test: lint build
	go test -v -race -cover ./...

$(BIN): $(SRC)
	godep go build -o $@

dist-clean:
	rm -rf dist
	rm -f $(BIN)-alpine-linux-*.tar.gz
	rm -f $(BIN)-linux-*.tar.gz
	rm -f $(BIN)-darwin-*.tar.gz

dist: dist-clean
	mkdir -p dist/alpine-linux/amd64 && GOOS=linux GOARCH=amd64 go build -a -tags netgo -installsuffix netgo -o dist/alpine-linux/amd64/$(BIN)
	mkdir -p dist/alpine-linux/armhf && GOOS=linux GOARCH=arm GOARM=6 go build -a -tags netgo -installsuffix netgo -o dist/alpine-linux/armhf/$(BIN)
	mkdir -p dist/alpine-linux/arm64 && GOOS=linux GOARCH=arm64 go build -a -tags netgo -installsuffix netgo -o dist/alpine-linux/arm64/$(BIN)
	mkdir -p dist/linux/amd64 && GOOS=linux GOARCH=amd64 go build -o dist/linux/amd64/$(BIN)
	mkdir -p dist/linux/i386  && GOOS=linux GOARCH=386 go build -o dist/linux/i386/$(BIN)
	mkdir -p dist/linux/armel  && GOOS=linux GOARCH=arm GOARM=5 go build -o dist/linux/armel/$(BIN)
	mkdir -p dist/linux/armhf  && GOOS=linux GOARCH=arm GOARM=6 go build -o dist/linux/armhf/$(BIN)
	mkdir -p dist/linux/arm64  && GOOS=linux GOARCH=arm64 go build -o dist/linux/arm64/$(BIN)
	mkdir -p dist/darwin/amd64 && GOOS=darwin GOARCH=amd64 go build -o dist/darwin/amd64/$(BIN)
	mkdir -p dist/darwin/i386  && GOOS=darwin GOARCH=386 go build -o dist/darwin/i386/$(BIN)


release: dist
	tar -cvzf $(BIN)-alpine-linux-amd64-$(TAG).tar.gz -C dist/alpine-linux/amd64 $(BIN)
	tar -cvzf $(BIN)-alpine-linux-armhf-$(TAG).tar.gz -C dist/alpine-linux/armhf $(BIN)
	tar -cvzf $(BIN)-alpine-linux-arm64-$(TAG).tar.gz -C dist/alpine-linux/arm64 $(BIN)
	tar -cvzf $(BIN)-linux-amd64-$(TAG).tar.gz -C dist/linux/amd64 $(BIN)
	tar -cvzf $(BIN)-linux-i386-$(TAG).tar.gz -C dist/linux/i386 $(BIN)
	tar -cvzf $(BIN)-linux-armel-$(TAG).tar.gz -C dist/linux/armel $(BIN)
	tar -cvzf $(BIN)-linux-armhf-$(TAG).tar.gz -C dist/linux/armhf $(BIN)
	tar -cvzf $(BIN)-linux-arm64-$(TAG).tar.gz -C dist/linux/arm64 $(BIN)
	tar -cvzf $(BIN)-darwin-amd64-$(TAG).tar.gz -C dist/darwin/amd64 $(BIN)
	tar -cvzf $(BIN)-darwin-i386-$(TAG).tar.gz -C dist/darwin/i386 $(BIN)
