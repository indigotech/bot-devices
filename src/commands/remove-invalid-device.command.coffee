module.exports = (deviceResource, messages) ->

  removeDevice = (robot, callback) ->
    devices = deviceResource.getAll robot

    devices = devices.filter (device) ->
      not device.id or device.id.length == 0

    if devices.length > 0
      deviceResource.remove robot, device

    callback null, messages.SUCCESS_REMOVE_INVALID_DEVICE device

  execute = (args, user, robot, callback) ->
    removeDevice robot, callback

  execute: execute
