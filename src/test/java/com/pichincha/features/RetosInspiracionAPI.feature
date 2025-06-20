Feature: API de Retos Diarios de Inspiración
  Como usuario de la aplicación
  Quiero acceder a retos diarios de inspiración
  Para mejorar mi desarrollo personal y mantenerme motivado

  Background:
    * url 'http://localhost:8080'

  # Historia de Usuario: HU-RET-001

  @RetosCreacion
  Scenario: Crear un nuevo reto de inspiración
    Given path '/api/challenges'
    And request
    """
    {
      "title": "Medita 10 minutos",
      "description": "Dedica 10 minutos a meditar y enfocarte en tu respiración para tener un mejor día",
      "category": "Salud",
      "difficulty": "Fácil",
      "status": "Activo",
      "dueDate": "2025-07-15"
    }
    """
    When method post
    Then status 201
    And match response contains { id: '#notnull', title: 'Medita 10 minutos' }
    And match response.category == 'Salud'
    And match response.status == 'Activo'

  @RetosConsulta
  Scenario: Obtener todos los retos
    Given path '/api/challenges'
    When method get
    Then status 200
    And match response == '#array'
    And match each response contains { id: '#notnull', title: '#string', category: '#string' }

  @RetosConsulta
  Scenario: Obtener un reto específico por ID
    * def createReto = call read('classpath:helpers/create-reto.js')
    * def retoId = createReto.id

    Given path '/api/challenges', retoId
    When method get
    Then status 200
    And match response contains { id: '#(retoId)', title: '#string', description: '#string' }
    And match response.category == '#? ["Salud", "Productividad", "Inspiración", "Disciplina"].contains(_)'

  @RetosModificacion
  Scenario: Actualizar un reto existente
    * def createReto = call read('classpath:helpers/create-reto.js')
    * def retoId = createReto.id

    Given path '/api/challenges', retoId
    And request
    """
    {
      "title": "Medita 15 minutos actualizado",
      "description": "Versión actualizada del reto de meditación",
      "category": "Salud",
      "difficulty": "Medio",
      "status": "Activo",
      "dueDate": "2025-08-01"
    }
    """
    When method put
    Then status 200
    And match response.title == "Medita 15 minutos actualizado"
    And match response.difficulty == "Medio"

  @RetosEliminacion
  Scenario: Eliminar un reto
    * def createReto = call read('classpath:helpers/create-reto.js')
    * def retoId = createReto.id

    Given path '/api/challenges', retoId
    When method delete
    Then status 204

    # Verificar que el reto fue eliminado
    Given path '/api/challenges', retoId
    When method get
    Then status 404

  @RetosConsulta
  Scenario: Obtener un reto sugerido
    Given path '/api/challenges/suggestion'
    When method get
    Then status 200
    And match response contains { id: '#notnull', title: '#string' }
    And match response.category == '#? ["Salud", "Productividad", "Inspiración", "Disciplina"].contains(_)'

  @RetosConsulta
  Scenario: Obtener el reto diario
    Given path '/api/challenges/daily'
    When method get
    Then status 200
    And match response contains { id: '#notnull', title: '#string' }
    And match response.status == '#string'
    And match response.difficulty == '#? ["Fácil", "Medio", "Difícil"].contains(_)'
