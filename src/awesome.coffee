module.exports = (async, _, devices) ->

  getAllDevices = (callback) ->
    devices.getAll (error, deviceList) ->
      if error
        callback 'error'
      else
        prettyList = _.map deviceList, (device) -> device.prettyPrint()
        callback null, prettyList.join()

  getDeviceByQ = (query, callback) ->
    devices.search query, (error, deviceList) ->
      if error
        callback 'error'
      else
        prettyList = _.map deviceList, (device) -> device.prettyPrint()
        callback null, prettyList.join()

  createDevice = (args, callback) ->
    device =
      model: args[1]
      os: args[2]
      version: args[3]
      notes: args[4]
      owner: args[5]
      status: 'available'
      date: null
      user: null
    
    devices.create device, (error, response) ->
      if error 
        callback 'error'
      else
        callback null, response

  getDeviceById = (id, callback) ->
    devices.getById id, (error, device) ->
      if error
        callback "Oops, there isn't such a device"
      else
        callback null, device

  gotDevice = (id, name, callback) ->
    async.waterfall [
      (cb) -> 
        getDeviceById id, (error, device) ->
          if error
            cb "Oops, there isn't such a device"
          else if device.isUnavailable()
            if device.hasSameUser(name)
              cb "It's already with you... o.O"
            else
              cb "Oops, someone else has it. Try talking with #{device.user}"
          else
            device.status = 'unavailable'
            device.user = name
            device.date = new Date()

            cb null, device

      (device, cb) ->
        devices.update id, device, (error, response) ->
          if error
            cb 'error'
          else
            cb null, "It's yours!"
    ], callback

  updateDevice = (id, field, newValue, callback) ->
    async.waterfall [
      (cb) -> 
        getDeviceById id, (error, device) ->
          if error
            cb error
          else if _.has device, field
            _.set device, field, newValue
            
            cb null, device
          else
            cb 'Oops, not a valid field.'

      (device, cb) ->
        devices.update id, device, (error, response) ->
          if error
            cb 'error'
          else
            cb null
    ], (error) ->
      if error
        callback error
      else
        callback null, "Done!\n\n#{body}"

  returnDevice = (id, callback) ->
    async.waterfall [
      (cb) ->
        getDeviceById id, (error, device) ->
          if error
            cb "Oops, there isn't such a device"
          else
            device.status = 'available'
            device.user = null
            device.date = null

            cb null, device

      (device, cb) ->
        devices.update id, device, (error, response) ->
          if error
            cb 'error'
          else
            cb null
    ], (error) ->
      if error
        callback error
      else
        callback null, "It's back"

  removeDevice = (id, callback) ->
    devices.remove id, (error) ->
      if error
        callback 'error'
      else
        callback null, 'Device was removed'

  executeCommand = (text, user, callback) ->
    async.waterfall [
      (cb) ->
        if !text || text == 'undefined'
          console.log text
          cb 'error'
        else
          cb null, text.split(' ')

      (args, cb) ->
        helpText = [
          "Yo #{user.name}! How r u doin, bro? Im here to help you find and manage devices. For example, an iPhone 6 Plus iOS 9.2 64 GB White.\n"
          "You can type \`want\` followed by any term of what you want to find (e.g., \*want iPhone\* or \*want iOS\*)."
          "Or, you can just ask for the availability of all devices by typing \`want all\`. When you take a device,"
          "remember to tell others by typing \`got\` followed by its id. When you return a device,"
          "tell your bros too: type \`back\` followed by its id.\n"
          "You can also register a new device or delete an existing one by typing \`register\` or \`delete\`, followed by its full information. Remember, bro, You will need: \*model\*, \*os\*, \*version\*, \*notes\*, \*owner\* (e.g., register \"Blackberry Curve\" \"blackberry\" \"7.0.0\" \"Bundle 2055 black\" \"your name\")."
        ].join '\n'

        action = args[0]

        if action == 'register'
          createDevice args, cb

        else if action == 'want'
          platform = args[1]

          if platform == 'all' || !platform || platform == 'undefined'
            getAllDevices cb
          else
            getDeviceByQ platform, cb

        else if action == 'got'
          id = args[1]
          if id != null
            gotDevice id, user.name, cb

        else if action == 'back'
          id = args[1]
          if id != null
            returnDevice id, cb

        else if action == 'help'
         text = helpText
         cb null, text

        else if action == 'delete'
          id = args[1]
          if id
            removeDevice args, cb

        else if action == 'update'
          id = args[1]
          if id != null
            updateDevice id, args[2], args[3], cb

        else
          cb null, "Whaaat? \n\n#{helpText}"

    ], callback

  execute: executeCommand
