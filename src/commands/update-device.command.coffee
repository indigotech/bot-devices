module.exports = (deviceResource, messages) ->

  updateDevice = (id, field, newValue, brain, callback) ->
    device = deviceResource.getById brain, id

    if not device
      callback messages.ERROR_GET_DEVICE id

    else if (field == 'model' || field == 'os' || field == 'version' || field == 'notes' || field == 'owner')
      devices = deviceResource.getAll brain
      index = devices.indexOf(device)

      device[field] = newValue

      deviceResource.update brain, index, device

      callback null, messages.SUCCESS_DEVICE_UPDATE device, field, newValue

  parseArgs = (args) ->
    id:  args[1]
    field: args[2]
    newValue: args[3]

  execute = (args, user, brain, callback) ->
    params = parseArgs args
    gotDevice params.id, params.field, params.newValue, brain, callback

  execute: execute
