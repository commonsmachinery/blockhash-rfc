
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

$(destdir)/%.xml: %.md
	@mkdir -p $(destdir)
	$(PANDOC) -t docbook -s $^ | xsltproc --nonet transform.xsl - > $@


.PHONY: all clean
