COBCOPTS="-Wextra -debug -fnotrunc -fword-length=63 -ftab-width=2 -Wparentheses -Wstrict-typing -Wimplicit-define -Wcorresponding -Winitial-value -Wprototypes -Warithmetic-osvs -I./copybooks -fpretty-display "
#-fdebugging-line "

echo "cobc -x ${COBCOPTS} -T MS.listing -Xref MS.cbl"
cobc -x ${COBCOPTS} -T MS.listing -Xref MS.cbl; echo "compiled MS.cbl"

cd common
./comp-common.sh

cd ../stock
./comp-stock.sh

cd ../purchase
./comp-purchase.sh
