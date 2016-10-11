Scripts to extract antibody sequence data from the INN data

./getlists.pl     - Obtains the Recommended INN PDFs from the WHO website
                    With '-p' obtains the Proposed INN PDFs

./getabs.pl       - Extracts the antibodies from an INN PDF

./dogetallrec.sh  - Simple script to run getabs.pl on all the
                    Recommended INN PDFs on my machine at home

./dogetallprop.sh - Simple script to run getabs.pl on all the Proposed
                    INN PDFs on my machine at home

./check.pl        - Checks the output from getabs.pl to look for
                    unexpected characters.

./clean.pl        - Early attempt at obtaining a clean set of
                    sequences from the concatenated fasta output


        
        
