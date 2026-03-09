XSLT = XML_CATALOG_FILES=$(CAT) xsltproc
PROC = XML_CATALOG_FILES=$(CAT) xmllint
DOCS=silkpage-docs
CAT = cfg/catalog.xml
SRC = src
TMP = /tmp
OUT = $(TMP)/$(DOCS)
CHUNK_DIR = $(OUT)/guides/html/chunked
SINGLE_DIR = $(OUT)/guides/html/single
LANG = en
XML = $(SRC)/xml/$(LANG)/main.xml
CHUNK_PRX=silkpage-userguide_html

.PHONY : clean 

all: valid html-chunk html-single tidy zip-chunk css zip-chunk zip

init:
	mkdir -p $(OUT)

valid:
	$(PROC)  \
	--noout  \
	--xinclude  \
	--postvalid  \
	$(XML)

html-single:  
	mkdir -p $(SINGLE_DIR)
	$(XSLT)  \
	-o $(OUT)/guides/html/single/core-userguide.html  \
	--xinclude  \
	$(SRC)/xsl/html-single.xsl  \
	$(XML)

html-chunk:  
	mkdir -p $(CHUNK_DIR)
	$(XSLT)  \
	--xinclude  \
	--stringparam base.dir $(OUT)/guides/html/chunked/ \
	$(SRC)/xsl/html-chunk.xsl  \
	$(XML)

tidy:
	find $(OUT) -name '*.html' -print -exec \
	tidy -q -latin1 -mn -asxhtml {} ';'

zip-chunk:
	cd $(CHUNK_DIR) && cd .. && cp -rf chunked $(CHUNK_PRX) && \
	zip -r $(CHUNK_PRX).zip $(CHUNK_PRX) && \
	rm -fr $(CHUNK_PRX) && \
	mv $(CHUNK_PRX).zip chunked

zip:
	cd $(TMP)/$(DOCS) && zip -rpD $(DOCS).zip *

clean:
	rm -rf $(OUT)
css:
	mkdir $(CHUNK_DIR)/css $(SINGLE_DIR)/css
	cp -f $(SRC)/css/*.css $(CHUNK_DIR)/css
	cp -f $(SRC)/css/*.css $(SINGLE_DIR)/css
