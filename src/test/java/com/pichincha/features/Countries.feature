@REQ_PQBP-4163  @countries @agente3
Feature: Manejo de API paises ejemplos

  Background:
    * def manSysProp = Java.type('com.pichincha.utils.ManegeSystemProperties')

  @id:1 @consultaPais
  Scenario Outline: T-API-PQBP-4163-CA1- Consulta datos por pais <pais>
    Given url 'https://restcountries.com/v3.1/name/<pais>'
    And param fields = 'capital,fifa,startOfWeek,capitalInfo,languages'
    When method GET
    Then status <statusCode>
    * print response
    * string responseString = response
    * def setProperty = manSysProp.setProp("ResponseSaved",responseString)
    * print setProperty
    And match response[0].capital == [<capital>]
    And print response[0].capital
    And def schemaValidate = read('classpath:../data/countries/DataSchemaCountries.json')
    # Esta linea nos permite validar el esquema/estructura del response, que cada valor corresponda con el tipo de dato
    And match each response[*] contains schemaValidate
    Examples:
      | read('classpath:../data/countries/DataCountries.csv') |


  @id:2 @consultaCapital
  Scenario: T-API-PQBP-4163-CA2- Consulta datos por capital
    * json lastResponse = manSysProp.getProp("ResponseSaved")
    * def capital = lastResponse[0].capital
    * print capital
    Given url 'https://restcountries.com/v3.1/capital/' + capital
    And param fields = 'fifa'
    When method GET
    Then status 200
    * print response
    * def dataCsv = read('classpath:../data/countries/DataCountries.csv')
    * def fifaData = dataCsv[0].fifa
    * print fifaData
    And match response[0].fifa == fifaData


  @id:3 @consultaListaHablaHispana
  Scenario Outline: T-API-PQBP-4163-CA3- Validar que Ecuador este en la lista de habla hispana
    Given url 'https://restcountries.com/v3.1/lang/spanish'
    When method GET
    Then status 200
    * print response
    #Primera forma de validar pais y region accediendo directo al indice
    And match response[0].name.common == 'Ecuador'
    And match response[0].region == 'Americas'
    #Segunda forma de validar pais y region accediendo a cualquier indice
    And match $..name.common contains '<pais>'
    And match $..region contains '<region>'
    #validacion que devuelve 24 registros
    And match response == '#[<registros>]'
    Examples:
      | read('classpath:../data/countries/DataGetList.csv') |