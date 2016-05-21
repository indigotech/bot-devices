module.exports = (configHelper) ->

  result =
    slackToken: process.env.SLACK_TOKEN # Add a bot at https://my.slack.com/services/new/bot and copy the token here.
    devicesEndpoint: process.env.SERVER_URL + "/devices"

  return result
