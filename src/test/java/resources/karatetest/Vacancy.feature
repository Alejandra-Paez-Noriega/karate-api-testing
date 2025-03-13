Feature: Pruebas de API para Vacantes

Background:
  * url 'http://localhost:8080/'

Scenario: Visualización de vacante por ID válido
  Given path 'api/vacancy_company/id/1'
  When method get
  Then status 200
  And match response contains { "id": 1 }

Scenario: Visualización de vacante por ID inexistente
  Given path 'api/vacancy_company/id/99999'
  When method get
  Then status 409
  And match response contains {"Message":"The vacancy does not exist"}

Scenario: Listado de todas las vacantes
  Given path 'api/vacancy_company/',''
  When method get
  Then status 200
  And match each response contains 
  """
  { 
      "id": "#number",
      "title": "#string",
      "company": "#string",
      "location": "#string"
  }
  """

Scenario: Creación de una nueva vacante
  Given path 'api/vacancy_company/',''
  And request { "title": "Desarrollador Backend", "company": "Tech Corp", "location": "Medellín", "salary": 6000000, "description": "Desarrollo en Java Spring Boot" }
  When method post
  Then status 201

Scenario: Creación de una vacante con datos incompletos
  Given path 'api/vacancy_company/',''
  And request { "title": "Analista QA" }
  When method post
  Then status 404

Scenario: Actualización de una vacante existente
  Given path 'api/vacancy_company/1'
  And request { "title": "Desarrollador Full Stack", "company": "Tech Corp", "location": "Bogotá", "salary": 7000000, "description": "Desarrollo en Java y Angular" }
  When method put
  Then status 200

Scenario: Actualización de una vacante inexistente
  Given path 'api/vacancy_company/99999'
  And request { "title": "No Existe" }
  When method put
  Then status 404

Scenario: Actualización de una vacante con datos inválidos
  Given path 'api/vacancy_company/1'
  And request { "title": "Desarrollador", "company": "Tech Corp", "location": "Cali", "salary": "INVALIDO", "description": "Desarrollo en Python" }
  When method put
  Then status 400  
  And match response == "Invalid salary format. Please use a number"

Scenario: Eliminación de una vacante
  Given path 'api/vacancy_company/2'
  When method delete
  Then status 204

Scenario: Eliminación de una vacante inexistente
  Given path 'api/vacancy_company/99999'
  When method delete
  Then status 404
