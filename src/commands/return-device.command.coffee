module.exports = (deviceResource, messages) ->

  returnDevice = (id, robot, callback) ->
    device = deviceResource.getById robot, id

    if not device
      callback messages.ERROR_GET_DEVICE id

    else
      devices = deviceResource.getAll robot
      index = devices.indexOf(device)

      device.status = 'available'
      device.user = ''
      device.date = ''

      deviceResource.update robot, index, device
      callback null, messages.SUCCESS_RETURN_DEVICE

  parseArgs = (args) ->
    args[1]

  execute = (args, robot, callback) ->
    id = parseArgs args
    returnDevice id, robot, callback

  execute: execute
