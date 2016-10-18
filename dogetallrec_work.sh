DATADIR=/acrm/data/inn

for file in $DATADIR/RL*.pdf
do
   ./getabs.pl $file
done
