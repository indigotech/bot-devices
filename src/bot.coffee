Slack   = require('slack-client')

# DEPS
_ = require('lodash')
async   = require('async')
request = require('request')
config  = require('src/config')

# TQT
devices = require('src/devices')(request, config)
awesome = require('src/awesome')(async, _, devices)

module.exports = (callback) ->

  slack = new Slack(config.slack.token, config.slack.autoReconnect, config.slack.autoMark)

  slack.on 'open', ->
    channels = []
    groups = []
    unreads = slack.getUnreadCount()

    # Get all the channels that bot is a member of
    channels = ("##{channel.name}" for id, channel of slack.channels when channel.is_member)

    # Get all groups that are open and not archived
    groups = (group.name for id, group of slack.groups when group.is_open and not group.is_archived)

    console.log "Welcome to Slack. You are @#{slack.self.name} of #{slack.team.name}"
    console.log 'You are in: ' + channels.join(', ')
    console.log 'As well as: ' + groups.join(', ')

    # messages = if unreads is 1 then 'message' else 'messages'
    #
    # console.log "You have #{unreads} unread #{messages}"


  slack.on 'message', (message) ->
    channel = slack.getChannelGroupOrDMByID(message.channel)
    user = slack.getUserByID(message.user)
    response = ''

    {type, ts, text} = message

    channelName = if channel?.is_channel then '#' else ''
    channelName = channelName + if channel then channel.name else 'UNKNOWN_CHANNEL'

    userName = if user?.name? then "@#{user.name}" else "UNKNOWN_USER"

    # console.log """
    #   Received: #{type} #{channelName} #{userName} #{ts} "#{text}"
    # """

    # Respond to messages with the reverse of the text received.
    if type is 'message' and channel?

      channel.send "Got it! Just a sec..."

      awesome.execute text, user, (err, result) ->
        if err == 'error'
          channel.send "Something went wrong! :scream:"
        else if err
          channel.send err
        else
          channel.send result

  slack.on 'error', (error) ->
    console.error "Error: #{JSON.stringify(error)}"


  slack.login()

  return callback()
