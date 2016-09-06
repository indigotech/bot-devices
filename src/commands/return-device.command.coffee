module.exports = (deviceResource, messages) ->

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
    returnDevice id, brain, callback

  execute: execute
