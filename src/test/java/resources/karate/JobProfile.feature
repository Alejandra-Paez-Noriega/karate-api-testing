Feature: Pruebas automatizadas para el endpoint /api/jobprofile
  Background:
    * url 'http://localhost:8080/api/jobprofile'

  Scenario Outline: Obtener un estado por ID
    Given path '<id>'
    When method GET
    Then status 200
    And match response == { id: <id>, name: <name> }

    Examples:
      | id | name                 |
      | 1  | "Dev Backend"        |
      | 2  | "Dev Front"          |
      | 3  | "Dev Full Stack"     |
      | 4  | "Ing. Datos"         |
      | 5  | "Lider Técnico"      |
      | 6  | "Automatizador"      |
      

  Scenario: Obtener todos los estados
    Given path ''
    When method GET
    Then status 200
    And match response contains { id: 1, name: "Dev Backend" }
    And match response contains { id: 6, name: "Automatizador" }

  Scenario: Crear un nuevo estado
    Given request { name: "QA Junior" }
    When method POST
    Then status 201
    And match response == { id: #number, name: "QA Junior" }

  Scenario Outline: Actualizar un estado
    Given path '<id>'
    And request { name: <newName> }
    When method PUT
    Then status 200
    And match response.name == <newName>

    Examples:
      | id | newName                        |
      | 1  | "Dev Backend junior"           |
      | 2  | "Dev Front senior"             |
      | 3  | "Dev Full Stack senior"        |
      | 4  | "Ing. Datos practicante sena"  |
      | 5  | "Lider Técnico senior"         |
      | 6  | "Automatizador senior"         |
    

  Scenario Outline: Eliminar un estado
    Given path '<id>'
    When method DELETE
    Then status 202

    Examples:
      | id |
      | 3  |
      | 4  |
      | 5  |
      | 6  |
      