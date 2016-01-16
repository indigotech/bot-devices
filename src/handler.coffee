module.exports = () ->
  devices = () ->
    router_module = require('../src/router')
    mrouter = router_module()
    body = mrouter.getdevices()
    console.log(body)
    mrouter.getdevices (body) ->
      console.log("handler")
      return body

  getdevices: devices,
