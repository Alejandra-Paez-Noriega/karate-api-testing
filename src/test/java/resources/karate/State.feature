Feature: Pruebas automatizadas para el endpoint /state

Background:
  * url 'http://localhost:8080/state'  # Apunta a la API Mock

Scenario: CP-API-STATE-001 - Obtener un estado por ID
  Given path '1'
  When method GET
  Then status 200
  And match response == { id: 1, name: "Nuevo" }

Scenario: CP-API-STATE-002 - Obtener todos los estados
  Given path ''
  When method GET
  Then status 200
  And match response contains { id: 1, name: "Nuevo" }

Scenario: CP-API-STATE-003 - Crear un nuevo estado
  Given request { name: "Revisión" }
  When method POST
  Then status 201
  And match response.name == "Revisión"

Scenario: CP-API-STATE-004 - Actualizar un estado
  Given path '1'
  And request { name: "Actualizado" }
  When method PUT
  Then status 200
  And match response.name == "Actualizado"

Scenario: CP-API-STATE-005 - Eliminar un estado
  Given path '1'
  When method DELETE
  Then status 204
