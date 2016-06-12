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
configHelper = require('tq1-helpers').config_helper

# DEPS
async   = require('async')
config  = require('../src/config')(configHelper)


router_module = require('../src/router')


# TQT
awesome_module = require './awesome'
awesome = awesome_module async, config, router_module


module.exports = (robot) ->

robot.respond /\b(-device)\b/i, (msg) ->
  awesome.execute msg.message.text, msg.user, (err, result) ->
    if err == 'error'
      msg.send "Something went wrong! :scream:"
    else if err
      msg.send err
    else
      msg.send result
