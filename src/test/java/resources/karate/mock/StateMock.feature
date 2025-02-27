Feature: Mocked API para el endpoint /state

Background:
  * configure server { cors: true }
  * def estados =
  """
  [
    { "id": 1, "name": "Nuevo" },
    { "id": 2, "name": "Validación CCI" },
    { "id": 3, "name": "En prueba técnica" }
  ]
  """

Scenario: Obtener un estado por ID
  * def id = karate.extract(request.path, '/state/(\\d+)', 1)
  * def estado = karate.filter(estados, function(e){ return e.id == id })[0]
  * def responseBody = estado ? { status: 200, body: estado } : { status: 404, body: {} }
  * karate.response = responseBody

Scenario: Obtener todos los estados
  * karate.response = { status: 200, body: estados }

Scenario: Crear un nuevo estado
  * def nuevoEstado = request
  * if (!nuevoEstado.name || nuevoEstado.name.trim() == '') 
    * karate.response = { status: 400, body: { error: "State cannot be null" } }
  * else if (karate.filter(estados, function(e){ return e.name == nuevoEstado.name }).length > 0)
    * karate.response = { status: 409, body: { error: "State already exists" } }
  * else 
    * def newId = estados.length + 1
    * def createdState = { id: newId, name: nuevoEstado.name }
    * estados = estados + createdState
    * karate.response = { status: 201, body: createdState }

Scenario: Actualizar un estado
  * def id = karate.extract(request.path, '/state/(\\d+)', 1)
  * def estadoIndex = karate.findIndex(estados, function(e){ return e.id == id })
  * if (estadoIndex == -1) 
    * karate.response = { status: 404, body: { error: "State not found" } }
  * else 
    * estados[estadoIndex] = { id: id, name: request.name }
    * karate.response = { status: 200, body: estados[estadoIndex] }

Scenario: Eliminar un estado
  * def id = karate.extract(request.path, '/state/(\\d+)', 1)
  * def estadoIndex = karate.findIndex(estados, function(e){ return e.id == id })
  * if (estadoIndex == -1) 
    * karate.response = { status: 404, body: { error: "State not found" } }
  * else 
    * estados = karate.removeAt(estados, estadoIndex)
    * karate.response = { status: 204 }
