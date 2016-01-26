# Awesome Bot

Bot to manage devices through Slack's chat interface.

Original source at [guilhermemamprin/awesome-bot](https://github.com/guilhermemamprin/awesome-bot), project was develop for Taqtile's Hackathon '16

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
- [ ] Decide how/where to host it - Heroku?
- [ ] Create a BACKEND application with the same function from jsonServer - Use Parser.com?
- [ ] Create a DB using the same struture from db.json - Use Parser.com?
- [ ] import the data from db.json
