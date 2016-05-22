deviceDecorator = require('src/device-decorator')

module.exports = (request, config) ->
  url = config.server.devicesUrl

  isResponseValid = (checkBody, error, response, body) ->
    return !error && (response.statusCode >= 200 && response.statusCode < 300) && (if checkBody then body else true)

  logError = (name, error, response) ->
    console.error "#{name} error: #{response.statusCode} - #{error}"
    console.log "\t#{response.statusMessage}"

  getAll = (callback) ->
    request.get url, (error, response, body) ->
      if (isResponseValid(true, error, response, body))
        devices = JSON.parse(body).data

        for device in devices
          deviceDecorator.decorate device

        callback null, devices
      else
        logError 'getAll', error, response
        callback 'Unable to list devices'

  getById = (id, callback) ->
    request.get "#{url}/#{id}", (error, response, body) ->
      if (isResponseValid(true, error, response, body))
        device = JSON.parse(body).data
        
        deviceDecorator.decorate device

        callback null, device
      else
        logError 'getById', error, response
        callback 'Device not found'

  update = (id, device, callback) ->
    request.put "#{url}/#{id}", { json: device }, (error, response, body) ->
      if (isResponseValid(false, error, response, body))
        callback null, body
      else
        logError 'update', error, response
        callback 'Unable to update device'

  create = (params, callback) ->
    request.post url, { json: params }, (error, response, body) ->
      if (isResponseValid(false, error, response, body))
        callback null, body
      else
        logError 'create', error, response
        callback 'Device not created'

  remove = (id, callback) ->
    request.del "#{url}/#{id}", (error, response, body) ->
      if (isResponseValid(false, error, response, body))
        callback null
      else
        logError 'remove', error, response
        callback 'Device not removed'

  search = (query, callback) ->
    request.get "#{url}?q=#{query}", (error, response, body) ->
      if (isResponseValid(true, error, response, body))
        devices = JSON.parse(body).data

        for device in devices
          deviceDecorator.decorate device

        callback null, devices
      else
        logError 'search', error, response
        callback "Unable to search for #{query}"

  return {
    getAll: getAll
    getById: getById
    update: update
    create: create
    remove: remove
    search: search
  }