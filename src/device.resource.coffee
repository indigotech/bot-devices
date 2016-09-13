module.exports = (_) ->

  devicesArrayKey = "devices"

  getAll = (brain) ->
    devices = brain.get devicesArrayKey
    devices = [] if not devices

    devices.filter (device) -> device?

  getByQ = (brain, query) ->
    devices = getAll brain

    if _.get(query, 'length', 0) > 0
      query = query.toLowerCase()
      devices.filter (device) ->
        _.includes(device.id?.toLowerCase(), query) or
        _.includes(device.model?.toLowerCase(), query) or
        _.includes(device.os?.toLowerCase(), query) or
        _.includes(device.version?.toLowerCase(), query) or
        _.includes(device.status?.toLowerCase(), query)
    else
      devices

  getById = (brain, id) ->
    devices = getAll brain
    devices = devices.filter (device) -> _.includes(device.id?.toLowerCase(), id?.toLowerCase())

    devices[0]

  saveAll = (brain, devices) ->
    brain.set devicesArrayKey, devices

  create = (brain, params) ->
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

    devices = getAll brain
    devices.push device
    saveAll brain, devices

    device

  update = (brain, index, device) ->
    devices = getAll brain

    # TODO what happens if device is not found? is it possible
    if index > -1
      # probably a useless line of code
      devices[index] = device
      saveAll brain, devices

  remove = (brain, device) ->
    devices = getAll brain
    index = devices.indexOf device

    # TODO what happens if device is not found? is it possible
    if index > -1
      devices.splice index, 1
      saveAll brain, devices

  getAll: getAll
  getByQ: getByQ
  getById: getById
  create: create
  update: update
  remove: remove
