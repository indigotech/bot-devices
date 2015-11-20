# TQT bot

Bot to access [tqt](https://github.com/indigotech/tqt) remotely on users' behalf.

(Based on [slack's example](https://github.com/slackhq/node-slack-client/blob/master/examples/simple_reverse.coffee) code)

## Configure

This bot runs using [node-foreman](https://github.com/strongloop/node-foreman), so to set up you local environment variables, create .env file with the following values

- `TQT_PATH`: Absolute path to `tqt` bin on machine running the bot. Default: '/bin/local/tqt'
- `SLACK_TOKEN`: Token to be used to connect to Slack. Check https://my.slack.com/services/new/bot to create/get one.

_tip:_ You can use [`.env.example`](.env.example) file as a template for the config

## Running

- Tested only on node.js `v0.12.0`

- Execute:
```
$ npm install
$ npm start
```

## Usage example

![Usage example](assets/screenshot.png)

## Pending

- [ ] Decide how/where to host it (machine needs to have TQT CLI installed and properly configured)
- [ ] Create github user to exec all github related commands
- [ ] Review commands that are allowed and make sense for the bot
- [x] ~~local tests showed `exec` to be really slow to respond, needs improvement~~ Using `childProcess.execFile` to avoid command injection
