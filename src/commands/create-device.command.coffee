module.exports = (deviceResource, messages) ->

  createDevice = (params, brain, callback) ->
    device = deviceResource.create brain, params
    callback null, messages.SUCCESS_CREATE_DEVICE device

  parseArgs = (args) ->
    id: args[1]
    model: args[2]
    os: args[3]
    version: args[4]
    notes: args[5]
    owner: args[6]

  execute = (args, user, brain, callback) ->
    params = parseArgs args
    createDevice params, brain, callback

  execute: execute
