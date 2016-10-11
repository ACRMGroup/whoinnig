#!/usr/bin/perl

use strict;

my $lineNum=0;
my $abName='';
my $fileName='';
while(<>)
{
    chomp;
    $lineNum++;

    if(/^>(.+)/)
    {
        $abName = $1;
    }

    if(/^\#\#\s*(.+)/)
    {
        $fileName = $1;
        $_ = '';
    }

    s/[a-zA-Z]//g;
    s/\|//g;
    s/\s//g;
    s/\>//g;
    s/-//g;

    if(length)
    {
        printf "%5d: $_\t%s\t(%s)\n", $lineNum, $abName, $fileName;
    }
}
