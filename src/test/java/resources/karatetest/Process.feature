Feature: Pruebas de API para los Procesos

  Background:
    * url 'http://localhost:8080/'
  Scenario: Postular un candidato a una vacante
    Given path 'api/postulation/'
    And request { "datePresentation": "2025-01-01", "salaryAspiration": "1000000", "vacancyCompanyId": 1, "candidateId": 1 }
    When method POST
    Then status 201
    And match response.id == '#notnull'

  Scenario: Obtener proceso activo de un candidato
    Given path 'api/process/candidate/1'
    When method GET
    Then status 200
    And match response[0].postulation.candidate.id == 1

  Scenario: Postular un candidato con proceso activo
    Given path 'api/postulation/'
    And request { "datePresentation": "2025-01-01", "salaryAspiration": "1000000", "vacancyCompanyId": 2, "candidateId": 1 }
    When method POST
    Then status 409

  Scenario: Avanzar candidato a la siguiente fase
    Given path 'api/candidate_phases/1'
    And request { "stateId": 2, "description": "Avance a entrevista", "status": true, "assignedDate": "2025-03-12" }
    When method PUT
    Then status 200
    And match response.stateId == 2

  Scenario: Finalizar proceso de reclutamiento
    Given path 'api/process/1'
    And request { "postulationId": 1, "description": "Proceso completado", "assignedDate": "2025-03-12" }
    When method PUT
    Then status 200
    And match response.description == 'Proceso completado'

    # Caso 6: Intentar postular con datos inválidos
  Scenario: Postulación con datos inválidos
    Given path 'api/postulation/'
    And request { "datePresentation": "", "salaryAspiration": "", "vacancyCompanyId": 1, "candidateId": "" }
    When method POST
    Then status 400

  Scenario: Consultar proceso de un candidato sin postulaciones
    Given path 'api/process/candidate/9999'
    When method GET
    Then status 404

  Scenario: Cambio de fase sin cumplir requisitos
    Given path 'api/candidate_phases/1'
    And request { "stateId": 3, "description": "Intento de avance sin requisitos", "status": false, "assignedDate": "2025-03-12" }
    When method PUT
    Then status 400

  Scenario: Rechazar a un candidato
    Given path 'api/candidate_phases/1'
    And request { "stateId": 8, "description": "Candidato rechazado", "status": false, "assignedDate": "2025-03-12" }
    When method PUT
    Then status 200
    And match response.stateId == 8

  Scenario: Actualizar un proceso inexistente
    Given path 'api/process/9999'
    And request { "postulationId": 9999, "description": "Proceso no existente", "assignedDate": "2025-03-12" }
    When method PUT
    Then status 404

  Scenario: Eliminar un proceso de candidato
    Given path 'api/process/1'
    When method DELETE
    Then status 200

  Scenario: Consultar candidato sin procesos activos
    Given path 'api/process/candidate/2'
    When method GET
    Then status 200
    And match response == []

  Scenario: Finalizar proceso de selección correctamente
    Given path 'api/process/1'
    And request { "postulationId": 1, "description": "Aceptado por cliente", "assignedDate": "2025-03-12" }
    When method PUT
    Then status 200
    And match response.description == 'Aceptado por cliente'