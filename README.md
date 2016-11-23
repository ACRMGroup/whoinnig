WHOINNIg
========

These are scripts to extract data about antibody sequences in the WHO
INN and build our web site as part of abYbank.

Files in the main directory are for extracting information from the
Word files that are available for each individual antibody.




ExtractFromPDF
--------------

These scripts are designed to extract antibody sequence data from the
INN PDF files.

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


        
        
Notes
=====

Not available in the text INN files

- gemtuzumab ozogamicin
- abciximab
- nofetumomab (diagnositic)
- imiciromab (diagnositic)
- arcitumomab (diagnositic)
- infliximab
- adalimumab
- natalizumab
- rituximab
- vendolizumab
- alemtuzumab
- pantumumab
- palivizumab
- muromonab
- basiliximab
- abciximab

Partially in INN files

- 'trastuzumab emtansine' appears but not normal 'trastuzumab'

Nonstandard entries without a # or *

- inotuzumabum ozogamicinum
- ranibizumab
- certolizumab
- sulesomab
- omalizumab
- certolizumab pegol
- ofatumumab
- pertuzumab
- raxibacumab
- golimumab
- tocilizumab
- belimumab
- eculizumab
- ranibizumab


