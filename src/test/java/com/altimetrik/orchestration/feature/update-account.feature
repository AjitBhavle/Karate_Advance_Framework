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
Feature: Verify PUT API - Updation of Account

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
    * def updateAccount = read('classpath:updateaccount.json')
    * def random = functions.getRandomString(5)
    * def accountName = 'TestUser' + random
    * set updateAccount.acctName = accountName
    * def emailID = 'TestEmail' + random + '@citi.com'
    * set updateAccount.contacts.email = emailID
    * print baseUrl

  Scenario: Update Account Details
    Given url baseUrl
    And path path_UpdateAccount
    And header clientTxnId = random
    * set updateAccount.acctId = response.data[0].acctId
    * print updateAccount
    And request updateAccount
    When method PUT
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 200
    And match header Content-Type == 'application/json'
    And match response.data[0].acctName == accountName
    And match response.data[0].bankDetails.bankName == functions.getValueByAttribute(accountName, 'bankDetails', 'bankName')
    And match response.data[0].contacts.email == emailID
    And match response.data[0].addressDetails.country == functions.getValueByAttribute(accountName, 'addressDetails', 'country')
    * def actualAmount = response.data[0].amount
    * string strAmount = { amount: '#(1 * actualAmount)' }
    And match strAmount == '{"amount":50009.957}'
    And match response.data[0].audit.createdBy == functions.getValueByAttribute(accountName, 'audit', 'createdBy')
    And path path_DeleteAccount + '/' + response.data[0].acctId
    And header clientTxnId = random
    When method DELETE
    And status 200

  Scenario: Update Account which is not present
    Given url baseUrl
    And path path_UpdateAccount
    And header clientTxnId = random
    * set updateAccount.acctId = 'CITI12345'
    * print updateAccount
    And request updateAccount
    When method PUT
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 200
    And match header Content-Type == 'application/json'
    And match response.error[0] contains 'No such Account present'
