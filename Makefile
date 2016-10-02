# Makefile for OrientDB Documentation Builds
OUT = deploy
WEB = $(OUT)/last
PDF = $(OUT)/pdf
SRC = .e

NODEMOD = node_modules
GITPLUG = gitbook-plugin
NODEGIT = $(NODEMOD)/$(GITPLUG)
NPM = npm install

MODULES = $(NODEGIT)-ga $(NODEGIT)-anchors $(NODEGIT)-addcssjs $(NODEGIT)-reveal $(NODEGIT)-highlight $(NODEGIT)-versions $(NODEGIT)-collapsible-menu $(NODEGIT)-edit-link

NODECALL = node --stack-size=32000
MAC_GITBOOK = /usr/local/bin/gitbook 
LINUX_GITBOOK = /usr/bin/gitbook
PLATFORM = "$(shell uname)"
ifeq ($(PLATFORM), "Darwin")
	GITBOOK = $(MAC_GITBOOK)
endif
ifeq ($(PLATFORM), "Linux")
	GITBOOK = $(LINUX_GITBOOK)
endif


# Build Local Website
create: clean $(MODULES)
	$(NODECALL) $(GITBOOK) build --gitbook 3.1.1 $(SRC) --output=$(WEB)

# Build PDF
pdf: clean $(MODULES)
	$(NODECALL) $(GITBOOK) pdf --gitbook 3.1.1 $(SRC) --output=$(PDF)

# Pull Updates
pull:
	git pull

check:
	ls -al $(BLD)/*/*.md | grep -v Footer.md | grep -v Home.md

# Run All Builds
all: clean $(MODULES) create

clean:
	rm -rf $(WEB)/*


# GitBook Plugin Installation
install: $(MODULES)

$(NODEGIT)-ga:
	$(NPM) $(GITPLUG)-ga
$(NODEGIT)-anchors: 
	$(NPM) $(GITPLUG)-anchors
$(NODEGIT)-addcssjs: 
	$(NPM) $(GITPLUG)-addcssjs
$(NODEGIT)-reveal: 
	$(NPM) $(GITPLUG)-reveal
$(NODEGIT)-highlight: 
	$(NPM) $(GITPLUG)-highlight
$(NODEGIT)-collapsible-menu:
	$(NPM) $(GITPLUG)-collapsible-menu
$(NODEGIT)-edit-link:
	$(NPM) $(GITPLUG)-edit-link
$(NODEGIT)-versions:
	$(NPM) $(GITPLUG)-versions
