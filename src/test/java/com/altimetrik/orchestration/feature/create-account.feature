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
Feature: Verify POST API - Creation of Account

  Background: 
    * def functions = callonce read('classpath:karate-reusable.js')
    * def createAccount =  read('classpath:createaccount.json')
    * url baseUrl
    * def random = functions.getRandomString(5)
    * def accountName = 'TestUser' + random
    * set createAccount.acctName = accountName
    * def emailID = 'TestEmail' + random + '@citi.com'
    * set createAccount.contacts.email = emailID
    * print createAccount
    * print baseUrl

  Scenario: Create New Account with all valid data
    Given url baseUrl
    And path path_CreateAccount
    And header clientTxnId = random
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
    And path path_DeleteAccount + '/' + response.data[0].acctId
    And header clientTxnId = random
    When method DELETE
    And status 200

  Scenario Outline: Creating New Account without '<AttributeName>' attribute (Mandatory Field)
    Given url baseUrl
    And path path_CreateAccount
    And header clientTxnId = random
    * remove createAccount.<AttributeName>
    And request createAccount
    When method POST
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 400
    And match header Content-Type == 'application/json'
    And match response.message contains '<MessageText> mandatory'

    Examples: 
      | AttributeName               | MessageText       |
      | acctName                    | Account Name is   |
      | bankDetails                 | Bank details are  |
      | bankDetails.bankId          | Bank Id is        |
      | bankDetails.bankName        | Bank Name is      |
      | bankDetails.ifsc            | IFSC is           |
      | bankDetails.branchCode      | Branch Code is    |
      | contacts.contactNumber      | Contact Number is |
      | addressDetails.addressLine1 | Address Line 1 is |
      | accountType                 | Account Type is   |

  Scenario Outline: Creating New Account with invalid value of '<AttributeName>'
    Given url baseUrl
    And path path_CreateAccount
    And header clientTxnId = random
    * set createAccount.<AttributeName> = '<AttributeValue>'
    And request createAccount
    When method POST
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 400
    And match header Content-Type == 'application/json'
    And match response.message contains '<MessageText>'

    Examples: 
      | AttributeName          | AttributeValue      | MessageText                                                   |
      | acctName               | @#$%^&&             | Only characters and space is allowed                          |
      | acctName               |              123456 | Only characters and space is allowed                          |
      | acctName               | 1254@#$%            | Only characters and space is allowed                          |
      | acctName               | Test_User           | Only characters and space is allowed                          |
      | bankDetails.bankId     | abcd                | Bank Id: Only digits are allowed                              |
      | bankDetails.bankId     | !@#$%               | Bank Id: Only digits are allowed                              |
      | bankDetails.bankId     | 12dc54              | Bank Id: Only digits are allowed                              |
      | bankDetails.bankId     | 87_65               | Bank Id: Only digits are allowed                              |
      | bankDetails.bankName   |              123456 | Only characters are allowed                                   |
      | bankDetails.bankName   | %$^#$@              | Only characters are allowed                                   |
      | bankDetails.bankName   | Bank_1234           | Only characters are allowed                                   |
      | bankDetails.ifsc       | CITI012345          | 4 characters then 0 and 7 alphanumeric characters are allowed |
      | bankDetails.ifsc       | C12I012345          | 4 characters then 0 and 7 alphanumeric characters are allowed |
      | bankDetails.ifsc       |          1234012345 | 4 characters then 0 and 7 alphanumeric characters are allowed |
      | bankDetails.ifsc       | !@#$012345          | 4 characters then 0 and 7 alphanumeric characters are allowed |
      | bankDetails.ifsc       | CITII0123456        | 4 characters then 0 and 7 alphanumeric characters are allowed |
      | bankDetails.branchCode | abcd                | Only digits are allowed                                       |
      | bankDetails.branchCode | !@#$                | Only digits are allowed                                       |
      | bankDetails.branchCode | 12dc45              | Only digits are allowed                                       |
      | bankDetails.branchCode | 23_54               | Only digits are allowed                                       |
      | contacts.contactNumber | abcdef              | Contact Number should have 10 digits                          |
      | contacts.contactNumber | #$@$%^              | Contact Number should have 10 digits                          |
      | contacts.contactNumber |              123456 | Contact Number should have 10 digits                          |
      | contacts.contactNumber |         12345678901 | Contact Number should have 10 digits                          |
      | contacts.contactNumber | asdfghjkle          | Only digits are allowed                                       |
      | contacts.contactNumber | !@#$%^&*()          | Only digits are allowed                                       |
      | contacts.email         | Test.com            | Email is should be proper                                     |
      | contacts.email         | TestEmail@          | Email is should be proper                                     |
      | contacts.email         | Test@#$123@citi.com | Email is should be proper                                     |
      | addressDetails.zip     |               12345 | Only 6 digits allowed                                         |
      | addressDetails.zip     |             1234567 | Only 6 digits allowed                                         |
      | addressDetails.zip     | abcdef              | Only 6 digits allowed                                         |
      | addressDetails.zip     | !@#$%^              | Only 6 digits allowed                                         |
      | addressDetails.zip     | 123c45              | Only 6 digits allowed                                         |
      | accountType            |              123456 | Only characters are allowed                                   |
      | accountType            | !@#$%^              | Only characters are allowed                                   |
      | accountType            | Account2Saving      | Only characters are allowed                                   |

  Scenario Outline: Creating New Account with invalid Attribute name as '<AttributeName>'
    Given url baseUrl
    And path path_CreateAccount
    And header clientTxnId = random
    * set createAccount.<AttributeName> = '123456'
    And request createAccount
    When method POST
    Then print response
    And print responseTime
    And print responseStatus
    And print responseHeaders
    And status 400
    And match header Content-Type == 'application/json'
    And match response.errors contains '<MessageText>'

    Examples: 
      | AttributeName          | MessageText                     |
      | contacts.contactNum    | Please enter valid Request Body |
      | addressDetails.zipcode | Please enter valid Request Body |
      | Amount                 | Please enter valid Request Body |
