module.exports = (deviceResource, messages) ->

  removeDevice = (id, robot, callback) ->
    device = deviceResource.getById robot, id

    if not device
      callback messages.ERROR_GET_DEVICE id

    else
      deviceResource.remove robot, device
      callback null, messages.SUCCESS_REMOVE_DEVICE device

  parseArgs = (args) ->
    args[1]

  execute = (args, user, robot, callback) ->
    id = parseArgs args
    removeDevice id, robot, callback

  execute: execute
