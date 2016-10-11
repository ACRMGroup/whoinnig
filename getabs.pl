#!/usr/bin/perl

# etaracizumab has a trailing ' on the light chain
# emicizumab is a bispecific

use strict;

my $pdffile = shift (@ARGV);

my $txtfile = $pdffile;

if($pdffile =~ /.pdf/)
{
    system("pdftotext -layout $pdffile");
    $txtfile =~ s/\.pdf//;
    $txtfile .= ".txt";
}

if(open(my $fp, '<', $txtfile))
{
    ProcessFile($fp);
    close $fp;
}
else
{
    die "Can't read $txtfile";
}

sub ProcessFile
{
    my($fp) = @_;

    my $abname      = '';
    my $inHeavy     = 0;
    my $inLight     = 0;
    my $gotSequence = 0;
    my $fusion      = 0;
    my $isAntibody  = 0;
    my $hcCount     = '';
    my $lcCount     = '';

    while(<$fp>)
    {
        chomp;


        if(/^\s?([a-zA-Z]+mabum.*)\s?[\#\*]/)
        {
            if(($abname ne '') && (!$gotSequence))
            {
                print ">$abname - no sequence\n";
            }

            $abname      = $1;
            $abname      = DeLatinify($abname);
            $gotSequence = 0;
            $isAntibody  = 1;
            $hcCount     = '';
            $lcCount     = '';
            print "\n\n";
        }
        elsif(/^\s?[a-zA-Z]+um\s/ ||
              /^\s?[a-zA-Z]+um$/)
        {
            $isAntibody = 0;
        }
        elsif($isAntibody && /Heavy chain[\s\-]/)
        {
            if(/fused/i || /toxin/i)
            {
                $fusion = 1;
                print ">$abname|Heavy$hcCount|Fusion\n";
            }
            else
            {
                $fusion = 0;
                print ">$abname|Heavy$hcCount\n";
            }
            $inHeavy = 1;
            $inLight = 0;
            $gotSequence = 1;
            if($hcCount eq '')
            {
                $hcCount = 2;
            }
            else
            {
                $hcCount++;
            }
        }
        elsif($isAntibody && /Light chain[\s\-]/)
        {
            if(/fused/i || /toxin/i)
            {
                $fusion = 1;
                print ">$abname|Light$lcCount|Fusion\n";
            }
            else
            {
                $fusion = 0;
                print ">$abname|Light$lcCount\n";
            }
            $inHeavy = 0;
            $inLight = 1;
            $gotSequence = 1;
            if($lcCount eq '')
            {
                $lcCount = 2;
            }
            else
            {
                $lcCount++;
            }
        }
        elsif(!length)
        {
            $inHeavy = 0;
            $inLight = 0;
        }
        elsif(/Disulphide/ || /Disulfide/ || /N-glyc/ || /Modified/)
        {
            $inHeavy = 0;
            $inLight = 0;
        }
        elsif($isAntibody && $inLight)
        {
            s/\s//g;            # Remove whitespace
            s/\d//g;            # Remove digits
            s/'//g;             # Remove ' 
                                #   (RL65 obinutuzumab and RL61 etaracizumab)
            if($fusion)
            {
                if(!(/fus/ || /[\(\)]/))
                {
                    print "$_\n";
                }
            }
            else
            {
                print "$_\n";
            }
        }
        elsif($isAntibody && $inHeavy)
        {
            s/\s//g;            # Remove whitespace
            s/\d//g;            # Remove digits
            if($fusion)
            {
                if(!(/fus/ || /[\(\)]/))
                {
                    print "$_\n";
                }
            }
            else
            {
                print "$_\n";
            }
        }
        
    }

    # Deal with the last antibody if it didn't have a sequence
    if(($abname ne '') && (!$gotSequence))
    {
        print ">$abname - no sequence\n";
    }
}

sub DeLatinify
{
    my($name) = @_;

    $name =~ s/^\s//g;
    $name =~ s/\s$//g;

    my @fields = split(/\s/, $name);
    $name = '';
    my $count = 0;
    foreach my $field (@fields)
    {
        if(!$count)             # First word is the antibody
        {
            $field =~ s/mabum$/mab/;
        }
        else                    # Other words are the modification
        {
            $field =~ s/um$//;
        }
        $name = ($name eq '')?$field:"$name $field";
        $count++;
    }
    return($name);
}
