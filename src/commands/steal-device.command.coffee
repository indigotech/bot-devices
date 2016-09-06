module.exports = (deviceResource, messages) ->

  gotDevice = (id, name, brain, callback) ->
    device = deviceResource.getById brain, id

    if not device
      callback messages.ERROR_GET_DEVICE id

    else
      if device.status is 'unavailable' && device.user == name
        callback messages.ERROR_DEVICE_OWNED device
      else
        devices = deviceResource.getAll brain
        index = devices.indexOf(device)

        oldUser = device.user

        device.status = 'unavailable'
        device.user = name
        device.date = new Date()

        deviceResource.update brain, index, device
        callback null, messages.SUCCESS_GOT_DEVICE device, oldUser

  parseArgs = (args) ->
    args[1]

  execute = (args, user, brain, callback) ->
    id = parseArgs args
    gotDevice id, user.name, brain, callback

  execute: execute
