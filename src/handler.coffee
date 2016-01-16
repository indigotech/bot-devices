module.exports = () ->
  devices = () ->
    router_module = require('../src/router')
    mrouter = router_module()
    mrouter.getdevices (body) ->
      return body

  getdevices: devices,
