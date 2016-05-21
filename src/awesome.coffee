module.exports = (async, config) ->

  devicesEndpoint = config.devicesEndpoint

  getAllDevices = (callback) ->
    request = require('request')
    response = ''
    request devicesEndpoint, (error, response, body) ->
      if (!error && response.statusCode == 200 && body)
        jsonDevice = JSON.parse(body)
        pretty = ''
        for device in jsonDevice
          if device && device.model && device.version && device.status
            
            if device.status == 'unavailable'
              pretty = pretty + ':red_circle: '
            else
              pretty = pretty + ':large_blue_circle: '
            pretty = pretty + device.model + ' ' + device.version
            if device.status == 'unavailable'
              pretty = pretty + ' with ' + device.user
            if device.owner != 'taqtile'
              pretty = pretty + ' owned by ' + device.owner
            pretty = pretty + '\n'


        callback null, pretty
      else callback 'error'

  getDeviceByOs = (os, callback) ->
    params = 'os=' + os
    request = require('request')
    response = ''

    router params, (body) ->
      console.log body
      callback body

  getDeviceByQ = (query, callback) ->
    params = 'q=' + query
    request = require('request')
    response = ''
    path = devicesEndpoint + '?' + params

    request path, (error, response, body) ->
      console.log devicesEndpoint + '?' + params
      if (!error && response.statusCode == 200 && body)
        jsonDevice = JSON.parse(body)
        pretty = ''
        for device in jsonDevice
          if device && device.model && device.version && device.status
            
            if device.status == 'unavailable'
              pretty = pretty + ':red_circle: '
            else
              pretty = pretty + ':large_blue_circle: '
            pretty = pretty + device.model + ' ' + device.version
            if device.status == 'unavailable'
              pretty = pretty + ' with ' + device.user
            if device.owner != 'taqtile'
              pretty = pretty + ' owned by ' + device.owner
            pretty = pretty + '\n'


        callback null, pretty
      else callback 'error'

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

    request.post devicesEndpoint, {form:params}, (error, response, body) ->
      console.log 'cheguei aqui' + response.statusCode
      if (!error && response.statusCode == 201)
        console.log 'Looog ' + body
        callback null, body

  getDeviceById = (id, name, callback) ->
    request = require('request')
    path = devicesEndpoint + '/' + id

    request path, (error, response, body) ->
      if (!error && response.statusCode == 200)
        jsonDevice = JSON.parse(body)
        if jsonDevice.length == 0
          callback "Oops, there isn't such a device"
        else if jsonDevice.status == 'unavailable' && jsonDevice.user == name
          callback "It's already with you... o.O"
        else if jsonDevice.status == 'unavailable'
          callback "Oops, someone else has it. Try talking with " + jsonDevice.user
        gotDevice body, name, callback

  gotDevice = (device, name, callback) ->
    request = require('request')

    jsonDevice = JSON.parse(device)

    jsonDevice.status = 'unavailable'
    jsonDevice.user = name
    jsonDevice.date = new Date()

    request.post devicesEndpoint, {form:jsonDevice}, (error, response, body) ->
      console.log 'cheguei aqui' + response.statusCode
      if (!error && response.statusCode == 201)
        callback null, "It's yours!"
      else callback 'error'

  validate = (text, callback) ->
    return callback()

  returnDevice = (id, callback) ->
    request = require('request')
    path = devicesEndpoint + '/' + id

    request path, (error, response, body) ->
      if (!error && response.statusCode == 200)
        jsonDevice = JSON.parse(body)

        jsonDevice.status = 'available'
        jsonDevice.user = ''
        jsonDevice.date = ''

        request.post devicesEndpoint, {form:jsonDevice}, (error, response, body) ->
          console.log 'cheguei aqui' + response.statusCode
          if (!error && response.statusCode == 201)
            callback null, "It's back!"
          else callback 'error'

  removeDevice = (args, callback) ->
    request = require('request')
    path = devicesEndpoint+ '/' + args[1]

    request.del path, (error, response, body) ->
      if (!error && response.statusCode == 200)
        callback null, "Device was removed"

  executeCommand = (text, user, callback) ->
    async.waterfall [
      async.apply validate, text
      (cb) ->
        if text == null || text == 'undefined' || text == undefined
          console.log text
          cb 'error'
        else cb null, text.split(' ')
      (args, cb) ->
        helpText = "Yo " + user.name + "! How r u doin, bro? Im here to help you find and manage devices. For example, an iPhone 6 Plus iOS 9.2 64 GB White. \n\nYou can type \`want\` followed by any term of what you want to find (e.g., \*want iPhone\* or \*want iOS\*). \n\nOr, you can just ask for the availability of all devices by typing \`want all\`. When you take a device, \nremember to tell others by typing \`got\` followed by its id. When you return a device, \ntell your bros too: type \`back\` followed by its id.\n\nYou can also register a new device or delete an existing one by typing \`register\` or \`delete\`, followed by its full information. Remember, bro, You will need: \*model\*, \*os\*, \*version\*, \*notes\*, \*owner\* (e.g., register \"Blackberry Curve\" \"blackberry\" \"7.0.0\" \"Bundle 2055 black\" \"your name\")."

        action = args[0]
        if action == 'register'
          createDevice args, cb
          (response, cb) ->
            return cb null, response

        else if action == 'want'
          platform = args[1]
          if platform == 'all'
            getAllDevices cb
            (response, cb) ->
              return cb null, response
          if platform != null && platform != 'undefined' && platform != undefined
            getDeviceByQ platform, cb
            (response, cb) ->
              return cb null, response
          else
            getAllDevices cb
            (response, cb) ->
              return cb null, response

        else if action == 'got'
          id = args[1]
          if id != null
            getDeviceById id, user.name, cb
            (response, cb) ->
              return cb null, response

        else if action == 'back'
          id = args[1]
          if id != null
            returnDevice id, cb
            (response, cb) ->
              return cb null, response

        else if action == 'help'
         text = helpText
         return cb null, text

        else if action == 'delete'
          removeDevice args, cb
          (response, cb) ->
            return cb null, response

        else
          text = "Whaaat? \n\n" + helpText
          return cb null, text
    ], callback

  execute: executeCommand,
