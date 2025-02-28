Feature: Pruebas automatizadas para el endpoint /api/phase

  Background:
    * url 'http://localhost:8080/api/phase'

  Scenario Outline: Obtener un estado por ID
    Given path '<id>'
    When method GET
    Then status 200
    And match response == { id: <id>, name: <name> }

    Examples:
      | id | name                       |
      | 1  | "Validación CCI"           |
      | 2  | "Prueba Técnica"           |
      | 3  | "Entrevista LT Accenture"  |
      | 4  | "Entrevista Cliente"       |
      | 5  | "Validación BGC"           |
      | 6  | "Oferta Salarial"          |
      | 7  | "Inicio"                   |
     
  Scenario: Obtener todos los estados
    Given path ''
    When method GET
    Then status 200
    And match response contains { id: 1, name: "Validación CCI" }
    And match response contains { id: 7, name: "Inicio" }

  Scenario: Crear un nuevo estado
    Given request { name: "Lista de Espera" }
    When method POST
    Then status 201
    And match response == { id: #number, name: "Lista de Espera" }

  Scenario Outline: Actualizar un estado
    Given path '<id>'
    And request { name: <newName> }
    When method PUT
    Then status 200
    And match response.name == <newName>

    Examples:
      | id | newName                             |
      | 1  | "Validación CCI paso"               |
      | 2  | "Prueba Técnica presentada"         |
      | 3  | "Entrevista LT Accenture aprobada"  |
      | 4  | "Entrevista Cliente aprobada"       |
      | 5  | "Validación BGC ok"                 |
      | 6  | "Oferta Salarial aceptada"          |
      | 7  | "Inicio ok"                         |
      

  Scenario Outline: Eliminar un estado
    Given path '<id>'
    When method DELETE
    Then status 202

    Examples:
      | id |
      | 1  |
      | 2  |
      | 6  |
     
      