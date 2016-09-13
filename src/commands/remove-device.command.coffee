module.exports = (deviceResource, messages) ->

  removeDevice = (id, brain, callback) ->
    device = deviceResource.getById brain, id

    if not device
      callback messages.ERROR_GET_DEVICE id

    else
      deviceResource.remove brain, device
      callback null, messages.SUCCESS_REMOVE_DEVICE device

  parseArgs = (args) ->
    args[1]

  execute = (args, user, brain, callback) ->
    id = parseArgs args
    removeDevice id, brain, callback

  execute: execute
