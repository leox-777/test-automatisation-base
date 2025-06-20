@REQ_HU-RET-0001 @HU0001 @marvel_characters_api @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-RET-0001 Gestión de personajes de Marvel (microservicio para manejo de personajes Marvel)

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * path '/testuser/api/characters'
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @obtenerTodosLosPersonajes @solicitudExitosa200
  Scenario: T-API-HU-RET-0001-CA01-Obtener todos los personajes exitoso 200 - karate
    When method GET
    Then status 200
    # And match response != null
    # And match response == '#array'

  @id:2 @obtenerPersonajePorId @solicitudExitosa200
  Scenario: T-API-HU-RET-0001-CA02-Obtener personaje por ID exitoso 200 - karate
    * def characterId = 1
    * path '/' + characterId
    When method GET
    Then status 200
    # And match response != null
    # And match response.id == characterId

  @id:3 @obtenerPersonajePorId @personajeNoExiste404
  Scenario: T-API-HU-RET-0001-CA03-Obtener personaje por ID no existente 404 - karate
    * def characterId = 999
    * path '/' + characterId
    When method GET
    Then status 404
    # And match response.error == 'Character not found'
    # And match response != null

  @id:4 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-HU-RET-0001-CA04-Crear personaje exitoso 201 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    And request jsonData
    When method POST
    Then status 201
    # And match response != null
    # And match response.id != null

  @id:5 @crearPersonaje @nombreDuplicado400
  Scenario: T-API-HU-RET-0001-CA05-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response.error contains 'Character name already exists'
    # And match response.error != null

  @id:6 @crearPersonaje @camposRequeridosInvalidos400
  Scenario: T-API-HU-RET-0001-CA06-Crear personaje con campos requeridos inválidos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character_invalid.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response contains { name: '#string' }
    # And match response..* contains 'required'

  @id:7 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-HU-RET-0001-CA07-Actualizar personaje exitoso 200 - karate
    * def characterId = 1
    * path '/' + characterId
    * def jsonData = read('classpath:data/marvel_characters_api/request_update_character.json')
    And request jsonData
    When method PUT
    Then status 200
    # And match response.description == 'Updated description'
    # And match response.id == characterId

  @id:8 @actualizarPersonaje @personajeNoExiste404
  Scenario: T-API-HU-RET-0001-CA08-Actualizar personaje no existente 404 - karate
    * def characterId = 999
    * path '/' + characterId
    * def jsonData = read('classpath:data/marvel_characters_api/request_update_character.json')
    And request jsonData
    When method PUT
    Then status 404
    # And match response.error == 'Character not found'
    # And match response.error != null

  @id:9 @eliminarPersonaje @solicitudExitosa204
  Scenario: T-API-HU-RET-0001-CA09-Eliminar personaje exitoso 204 - karate
    * def characterId = 1
    * path '/' + characterId
    When method DELETE
    Then status 204
    # And match response == ''
    # And match responseBytes == ''

  @id:10 @eliminarPersonaje @personajeNoExiste404
  Scenario: T-API-HU-RET-0001-CA10-Eliminar personaje no existente 404 - karate
    * def characterId = 999
    * path '/' + characterId
    When method DELETE
    Then status 404
    # And match response.error == 'Character not found'
    # And match response.error != null

  @id:11 @crearPersonaje @errorServicio500
  Scenario: T-API-HU-RET-0001-CA11-Crear personaje con error interno 500 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * set jsonData.name = repeat('A', 1000) // Nombre muy largo para forzar error interno
    And request jsonData
    When method POST
    Then status 500
    # And match response.message contains 'Error interno del servidor'
    # And match response.status == 500
