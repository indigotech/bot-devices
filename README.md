# Awesome Bot

Bot to manage devices through Slack's chat interface.

(Based on [slack's example](https://github.com/slackhq/node-slack-client/blob/master/examples/simple_reverse.coffee) code)

## Configure

This bot runs using [node-foreman](https://github.com/strongloop/node-foreman), so to set up you local environment variables, create .env file with the following values

- `SLACK_TOKEN`: Token to be used to connect to Slack. Check https://my.slack.com/services/new/bot to create/get one.

_tip:_ You can use [`.env.example`](.env.example) file as a template for the config

## Running

- Tested only on node.js `v0.12.0`

- Execute:
```
$ npm install
$ npm start
```

## Testing

```
$ npm test
```
## Pending
- [ ] Change SLACK TOKEN to the Taqtile's Slack Token
- [ ] Decide how/where to host it
- [ ] Create a BACKEND application with the same fuction from jsonServer(CRUD e filter)
- [ ] Create a DB using the same struture from db.json
- [ ] import the data from db.json

