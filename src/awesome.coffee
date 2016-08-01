module.exports = (async) ->

  devicesArrayKey = "devices"
  request = require('request')

  getAllDevices = (robot, callback) ->
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices
    pretty = ''
    for device in devices
      if device and device.model and device.version and device.status and device.id
        if device.status == 'unavailable'
          pretty = pretty + ':red_circle: '
        else
          pretty = pretty + ':large_blue_circle: '
        pretty = pretty + device.id + ' ' + device.model + ' ' + device.version
        if device.status == 'unavailable'
          pretty = pretty + ' with ' + device.user
        if device.owner != 'taqtile'
          pretty = pretty + ' owned by ' + device.owner
        pretty = pretty + '\n'


    callback null, pretty

  getDeviceByQ = (query, robot, callback) ->
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices
    pretty = ''
    query = query.toLowerCase()
    for device in devices
      if device && device.model && device.version && device.status && device.id
        if device.model.toLowerCase().indexOf(query) > -1 or device.version.toLowerCase().indexOf(query) > -1 or device.status.toLowerCase().indexOf(query) > -1 or device.os.toLowerCase().indexOf(query) > -1
          if device.status == 'unavailable'
            pretty = pretty + ':red_circle: '
          else
            pretty = pretty + ':large_blue_circle: '
          pretty = pretty + device.id + ' ' + device.model + ' ' + device.version
          if device.status == 'unavailable'
            pretty = pretty + ' with ' + device.user
          if device.owner != 'taqtile'
            pretty = pretty + ' owned by ' + device.owner
          pretty = pretty + '\n'
    callback null, pretty

  createDevice = (args, robot, callback) ->
    params = {}
    params['id'] = args[1]
    params['model'] = args[2]
    params['os'] = args[3]
    params['version'] = args[4]
    params['notes'] = args[5]
    params['owner'] = args[6]
    params['status'] = 'available'
    params['date'] = ' '
    params['user'] = ' '
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices
    devices.push params
    devices = robot.brain.set devicesArrayKey, devices
    callback null, "Success!"

  getDeviceById = (id, robot, callback) ->
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices

    for device in devices
      if device.id is id
        callback null, device, devices
        return
    return "Device not found"


  gotDevice = (id, name, robot, slackCallback) ->
    getDeviceById id, robot, (error, device, devices) ->
      index = devices.indexOf(device)
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

        devices[index] = device
        devices = robot.brain.set devicesArrayKey, devices
        slackCallback null, "It's yours!"

  updateDevice = (id, field, newValue, slackCallback) ->
    getDeviceById id, robot, (error, device, devices) ->
      index = devices.indexOf(device)
      if error
        slackCallback error
      else if (field == 'model' || field == 'os' || field == 'version' || field == 'notes' || field == 'owner')
        console.log field
        device[field] = newValue

        device.status = 'unavailable'
        device.user = name
        device.date = new Date()

        devices[index] = device
        devices = robot.brain.set devicesArrayKey, devices

        devices[index] = device
        devices = robot.brain.set devicesArrayKey, devices

        slackCallback null, "It's yours!"

  returnDevice = (id, robot, slackCallback) ->
    getDeviceById id, robot, (error, device, devices) ->
      index = devices.indexOf(device)
      if error
        slackCallback error
      else
        device.status = 'available'
        device.user = ''
        device.date = ''

        devices[index] = device
        devices = robot.brain.set devicesArrayKey, devices
        slackCallback null, "It's back!"

  removeDevice = (id, robot, callback) ->
    getDeviceById id, robot, (error, device, devices) ->
      if device
        index = devices.indexOf(device)
        if error
          slackCallback error
        else
          devices.splice index, 1
          devices = robot.brain.set devicesArrayKey, devices
          slackCallback null, "Removed"
      else
        slackCallback null, "Error removing"

  executeCommand = (msg, robot, callback) ->
    text = msg.message.text
    user = msg.message.user
    console.log text
    async.waterfall [
      (cb) ->
        if text == null || text == 'undefined' || text == undefined
          console.log text
          cb 'error'
        else cb null, text.split(' ')
      (args, cb) ->
        args.splice(0, 1);
        helpText = "Yo " + user.name + "! How r u doin, bro? Im here to help you find and manage devices. For example, an iPhone 6 Plus iOS 9.2 64 GB White. \n\nYou can type \`want-device\` followed by any term of what you want to find (e.g., \*want-device iPhone\* or \*want-device iOS\*). \n\nOr, you can just ask for the availability of all devices by typing \`want-device all\`. When you take a device, \nremember to tell others by typing \`got-device\` followed by its id. When you return a device, \ntell your bros too: type \`back-device\` followed by its id.\n\nYou can also register a new device or delete an existing one by typing \`register-device\` or \`delete-device\`, followed by its full information. Remember, bro, You will need: \*id\*, \*model\*, \*os\*, \*version\*, \*notes\*, \*owner\* (e.g., register-device \"Blackberry 1\" \"Blackberry Curve\" \"blackberry\" \"7.0.0\" \"Bundle 2055 black\" \"your name\")."

        action = args[0]
        if action == 'register-device'
          createDevice args, robot, cb
          (response, cb) ->
            return cb null, response

        else if action == 'want-device'
          platform = args[1]
          if platform == 'all'
            getAllDevices robot, cb
            (response, cb) ->
              return cb null, response
          if platform != null && platform != 'undefined' && platform != undefined
            getDeviceByQ platform, robot, cb
            (response, cb) ->
              return cb null, response
          else
            getAllDevices robot, cb
            (response, cb) ->
              return cb null, response

        else if action == 'got-device'
          id = args[1]
          if id != null
            gotDevice id, user.name, robot, cb
            (response, cb) ->
              return cb null, response

        else if action == 'back-device'
          id = args[1]
          if id != null
            returnDevice id, robot, cb
            (response, cb) ->
              return cb null, response

        else if action == 'help-device'
         text = helpText
         return cb null, text

        else if action == 'delete-device'
          removeDevice args, robot, cb
          (response, cb) ->
            return cb null, response

        else if action == 'update-device'
          id = args[1]
          if id != null
            console.log args
            updateDevice id, args[2], args[3], robot, cb
            (response, cb) ->
              return cb null, response

        else
          return cb null, null
    ], callback

  execute: executeCommand
