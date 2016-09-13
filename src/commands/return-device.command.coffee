module.exports = (deviceResource, messages) ->

  returnAll = (user, brain, callback) ->
    devices = deviceResource.getAll brain

    devices.forEach (device, index) ->
      if device.user is user.name
        device.status = 'available'
        device.user = ''
        device.date = ''
        deviceResource.update brain, index, device

    callback null, messages.SUCCESS_RETURN_ALL_DEVICES

  returnDevice = (id, brain, callback) ->
    device = deviceResource.getById brain, id

    if not device
      callback messages.ERROR_GET_DEVICE id

    else
      devices = deviceResource.getAll brain
      index = devices.indexOf(device)

      device.status = 'available'
      device.user = ''
      device.date = ''

      deviceResource.update brain, index, device
      callback null, messages.SUCCESS_RETURN_DEVICE device

  parseArgs = (args) ->
    args[1]

  execute = (args, user, brain, callback) ->
    id = parseArgs args

    if id is "all"
      returnAll user, brain, callback
    else
      returnDevice id, brain, callback

  execute: execute
