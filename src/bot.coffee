# This is a simple example of how to use the slack-client module in CoffeeScript. It creates a
# bot that responds to all messages in all channels it is in with a reversed
# string of the text received.
#
# To run, copy your token below, then, from the project root directory:
#
# To run the script directly
#    npm install
#    node_modules/coffee-script/bin/coffee examples/simple_reverse.coffee
#
# If you want to look at / run / modify the compiled javascript
#    npm install
#    node_modules/coffee-script/bin/coffee -c examples/simple_reverse.coffee
#    cd examples
#    node simple_reverse.js
#

Slack   = require('slack-client')
exec    = require('child_process').exec

module.exports = (callback) ->

  token = process.env.SLACK_TOKEN # Add a bot at https://my.slack.com/services/new/bot and copy the token here.
  autoReconnect = true
  autoMark = true

  allowedArgs = ['help', 'version', 'config', 'github', 'google_drive']

  slack = new Slack(token, autoReconnect, autoMark)

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

    messages = if unreads is 1 then 'message' else 'messages'

    console.log "You have #{unreads} unread #{messages}"


  slack.on 'message', (message) ->
    channel = slack.getChannelGroupOrDMByID(message.channel)
    user = slack.getUserByID(message.user)
    response = ''

    {type, ts, text} = message

    channelName = if channel?.is_channel then '#' else ''
    channelName = channelName + if channel then channel.name else 'UNKNOWN_CHANNEL'

    userName = if user?.name? then "@#{user.name}" else "UNKNOWN_USER"

    console.log """
      Received: #{type} #{channelName} #{userName} #{ts} "#{text}"
    """

    # Respond to messages with the reverse of the text received.
    if type is 'message' and text?.indexOf("tqt") is 0 and channel?

      args = text.split(' ')

      if args.length < 2
        channel.send "Missing arguments. Try using 'tqt help'"
      else if allowedArgs.indexOf(args[1]) < 0
        channel.send "Argumment not allowed. BOT current only supports the following arguments: `#{allowedArgs.join('`, `')}`"
      else
        command = text # ⚠️ ATTENTION!! Needs input sanitation before going to production
        channel.send "Ok, working on `$ #{command}`..."
        exec command,(error, stdout, stderr) ->
          channel.send """
            $ #{command}
            ```#{stdout}```
          """
          console.log """
            @#{slack.self.name} responded with "#{stdout}"
          """


  slack.on 'error', (error) ->
    console.error "Error: #{error}"


  slack.login()

  return callback()
