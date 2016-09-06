module.exports = (deviceResource, messages) ->

  gotDevice = (id, name, robot, callback) ->
    device = deviceResource.getById robot, id

    if not device
      callback messages.ERROR_GET_DEVICE id

    else
      if device.status is 'unavailable' && device.user == name
        callback messages.ERROR_DEVICE_OWNED device
      else
        devices = deviceResource.getAll robot
        index = devices.indexOf(device)

        oldUser = device.user

        device.status = 'unavailable'
        device.user = name
        device.date = new Date()

        deviceResource.update robot, index, device
        callback null, messages.SUCCESS_GOT_DEVICE device, oldUser

  parseArgs = (args) ->
    args[1]

  execute = (args, user, robot, callback) ->
    id = parseArgs args
    gotDevice id, user.name, robot, callback

  execute: execute
