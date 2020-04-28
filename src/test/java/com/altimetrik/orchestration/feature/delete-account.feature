#Author: your.email@your.domain.com
#Keywords Summary :
#Feature: List of scenarios.
#Scenario: Business rule through list of steps with arguments.
#Given: Some precondition step
#When: Some key actions
#Then: To observe outcomes or validation
#And,But: To enumerate more Given,When,Then steps
#Scenario Outline: List of steps for data-driven as an Examples and <placeholder>
#Examples: Container for s table
#Background: List of steps run before each of the scenarios
#""" (Doc Strings)
#| (Data Tables)
#@ (Tags/Labels):To group Scenarios
#<> (placeholder)
#""
## (Comments)
#Sample Feature Definition Template
Feature: Verify DELETE API - Deletion of Account

  Background: 
    * def functions = callonce read('classpath:karate-reusable.js')
    * def createAccount = read('classpath:createaccount.json')
    * url baseUrl
    * def random = functions.getRandomString(5)
    * def accountName = 'TestUser' + random
    * set createAccount.acctName = accountName
    And path path_CreateAccount
    And header clientTxnId = random
    And request createAccount
    When method POST
    And status 200

  Scenario: Delete Account
    Given url baseUrl
    And path path_DeleteAccount + '/' + response.data[0].acctId
    And header clientTxnId = random
    When method DELETE
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 200
    And match header Content-Type == 'application/json'
    And match response.data[0] == 'Account record deleted Successfully'

  Scenario: Delete Account which is not present
    Given url baseUrl
    And path path_DeleteAccount + '/' + 'CITI12345'
    And header clientTxnId = random
    When method DELETE
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 200
    And match header Content-Type == 'application/json'
    And match response.error[0] contains 'No such Account present'
