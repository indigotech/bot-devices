module.exports =
  DEVICE_STATUS: (device) ->
    unavailable = device.status == 'unavailable'
    hasOwner = device.owner != 'taqtile'

    output = []

    output.push if unavailable then ':red_circle:' else ':large_blue_circle:'
    output.push "id: `#{device.id}`"
    output.push "name: `#{device.model}`"
    output.push "version: `#{device.version}`"
    output.push "owned by _#{device.owner}_" if hasOwner
    output.push "with #{device.user}" if unavailable

    output.join ' '

  SUCCESS_CREATE_DEVICE: (device) -> "Success adding `#{device.id}` (`#{device.model}`)!"

  ERROR_GET_DEVICE: (id) -> "Device not found for id `#{id}`"

  # got-devices
  ERROR_DEVICE_OWNED: (device) -> "It's already with you... o.O"
  ERROR_DEVICE_UNAVAILABLE: (device) -> "Oops, someone else has it. Try talking with #{device.user}"
  SUCCESS_GOT_DEVICE: (device) -> "`#{device.id}` (`#{device.model}`) is yours!"

  SUCCESS_DEVICE_UPDATE: (device, field, newValue) -> "`#{device.id}` (`#{field}: #{newValue}`) updated!"

  SUCCESS_RETURN_DEVICE: (device) -> "`#{device.id}` (`#{device.model}`) is back to the pool!"
  SUCCESS_RETURN_ALL_DEVICES: "All devices you had are back to the pool!"

  SUCCESS_REMOVE_DEVICE: (device) -> "`#{device.id}` (`#{device.model}`) removed"

  SUCCESS_REMOVE_INVALID_DEVICE: (device) -> "Invalid device (`#{device.model}`) removed"
  SUCCESS_NO_INVALID_DEVICE: "No invalid device"

  SUCCESS_STEAL_DEVICE: (device, oldUser) -> "Sticky fingers! You've stolen `#{device.id}` (`#{device.model}`) from #{oldUser}! :parrot:"

  SUCCESS_NO_DEVICES_FORGOTTEN: "Congrats!!! U've returned all devices! But should see a doctor... your head is not as it used to be"
  SUCCESS_HAS_DEVICES_FORGOTTEN: "Hey buddy! U owe me devices!"
  DEVICE_FORGOTTEN: (device) ->
    output = []

    output.push "id: `#{device.id}`"
    output.push "name: `#{device.model}`"
    output.push "version: `#{device.version}`"

    output.join ' '
