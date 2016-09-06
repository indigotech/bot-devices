module.exports = (async, deviceResource, messages) ->

  # comands
  commands =
    "device-help": require('./commands/help.command') messages
    "device-want": require('./commands/get-devices.command') deviceResource, messages
    "device-got": require('./commands/got-device.command') deviceResource, messages
    "device-register": require('./commands/create-device.command') deviceResource, messages
    "device-delete": require('./commands/remove-device.command') deviceResource, messages
    "device-back": require('./commands/return-device.command') deviceResource, messages
    "device-update": require('./commands/update-device.command') deviceResource, messages

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
        action = args[0]
        args.splice(0, 1)
        args = args.join(" ")
        args = args.split(", ")
        args.unshift(action)

        command = commands[action]

        if not command
          command = commands["device-help"]

        command.execute args, user, robot, cb

    ], callback

  execute: executeCommand
