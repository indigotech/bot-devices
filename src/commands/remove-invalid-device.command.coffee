module.exports = (deviceResource, messages) ->

  removeDevice = (brain, callback) ->
    devices = deviceResource.getAll brain

    devices = devices.filter (device) -> not device.id or device.id.length == 0

    if devices.length > 0
      device = devices[0]
      deviceResource.remove brain, device
      callback null, messages.SUCCESS_REMOVE_INVALID_DEVICE device

    callback null, messages.SUCCESS_NO_INVALID_DEVICE

  execute = (args, user, brain, callback) ->
    removeDevice brain, callback

  execute: execute
