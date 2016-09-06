module.exports = (utils) ->

  devicesArrayKey = "devices"

  getAll = (robot) ->
    devices = robot.brain.get devicesArrayKey
    devices = [] if not devices

    devices.filter (device) -> device?

  getByQ = (robot, query) ->
    devices = getAll robot

    if query && query.length > 0
      query = query.toLowerCase()
      devices.filter (device) ->
        utils.strContains(device.model, query) ||
        utils.strContains(device.version, query) ||
        utils.strContains(device.id, query) ||
        utils.strContains(device.status, query)
    else
      devices

  getById = (robot, id) ->
    id = id.toLowerCase()
    devices = getAll robot
    devices = devices.filter (device) -> utils.strContains(device.id, id)

    devices[0]

  saveAll = (robot, devices) ->
    robot.brain.set devicesArrayKey, devices

  create = (robot, params) ->
    device =
      id: params.id
      model: params.model
      os: params.os
      version: params.version
      notes: params.notes
      owner: params.owner
      status: 'available'
      date: ' '
      user: ' '

    devices = getAll robot
    devices.push device
    saveAll robot, devices

    device

  update = (robot, index, device) ->
    devices = getAll robot

    # TODO what happens if device is not found? is it possible
    if index > -1
      # probably a useless line of code
      devices[index] = device
      saveAll robot, devices

  remove = (robot, device) ->
    devices = getAll robot
    index = devices.indexOf device

    # TODO what happens if device is not found? is it possible
    if index > -1
      devices.splice index, 1
      saveAll robot, devices

  getAll: getAll
  getByQ: getByQ
  getById: getById
  create: create
  update: update
  remove: remove
