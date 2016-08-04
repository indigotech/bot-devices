module.exports = (async) ->

  devicesArrayKey = "devices"
  request = require('request')


  builtOutput = (device, callback) ->
    status = ""
    holder = ""
    ownership = ""

    if device.status == 'unavailable'
      status = ':red_circle:'
    else
      status = ':large_blue_circle:'

    if device.status == 'unavailable'
      holder = "with #{device.user}"

    if device.owner != 'taqtile'
      ownership = "owned by _#{device.owner}_"

    # Example output =>
    #  :red_circle: id: `nexus5xwhite` name: `Nexus 5X 16GB White` version: `6.0.1` owned by _Taqtile_
    text = "#{status} id: `#{device.id}` name: `#{device.model}` version: `#{device.version}` #{ownership} #{holder}"

    callback null, text

  printDevices = (robot, devices, callback) ->

    output = []
    devices.forEach (device) ->

      if device and device.model and device.version and device.status and device.id
        builtOutput device, (err, text) ->
          output.push(text) if not err

    text = output.join('\n')

    callback null, text

  getAllDevices = (robot, callback) ->
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices

    printDevices robot, devices, callback

  getDeviceByQ = (query, robot, callback) ->
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices
    pretty = ''
    query = query.toLowerCase()

    devices = devices.map (device) ->
      if device &&
        device.model &&
        device.version &&
        device.status &&
        device.id &&
        (device.model.toLowerCase().indexOf(query) > -1 or device.version.toLowerCase().indexOf(query) > -1 or device.status.toLowerCase().indexOf(query) > -1 or device.os.toLowerCase().indexOf(query) > -1)
          return device

    printDevices robot, devices, callback


  createDevice = (args, robot, callback) ->
    device = {}
    device.id = args[1]
    device.model = args[2]
    device.os = args[3]
    device.version = args[4]
    device.notes = args[5]
    device.owner = args[6]
    device.status = 'available'
    device.date = ' '
    device.user = ' '
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices
    devices.push device
    devices = robot.brain.set devicesArrayKey, devices
    callback null, "Success adding `#{device.id}` (`#{device.model}`)!"

  getDeviceById = (id, robot, callback) ->
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices

    for device in devices
      if device.id && id && device.id.toLowerCase() is id.toLowerCase()
        callback null, device, devices
        return
    return callback "Device not found for id `#{id}`"


  gotDevice = (id, name, robot, slackCallback) ->
    getDeviceById id, robot, (error, device, devices) ->
      if error
        return slackCallback error

      index = devices.indexOf(device)
      if device.status == 'unavailable' && device.user == name
        slackCallback "It's already with you... o.O"
      else if device.status == 'unavailable'
        slackCallback "Oops, someone else has it. Try talking with " + device.user

      else
        device.status = 'unavailable'
        device.user = name
        device.date = new Date()

        devices[index] = device
        devices = robot.brain.set devicesArrayKey, devices
        slackCallback null, "`#{device.id}` (`#{device.model}`) is yours!"

  updateDevice = (id, field, newValue, slackCallback) ->
    getDeviceById id, robot, (error, device, devices) ->
      if error
        slackCallback error
      index = devices.indexOf(device)
      if (field == 'model' || field == 'os' || field == 'version' || field == 'notes' || field == 'owner')
        console.log field
        device[field] = newValue

        device.status = 'unavailable'
        device.user = name
        device.date = new Date()

        devices[index] = device
        devices = robot.brain.set devicesArrayKey, devices

        devices[index] = device
        devices = robot.brain.set devicesArrayKey, devices

        slackCallback null, "`#{device.id}` (`#{device.model}`) is yours!"

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
        slackCallback null, "`#{device.id}` (`#{device.model}`) is back to the pool!"

  removeDevice = (id, robot, slackCallback) ->
    getDeviceById id, robot, (error, device, devices) ->
      if device && devices
        index = devices.indexOf(device)
        if error
          slackCallback error
        else
          devices.splice index, 1
          devices = robot.brain.set devicesArrayKey, devices
          slackCallback null, "`#{device.id}` (`#{device.model}`) removed"
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
        helpText = "Yo " + user.name + "! How r u doin, bro? Im here to help you find and manage devices. For example, an iPhone 6 Plus iOS 9.2 64 GB White. \n\nYou can type \`device-want\` followed by any term of what you want to find (e.g., \*device-want iPhone\* or \*device-want iOS\*). \n\nOr, you can just ask for the availability of all devices by typing \`device-want all\`. When you take a device, \nremember to tell others by typing \`device-got\` followed by its id. When you return a device, \ntell your bros too: type \`device-back\` followed by its id.\n\nYou can also register a new device or delete an existing one by typing \`device-register\` or \`device-delete\`, followed by its full information. Remember, bro, You will need: \*id\*, \*model\*, \*os\*, \*version\*, \*notes\*, \*owner\* (e.g., device-register Blackberry 1, Blackberry Curve, blackberry, 7.0.0,  Bundle 2055 black, your name)."

        action = args[0]
        args.splice(0, 1)
        args = args.join(" ")
        args = args.split(", ")
        args.unshift(action)
        if action == 'device-register'
          createDevice args, robot, cb
          (response, cb) ->
            return cb null, response

        else if action == 'device-want'
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

        else if action == 'device-got'
          id = args[1]
          if id != null
            gotDevice id, user.name, robot, cb
            (response, cb) ->
              return cb null, response

        else if action == 'device-back'
          id = args[1]
          if id != null
            returnDevice id, robot, cb
            (response, cb) ->
              return cb null, response

        else if action == 'device-help'
         text = helpText
         return cb null, text

        else if action == 'device-delete'
          removeDevice args[1], robot, cb
          (response, cb) ->
            return cb null, response

        else if action == 'device-update'
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
