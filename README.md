
Blockhash RFC
=============

This repository contains the working files for an internet draft for
an URN of the blockhash perceptual hash algorithm.  The goal is to
have it submitted as an RFC, hence the repository name.

Writing
-------

There are three parts which gets built into the RFC.

* [Abstract](abstract.md)
* [Main document](main.md)
* [Appendices](appendices.md)

These are written in the pandoc version of Markdown:
http://tools.ietf.org/html/draft-gieben-pandoc2rfc-03

Info on the XML format and links to citations to copy into `bib/`.
http://xml2rfc.ietf.org/

Guidelines for internet drafts:
http://www.ietf.org/ietf-ftp/1id-guidelines.html

URN namespace definition metchanism, which this will have to comply
with:
http://tools.ietf.org/html/rfc3406


Building
--------

Install needed tools:

    apt-get install pandoc xsltproc xml2rfc

Then just build:

    make
