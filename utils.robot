*** Settings ***
Documentation    RobotFramework for Teams
...              Author: Romeo Asuncion (LADOT)
...              Date: 05/27/2020
...
...              Utility keywords/functions for Teams

Library          SeleniumLibrary
Library          DateTime
Library          Collections
Library          String



*** Variables ***
${DEBUG}      1
${BROWSER}    Chrome
${DELAY}      1



*** Keywords ***
Debug
#****
#
# Args: Message
# Return: none
#
    [Arguments]    ${message}
    Run Keyword If    "${message}"=="${EMPTY}"    Fail    Debug: Message required
    Run Keyword If    "${DEBUG}"=="1"    Log To Console    ${message}



Date String
#**********
#
# Args: none
# Return: Current date (YYYY-MM-DD HH:MM:SS)
#
    ${tag}=    Set Variable    Date String
    ${now}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Debug    ${tag}: now=${now}
    Return From Keyword    ${now}



Date YMD
#*******
#
# Args: none
# Return: Current date (YYYYMMDD)
#
    ${tag}=    Set Variable    Date YMD
    ${now}=    Get Current Date    result_format=%Y%m%d
    Debug    ${tag}: now=${now}
    Return From Keyword    ${now}



Date Numeric
#***********
#
# Args: none
# Return: Current date (YYYYMMDD.HHMMSS)
#
    ${tag}=    Set Variable    Date Numeric
    ${now}=    Get Current Date    result_format=%Y%m%d.%H%M%S
    Debug    ${tag}: now=${now}
    Return From Keyword    ${now}



Date Second
#**********
#
# Args: none
# Return: Current second (SS)
#
    ${tag}=    Set Variable    Date Second
    ${now}=    Get Current Date    result_format=datetime
    Debug    ${tag}: now=${now}
    Return From Keyword    ${now.second}



Date To Day
#**********
#
# Args: Date (MM/DD/YYYY)
# Return: Day (DD)
#
    [Arguments]    ${date}
    ${tag}=    Set Variable    Date To Day
    Run Keyword If    "${date}"=="${EMPTY}"    Fail    ${tag}: Date required
    ${day}=    Convert Date    ${date}    date_format=%m/%d/%Y    result_format=%d    exclude_millis=True
    Debug    ${tag}: day=${day}
    Return From Keyword    ${day}



Date Month
#*********
#
# Args: none
# Return: Current month (MM)
#
    ${tag}=    Set Variable    Date Month
    ${now}=    Get Current Date    result_format=datetime
    Debug    ${tag}: now=${now}
    Return From Keyword    ${now.month}



Date To Month
#************
#
# Args:  Date (MM/DD/YYYY)
# Return: Month (MM)
#
    [Arguments]    ${date}
    ${tag}=    Set Variable    Date To Month
    Run Keyword If    "${date}"=="${EMPTY}"    Fail    ${tag}: Date required
    ${month}=    Convert Date    ${date}    date_format=%m/%d/%Y    result_format=%m    exclude_millis=True
    Debug    ${tag}: month=${month}
    Return From Keyword    ${month}



Open Browser Page
#****************
#
# Args: URL
# Return: none
#
    [Arguments]    ${url}
    ${tag}=    Set Variable    Open Browser Page
    Run Keyword If    "${URL}"=="${EMPTY}"    Fail    ${tag}: URL required
    Open Browser    ${url}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Debug    ${tag}: Done



Enter Credentials
#****************
#
# Args: Username, Password
# Return: none
#
    [Arguments]    ${username}    ${password}
    ${tag}=    Set Variable    Enter Credentials
    Run Keyword If    "${username}"=="${EMPTY}"    Fail    ${tag}: Username required
    Run Keyword If    "${password}"=="${EMPTY}"    Fail    ${tag}: Password required
    Input Text    Email    ${username}
    Input Text    Password    ${password}
    Click Button    btnSubmit
    Debug    ${tag}: Done



Login As
#*******
#
# Args: Username, Password, Title
# Return: none
#
    [Arguments]    ${username}    ${password}    ${title}
    ${tag}=    Set Variable    Login As
    Run Keyword If    "${username}"=="${EMPTY}"    Fail    ${tag}: Username required
    Run Keyword If    "${password}"=="${EMPTY}"    Fail    ${tag}: Password required
    Run Keyword If    "${title}"=="${EMPTY}"    Fail    ${tag}: Title required
    Enter Credentials    ${username}    ${password}
    Title Should Be    ${title}
    Debug    ${tag}: Done



Click Panel
#**********
#
# Args: Panel
# Return: none
#
    [Arguments]    ${panel}
    ${tag}=    Set Variable    Click Panel
    Run Keyword If    "${panel}"=="${EMPTY}"    Fail    ${tag}: Panel required
    Wait Until Page Contains Element    //a[contains(text(), "${panel}")]
    Click Element    //a[contains(text(), "${panel}")]
    Debug    ${tag}: Done



Wait For Map Render
#******************
#
# Args: none
# Return: none
#
    ${tag}=    Set Variable    Wait For Map Render
    Wait Until Page Contains Element    mapDiv_layer0
    ${count}=    Get Element Count    //img[contains(@id, "mapDiv_layer0_tile")]
    Debug    ${tag}: count=${count}
    Run Keyword If    ${count} >= '25'    Wait Until Page Contains Element    //img[contains(@id, "_4_4")]
    Run Keyword If    ${count} >= '16'    Wait Until Page Contains Element    //img[contains(@id, "_3_3")]
    Debug    ${tag}: Done

