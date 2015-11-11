# TQT bot

Bot to access [tqt](https://github.com/indigotech/tqt) remotely on users' behalf.

(Based on [slack's example](https://github.com/slackhq/node-slack-client/blob/master/examples/simple_reverse.coffee) code)

## Running

- Tested only on node.js `v0.12.0`

- Execute:
```
$ npm install
$ SLACK_TOKEN=<insert_bot_token_here> node index.js
```

## Usage example

![Usage example](assets/screenshot.png)

## Pending

- [ ] Decide how/where to host it (machine needs to have TQT CLI installed and properly configured)
- [ ] Create github user to exec all github related commands
- [ ] Review commands that are allowed and make sense for the bot
- [ ] local tests showed `exec` to be really slow to respond, needs improvement
