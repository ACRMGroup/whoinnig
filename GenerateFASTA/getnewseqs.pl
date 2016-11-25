#!/usr/bin/perl

use strict;


my @allData = ParseINNMedNet();

PrintAllData(@allData);

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
    my $inRow = 0;
    my $inData = 0;
    my $column = -1;
    my @allData = ();
    my @data   = ();

    while(<>)
    {
        chomp;

        if(/\<tr.*\>/)          # Start of a table row
        {
            $inRow  =  1;
            $column = -1;
            @data   = ();
        }
        elsif(/\<\/tr\>/)       # End of a table row
        {
            $inRow = 0;
            CleanData(\@data);
            StoreData(\@allData, \@data);
        }
        elsif($inRow)           # In a row
        {
            if(/\<td\>/)        # In a <td>
            {
                $column++;
                if(/\<td\>(.*)\<\/td\>/) # <td>.....</td>
                {
                    $data[$column] = $1;
                }
                else                     # <td> (data on following lines)
                {
                    $inData = 1;
                    $data[$column] = '';
                }
            }
            elsif(/\<\/td\>/)   # </td>
            {
                $inData = 0;
            }
            elsif($inData)      # Between <td> and </td>
            {
                s/^\s+//;
                s/\s+$//;
                $data[$column] .= " $_";
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

