#!/usr/bin/perl

use strict;

$::dataDir = "data/";
$::binDir  = "share/bin";


my @allData = ParseINNMedNet();
PrintAllData(@allData);

GetMissingFiles($::dataDir, @allData)


sub GetMissingFiles
{
    my($dataDir, @allData) = @_;

    foreach my $item (@allData)
    {
        my $id      = $$item{'id'};
        my $url     = $$item{'url'};
        my $faaFile = "$dataDir/$id.faa";
        if(! -e $faaFile)
        { 
            GrabURLAsFAA($url, $id, $faaFile);
        }
    }
}

sub GrabURLAsFAA
{
    my($url, $id, $faaFile) = @_;
    my $tStem = "$$" .  time();
    my $tmpDoc = "/var/tmp/$tStem.doc";
    my $tmpTxt = "/var/tmp/$tStem.txt";

    `wget -o $tmpDoc $url`;

    DocToFAA($tmpDoc, $tmptxt, $faaFile);

    unlink($tmpDoc);
    unlink($tmpTxt);
}


sub DocToFAA
{
    my($tmpDoc, $tmpTxt, $faaFile) = @_; 
    my $exe = "$::binDir/catdoc $tmpDoc > $tmpTxt";
    `$exe`;
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

