Feature: Pruebas de API para Procesos

  Background:
    * url 'http://localhost:8080/'

  Scenario: Obtener proceso de un candidato por ID
    Given path 'api/process/1'
    When method get
    Then status 200

  Scenario: Obtener proceso de un candidato inexistente
    Given path 'api/process/99999'
    When method get
    Then status 404
    And match response.message == "ProcessEntity not found"

  Scenario: Obtener todos los procesos de candidatos
    Given path 'api/process/'
    When method get
    Then status 200
    And match response contains  { "id": '#number' } 

  Scenario: Creación de un nuevo proceso de candidato
    Given path 'api/process/'
    And request { "candidateId": 9007199254740991, "status": "Entrevista técnica aprobada" }
    When method post
    Then status 201

  Scenario: Creación de un proceso con estado inválido
    Given path 'api/process/'
    And request { "candidateId": 9007199254740991, "status": "Estado inválido" }
    When method post
    Then status 400
    And match response.message == "Estado no permitido"

  Scenario: Actualización de un proceso de candidato
    Given path 'api/process/1'
    And request { "status": "Oferta aceptada" }
    When method put
    Then status 200

  Scenario: Eliminación de un proceso de candidato
    Given path 'api/process/2'
    When method delete
    Then status 204

  Scenario: Eliminación de un proceso de candidato inexistente
    Given path 'api/process/99999'
    When method delete
    Then status 404