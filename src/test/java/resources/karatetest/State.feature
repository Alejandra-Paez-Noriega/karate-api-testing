Feature: Pruebas automatizadas para el endpoint /api/state

  Background:
    * url 'http://localhost:8080/api/state'

  Scenario Outline: Obtener un estado por ID
    Given path '<id>'
    When method GET
    Then status 200
    And match response == { id: <id>, name: <name> }

    Examples:
      | id | name                                |
      | 1  | "Nuevo"                             |
      | 2  | "Validación CCI"                    |
      | 3  | "En prueba técnica"                 |
      | 4  | "Expiró prueba"                     |
      | 5  | "Terminó prueba"                    |
      | 6  | "Descartado en prueba técnica"      |
      | 7  | "Aceptado en prueba técnica"        |
      | 8  | "Entrevista LT Accenture"           |
      | 9  | "Descartado LT Accenture"           |
      | 10 | "Aceptado LT Accenture"             |
      | 11 | "Entrevista Cliente"                |
      | 12 | "Descartado por cliente"            |
      | 13 | "Aceptado por cliente"              |
      | 14 | "Validación BGC"                    |
      | 15 | "Descartado en BGC"                 |
      | 16 | "Aceptado en BGC"                   |
      | 17 | "Declina"                           |
      | 18 | "Acepta"                            |
      | 19 | "Ingreso"                           |

  Scenario: Obtener todos los estados
    Given path ''
    When method GET
    Then status 200
    And match response contains { id: 1, name: "Nuevo" }
    And match response contains { id: 19, name: "Ingreso" }

  Scenario: Crear un nuevo estado
    Given request { name: "Estado de prueba" }
    When method POST
    Then status 201
    And match response == { id: #number, name: "Estado de prueba" }

  Scenario Outline: Actualizar un estado
    Given path '<id>'
    And request { name: <newName> }
    When method PUT
    Then status 200
    And match response.name == <newName>

    Examples:
      | id | newName                           |
      | 1  | "Nuevo Actualizado"               |
      | 2  | "Validación CCI Modificado"       |
      | 3  | "En prueba técnica Revisado"      |
      | 4  | "Expiró prueba Final"             |
      | 5  | "Terminó prueba Completado"       |
      | 6  | "Descartado en prueba técnica OK" |
      | 7  | "Aceptado en prueba técnica OK"   |
      | 8  | "Entrevista LT Accenture 2"       |
      | 9  | "Descartado LT Accenture Final"   |
      | 10 | "Aceptado LT Accenture Confirmado"|
      | 11 | "Entrevista Cliente Exitosa"      |
      | 12 | "Descartado por cliente Final"    |
      | 13 | "Aceptado por cliente Definitivo" |
      | 14 | "Validación BGC Completa"         |
      | 15 | "Descartado en BGC OK"            |
      | 16 | "Aceptado en BGC Aprobado"        |
      | 17 | "Declina Confirmado"              |
      | 18 | "Acepta Finalizado"               |
      | 19 | "Ingreso Confirmado"              |

  Scenario Outline: Eliminar un estado
    Given path '<id>'
    When method DELETE
    Then status 202

    Examples:
      | id |
      | 1  |
      | 2  |
      | 3  |
      | 4  |
      | 11 |
      | 12 |
      | 13 |
      | 14 |
      | 15 |
      | 16 |
      | 17 |
      | 18 |