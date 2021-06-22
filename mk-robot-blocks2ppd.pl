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
Resource    ppd-analyst.robot

*** Variables ***
\${URL}             https://localhost:44399
\${phone}           123-456-7890
\${email}           romeo.asuncion+robotframework\@lacity.org
\${address}         101 S Main St
\${city}            Los Angeles
\${zip}             90012
\${reason}          Backlog 
&{RESTRICTIONS}

*** Keywords ***
Add To Restrictions
    [Arguments]    \${primary_street}    \${cross_street}    \${end_of_block}    \${restriction}
    \${block}=    Catenate    SEPARATOR=\${SPACE}-\${SPACE}    \${primary_street}    \${cross_street}    \${end_of_block}
    Log To Console    Adding to RESTRICTIONS: \${restriction}
    Run Keyword If    "\${restriction}"=="\${EMPTY}"    Set To Dictionary    \${RESTRICTIONS}    \${block}=\${EMPTY}
    Run Keyword If    "\${restriction}"!="\${EMPTY}"    Set To Dictionary    \${RESTRICTIONS}    \${block}=\${restriction}

*** Test Cases ***
Initialize
    Login To Website    \${URL}    \${USERNAME}    \${PASSWORD}

INIT

my $post = <<END;
End PPD
    Close Browser

END

my $line=<>; # Remove headers
my $first = 1;
my $last_number = 0;
my $request_type = "";
my $key = "";
my $data = {};
my @cmds = ();
my $pnumber = 0;

while ($line=<>) {
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

    if ($last_action =~ /establishment/i) {
        $key = 'New';
    }
    elsif ($last_action =~ /temporary/i) {
        $key = 'Temp';
    }
    elsif ($last_action =~ /fill-in/i) {
        $key = 'Fill';
    }
    elsif ($last_action =~ /expansion/i) {
        $key = 'Expansion';
    }
    elsif ($last_action =~ /alternate/i) {
        $key = 'Alternate';
    }
    elsif ($last_action =~ /amend/i) {
        $key = 'Amend';
    }
    elsif ($last_action =~ /removal/i) {
        $key = 'Removal';
    }
    elsif ($last_action =~ /dead/i) {
        $key = 'New';
    }
    elsif ($last_action =~ /-/i) {
        $key = 'New';
    }
    else {
        print qq(Error: No matching key found\n);
    }

    # Check if in database already
    my $req_ID = 0;
    my $req_last_name = "";
    my $sql_primary_street = $primary_street;
    my $sql_cross_street = $cross_street;
    my $sql_end_of_block = $end_of_block;
    $sql_primary_street =~ s/'/''/g; # Handle single quote
    $sql_cross_street =~ s/'/''/g;   #
    $sql_end_of_block =~ s/'/''/g;   #
    my $query = qq(select B.id, B.PpdReqId, P.LastName ).
                qq(from Blocks as B join PpdRequests as P on B.PpdReqId=P.Id ).
                qq(where B.PrimarySt='$sql_primary_street' and B.CrossSt='$sql_cross_street' and B.Eob='$sql_end_of_block');
    my $res = `sqlcmd -S localhost -U sa -P BSG4L\@dot100 -d tppd -s ^ -r1 -Q "$query" 2>foobar`;
    if ($res =~ /0 rows affected/) {
        $cmd = qq(    Enter Blocks    ${primary_street}    ${cross_street}    ${end_of_block}\n);
    }
    else {
        my @lines_sql = split /\n/, $res;
        my @data_sql = split /\^/, $lines_sql[2];
        my $ID = trimstr($data_sql[0]);
        $req_ID = trimstr($data_sql[1]);
        $req_last_name = trimstr($sql_data[2]);
        $cmd = qq(    Log To Console    Block ($primary_street, $cross_street, $end_of_block) found: ID=$ID, ReqID=$req_ID, PPD=$number, last_name=$req_last_name\n);
    }

    if (!defined($data->{$key})) {
        $data->{$key} = [];
        push @{$data->{$key}}, qq(    \${first_name}=    Set Variable    AUTO\n);
        push @{$data->{$key}}, qq(    \${last_name}=    Set Variable    PPD $pnumber\n);
        push @{$data->{$key}}, qq(    \${CD}=    Set Variable    $CD\n);
        push @{$data->{$key}}, qq(    \${date_established}=    Set Variable    $date_established\n);
        push @{$data->{$key}}, qq(    \${date_posted}=    Set Variable    $date_posted\n);
        push @{$data->{$key}}, qq(    \${last_action}=    Set Variable    $last_action\n);
        push @{$data->{$key}}, qq(    \${data_entered_by}=    Set Variable    $data_entered_by\n);
        push @{$data->{$key}}, qq(    \${council_file_number}=    Set Variable    $council_file_number\n);
        push @{$data->{$key}}, qq(    \${prop_blocks}=    Catenate    SEPARATOR=,    ${primary_street}    ${cross_street}    ${end_of_block}\n);
        push @{$data->{$key}}, qq(    \${note_date_established}=    Set Variable    Date Established=\${date_established}\n);
        push @{$data->{$key}}, qq(    \${note_date_posted}=    Set Variable    Date Posted=\${date_posted}\n);
        push @{$data->{$key}}, qq(    \${note_data_entered_by}=    Set Variable    Data Entered By=\${data_entered_by}\n);
        push @{$data->{$key}}, qq(    \${note_council_file_number}=    Set Variable    Council File Number=\${council_file_number}\n);
        push @{$data->{$key}}, qq(    \${notes}=    Catenate    SEPARATOR=\\n    \${note_date_established}    \${note_date_posted}    \${note_data_entered_by}    \${note_council_file_number}\n);

        if (!$req_ID) {
            push @{$data->{$key}}, qq(    Go To $key Request Page\n);
            push @{$data->{$key}}, qq(    Create Request    \${first_name}    \${last_name}    \${phone}    \${email}    \${address}    \${city}    \${zip}    \${CD}    \${reason}    \${prop_blocks}\n);
        }

        push @{$data->{$key}}, qq(    Select Request From Inbox    \${last_name}\n);
        push @{$data->{$key}}, qq(    &{RESTRICTIONS}=    Create Dictionary    foo=bar\n);
    }
    push @{$data->{$key}}, $cmd;
    push @{$data->{$key}}, qq(    Add To Restrictions    ${primary_street}    ${cross_street}    ${end_of_block}    ${parking_restrictions}\n);

    if ($number eq $last_number) { # Process same PPD number
        next;
    }

    my $file = "data-$pnumber.robot";
    open fh, ">$file" or die "Cannot write $file";
    print fh $pre;
    foreach my $k (keys(%$data)) {
        if (defined($data->{$k}) {
            print fh @{$data->{$k}};
        }
    }
    print fh $post;
    close fh;

    exit;
}




