Feature: Mocked API para el endpoint /state

Background:
  * configure cors = true
  * def curId = 19
  * def nextId = function(){ return ++curId}
  * def estados = {}
  * estados[1] = { id: 1, name: 'Nuevo' }
  * estados[2] = { id: 2, name: 'Validación CCI' }
  * estados[3] = { id: 3, name: 'En prueba técnica' }
  * estados[4] = { id: 4, name: 'Expiró prueba' }
  * estados[5] = { id: 5, name: 'Terminó prueba' }
  * estados[6] = { id: 6, name: 'Descartado en prueba técnica' }
  * estados[7] = { id: 7, name: 'Aceptado en prueba técnica' }
  * estados[8] = { id: 8, name: 'Entrevista LT Accenture' }
  * estados[9] = { id: 9, name: 'Descartado LT Accenture' }
  * estados[10] = { id: 10, name: 'Aceptado LT Accenture' }
  * estados[11] = { id: 11, name: 'Entrevista Cliente' }
  * estados[12] = { id: 12, name: 'Descartado por cliente' }
  * estados[13] = { id: 13, name: 'Aceptado por cliente' }
  * estados[14] = { id: 14, name: 'Validación BGC' }
  * estados[15] = { id: 15, name: 'Descartado en BGC' }
  * estados[16] = { id: 16, name: 'Aceptado en BGC' }
  * estados[17] = { id: 17, name: 'Declina' }
  * estados[18] = { id: 18, name: 'Acepta' }
  * estados[19] = { id: 19, name: 'Ingreso' }

Scenario: pathMatches('/state/{id}') && methodIs('get')
  * def id = pathParams.id
  * def response = estados[id] ? estados[id] : { error: 'State not found' }
  * def responseStatus = estados[id] ? 200 : 404

Scenario: pathMatches('/state') && methodIs('get')
  * def response = $estados.*
  * def responseStatus = 200

Scenario: pathMatches('/state') && methodIs('post')
  * def nombreValido = karate.get('request.name', '').trim()
  * if (nombreValido == '') karate.abort({ error: 'State cannot be null' }, 400)
  * if (karate.filterKeys(estados, { name: nombreValido }).length > 0) karate.abort({ error: 'State already exists' }, 409)

  # Generar un nuevo ID asegurándonos de que es un número
  * def newId = nextId()

  # Crear el nuevo estado con ID numérico
  * def createdState = { id: #(newId), name: #(nombreValido) }

  # Almacenar en el mock de estados
  * eval estados[newId] = createdState  

  # Responder con el estado creado
  * def response = createdState
  * def responseStatus = 201

Scenario: pathMatches('/state/{id}') && methodIs('put')
  * def id = pathParams.id
  * def response = estados[id] ? estados[id] = { id: id, name: request.name } : { error: 'State not found' }
  * def responseStatus = estados[id] ? 200 : 404

Scenario: pathMatches('/state/{id}') && methodIs('delete')
  * def id = parseInt(pathParams.id)   
  * def estadoExiste = estados[id]
  * def responseStatus = estadoExiste ? 204 : 404
  * def response = estadoExiste ? { message: 'State deleted' } : { error: 'State not found' }
  * if (estadoExiste) delete estados[id]
  * if (responseStatus == 500) response = estados[id] ? estados[id] : { error: 'State not found' }
  * def responseStatus = estados[id] ? 204 : 202