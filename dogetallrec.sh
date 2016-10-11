DATADIR=/nas/data/andrew/work/inn

for file in $DATADIR/RL*.pdf
do
   ./getabs.pl $file
done
