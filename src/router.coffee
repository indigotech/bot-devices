module.exports = (http) ->
  devices = () ->
    request = require('request')
    request 'https://dandpb.fwd.wf/devices', (error, response, body) ->
      if (!error && response.statusCode == 200)
        return body



  getdevices: devices,

