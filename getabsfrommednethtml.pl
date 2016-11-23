#!/usr/bin/perl
# This code reads an HTML file from a mednet-communities.net/inn search to find antibodies and outputs the useful information
# 08.11.16 Original   By: ACRM

use strict;

my $rowCount  = 0;
my $dataCount = 0;
my $inTD      = 0;
my $inRow     = 0;
my $td        = '';

while(<>)
{
    chomp;

    # State machine
    if(/\<tr.*\>/)
    {
        $rowCount++;
        $dataCount = 0;
        $inRow     = 1;
    }
    if(/\<\/tr\>/)
    {
        $inRow = 0;
        if($rowCount > 1)
        {
            print "//\n";
        }
    }

    # Read data
    if($inRow && ($rowCount > 1))
    {
        if(/\<td\>/)
        {
            $inTD = 1;
            $dataCount++;
            $td = $_;
        }
        if(/\<\/td\>/)
        {
            if($dataCount == 3)
            {
                PrintClean('INN No: ', $td);
            }
            elsif($dataCount == 4)
            {
                PrintClean('Name: ', $td);
            }
            elsif($dataCount == 5)
            {
                PrintClean('PL: ', $td);
            }
            elsif($dataCount == 6)
            {
                PrintClean('RL: ', $td);
            }
            $inTD = 0;
            $td = '';
        }
        if($inTD)
        {
            $td .= $_;
        }
    }
}

sub PrintClean
{
    my($text, $data) = @_;

    $data =~ s/<.*?>//g;
    $data =~ s/^\s+//;
    $data =~ s/\s+$//;

    print "$text $data\n";
}
