#!/usr/bin/perl

# Script to extract key data from the INN Mednet HTML search results
# Puts the key information in separate lines


use strict;
my $inRow = 0;
my $inTD  = 0;
my $tdCount = 0;
my $data = '';

while(<>)
{
    chomp;
    s/\r//;
    s/^\s+//;
    s/\s+$//;

    if(/<tr.*?>/)
    {
        $inRow   = 1;
        $tdCount = 0;
    }
    elsif(/<\/tr>/)
    {
        $inRow = 0;
        print "//\n";
    }
    elsif($inRow)
    {
        if(/<td>/)
        {
            $tdCount++;
            $inTD = 1;
            $data = '';
        }
        if($inTD)
        {
            s/&nbsp;/unknown/;
            if(/href="/)
            {
                s/href="/href="https:\/\/mednet-communities.net\/inn\/db\//;
                s/<img.*?>//g;
                s/<a\s+href="//;
                s/">/     /;
                s/<\/a>//;
            }
            $data .= $_;
        }
        if(/<\/td>/)
        {
            $inTD = 0;
            if(($tdCount == 1)||
               ($tdCount == 2)||
               ($tdCount == 3)||
               ($tdCount == 4))
            {
                $data =~ s/<td>//;
                $data =~ s/<\/td>//;
                $data =~ s/<small>//;
                $data =~ s/<\/small>//;

                print "$data\n";
            }
        }
    }
}
