DATADIR=/nas/data/andrew/work/inn

for file in $DATADIR/PL*.pdf
do
   ./getabs.pl $file
done
