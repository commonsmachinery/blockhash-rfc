
Conventions used in this document
=================================

The key words "MUST", "MUST NOT", "SHOULD", "SHOULD NOT", and "MAY" in
this document are to be interpreted as defined in "Key words for use
in RFCs to Indicate Requirement Levels" [](#RFC2119).


Introduction
============

TODO

Specification Template
======================

## Namespace ID

"blockhash" requested.

## Registration information

Registration version number: 1

Registration date: 201?-??-??

## Declared registration of the namespace

Registering organisation:

> Commons Machinery in Sweden AB
> Åsgatan 5
> 646 32 Gnesta
> Sweden
> http://commonsmachinery.se/

Designated Contact Person:

> Jonas Öberg <jonas@commonsmachinery.se>

## Declaration of syntactic structure

The Namespace Specific Strings (NSS) of all URNs assigned by the
schema described in this document will conform to the syntax defined
in section 2.2 of [](#RFC2141).  The formal syntax of the NSS is
defined by the following normative ABNF [](#RFC5234) rules for
`blockhash-nss`:

    blockhash-nss = hexhash
    hexhash       = 1*hex
    hex           = %x30-39 / %x41-46 / %x61-66 ; 0-9, A-F, a-f

The following are comments and restrictions not captured by the above
grammar.

Though both upper-case and lowercase characters are allowed in the
hexadecimal value, lowercase characters SHOULD be used.

The number of bits encoded in `hexhash` MUST be M, where, M = N * N
and N is a multiple of 4.  It is not expected that hash lengths other
than 64, 144 and 256 bits will make sense.  Blockhashes SHOULD be 256
bits long unless there is a specific need for a different size.


## Relevant ancillary documentation 

None as yet.

## Identifier uniqueness considerations

TODO: discuss images as abstract entities.

## Identifier persistence considerations

TODO: refer to the abstract identification

## Process of identifier assignment

A blockhash identifier is calculated from a digital image, and require
no more than access to the file or a file that has already been
decoded into RGB pixels.

A blockhash SHOULD be calculated following these steps:

1. Convert the image to RGB format with an optional alpha channel (if
   not already done).  The standard conversion method of the file
   format SHOULD be used, avoiding any file- or system-specific colour
   profiles.

2. Construct a grid of N by N blocks covering the image.  N MUST be a
   multiple of 4.

3. Initialise each block to 0.

4. For each pixel:

    a.  Decide which blocks the pixel overlaps.  It can be one, two or
        four blocks, depending on the pixel coordinate.
 
    b.  If the image has an alpha channel and the alpha for the pixel
        is 0 (indicating transparency), set the RGB components
        to their maximum values, otherwise use them as they are.
 
    c.  Add the sum of the RGB components from the previous step to
        each of the blocks the pixel covers, in proportion to the area
        of the pixel that is in each block.

5. Determine the median value of all the blocks.

6. For each block, starting with the upper left and progressing row by
   row until the lower right, add a bit to the result hash:

    a.  If the block value is less than the median value, add a 0.

    b.  Otherwise, add a 1.

7. Encode the hash in hexadecimal, interpreting the sequence of bits
   as eight-bit bytes.

8. Construct a blockhash URN according to the grammar above using the
   hexadecimal representation of the hash.


Implementations MAY use a different process which yield similar
results, but SHOULD make users aware if the modified process can
introduce differences to the standard algorithm which may result in
false negatives.  One possible alternative to the algorithm described
above is to resize the image to ensure that each block holds an even
number of pixels to avoid the calculations in 4a and 4d.


## Process of identifier resolution

TODO: discuss hamming distances

## Rules for lexical equivalence

TODO: case-insensitive comparison

## Conformance with URN syntax

No special considerations.

## Validation mechanism

None specified.

## Scope

Global.


IANA Considerations
===================

This document includes a URN namespace registration that is to be
entered into the IANA registry for URN NIDs.


Namespace Considerations
========================

TODO: rationale


Community Considerations
========================

TODO: related work.


Security Considerations
=======================

TODO: none?

