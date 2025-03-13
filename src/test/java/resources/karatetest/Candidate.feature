Feature: Pruebas de API para Candidatos

  Background:
    * url 'http://localhost:8080/'
  Scenario: Búsqueda por Nombre Completo Válido
    Given path 'api/candidate/name/Juan Carlos Pérez'
    When method get
    Then status 200
    And match response contains { "name": "Juan Carlos Pérez" }

  Scenario: Búsqueda por Nombre Parcial
    Given path 'api/candidate/name/Juan'
    When method get
    Then status 200
    And match response contains [ { "name": '#string' } ]

  Scenario: Búsqueda por Nombre Inexistente
    Given path 'api/candidate/name/María García'
    When method get
    Then status 404
    And match response contains {"Message":"The candidate does not exist"}

  Scenario: Búsqueda de candidato por ID
    Given path 'api/candidate/id/1'
    When method get
    Then status 200
    And match response contains { "id": 1 }

  Scenario: Búsqueda de candidato por ID inexistente
    Given path 'api/candidate/id/99999'
    When method get
    Then status 404
    And match response contains {"Message":"The candidate does not exist"}

  Scenario: Creación de un nuevo candidato
    Given path 'api/candidate/',''
    And request { "name": "Pablo Jose","lastName": "Osorio Jimenez", "card": 1068874425, "birthdate": "2004-01-01","registrationDate": "2025-01-01", "phone": 3002004099, "city": "Cali", "email": "pablojose@example.com"}
    When method post
    Then status 201

  Scenario: Creación de un candidato con datos incompletos
    Given path 'api/candidate/'
    And request { "name": "Danilo" }
    When method post
    Then status 404

  Scenario: Creación de un candidato duplicado
    Given path 'api/candidate/',''
    And request { "name": "Pablo Jose","lastName": "Osorio Jimenez", "card": 1068874425, "birthdate": "2004-01-01","registrationDate": "2025-01-01", "phone": 3002004099, "city": "Cali", "email": "pablojose@example.com"}
    When method post
    Then status 409
    And match response.Message == "There is already a id card with that number"

  Scenario: Actualización de los datos de un candidato
    Given path 'api/candidate/1'
    And request {"name": "Juan Carlos","lastName": "Ramirez","card": 1000234567, "birthdate": "2004-01-01", "registrationDate": "2025-03-11","phone": 3002004050,"city": "Santa Marta", "email": "ramirez@gmail.com"}
    When method put
    Then status 200

  Scenario: Actualización de un candidato inexistente
    Given path 'api/candidate/99999'
    And request { "name": "No Existe" }
    When method put
    Then status 404

  Scenario: Actualización de un candidato con datos inválidos
    Given path 'api/candidate/1'
    And request {"name": "Juan Carlos","lastName": "Ramirez","card": 1000234567, "birthdate": "2004-01-01", "registrationDate": "2025-50-11","phone": 3002004050,"city": "Santa Marta", "email": "ramirez@gmail.com"}
    When method put
    Then status 400  
    And match response == "Invalid date format. Please use 'yyyy-MM-dd'"
  Scenario: Eliminación de un candidato
    Given path 'api/candidate/2'
    When method delete
    Then status 204

  Scenario: Eliminación de un candidato inexistente
    Given path 'api/candidate/99999'
    When method delete
    Then status 404

  Scenario: Obtener todos los candidatos
    Given path 'api/candidate/',''
    When method get
    Then status 200
    And match each response contains 
"""
{ 
    "id": "#number",
    "name": "#string",
    "lastName": "#string",
    "email": "#string"
}
"""