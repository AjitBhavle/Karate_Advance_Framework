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
Feature: Verify All APIs related to Accounts

  Background: 
    * def functions = callonce read('classpath:karate-reusable.js')
    * def createAccount = read('classpath:createaccount.json')
    * url baseUrl
    * print baseUrl
    * def random = functions.getRandomString(5)
    * print random
    * def accountName = 'TestUser_' + random
    * print accountName
    * set createAccount.acctName = accountName
    * def emailID = 'TestEmail' + random + '@citi.com'
    * set createAccount.contacts.email = emailID
    * def getAllAccounts = read('classpath:getallaccounts.txt')
    * def updateAccount = read('classpath:updateaccount.json')
    * def random = functions.getRandomString(5)
    * def accountName1 = 'TestUser_' + random
    * set updateAccount.acctName = accountName1
    * def emailID1 = 'TestEmail' + random + '@citi.com'
    * set updateAccount.contacts.email = emailID1

  Scenario: Accounts Operations
    #Create account
    Given url baseUrl
    And path path_CreateAccount
    And request createAccount
    When method POST
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
    # Get Account By ID
    And path path_GetAccount
    * def getAccountByID = functions.getAcctByID(response.data[0].acctId)
    * print getAccountByID
    And request getAccountByID
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
    # Get All Accounts
    And path path_GetAccount
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
    # Update Account
    And path path_UpdateAccount
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
    And match response.data[0].acctName == accountName1
    And match response.data[0].bankDetails.bankName == functions.getValueByAttribute(accountName1, 'bankDetails', 'bankName')
    And match response.data[0].contacts.email == emailID1
    And match response.data[0].addressDetails.country == functions.getValueByAttribute(accountName1, 'addressDetails', 'country')
    * def actualAmount = response.data[0].amount
    * string strAmount = { amount: '#(1 * actualAmount)' }
    And match strAmount == '{"amount":50009.957}'
    And match response.data[0].audit.createdBy == functions.getValueByAttribute(accountName1, 'audit', 'createdBy')
    # Delete Account
    And path path_DeleteAccount + '/' + response.data[0].acctId
    When method DELETE
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 200
    And match header Content-Type == 'application/json'
    And match response.data[0] == 'Account record deleted Successfully'
