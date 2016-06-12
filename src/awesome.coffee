module.exports = (async) ->

  devicesEndpoint = process.env.DEVICE_SERVER_URL
  request = require('request')

  getAllDevices = (callback) ->
    response = ''
    request devicesEndpoint, (error, response, body) ->
      if (!error && response.statusCode == 200 && body)
        jsonDevice = JSON.parse(body).data
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

  getDeviceByQ = (query, callback) ->
    params = 'q=' + query
    response = ''
    path = devicesEndpoint + '?' + params

    request path, (error, response, body) ->
      console.log devicesEndpoint + '?' + params
      if (!error && response.statusCode == 200 && body)
        console.log body
        jsonDevice = JSON.parse(body).data
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
      if (!error && response.statusCode == 200)
        console.log 'Looog ' + body
        callback null, body

  getDeviceById = (id, callback) ->
    path = devicesEndpoint + '/' + id

    request path, (error, response, body) ->
      if (!error && response.statusCode == 200)
        jsonDevice = JSON.parse(body).data

        if jsonDevice.length == 0
          callback "Oops, there isn't such a device"
        else
          callback null, jsonDevice
      else
        callback "error"


  gotDevice = (id, name, slackCallback) ->
    async.waterfall [
      (cb) ->
        getDeviceById id, (error, device) ->
          if error
            slackCallback error
          else if device.status == 'unavailable' && device.user == name
            slackCallback "It's already with you... o.O"
          else if device.status == 'unavailable'
            slackCallback "Oops, someone else has it. Try talking with " + device.user

          else
            device.status = 'unavailable'
            device.user = name
            device.date = new Date()

          cb null, device

      (jsonDevice, cb) ->
        request.post devicesEndpoint, {form:jsonDevice}, (error, response, body) ->
          console.log 'cheguei aqui' + response.statusCode
          if (!error && response.statusCode == 200)
            slackCallback null, "It's yours!"
          else slackCallback 'error'

          cb null

    ], slackCallback

  updateDevice = (id, field, newValue, slackCallback) ->
    async.waterfall [
      (cb) ->
        getDeviceById id, (error, device) ->
          console.log 'id: ' + id
          if error
            slackCallback error
          else if (field == 'model' || field == 'os' || field == 'version' || field == 'notes' || field == 'owner')
            console.log field
            device[field] = newValue
          else
            slackCallback "Oops, not a valid field."

          cb null, device

      (jsonDevice, cb) ->
        request.post devicesEndpoint, {form:jsonDevice}, (error, response, body) ->
          console.log 'cheguei aqui' + response.statusCode
          if (!error && response.statusCode == 201)
            slackCallback null, "Done!\n\n" + body
          else slackCallback 'error'

          cb null

    ], slackCallback


  returnDevice = (id, callback) ->
    path = devicesEndpoint + '/' + id

    request path, (error, response, body) ->
      if (!error && response.statusCode == 200)
        jsonDevice = JSON.parse(body).data

        jsonDevice.status = 'available'
        jsonDevice.user = ''
        jsonDevice.date = ''

        request.post devicesEndpoint, {form:jsonDevice}, (error, response, body) ->
          console.log 'cheguei aqui' + response.statusCode
          if (!error && response.statusCode == 201)
            callback null, "It's back!"
          else callback 'error'

  removeDevice = (args, callback) ->
    path = devicesEndpoint+ '/' + args[1]

    request.del path, (error, response, body) ->
      if (!error && response.statusCode == 200)
        callback null, "Device was removed"

  executeCommand = (text, user, callback) ->
    console.log text
    async.waterfall [
      (cb) ->
        if text == null || text == 'undefined' || text == undefined
          console.log text
          cb 'error'
        else cb null, text.split(' ')
      (args, cb) ->
        args.splice(0, 1);
        helpText = "Yo " + user.name + "! How r u doin, bro? Im here to help you find and manage devices. For example, an iPhone 6 Plus iOS 9.2 64 GB White. \n\nYou can type \`want-device\` followed by any term of what you want to find (e.g., \*want-device iPhone\* or \*want-device iOS\*). \n\nOr, you can just ask for the availability of all devices by typing \`want-device all\`. When you take a device, \nremember to tell others by typing \`got-device\` followed by its id. When you return a device, \ntell your bros too: type \`back-device\` followed by its id.\n\nYou can also register a new device or delete an existing one by typing \`register-device\` or \`delete-device\`, followed by its full information. Remember, bro, You will need: \*model\*, \*os\*, \*version\*, \*notes\*, \*owner\* (e.g., register-device \"Blackberry Curve\" \"blackberry\" \"7.0.0\" \"Bundle 2055 black\" \"your name\")."

        action = args[0]
        if action == 'register-device'
          createDevice args, cb
          (response, cb) ->
            return cb null, response

        else if action == 'want-device'
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

        else if action == 'got-device'
          id = args[1]
          if id != null
            gotDevice id, user.name, cb
            (response, cb) ->
              return cb null, response

        else if action == 'back-device'
          id = args[1]
          if id != null
            returnDevice id, cb
            (response, cb) ->
              return cb null, response

        else if action == 'help-device'
         text = helpText
         return cb null, text

        else if action == 'delete-device'
          removeDevice args, cb
          (response, cb) ->
            return cb null, response

        else if action == 'update-device'
          id = args[1]
          if id != null
            console.log args
            updateDevice id, args[2], args[3], cb
            (response, cb) ->
              return cb null, response

        else
          return cb null, null
    ], callback

  execute: executeCommand
