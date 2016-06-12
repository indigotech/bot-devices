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
async   = require('async')

router_module = require('../src/router')


# TQT
awesome_module = require './awesome'
awesome = awesome_module async, router_module


module.exports = (robot) ->
  robot.respond /.*-device.*\b/i, (msg) ->
    console.log msg
    awesome.execute msg.message.text, msg.user, (err, result) ->
      if err == 'error'
        msg.send "Something went wrong! :scream:"
      else if err
        msg.send err
      else
        msg.send result
