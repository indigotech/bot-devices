module.exports = (messages) ->

  displayHelp = (user, callback) ->
    helpText = [
      "Yo #{user.name}! How r u doin, bro? Im here to help you find and manage devices. For example, an iPhone 6 Plus iOS 9.2 64 GB White. \n",
      "You can type \`device-want\` followed by any term of what you want to find (e.g., \*device-want iPhone\* or \*device-want iOS\*). \n",
      "Or, you can just ask for the availability of all devices by typing \`device-want all\`. When you take a device, ",
      "remember to tell others by typing \`device-got\` followed by its id. When you return a device, ",
      "tell your bros too: type \`device-back\` followed by its id.\n",
      "Now, if u have sticky fingers u can steal a device from your bro by typiyng \`device-steal\` + id.\n",
      "You can also register a new device or delete an existing one by typing \`device-register\` or \`device-delete\`, followed by its full information. Remember, bro, You will need: \*id\*, \*model\*, \*os\*, \*version\*, \*notes\*, \*owner\* (e.g., device-register Blackberry 1, Blackberry Curve, blackberry, 7.0.0,  Bundle 2055 black, your name)."
    ].join '\n'

    callback null, helpText

  execute = (args, user, brain, callback) ->
    displayHelp user, callback

  execute: execute
