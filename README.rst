Tools for Simplified RNG
************************

License: GPL 3+


Quick Start
===========

Use :program:`rng2srng` to convert any RNG schema into SRNG.

#. Convert your RNG schema into SRNG::

   $ rng2srng foo.rng > foo.srng

#. To clean up the SRNG, use this stylesheet::

   $ xsltproc --output foo-cleaned.srng xslt/rng-cleanup.xsl foo.srng

#. To create a text output which contains an overview of all attributes
   and elements, use this stylesheet::

   $ xsltproc --output foo-overview.txt xslt/rng2txt.xsl foo.srng
