#!/usr/bin/env bash

# Compiles programs and modules in the stock directory

COBCOPTS="-Wextra -debug -fnotrunc -fword-length=63 -ftab-width=2 -Wparentheses -Wstrict-typing -Wimplicit-define -Wcorresponding -Winitial-value -Wprototypes -Warithmetic-osvs -I../copybooks -fpretty-display "
#-fdebugging-line "

for file in sc*.cbl
do
  cobc -m ${COBCOPTS} -T `basename $file .cbl`.listing -Xref $file
  echo "compiled $file"
done

# cobc -x ${COBCOPTS} -T stock.listing -Xref stock.cbl; echo "compiled stock.cbl"
#
