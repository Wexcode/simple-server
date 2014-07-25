express = require 'express'
cookie  = require 'cookie'

PORT     = 2000
sessions = {}

app = express()
app.set 'view engine', 'jade'

setSession = (req, res, next) ->
  req.sid = Math.random()
  sessions[req.sid] = Date.now()
  res.cookie 'sid', req.sid
  next()

getSession = (req, res, next) ->
  return next() if req.sid

  if c = req.headers.cookie
    req.sid = cookie.parse(c).sid
  next()

app.get '/new', setSession

app.get '*', getSession, (req, res) ->
  res.render 'index', { sid: req.sid, sessions }

app.listen PORT, ->
  console.log "Express server listening on port #{PORT}"
