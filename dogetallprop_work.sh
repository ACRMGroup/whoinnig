DATADIR=/acrm/data/inn

for file in $DATADIR/PL*.pdf
do
   ./getabs.pl $file
done
