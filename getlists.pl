#!/usr/bin/perl -s

use strict;


my $url    = "http://www.who.int/entity/medicines/publications/druginformation/innlists/%s?ua=1";


UsageDie() if(defined($::h));

$::maxRecInn  = 76;
$::maxPropInn = 115;
my $maxInn    = 0;

if(defined($::n))
{
    $maxInn = $::n;
}
else
{
    $maxInn = (defined($::p))?$::maxPropInn:$::maxRecInn;
}


for(my $i=1; $i<$maxInn; $i++)
{
    my $filename = '';
    if(defined($::p))
    {
        $filename = sprintf("PL%02d.pdf",$i);
    }
    else
    {
        $filename = sprintf("RL%02d.pdf",$i);
    }

    my $fullURL  = sprintf($url, $filename);

    if((! -e $filename) || defined($::f))
    {
        `wget -O $filename $fullURL`;
    }
}

sub UsageDie
{
    print <<__EOF;

getlists V1.0

getlists [-n maxinn] [-f] [-p]
         -n Specify last INN file to grab [Default 

Grabs all the INN recommended or proposed name PDF files

__EOF
}
