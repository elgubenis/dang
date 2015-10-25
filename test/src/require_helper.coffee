module.exports = (path) ->
  return require((__dirname + '/../coverage/instrument/build/') + path)