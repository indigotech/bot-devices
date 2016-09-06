module.exports = (deviceResource, async) ->
  builtOutput = (device) ->
    unavailable = device.status == 'unavailable'
    hasOwner = device.owner != 'taqtile'

    output = []

    output.push if unavailable then ':red_circle:' else ':large_blue_circle:'
    output.push "id: `#{device.id}`"
    output.push "name: `#{device.model}`"
    output.push "version: `#{device.version}"
    output.push "owned by _#{device.owner}_" if hasOwner
    output.push "with #{device.user}" if unavailable

    output.join ' '

  printDevices = (devices, callback) ->
    output = devices.map (device) -> builtOutput device
    callback null, output.join '\n'

  getAllDevices = (robot, callback) ->
    devices = deviceResource.getAll robot
    printDevices devices, callback

  getDeviceByQ = (query, robot, callback) ->
    devices = deviceResource.getByQ robot, query
    printDevices devices, callback

  createDevice = (args, robot, callback) ->
    device = deviceResource.create robot, { id: args[1], model: args[2], version: args[4], notes: args[5], owner: args[6] }
    callback null, "Success adding `#{device.id}` (`#{device.model}`)!"

  getDeviceById = (id, robot, callback) ->
    device = deviceResource.getById robot, id

    if device
      callback null, device
    else
      callback "Device not found for id `#{id}`"

  gotDevice = (id, name, robot, callback) ->
    getDeviceById id, robot, (error, device) ->
      if error
        callback error
      else
        if device.status == 'unavailable' && device.user == name
          callback "It's already with you... o.O"
        else if device.status == 'unavailable'
          callback "Oops, someone else has it. Try talking with " + device.user
        else
          devices = deviceResource.getAll robot
          index = devices.indexOf(device)

          device.status = 'unavailable'
          device.user = name
          device.date = new Date()

          deviceResource.update robot, index, device
          callback null, "`#{device.id}` (`#{device.model}`) is yours!"

  updateDevice = (id, field, newValue, callback) ->
    getDeviceById id, robot, (error, device) ->
      if error
        callback error
      else if (field == 'model' || field == 'os' || field == 'version' || field == 'notes' || field == 'owner')
        devices = deviceResource.getAll robot
        index = devices.indexOf(device)

        device[field] = newValue

        deviceResource.update robot, index, device

        callback null, "`#{device.id}` (`#{field}: #{newValue}`) updated!"

  returnDevice = (id, robot, callback) ->
    getDeviceById id, robot, (error, device) ->
      if error
        callback error
      else
        devices = deviceResource.getAll robot
        index = devices.indexOf(device)

        device.status = 'available'
        device.user = ''
        device.date = ''

        deviceResource.update robot, index, device
        callback null, "`#{device.id}` (`#{device.model}`) is back to the pool!"

  removeDevice = (id, robot, callback) ->
    getDeviceById id, robot, (error, device) ->
      if error
        callback error
      else
        deviceResource.remove robot, device
        callback null, "`#{device.id}` (`#{device.model}`) removed"

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
        helpText = [
          "Yo #{user.name}! How r u doin, bro? Im here to help you find and manage devices. For example, an iPhone 6 Plus iOS 9.2 64 GB White. \n",
          "You can type \`device-want\` followed by any term of what you want to find (e.g., \*device-want iPhone\* or \*device-want iOS\*). \n",
          "Or, you can just ask for the availability of all devices by typing \`device-want all\`. When you take a device, ",
          "remember to tell others by typing \`device-got\` followed by its id. When you return a device, ",
          "tell your bros too: type \`device-back\` followed by its id.\n",
          "You can also register a new device or delete an existing one by typing \`device-register\` or \`device-delete\`, followed by its full information. Remember, bro, You will need: \*id\*, \*model\*, \*os\*, \*version\*, \*notes\*, \*owner\* (e.g., device-register Blackberry 1, Blackberry Curve, blackberry, 7.0.0,  Bundle 2055 black, your name)."
        ].join '\n'

        action = args[0]
        args.splice(0, 1)
        args = args.join(" ")
        args = args.split(", ")
        args.unshift(action)

        if action == 'device-register'
          createDevice args, robot, cb

        else if action == 'device-want'
          platform = args[1]
          if platform == 'all'
            getAllDevices robot, cb

          if platform != null && platform != 'undefined' && platform != undefined
            getDeviceByQ platform, robot, cb
          else
            getAllDevices robot, cb

        else if action == 'device-got'
          id = args[1]
          if id != null
            gotDevice id, user.name, robot, cb

        else if action == 'device-back'
          id = args[1]
          if id != null
            returnDevice id, robot, cb

        else if action == 'device-help'
         text = helpText
         return cb null, text

        else if action == 'device-delete'
          removeDevice args[1], robot, cb

        else if action == 'device-update'
          id = args[1]
          if id != null
            console.log args
            updateDevice id, args[2], args[3], robot, cb

        else
          return cb null, null
    ], callback

  execute: executeCommand
