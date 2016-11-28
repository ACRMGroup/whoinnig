#!/usr/bin/perl

use strict;

$::dataDir = "./data";
$::binDir  = "share/bin";
$::URLBase = "https://mednet-communities.net/inn/db";


my @allData = ParseINNMedNet();
PrintAllData(@allData);

GetMissingFiles($::dataDir, @allData);


sub GetMissingFiles
{
    my($dataDir, @allData) = @_;

    foreach my $item (@allData)
    {
        my $id      = $$item{'id'};
        my $url     = $$item{'url'};
        my $name    = $$item{'name'};
        my $faaFile = "$dataDir/faa/$id.faa";
        if(($url ne "NULL") && (! -e $faaFile))
        { 
            GrabURLAsFAA($name, $url, $id, $faaFile);
        }
    }
}

sub GrabURLAsFAA
{
    my($name, $url, $id, $faaFile) = @_;
    my $tmpDoc = "$::dataDir/doc/$id.doc";
    my $tmpTxt = "$::dataDir/txt/$id.txt";

    my $fullURL = "$::URLBase/$url";


    `wget -O $tmpDoc $fullURL`           if(! -e $tmpDoc);
    `$::binDir/catdoc $tmpDoc > $tmpTxt` if(! -e $tmpTxt);

    TxtToFAA($name, $tmpTxt, $faaFile);
}


# ----------------------------------------------------------------------
# Parses a INN MedNet .html results file to find URLs, IDs, Name,
# Proposed list and Recommended list for each entry. Results are
# returned as an array of hashes where the had indexes are 
# - url
# - id
# - name
# - proposed
# - recommended
sub ParseINNMedNet
{
    my @allData   = ();
    my @data      = ();
    my $rowCount  = 0;
    my $dataCount = -1;
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
            $dataCount = -1;
            $inRow     = 1;
        }
        if(/\<\/tr\>/)
        {
            $inRow = 0;
            if($rowCount > 1)
            {
                CleanData(\@data);
                StoreData(\@allData, \@data);
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
                $data[$dataCount] = $td;
                $inTD = 0;
                $td = '';
            }
            if($inTD)
            {
                $td .= $_;
            }
        }
    }

    return(@allData); 
}

# ----------------------------------------------------------------------
# Cleans up the data array retrieved from an entry.  Slot[0] contains
# the URL so we extract that - NULL if missing. Other slots contain
# markup which we wish to remove as well as extraneous whitespace.
sub CleanData
{
    my($aData) = @_;

    my $nData = scalar(@$aData);

    for(my $i=0; $i<$nData; $i++)
    {
        if($i==0)
        {
            if($$aData[$i] =~ /\<a\s+href=['"](.*?)['"]/)
            {
                $$aData[$i] = $1;
            }
            else
            {
                $$aData[$i] = "NULL";
            }
        }
        else
        {
            $$aData[$i] =~ s/\<.*?\>//g;
            $$aData[$i] =~ s/&nbsp;//;
            $$aData[$i] =~ s/^\s+//;
            $$aData[$i] =~ s/\s+$//;
        }
    }
}


# ----------------------------------------------------------------------
# Takes a reference to the array of hashes and a reference to the data
# array for a given line of data. Constructs a hash out of the latter
# and pushes it onto the data array
sub StoreData
{
    my($aAllData, $aData) = @_;

    push @$aAllData, {url=>$$aData[0], id=>$$aData[2], name=>$$aData[3],
                      proposed=>$$aData[4], recommended=>$$aData[5]};
}


# ----------------------------------------------------------------------
# Prints all items in the data array
sub PrintAllData
{
    my(@allData) = @_;

    foreach my $data (@allData)
    {
        printf("%-20s %5d %-35s %4d %4d\n",
               $$data{'url'}, $$data{'id'}, $$data{'name'}, 
               $$data{'proposed'}, $$data{'recommended'});
    }
}

# ----------------------------------------------------------------------
sub TxtToFAA
{
    my($name, $tmpTxt, $faaFile) = @_; 

    if(open(my $inFp, '<', $tmpTxt))
    {
        if(open(my $outFp, '>', $faaFile))
        {
            my $inChain = 0;
            my $chain   = '';
            my $seq     = '';
            while(<$inFp>)
            {
                chomp;
                s/^\s+//;
                if(length)
                {
                    if(/^heavy/i)
                    {
                        $inChain = 1;
                        $seq     = '';
                        print $outFp ">${name}_H\n";
                    }
                    elsif(/^light/i)
                    {
                        $inChain = 1;
                        $seq     = '';
                        print $outFp ">${name}_L\n";
                    }
                    elsif(/disulphide/i || /disulfide/i)
                    {
                        $inChain = 0;
                    }
                    elsif($inChain)
                    {
                        s/\s+/ /g;
                        s/[0-9]//g;
                        s/\?//g;
                        print $outFp "$_\n";
                    }
                }
            }
            close $outFp;
        }
        else
        {
            print STDERR "Warning: Unable to write FAA file: $faaFile\n";
        }
        close $inFp;
    }
    else
    {
        print STDERR "Warning: Unable to read text file: $tmpTxt\n";
    }
}

