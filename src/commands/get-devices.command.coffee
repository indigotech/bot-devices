module.exports = (deviceResource, messages) ->

  printDevices = (devices, callback) ->
    output = devices.map (device) -> messages.DEVICE_STATUS device
    callback null, output.join '\n'

  getDeviceByQ = (query, brain, callback) ->
    devices = deviceResource.getByQ brain, query
    printDevices devices, callback

  parseArgs = (args) ->
    query = args[1]

    if query is 'all'
      undefined
    else
      query

  execute = (args, user, brain, callback) ->
    query = parseArgs args
    getDeviceByQ query, brain, callback

  execute: execute
