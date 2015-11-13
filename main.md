
Conventions used in this document
=================================

The key words "MUST", "MUST NOT", "SHOULD", "SHOULD NOT", and "MAY" in
this document are to be interpreted as defined in "Key words for use
in RFCs to Indicate Requirement Levels" [](#RFC2119).


Introduction
============

Most URN namespaces are intended to identify a unique resource
[](#RFC1630), e.g. by a unique ID that is assigned by a registry, or
from a cryptographic hash derived from the resource itself.

The blockhash URN namespace specified in this document instead
identifies a unique likeness of a resource, specifically of an image.
It is intended to be used in situations where an exact match may not
be possible, e.g. when comparing two instances of an image that might
have been resized or recoded in different file formats.

This is achieved by using a perceptual hash based on the blockhash
algorithm [](#BLOCKHASH).  A small change in an image also results in
a correspondingly small change in the blockhash.  This is in contrast
to a cryptographic hash where even small changes to a file result in
unpredictable and often large changes in the hash.

This allows not only the exact comparison of two blockhashes, but also
makes it possible to determine how similar two images are.  The
similary is measured as the hamming distance, i.e. the number of bits
in the two hashes that are different.  Tools using blockhashes can
then choose a maximum hamming distance that is relevant for the
particular use case and the precision needed.  Efficient algorithms
exist to query a set of hashes to find the ones within a given
distance from a particular hash, e.g. HmSearch [](#HMSEARCH).

The primary use case for blockhashes is to implement services that can
perform a reverse image lookup, i.e. based on the image itself find
out information about it or find similar images.

This namespace specification is for a formal namespace.  The
specification adheres to the guidelines given in "Uniform Resource
Names (URN) Namespace Definition Mechanisms" [](#RFC3406).


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
than 64, 144 and 256 bits will be useful.  Blockhashes SHOULD be 256
bits long unless there is a specific need for a different size.


## Relevant ancillary documentation 

None as yet.


## Identifier uniqueness considerations

A blockhash URN identifies the unique likeness of an image, rather
than a specific image file.  Within the blockhash scheme, all images
that produce the same blockhash are considered identicial.


## Identifier persistence considerations

The algorithm that calculate a blockhash from an image also establish
a persistent identifier.  The process can later be repeated on the
to reproduce the identifier at any point in the lifetime of the image.


## Process of identifier assignment

A blockhash identifier is calculated from a digital image, and only
depend on access to the pixel representation of the image.  It can
be read from a local or remote file, from an in-memory pixmap
or canvas, or another suitable source.

A blockhash SHOULD be calculated following these steps:

1. Convert the image to RGB format with an optional alpha channel (if
   not already done).  The standard conversion method of the file
   format SHOULD be used, avoiding any file- or system-specific colour
   profiles.  Any orientation tag in the image metadata SHOULD be
   applied.

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

5. Divide the block grid into four horizontal groups, each containing
   N columns and N/4 rows.  For each group, determine the median value
   of all the blocks contained in the group.

5. Let H be the theoretically maximum cumulative value of all pixels
   in a block divided by two (half the value space).

6. For each block, starting with the upper left and progressing row by
   row until the lower right, add a bit to the result hash:

    a.  If the block value is higher than the median value of the
        horizontal group the block belongs to, add a 1.

    b.  If the block value and median have the same value, and the
        median is above above H, add a 1. Note that imprecisions from
        floating point calculations or other implementation details
        must be taken into consideration when determining if the block
        value and the median are the same value.

    c.  Otherwise, add a 0.

7. Encode the hash in hexadecimal, interpreting the sequence of bits
   as eight-bit bytes.

8. Construct a blockhash URN according to the grammar above using the
   hexadecimal representation of the hash.


Implementations MAY use a different process which yield similar
results, but SHOULD make users aware if the modified process can
introduce differences to the standard algorithm which may result in
false negatives.  One possible alternative to the algorithm described
above is to resize the image to ensure that each block holds an even
number of pixels to avoid the calculations in 4a and 4c.


## Process of identifier resolution

Not specified.


## Rules for lexical equivalence

Lexical equivalence of two blockhash identifiers are determined by
first converting both hexadecimal strings to lower-case or upper-case,
and then comparing the resulting strings.

Alternatively, the hexadecimal strings can be converted to byte or bit
sequences, which are then compared directly.


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

A new URN namespaces is needed as there are no existing namespaces for
representing perceptual hashes as URNs in general, and none
specifically for the blockhash algorithm.

[](#I-D.thiemann-hash-urn) proposes a namespace for cryptographic hashes,
but it is intentionally limited to only allow the hash algorithms
specified in the internet draft.

In a similar vein this namespace is limited to blockhash itself, to
avoid having to establish a secondary level of namespace assignments
for different perceptual hash algorithms.

The blockhash algorithm was choosen to allow even relatively
restricted environments (e.g. javascript code in a web browser) to
produce an image hash, that is still sufficiently precise for
identifying images as they are shared across the Internet, even after
resizes, recodings and smaller edits.

More complex perceptual hashes exist that can track more complex
changes, e.g. large crops or rotations, but they also put higher
requirements on the implementation.  Such larger changes would often
mean that the edit is no longer the same image but a derivate work.
Blockhash is intended to only match images that can be considered the
same work, so not matching derivatives is actually a benefit.

Representing the hash as a hexadecimal string rather than as a more
compact base32 is choosen to align the format more closely with the
underlying bit structure.  This allow code to determine a rough
hamming distance between two blockhashes just by comparing the
hexadecimal strings, rather than first having to convert them into
binary sequences.

The restriction that the grid width and height must be the same allow
some scope to implementations to choose a reasonable hash size while
ensuring that the hash size can always be reconstructed from the hash
length.  Requiring that the grid width and height must be a multiple
of 4 ensures that the hash size is a multiple of eight, and thus will
fill up a sequence of bytes exactly.

The original blockhash algorithm [](#BLOCKHASH) calculated a single
median value for the entire block grid.  During testing it was found
that this often resulted collisions in images with a lot of contrast
between different parts of the image.  An example is outdoor images of
landscapes with a bright sky and a darker ground.  An image-wide
median results in the bright areas mostly being represented by 0 bits
and the darker with 1 bits, losing a lot of detail that could help
discern different images with similar contrast structure.  By
calculating a median value for each of four horizontal groups and
comparing the block values to the median in the corresponding group
help retain such contrast and reduce the collision frequency.


Community Considerations
========================

Internet services today make it very simple to share an image, but
most loses the context of the original image in the process.  The
context is where and when the image was created or a photo taken, by
whom, and what the conditions are for properly sharing the image.  It
is needed both to avoid copyright infringements, and to give credit to
the original creator.

There already exist several reverse image search services, but they
are generally proprietary, closed implementations, and require users
to upload the image to the service, potentially violating the user's
privacy.

Having a standardised way to refer to a perceptual hash of an image
will provide new capabilities directly to Internet users to find out
the context of images, even when they have passed through several
steps of sharing.

The blockhash on its own is not sufficient, but it will enable new
services that can index large collections of images.  Client-side
tools can then calculate a blockhash and query these indices to find
more information about the image, preserving the user privacy.

The scope of this document does not cover processes for finding and
querying such indices, but enable such future work to build on
blockhash URNs.


Security Considerations
=======================

Blockhashes are generally only useful when they relate to images that
are already public and being shared.  As such, producing a blockhash
of the image and sharing that will not change the security or privacy
situation significantly.

For all images that are a few times larger than the grid size, it will
be practically impossible to reconstruct the original image based on
its blockhash.  Thus sharing a blockhash of a private image does not
infringe on the user's privacy directly.  However, if the image is
later shared, the previously shared blockhash can be used to infer
that the user had access of the image at the earlier time.

Images that are not much bigger than the grid size could be reproduced
in sufficient detail to be identified from a blockhash.  Such images
are usually icons and other non-sensitive content, but implementation
can also mitigate against this by requiring the user to confirm that
such a small image should be hashed.
