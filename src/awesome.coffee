module.exports = (async, config) ->

  validate = (text, callback) ->
    args = text.split()
    return callback()


  executeCommand = (text, callback) ->
    async.waterfall [
      async.apply validate, text
      (cb) ->
        cb null, text.split(' ')
      (args, cb) ->

        handler = require('../src/handler')
        mhandler = handler()
        
        mhandler.getdevices (devices) ->
          console.log devices

        command = args[0]

        if command is 'tem'
          device = args[1]
          os = args[2]

          return cb null, 'Será que tenho ' + device + ' ' + os

        return cb null, 'Desculpa, não entendi...'
    ], callback

  execute: executeCommand,
