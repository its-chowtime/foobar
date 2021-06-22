#!/usr/bin/perl
use strict;

sub trimstr {
    my $str = shift;
    $str =~ s/^\s+//;  # Trim front
    $str =~ s/\s+$//;  # Trim end
    $str =~ s/\s+/ /g; # Multiple to one
    return $str;
}

my $pre = <<INIT;
*** Settings ***
Resource    verify.robot

*** Variables ***
\${URL}             https://localhost:44399
\${first_name}      AUTO

*** Test Cases ***
Initialize
    Login To Website    \${URL}    \${USERNAME}    \${PASSWORD}

INIT

my $post = <<END;
End PPD
    Close Browser

END

my $line=<>; # Remove headers
my $new = 1;
my $last_number = 0;
my $block_count;
while ($line=<>) {
    #print fh qq(Processing line=$line\n);
    $line =~ s/\s+$//;
    my @data = split /\|/, $line;
    #Type|Number|CD|Street Name|Cross Street 1|Cross Street 2|Parking Restrictions|Petition Validation|Parking Study|Date Established|Date Posted|Last Action|Data Entered By|Council File Number
    my $type = trimstr($data[0]);
    my $number = trimstr($data[1]);
    my $CD = trimstr($data[2]);
    my $primary_street = trimstr($data[3]);
    my $cross_street = trimstr($data[4]);
    my $end_of_block = trimstr($data[5]);
    my $parking_restrictions = trimstr($data[6]);
    my $petition_validation = trimstr($data[7]);
    my $parking_study = trimstr($data[8]);
    my $date_established = trimstr($data[9]);
    my $date_posted = trimstr($data[10]);
    my $last_action = trimstr($data[11]);
    my $data_entered_by = trimstr($data[12]);
    my $council_file_number = trimstr($data[13]);
    my $file = "ppd-data-$number.txt";

    if (!$new && $number ne $last_number) {
        print fh qq(    Log To Console    Block count=$block_count\n);
        print fh qq(    Get Blocks\n);
        print fh qq(    Get Petitions\n);
        print fh qq(    Get Studies\n);
        print fh qq(\n);
        print fh qq($post);
        print fh qq(\n);
        close fh;
        $new = 1;
    }

    if (!$new && $number eq $last_number) {
        #print fh qq(    Enter Blocks    ${primary_street}    ${cross_street}    ${end_of_block}\n);
        $block_count++;
    }

    if ($new) {
        my $pnumber = sprintf("%04d", $number);
        my $file = "verify-$pnumber.robot";
        open fh, ">$file" or die "Cannot write $file";
        print fh qq($pre);
        print fh qq(PPD $pnumber\n);
        print fh qq(    \${last_name}=    Set Variable    PPD $pnumber\n);
        print fh qq(    Select Request From Inbox    \${first_name}    \${last_name}\n);
        #print fh qq(    Enter Blocks    ${primary_street}    ${cross_street}    ${end_of_block}\n);
        $block_count=1;
        $last_number = $number;
        $new = 0;
    }

    #last if ($number eq '4');
} 



