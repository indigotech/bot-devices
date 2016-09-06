# Description:
#   Device bot
#
# Dependencies:
#
# Configuration:
#   SLACK_TOKEN
#
# Commands:
#   device bot - Taqtile Device manager bot - Use help-device to know more
#
# Author:
#   Taqtile

# Config helpers

# DEPS
async   = require 'async'

# Awesome bot
_ = require 'lodash'
deviceResource = require('./device.resource') _
messages = require './messages'

awesome = require('./awesome') async, deviceResource, messages

module.exports = (robot) ->
  robot.respond /.*device-.*\b/i, (msg) ->
    awesome.execute msg, robot, (err, result) ->
      if err == 'error'
        msg.send "Something went wrong! :scream:"
      else if err
        msg.send err
      else
        if result
          msg.send result
