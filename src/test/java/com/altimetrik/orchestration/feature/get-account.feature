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
Feature: Verify GET API - Fetching Account details

  Background: 
    * def functions = call read('classpath:karate-reusable.js')
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
    * def getAllAccounts = read('classpath:getallaccounts.txt')
    * print baseUrl
    * print getAllAccounts

  Scenario: Get All Accounts
    Given url baseUrl
    And path path_GetAccount
    And header clientTxnId = random
    And request getAllAccounts
    When method POST
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 200
    And match header Content-Type == 'application/json'
    And match response.data[0].acctName contains 'TestUser'
    And match response.data[0].bankDetails.bankName == functions.getValueByNestedAttributeAndAcctID(response.data[0].acctId, 'bankDetails', 'bankName')
    And match response.data[0].contacts.email contains '@citi.com'
    And match response.data[0].addressDetails.country == functions.getValueByNestedAttributeAndAcctID(response.data[0].acctId, 'addressDetails', 'country')
    * def actualAmount = response.data[0].amount
    * string strAmount = { amount: '#(1 * actualAmount)' }
    And match strAmount == '{"amount":50009.957}'
    And match response.data[0].audit.createdBy == functions.getValueByNestedAttributeAndAcctID(response.data[0].acctId, 'audit', 'createdBy')
    And path path_DeleteAccount + '/' + response.data[0].acctId
    And header clientTxnId = random
    When method DELETE
    And status 200

  Scenario: Get Account by Account ID
    Given url baseUrl
    And path path_GetAccount
    * def getAccountByID = functions.getAcctByID(response.data[0].acctId)
    * print getAccountByID
    And request getAccountByID
    And header clientTxnId = random
    When method POST
    Then status 200
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And match header Content-Type == 'application/json'
    And match response.data[0].acctName == functions.getValueByAttributeAndAcctID(response.data[0].acctId, 'acctName')
    And match response.data[0].bankDetails.bankName == functions.getValueByNestedAttributeAndAcctID(response.data[0].acctId, 'bankDetails', 'bankName')
    And match response.data[0].contacts.email == functions.getValueByNestedAttributeAndAcctID(response.data[0].acctId, 'contacts', 'email')
    And match response.data[0].addressDetails.country == functions.getValueByNestedAttributeAndAcctID(response.data[0].acctId, 'addressDetails', 'country')
    * def actualAmount = response.data[0].amount
    * string strAmount = { amount: '#(1 * actualAmount)' }
    And match strAmount == '{"amount":50009.957}'
    And match response.data[0].audit.createdBy == functions.getValueByNestedAttributeAndAcctID(response.data[0].acctId, 'audit', 'createdBy')
    And path path_DeleteAccount + '/' + response.data[0].acctId
    And header clientTxnId = random
    When method DELETE
    And status 200
