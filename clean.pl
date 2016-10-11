#!/usr/bin/perl

use strict;

%::data = ();
ReadData();
foreach my $key (sort keys %::data)
{
    print "$key\n";
}


sub ReadData
{
    my $ab    = '';
    my $chain = '';
    my $count = '';
    my $abnam = '';

    while(<>)
    {
        chomp;
        s/^\s+//;
        if(length)
        {
            if(/^>(.*)\|(.*)/)
            {
                $ab    = $1;
                $chain = $2;
                $count = 0;
                $abnam = $ab;
                while(defined($::data{$abnam}{$chain}))
                {
                    $count++;
                    $abnam = "$ab$count";
                }
                $::data{$abnam}{$chain} = '';
            }
            elsif(/^>(.*)\s*-/)
            {
                $abnam = $1;
                if(defined($::data{$abnam}{'noseq'}))
                {
                    $::data{$abnam}{'noseq'}++;
                }
                else
                {
                    $::data{$abnam}{'noseq'} = 0;
                }
            }
            else
            {
                $::data{$abnam}{$chain} .= $_;
            }
        }
    }
}



