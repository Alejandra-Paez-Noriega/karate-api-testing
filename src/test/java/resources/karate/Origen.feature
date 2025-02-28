Feature: Pruebas automatizadas para el endpoint /api/origen
  Background:
    * url 'http://localhost:8080/api/origen'

  Scenario Outline: Obtener un estado por ID
    Given path '<id>'
    When method GET
    Then status 200
    And match response == { id: <id>, name: <name> }

    Examples:
      | id | name        |
      | 1  | "Reclu"     |
      | 2  | "Interno"   |
      | 3  | "Subk"      |
      

  Scenario: Obtener todos los estados
    Given path ''
    When method GET
    Then status 200
    And match response contains { id: 1, name: "Reclu" }
    And match response contains { id: 3, name: "Subk" }

  Scenario: Crear un nuevo estado
    Given request { name: "LinkedIn" }
    When method POST
    Then status 201
    And match response == { id: #number, name: "LinkedIn" }

  Scenario Outline: Actualizar un estado
    Given path '<id>'
    And request { name: <newName> }
    When method PUT
    Then status 200
    And match response.name == <newName>

    Examples:
      | id | newName               |
      | 1  | "Reclu Recomendado"   |
      | 2  | "Interno en Revision" |
      | 3  | "Subk en espera"      |
     

  Scenario Outline: Eliminar un estado
    Given path '<id>'
    When method DELETE
    Then status 202

    Examples:
      | id |
      |  2 |
      
     