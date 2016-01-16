module.exports = (async, config) ->

  router = (params, callback) ->
    request = require('request')
    response = ''

    if params
      request 'https://dandpb.fwd.wf/devices?' + params, (error, response, body) ->
        console.log 'https://dandpb.fwd.wf/devices?' + params
        if (!error && response.statusCode == 200)
          callback body

    else
      request 'https://dandpb.fwd.wf/devices', (error, response, body) ->
        if (!error && response.statusCode == 200)
          callback body

  getAllDevices = (callback) ->
    router null, (body) ->
      console.log body
      callback body

  getDeviceByOs = (os, callback) ->
    params = 'os=' + os

    router params, (body) ->
      console.log body
      callback body

  getDeviceByQ = (query, callback) ->
    params = 'q=' + query

    router params, (body) ->
      callback body

  createDevice = (args, callback) ->
    request = require('request')

    params = {}
    params['model'] = args[1]
    params['os'] = args[2]
    params['version'] = args[3]
    params['notes'] = args[4]
    params['owner'] = args[5]
    params['status'] = 'available'
    params['date'] = ' '
    params['user'] = ' '

    request.post 'https://dandpb.fwd.wf/devices', {form:params}, (error, response, body) ->
      console.log 'cheguei aqui' + response.statusCode
      if (!error && response.statusCode == 201)
        console.log 'Looog ' + body
        callback null, body

  getDeviceById = (id, name, callback) ->
    request = require('request')

    request 'https://dandpb.fwd.wf/devices/' + id, (error, response, body) ->
      if (!error && response.statusCode == 200)
        gotDevice body, name, callback

  gotDevice = (device, name, callback) ->
    request = require('request')

    jsonDevice = JSON.parse(device)

    jsonDevice.status = 'unavailable'
    jsonDevice.user = name
    jsonDevice.date = new Date()

    request.post 'https://dandpb.fwd.wf/devices', {form:jsonDevice}, (error, response, body) ->
      console.log 'cheguei aqui' + response.statusCode
      if (!error && response.statusCode == 201)
        callback null, "It's yours!"
      else callback error

  validate = (text, callback) ->
    args = text.split()
    return callback()


  executeCommand = (text, user, callback) ->
    async.waterfall [
      async.apply validate, text
      (cb) ->
        cb null, text.split(' ')
      (args, cb) ->
        action = args[0]
        if action == 'create'
          createDevice args, cb
          (response, cb) ->
            return cb null, response

        else if action == 'get'
          platform = args[1]
          if platform != null
            getDeviceByQ platform, cb
            (response, cb) ->
              return cb null, response

        else if action == 'got'
          id = args[1]
          if id != null
            getDeviceById id, user, cb
            (response, cb) ->
              return cb null, response
    ], callback

  execute: executeCommand,
