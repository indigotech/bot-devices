module.exports = (async, config, childProcess) ->

  parseRequest = (args, cb) ->
    action = args[0]
    if action == 'want' && args[1]?
      code = args[1]
      #post device code
#      response = httpGet(serverURL + args[1])
    else if action == 'get' && args[1]?
      platform = args[1]
      if platform == 'iphone'
        return args.slice(2).join(" ")
        # query parameters (args.slice(2).join(" "))
      else if platform == 'android'
        return args.slice(2).join(" ")
        # query parameters (args.slice(2).join(" "))
      else if platform  == 'wp'
        return args.slice(2).join(" ")
        # query parameters (args.slice(2).join(" "))
    else if action == 'create' || action == 'update'
      params = {}
      params['model'] = args[1]
      params['os'] = args[2]
      params['version'] = args[3]
      params['notes'] = args[4]
      params['owner'] = args[5]
      params['status'] = 'available'
      params['date'] = ' '
      params['user'] = ' '
      if action == 'update'
        params['status'] = args[6]
        return params
        #Put updated device
      else
        return params
        #Post created device

      # post create/update device with params

  getQueryParams = (args) ->
    return args.slice(2).join(" ")

  validate = (text, callback) ->
    return callback()



  executeCommand = (text, callback) ->
    async.waterfall [
      async.apply validate, text
      (cb) ->
        cb null, text.split(' ') #removes 'tqt' and keep following arguments
      (args, cb) ->
        return cb null, parseRequest(args, cb)

    ], callback

  execute: executeCommand,
