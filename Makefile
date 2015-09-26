# Makefile for OrientDB Documentation Builds
OUT = deploy
WEB = $(OUT)/latest
PDF = $(OUT)/pdf
SRC = source

MODULES = node_modules/gitbook-plugin-ga node_modules/gitbook-plugin-anchors node_modules/gitbook-plugin-addcssjs node_modules/gitbook-plugin-reveal node_modules/gitbook-plugin-highlight


# Build Local Website
create: clean install
	gitbook build $(SRC) --output=$(WEB)

# Build PDF
pdf: clean install
	gitbook pdf $(SRC) --output=$(PDF)

# Pull Updates
pull:
	git pull

check:
	ls -al $(BLD)/*/*.md | grep -v Footer.md | grep -v Home.md

# Run All Builds
all: clean install create

clean:
	rm -rf $(WEB)/*


# GitBook Plugin Installation
install: $(MODULES)

node_modules/gitbook-plugin-ga:
	npm install gitbook-plugin-ga
node_modules/gitbook-plugin-anchors: 
	npm install gitbook-plugin-anchors
node_modules/gitbook-plugin-addcssjs: 
	npm install gitbook-plugin-addcssjs
node_modules/gitbook-plugin-reveal: 
	npm install gitbook-plugin-reveal
node_modules/gitbook-plugin-highlight: 
	npm install gitbook-plugin-highlight
