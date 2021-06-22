*** Settings ***
Documentation    RobotFramework for TPPD
...              Author: Romeo Asuncion (LADOT)
...              Date: 04/14/2021
...

Resource         identity.robot
Resource         utils.robot


*** Keywords ***
Login To Website
    [Arguments]    ${URL}    ${USERNAME}    ${PASSWORD}
    ${tag}=    Set Variable    Login To Website:
    Open Browser Page    ${URL}
    Maximize Browser Window
    Wait Until Page Contains Element    //a[@id="robot-a-login"]
    Click Link    robot-a-login
    Wait Until Page Contains Element    //input[@id="Email"]
    Input Text    Email    ${USERNAME}
    Input Text    Password    ${PASSWORD}
    Click Button    btnLogin


Go To New Request Page
    ${tag}=    Set Variable    Go To Request Page:
    Wait Until Page Contains Element    //a[@id="robot-a-ppd"]
    Click Link    robot-a-ppd
    Wait Until Page Contains Element    //input[@id="input-Checkbox"]
    Select Checkbox    input-Checkbox
    Click Link    robot-a-new-request


Go To Temp Request Page
    ${tag}=    Set Variable    Go To Request Page:
    Wait Until Page Contains Element    //a[@id="robot-a-ppd"]
    Click Link    robot-a-ppd
    Wait Until Page Contains Element    //input[@id="input-Checkbox"]
    Select Checkbox    input-Checkbox
    Click Link    robot-a-temp-request


Go To Fill Request Page
    ${tag}=    Set Variable    Go To Request Page:
    Wait Until Page Contains Element    //a[@id="robot-a-ppd"]
    Click Link    robot-a-ppd
    Wait Until Page Contains Element    //input[@id="input-Checkbox"]
    Select Checkbox    input-Checkbox
    Click Link    robot-a-fill-request


Go To Expansion Request Page
    ${tag}=    Set Variable    Go To Request Page:
    Wait Until Page Contains Element    //a[@id="robot-a-ppd"]
    Click Link    robot-a-ppd
    Wait Until Page Contains Element    //input[@id="input-Checkbox"]
    Select Checkbox    input-Checkbox
    Click Link    robot-a-exp-request


Go To Alternate Request Page
    ${tag}=    Set Variable    Go To Request Page:
    Wait Until Page Contains Element    //a[@id="robot-a-ppd"]
    Click Link    robot-a-ppd
    Wait Until Page Contains Element    //input[@id="input-Checkbox"]
    Select Checkbox    input-Checkbox
    Click Link    robot-a-alt-request


Go To Amend Request Page
    ${tag}=    Set Variable    Go To Request Page:
    Wait Until Page Contains Element    //a[@id="robot-a-ppd"]
    Click Link    robot-a-ppd
    Wait Until Page Contains Element    //input[@id="input-Checkbox"]
    Select Checkbox    input-Checkbox
    Click Link    robot-a-amend-request


Go To Removal Request Page
    ${tag}=    Set Variable    Go To Request Page:
    Wait Until Page Contains Element    //a[@id="robot-a-ppd"]
    Click Link    robot-a-ppd
    Wait Until Page Contains Element    //input[@id="input-Checkbox"]
    Select Checkbox    input-Checkbox
    Click Link    robot-a-rem-request


Create Request
    [Arguments]    ${first_name}    ${last_name}    ${phone}    ${email}    ${address}    ${city}    ${zip}    ${CD}    ${reason}    ${prop_blocks}
    ${tag}=    Set Variable    Create Request:
    Wait Until Page Contains Element    //input[@id="input-Council"]
    Select Radio Button    Origin    CO
    Set Selenium Speed    0.5
    Input Text    FirstName    ${first_name}
    Input Text    LastName    ${last_name}
    Input Text    Phone    ${phone}
    Input Text    Email    ${email}
    Input Text    Address    ${address}
    Input Text    City    ${city}
    Input Text    Zipcode    ${zip}
    Input Text    Reason    ${reason}
    Input Text    PropBlocks    ${prop_blocks}
    Set Selenium Speed    1.0
    Select From List By Label    CD    ${CD}
    Click Button    btnSubmit


Select Request From Inbox
    [Arguments]    ${first_name}    ${last_name}
    ${tag}=    Set Variable    Select Request From Inbox:
    Wait Until Page Contains Element    //a[@id="robot-a-inbox"]
    Click Link    robot-a-inbox
    Wait Until Page Contains Element    //input[@id="tome"]
    Unselect Checkbox    tome
    Checkbox Should Not Be Selected    tome
    Input Text    input-Search    ${last_name}
    Click Button    btnSubmit
    Wait Until Page Contains Element    //td[contains(text(), "- ${first_name} ${last_name} -")]
    Click Element    //td[contains(text(), "- ${first_name} ${last_name} -")]


Enter PPD Number
    [Arguments]    ${number}
    ${tag}=    Set Variable    Enter PPD Number:
    Wait Until Page Contains Element    //a[@id="robot-a-blocks"]
    Click Link    robot-a-blocks
    ${c}=    Get Element Count    //input[@id="Ppdnum"]
    Run Keyword If    ${c}<1    Log To Console    ${tag} Skipped. Ppdnum not visible.
    Return From Keyword If    ${c}<1
    Input Text     Ppdnum     ${number}
    Click Link    btnAssignPpd
    Alert Should Be Present    action=ACCEPT
    #Wait Until Element Is Visible    //div[@id="divAlertsFunc"]
    #Wait Until Element Is Not Visible    //div[@id="divAlertsFunc"]


Enter Blocks
    [Arguments]    ${primary_street}    ${cross_street}    ${end_of_block}
    ${tag}=    Set Variable    Enter Blocks:
    Wait Until Page Contains Element    //a[@id="robot-a-blocks"]
    Set Selenium Speed    0.5
    Click Link    robot-a-blocks
    Input Text    PrimarySt    ${primary_street}
    Input Text    CrossSt    ${cross_street}
    Input Text    Eob    ${end_of_block}
    Set Selenium Speed    1.0
    Click Button    btnAdd
    #Wait Until Element Is Visible    //div[@id="divAlertsFunc"]
    #Wait Until Element Is Not Visible    //div[@id="divAlertsFunc"]


Enter Petition Percentages
    [Arguments]    ${row}
    ${tag}=    Set Variable    Enter Petition Count:
    Log To Console    ${tag} Waiting for row=${row}
    Wait Until Page Contains Element    //tbody[@id="tblListBlocks"]//tr[${row}]
    Click Element    //tbody[@id="tblListBlocks"]//tr[${row}]
    ${block_text}=    Get Text    //tbody[@id="tblListBlocks"]//tr[${row}]//td[1]
    Log To Console    ${tag} Block text=${block_text}
    Click Link    btnAddPetition
    #Wait Until Element Is Visible    //div[@id="divAlertsFunc"]
    #Wait Until Element Is Not Visible    //div[@id="divAlertsFunc"]
    ${ID_attribute}=    Get Element Attribute    //tbody[@id="ListPetitions"]//tr//td[contains(text(), "${block_text}")]//input    id
    ${petition_label}    ${petition_ID}=    Split String    ${ID_attribute}    _
    Log To Console    ${tag} ID attribute=${ID_attribute}, Petition ID=${petition_ID}
    Input Text    nbAddress_${petition_ID}    10
    Input Text    nbSigned_${petition_ID}    10
    Input Text    Restrictions_${petition_ID}    ${RESTRICTIONS}[${block_text}]
    Click Link    btnSave
    #Wait Until Element Is Visible    //div[@id="divAlertsFunc"]
    #Wait Until Element Is Not Visible    //div[@id="divAlertsFunc"]
 

Enter Petitions
    ${tag}=    Set Variable    Enter Petitions:
    Wait Until Page Contains Element    //a[@id="robot-a-petitions"]
    Click Link    robot-a-petitions
    Wait Until Page Contains Element    //tbody[@id="tblListBlocks"]
    ${block_rows}=    Get Element Count    //tbody[@id="tblListBlocks"]//tr
    Log To Console    ${tag} Blocks table has rows=${block_rows}
    FOR    ${i}    IN RANGE    1    ${block_rows} + 1
        Enter Petition Percentages    ${i}
    END


Enter Study Percentages
    [Arguments]    ${row}
    ${tag}=    Set Variable    Enter Study Count:
    Log To Console    ${tag} Waiting for row=${row}
    Wait Until Page Contains Element    //tbody[@id="tblListBlocks"]//tr[${row}]
    Click Element    //tbody[@id="tblListBlocks"]//tr[${row}]
    ${block_text}=    Get Text    //tbody[@id="tblListBlocks"]//tr[${row}]//td[1]
    Log To Console    ${tag} Block text=${block_text}
    Click Link    btnAddStudy
    #Wait Until Element Is Visible    //div[@id="divAlertsFunc"]
    #Wait Until Element Is Not Visible    //div[@id="divAlertsFunc"]
    ${study_ID}=    Get Element Attribute    //tbody[@id="ListStudies"]//tr//td[contains(text(), "${block_text}")]    data-id
    Log To Console    ${tag} Study ID=${study_ID}
    Input Text    Spaces_${study_ID}    10
    Input Text    Occupancy_${study_ID}    10
    Click Link    btnSave
    #Wait Until Element Is Visible    //div[@id="divAlertsFunc"]
    #Wait Until Element Is Not Visible    //div[@id="divAlertsFunc"]


Enter Studies
    ${tag}=    Set Variable    Enter Studies:
    Wait Until Page Contains Element    //a[@id="robot-a-studies"]
    Click Link    robot-a-studies
    Wait Until Page Contains Element    //tbody[@id="tblListBlocks"]
    ${rows}=    Get Element Count    //tbody[@id="tblListBlocks"]//tr
    Log To Console    ${tag} Blocks table has rows=${rows}
    FOR    ${i}    IN RANGE    1    ${rows} + 1
        Enter Study Percentages    ${i}
    END


Enter Summary
    [Arguments]    ${notes}
    ${tag}=    Set Variable    Enter Summary:
    Wait Until Page Contains Element    //a[@id="robot-a-summary"]
    Click Link    robot-a-summary
    Wait Until Page Contains Element    //textarea[@id="DescriptionNew"]
    Input Text    DescriptionNew    ${notes}
    Click Link    btnSave


