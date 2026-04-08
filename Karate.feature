  #Author: Anusha Poojary
  #Keywords Summary : LMT-187587, LMT-128515, Post, Market Details, Validations, RulesMS

  Feature: LMT-187587, LMT-128515 Enhancements in Support of Business Validations - Market Details Validations (Rules MS)

    Background: Setup and declarations
      * def utils = call _utils
      * def sleep = utils.sleep
      * def delay = 2000
      * sleep(delay)
      * def keycloak = callonce _keycloakToken {_username:'#(_user.TechArthur)'}

    @regression
    Scenario: Verify 200 Post marketDetailsValidations - valid inputs
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Valid.json")
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Valid.json")
      Then match response == expectedResponse

    @regression
    Scenario: Verify 200 Post marketDetailsValidations - invalid inputs for S0019, E0530, E0362, E10253, E10252 
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Invalid.json")
      * requestBody.marketSyndicates[0].percentage = -2
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Invalid.json")
      Then match response == expectedResponse
      
      @regression
    Scenario: Verify 200 Post marketDetailsValidations - invalid inputs for E2070C
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Invalid.json")
      * requestBody.screenType = "LLOYDS"
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Invalid.json")
      * expectedResponse[5].validateResponse = "Valid"
      * expectedResponse[6].validateResponse = "Valid"
      * expectedResponse[12].validateResponse = "E2070C: Syndicate signed line total must equal bureau share"
      Then match response == expectedResponse

    @regression
    Scenario: Verify 200 Post marketDetailsValidations - invalid inputs for S0020, E0480, E1170-2 & E1170-3
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Invalid.json")
      * requestBody.bureau = "LLOYDS"
      * requestBody.slipType = "N"
      * requestBody.yearOfAccount = 2026
      * requestBody.marketSyndicates[0].percentage = 2
      * requestBody.marketSyndicates[1].percentage = 4
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Invalid.json")
      * expectedResponse[0].validateResponse = "S0020 : Year of account should  not be more than one year in the future"
      * expectedResponse[2].validateResponse = "Valid"
      * expectedResponse[3].validateResponse = "Valid"
      * expectedResponse[4].validateResponse = "Valid"
      * expectedResponse[5].validateResponse = "Valid"
      * expectedResponse[6].validateResponse = "Valid"
      * expectedResponse[7].validateResponse = "Valid"
      * expectedResponse[8].validateResponse = "Valid"
      * expectedResponse[11].validateResponse = "E0480 : Year Of Account must not be greater than the current year for a non-bulking lineslip"
      * expectedResponse[14].validateResponse = "E1170: Cannot be a future year when Delink Indicator is Delink"
      * expectedResponse[15].validateResponse = "E1170 : Cannot be a future year when Delink Indicator is Delink"
      Then match response == expectedResponse
    
    @regression
    Scenario: Verify 200 Post marketDetailsValidations - Negative inputs for E1170  
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Invalid.json")
      * requestBody.bureau = "LLOYDS"
      * requestBody.slipType = "N"
      * requestBody.yearOfAccount = 2026
      * requestBody.delinkReleaseFlag = "CASH"
       * requestBody.qualifyingCategory = "A"
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Invalid.json")
      * expectedResponse[0].validateResponse = "S0020 : Year of account should  not be more than one year in the future"
      * expectedResponse[2].validateResponse = "Valid"
      * expectedResponse[3].validateResponse = "Valid"
      * expectedResponse[4].validateResponse = "Valid"
      * expectedResponse[7].validateResponse = "Valid"
      * expectedResponse[8].validateResponse = "Valid"
      * expectedResponse[11].validateResponse = "E0480 : Year Of Account must not be greater than the current year for a non-bulking lineslip"
      * expectedResponse[13].validateResponse = "E1170: The year of account can only be in the future if the qualifying category is F (FDO) or it is delinked"
      Then match response == expectedResponse
      
    @regression
    Scenario Outline: Verify 200 Post marketDetailsValidations - Positive inputs for E1170  
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Invalid.json")
      * requestBody.bureau = "LLOYDS"
      * requestBody.slipType = "N"
      * requestBody.yearOfAccount = <YOA>
      * requestBody.delinkReleaseFlag = <delinkReleaseFlag>
      * requestBody.qualifyingCategory = <qualifyingCategory>
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Invalid.json")
      * expectedResponse[0].validateResponse = <validateResponse3>
      * expectedResponse[2].validateResponse = "Valid"
      * expectedResponse[3].validateResponse = "Valid"
      * expectedResponse[4].validateResponse = "Valid"
      * expectedResponse[7].validateResponse = "Valid"
      * expectedResponse[8].validateResponse = "Valid"
      * expectedResponse[11].validateResponse = <validateResponse4>
      * expectedResponse[13].validateResponse = "Valid"
      * expectedResponse[14].validateResponse = <validateResponse1>
      * expectedResponse[15].validateResponse = <validateResponse2>
      Then match response == expectedResponse
      
     Examples: 
      |		YOA		| delinkReleaseFlag   	| qualifyingCategory	|	validateResponse1												|	validateResponse2												| validateResponse3															|	validateResponse4																			|
      |		2026	|		 "DELINK" 		|		 "A"			|"E1170: Cannot be a future year when Delink Indicator is Delink"	|"E1170 : Cannot be a future year when Delink Indicator is Delink"	|"S0020 : Year of account should  not be more than one year in the future"	|"E0480 : Year Of Account must not be greater than the current year for a non-bulking lineslip"	|
      |		2026	|		 "DELINK" 		|		 "F"			|"E1170: Cannot be a future year when Delink Indicator is Delink"	|"E1170 : Cannot be a future year when Delink Indicator is Delink"	|"S0020 : Year of account should  not be more than one year in the future"	|"E0480 : Year Of Account must not be greater than the current year for a non-bulking lineslip"	|
      |		2026	|		 "CASH" 		|		 "F"			|"Valid"															|"Valid"															|"S0020 : Year of account should  not be more than one year in the future"	|"E0480 : Year Of Account must not be greater than the current year for a non-bulking lineslip"	|
      |		2024	|		 "CASH" 		|		 "A"			|"Valid"															|"Valid"															|"Valid"																	|"Valid"																						|
      
    @regression
    Scenario Outline: Verify 200 Post marketDetailsValidations - Positive inputs for E2070C  
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Valid.json")
      * requestBody.screenType = <screenType>
      * requestBody.bureauLinePercent= <bureauLinePercent>
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Valid.json")
      Then match response == expectedResponse
      
     Examples: 
      |		screenType		| bureauLinePercent   	| 
      |		"LLOYDS" 		|		 90.0 			|
      |		"ILU" 			|		 70.0 			|
      
	@regression
    Scenario Outline: Verify 200 Post marketDetailsValidations - Positive inputs for E10253  
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Valid.json")
      * requestBody.screenType = <screenType>
      * requestBody.marketSyndicates[0].percentage = <percentage>
      * requestBody.marketSyndicates[1].percentage = <percentage>
      * requestBody.bureauLinePercent	= <bureauLinePercent>
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Valid.json")
      Then match response == expectedResponse
      
     Examples: 
      |		screenType		| 		percentage   	| bureauLinePercent	|
      |		"LLOYDS" 		|		 0.0 			|		0.0			|
      |		"LLOYDS" 		|		 -10.0 			|		-20.0		|
      |		"ILU" 			|		 45.0 			|		90.0		|
  

    @regression
    Scenario: Verify 200 Post marketDetailsValidations - invalid inputs for E10251
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Invalid.json")
      * requestBody.marketSyndicates[0].percentage = 50.0
      * requestBody.marketSyndicates[1].percentage = 60.0
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Invalid.json")
      * expectedResponse[5].validateResponse = "Valid"
      * expectedResponse[6].validateResponse = "Valid"
      * expectedResponse[16].validateResponse = "E10251: Total of all Company/Syndicate Signed Line Percentages must not be greater than 100"
      Then match response == expectedResponse

    @regression
    Scenario: Verify 200 Post marketDetailsValidations - null checks
      * json requestBody = read("post/marketDetailsValidationsRequestBody_nullChecks.json")
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      * print responseHeaders['x-correlation-id'][0]
      Then status 200
      * print response
      * json expectedResponse = read("post/marketDetailsValidationsExpectedResponse_Valid.json")
      Then match response == expectedResponse
       

    @regression
    Scenario: Verify 403 POST marketDetailsValidations
      * def keycloak_invalid = call _keycloakToken {_username:'#(_user.premiumValidationServiceUser)'}
      * json requestBody = read("post/marketDetailsValidationsRequestBody_Valid.json")
      * print requestBody
      Given url _rules
      And path _endpoint._marketDetailsValidations
      And configure headers = _headers.commonHeaders
      And header Authorization = 'Bearer ' + keycloak_invalid.accessToken
      And request requestBody
      When method post
      * sleep(delay)
      Then status 403