safeAdd = (device, functionName, func) ->
  if (device)
    device[functionName] = func
    
addPrettyPrint = (device) ->
  safeAdd device, 'prettyPrint', () ->
    if device.model && device.version && device.status
      prettyList = []

      unavailable = device.status == 'unavailable'
      hasOwner = device.owner != 'taqtile'

      prettyList.push if unavailable then ':red_circle:' else ':large_blue_circle:'
      prettyList.push device.model
      prettyList.push device.version
      prettyList.push "with #{device.user}" if unavailable
      prettyList.push "owned by #{device.owner}" if hasOwner
      prettyList.push '\n'

      return prettyList.join ' '
    else
      return ''

addIsUnavailable = (device) ->
  safeAdd device, 'isUnavailable', () ->
    return device.status == 'unavailable'

addHasSameUser = (device) ->
  safeAdd device, 'hasSameUser', (user) ->
    return device.user == user

module.exports =
  decorate: (device) ->
    addPrettyPrint device
    addIsUnavailable device
    addHasSameUser device

