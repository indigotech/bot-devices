module.exports = (deviceResource, messages) ->

  forgotDevices = (brain, user, callback) ->
    devices = deviceResource.getAll brain

    devices = devices.filter (device) -> device.user is user.name

    if devices.length is 0
      callback null, messages.SUCCESS_NO_DEVICES_FORGOTTEN
    else
      output = devices.map (device) -> messages.DEVICE_FORGOTTEN device
      output.unshift messages.SUCCESS_HAS_DEVICES_FORGOTTEN

      callback null, output.join '\n'

  execute = (args, user, brain, callback) ->
    forgotDevices brain, user, callback

  execute: execute
