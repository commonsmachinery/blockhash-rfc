
XML2RFC = xml2rfc
PANDOC = pandoc
XSLTPROC = xsltproc 

name = draft-commonsmachinery-urn-blockhash-00

sections = abstract main appendices

destdir = build

all: $(name).txt

clean:
	rm -rf $(name).txt $(destdir)

$(name).txt: template.xml $(sections:%=$(destdir)/%.xml)
	$(XML2RFC) template.xml -f $@ --text

$(destdir)/%.xml: $(destdir)/%.docbook.xml
	xsltproc --nonet transform.xsl $^ > $@

$(destdir)/%.docbook.xml: %.md
	@mkdir -p $(destdir)
	$(PANDOC) -t docbook -s $^ > $@


# Keep the intermediary files to help with formatting errors
.SECONDARY: $(sections:%=$(destdir)/%.docbook.xml)

.PHONY: all clean

