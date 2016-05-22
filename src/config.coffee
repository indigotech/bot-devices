config = 
  server:
    devicesUrl: process.env.SERVER_URL + process.env.DEVICES_ENDPOINT
  slack:
    token: process.env.SLACK_TOKEN # Add a bot at https://my.slack.com/services/new/bot and copy the token here.
    autoReconnect: true
    autoMark: true

module.exports = config