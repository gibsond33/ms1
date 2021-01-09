#!/usr/bin/env bash

# Compiles programs and modules in the common directory

COBCOPTS="-Wextra -debug -fnotrunc -fword-length=63 -ftab-width=2 -Wparentheses -Wstrict-typing -Wimplicit-define -Wcorresponding -Winitial-value -Wprototypes -Warithmetic-osvs -I../copybooks -fpretty-display "
#-fdebugging-line "

for file in ms*.cbl
do
  cobc -m ${COBCOPTS} -T `basename $file .cbl`.listing -Xref $file
  echo "compiled $file"
done

cobc -m ${COBCOPTS} -T syssetup.listing -Xref syssetup.cbl; 
cobc -x ${COBCOPTS} -T syssetup.listing -Xref syssetup.cbl; echo "compiled syssetup.cbl"
cobc -x ${COBCOPTS} -T sysserialup.listing -Xref sysserialup.cbl; echo "compiled sysserialup.cbl"
#
