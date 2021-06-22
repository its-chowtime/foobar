*** Settings ***
Resource    ppd-analyst.robot

*** Variables ***
${URL}             http://localhost:54398
${first_name}      AUTO
${phone}           123-456-7890
${email}           romeo.asuncion+robotframework@lacity.org
${address}         101 S Main St
${city}            Los Angeles
${zip}             90012
${reason}          Backlog 
&{RESTRICTIONS}

*** Keywords ***
Add To Restrictions
    [Arguments]    ${primary_street}    ${cross_street}    ${end_of_block}    ${restriction}
    ${block}=    Catenate    SEPARATOR=${SPACE}-${SPACE}    ${primary_street}    ${cross_street}    ${end_of_block}
    Run Keyword If    "${restriction}"=="${EMPTY}"    Set To Dictionary    ${RESTRICTIONS}    ${block}=${EMPTY}
    Run Keyword If    "${restriction}"!="${EMPTY}"    Set To Dictionary    ${RESTRICTIONS}    ${block}=${restriction}

*** Test Cases ***
Initialize
    Login To Website    ${URL}    ${USERNAME}    ${PASSWORD}

PPD 1003
    ${last_name}=    Set Variable    PPD 0003
    ${CD}=    Set Variable    12
    ${primary_street}=    Set Variable    Cantara Street
    ${cross_street}=    Set Variable    Garden Grove Avenue
    ${end_of_block}=    Set Variable    Wynne Avenue
    ${date_established}=    Set Variable    3/1/2016
    ${date_posted}=    Set Variable    -
    ${last_action}=    Set Variable    -
    ${data_entered_by}=    Set Variable    SM
    ${council_file_number}=    Set Variable    81-5863
    ${prop_blocks}=    Catenate    SEPARATOR=,    ${primary_street}    ${cross_street}    ${end_of_block}
    ${note_date_established}=    Set Variable    Date Established=${date_established}
    ${note_date_posted}=    Set Variable    Date Posted=${date_posted}
    ${note_last_action}=    Set Variable    Last Action=${last_action}
    ${note_data_entered_by}=    Set Variable    Data Entered By=${data_entered_by}
    ${note_council_file_number}=    Set Variable    Council File Number=${council_file_number}
    ${notes}=    Catenate    SEPARATOR=\n    ${note_date_established}    ${note_date_posted}    ${note_last_action}    ${note_data_entered_by}    ${note_council_file_number}
    Go To New Request Page
    Create Request    ${first_name}    ${last_name}    ${phone}    ${email}    ${address}    ${city}    ${zip}    ${CD}    ${reason}    ${prop_blocks}
    Select Request From Inbox    ${first_name}    ${last_name}
    &{RESTRICTIONS}=    Create Dictionary    foo=bar
    Enter PPD Number    3
    Enter Blocks    Cantara Street    Garden Grove Avenue    Wynne Avenue
    Add To Restrictions    Cantara Street    Garden Grove Avenue    Wynne Avenue    N/A
    Enter Blocks    Cantara Street    Wynne Avenue    Nestle Avenue
    Add To Restrictions    Cantara Street    Wynne Avenue    Nestle Avenue    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt
    Enter Blocks    Cantara Street    Nestle Avenue    Etiwanda Avenue
    Add To Restrictions    Cantara Street    Nestle Avenue    Etiwanda Avenue    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt
    Enter Blocks    Cantara Street (N/S)    Etiwanda Avenue    Darby Place
    Add To Restrictions    Cantara Street (N/S)    Etiwanda Avenue    Darby Place    N/A
    Enter Blocks    Cantara Street (S/S)    Etiwanda Avenue    Darby Place
    Add To Restrictions    Cantara Street (S/S)    Etiwanda Avenue    Darby Place    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt
    Enter Blocks    Cantara Street (N/S)    Darby Place    Darby Avenue
    Add To Restrictions    Cantara Street (N/S)    Darby Place    Darby Avenue    N/A
    Enter Blocks    Cantara Street (S/S)    Darby Place    Darby Avenue
    Add To Restrictions    Cantara Street (S/S)    Darby Place    Darby Avenue    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt
    Enter Blocks    Darby Avenue    Lorne Street    Cantara Street
    Add To Restrictions    Darby Avenue    Lorne Street    Cantara Street    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt
    Enter Blocks    Darby Place    Lorne Street    Cantara Street
    Add To Restrictions    Darby Place    Lorne Street    Cantara Street    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt
    Enter Blocks    Etiwanda Avenue    Lorne Street    Cantara Street
    Add To Restrictions    Etiwanda Avenue    Lorne Street    Cantara Street    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt (Posted on Residential Portion)
    Enter Blocks    Etiwanda Avenue    Cantara Street    Roscoe Boulevard
    Add To Restrictions    Etiwanda Avenue    Cantara Street    Roscoe Boulevard    N/A
    Enter Blocks    Garden Grove Avenue    Cantara Street    Cul-De-Sac N of Cantara Street
    Add To Restrictions    Garden Grove Avenue    Cantara Street    Cul-De-Sac N of Cantara Street    N/A
    Enter Blocks    Nestle Avenue    Lorne Street    Cantara Street
    Add To Restrictions    Nestle Avenue    Lorne Street    Cantara Street    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt (Posted on Residential Portion)
    Enter Blocks    Nestle Avenue    Cantara Street    Cul-De-Sac N of Cantara Street
    Add To Restrictions    Nestle Avenue    Cantara Street    Cul-De-Sac N of Cantara Street    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt
    Enter Blocks    Wynne Avenue    Nestle Avenue    Cantara Street
    Add To Restrictions    Wynne Avenue    Nestle Avenue    Cantara Street    N/A
    Enter Blocks    Wynne Avenue    Cantara Street    Cul-De-Sac N of Cantara Street
    Add To Restrictions    Wynne Avenue    Cantara Street    Cul-De-Sac N of Cantara Street    No Parking 8AM - 6PM Mon. - Fri.; Vehicles with District No. 3 Permits Exempt
    Enter Petitions
    Enter Studies
    Enter Summary    ${notes}

