module.exports = (deviceResource, messages) ->

  printDevices = (devices, callback) ->
    output = devices.map (device) -> messages.DEVICE_STATUS device
    callback null, output.join '\n'

  getDeviceByQ = (query, robot, callback) ->
    devices = deviceResource.getByQ robot, query
    printDevices devices, callback

  parseArgs = (args) ->
    query = args[1]

    if query == 'all' || (query != null && query != 'undefined' && query != undefined)
      undefined
    else
      query

  execute = (args, robot, callback,) ->
    query = parseArgs args
    getDeviceByQ query, robot, callback

  execute: execute
