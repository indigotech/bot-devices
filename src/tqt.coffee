module.exports = (async, config, childProcess) ->

  # allowedArgs = ['help', 'version', 'config', 'github']

  validate = (text, callback) ->
    args = text.split(' ')
    
    # if args[0] isnt 'tqt'
    #   return callback "First argument must be 'tqt'"
    # else 
    # if args.length < 2
    #   return callback "Missing arguments. Try using 'tqt help'"
    # else 
    # if allowedArgs.indexOf(args[1]) < 0
    #   return callback "Argumment not allowed. BOT current only supports the following arguments: `#{allowedArgs.join('`, `')}`"
    # else
    return callback()


  executeCommand = (text, callback) ->
    async.waterfall [
      async.apply validate, text
      (cb) ->
        cb null, text.split(' ') #removes 'tqt' and keep following arguments
      (args, cb) ->
        return cb null, 'hello'
    ], callback

  execute: executeCommand,
