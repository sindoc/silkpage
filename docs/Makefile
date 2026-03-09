CAT = cfg/catalog.xml
XSLT = XML_CATALOG_FILES=$(CAT) xsltproc
PROC = XML_CATALOG_FILES=$(CAT) xmllint
XEP = XML_CATALOG_FILES=$(CAT) /opt/xml/xep/xep
DOCS=silkpage-docs
SRC = src
TMP = /tmp
OUT = $(TMP)/$(DOCS)
UG_CHUNK_PRX = silkpage-docs-ug
UG_CHUNK_DIR = $(OUT)/guides/html-chunk
UG_SINGLE_DIR = $(OUT)/guides/html-single
UG_PDF_DIR = $(OUT)/guides/pdf
LANG = en
XML = $(SRC)/xml/$(LANG)/main.xml
DOCS_UG = $(DOCS)-ug
.PHONY : clean 

all: html-chunk html-single tidy css zip

init:
	mkdir -p $(OUT)

valid:
	$(PROC)  \
	--noout  \
	--xinclude  \
	--postvalid  \
	$(XML)

fo:  
	mkdir -p $(UG_PDF_DIR)
	$(XSLT)  \
	-o $(UG_PDF_DIR)/$(DOCS_UG).fo  \
	--stringparam fop.extensions 1  \
	--xinclude  \
	$(SRC)/xsl/fo.xsl  \
	$(XML)

pdf:
	$(XEP) \
	-fo $(UG_PDF_DIR)/$(DOCS_UG).fo \
	-pdf $(UG_PDF_DIR)/$(DOCS_UG).pdf
	rm $(UG_PDF_DIR)/$(DOCS_UG).fo

html-single:  
	mkdir -p $(UG_SINGLE_DIR)
	$(XSLT)  \
	-o $(UG_SINGLE_DIR)/$(DOCS_UG).html  \
	--xinclude  \
	$(SRC)/xsl/html-single.xsl  \
	$(XML)

html-chunk:  
	mkdir -p $(UG_CHUNK_DIR)
	$(XSLT)  \
	--xinclude  \
	--stringparam base.dir $(UG_CHUNK_DIR)/ \
	$(SRC)/xsl/html-chunk.xsl  \
	$(XML)

tidy:
	find $(OUT) -name '*.html' -print -exec \
	tidy -q -latin1 -mn -asxhtml {} ';'

zip-chunk:
	cp -fr $(UG_CHUNK_DIR) $(UG_CHUNK_DIR)/../$(UG_CHUNK_PRX)
	cd $(UG_CHUNK_DIR)/.. 
	zip -rpD $(UG_CHUNK_PRX).zip . -i $(UG_CHUNK_PRX) 
	rm -fr $(UG_CHUNK_PRX) 
	mv $(UG_CHUNK_PRX).zip $(UG_CHUNK_DIR)

zip:
	cd $(TMP)/$(DOCS) && zip -rpD $(DOCS).zip *

clean:
	rm -rf $(OUT)
css:
	mkdir $(UG_CHUNK_DIR)/css $(UG_SINGLE_DIR)/css
	cp -f $(SRC)/css/*.css $(UG_CHUNK_DIR)/css
	cp -f $(SRC)/css/*.css $(UG_SINGLE_DIR)/css
