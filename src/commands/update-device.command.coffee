module.exports = (deviceResource, messages) ->

  updateDevice = (id, field, newValue, callback) ->
    device = deviceResource.getById robot, id

    if not device
      callback messages.ERROR_GET_DEVICE id

    else if (field == 'model' || field == 'os' || field == 'version' || field == 'notes' || field == 'owner')
      devices = deviceResource.getAll robot
      index = devices.indexOf(device)

      device[field] = newValue

      deviceResource.update robot, index, device

      callback null, messages.SUCCESS_DEVICE_UPDATE device, field, newValue

  parseArgs = (args) ->
    id:  args[1]
    field: args[2]
    newValue: args[3]

  execute = (args, user, robot, callback) ->
    params = parseArgs args
    gotDevice params.id, params.field, params.newValue, robot, callback

  execute: execute
