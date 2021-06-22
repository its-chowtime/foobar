*** Settings ***
Documentation    RobotFramework for TPPD
...              Author: Romeo Asuncion (LADOT)
...              Date: 04/14/2021
...

Resource         /PreferentialParking/scripts/identity.robot
Resource         /PreferentialParking/scripts/utils.robot


*** Keywords ***
Login To Website
    [Arguments]    ${URL}    ${USERNAME}    ${PASSWORD}
    ${tag}=    Set Variable    Login To Website:
    Open Browser Page    ${URL}
    #Maximize Browser Window
    Set Window Size    1700    1000
    Set Window Position    200    10
    Wait Until Page Contains Element    //a[@id="robot-a-login"]
    Click Link    robot-a-login
    Wait Until Page Contains Element    //input[@id="Email"]
    Input Text    Email    ${USERNAME}
    Input Text    Password    ${PASSWORD}
    Click Button    btnLogin


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


Get Blocks
    ${tag}=    Set Variable    Get Blocks:
    Wait Until Page Contains Element    //a[@id="robot-a-blocks"]
    Click Link    robot-a-blocks
    Wait Until Page Contains Element    //tbody[@id="ppdListTbody"]
    ${rows}=    Get Element Count    //tbody[@id="ppdListTbody"]//tr
    Log To Console    ${tag} Blocks table has rows=${rows}


Get Petitions
    ${tag}=    Set Variable    Get Petitions:
    Wait Until Page Contains Element    //a[@id="robot-a-petitions"]
    Click Link    robot-a-petitions
    Wait Until Page Contains Element    //tbody[@id="ListPetitions"]
    ${rows}=    Get Element Count    //tbody[@id="ListPetitions"]//tr
    Log To Console    ${tag} Petitions table has rows=${rows}


Get Studies
    ${tag}=    Set Variable    Get Studies:
    Wait Until Page Contains Element    //a[@id="robot-a-studies"]
    Click Link    robot-a-studies
    Wait Until Page Contains Element    //tbody[@id="ListStudies"]
    ${rows}=    Get Element Count    //tbody[@id="ListStudies"]//tr
    Log To Console    ${tag} Studies table has rows=${rows}


