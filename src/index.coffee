_ = require 'lodash'

((factory) ->
  root = typeof self is 'object' and self.self is self and self or typeof global is 'object' and global.global is global and global
  ###
    istanbul ignore next
  ###
  if typeof define == 'function' and define.amd
    define [
      'exports'
    ], (exports) ->
      root.Dang = factory()
      return
  else if typeof exports != 'undefined'
    module.exports = factory()
  else
    root.Dang = factory()
)(->

  class Dang
    constructor: ->
      @stack = []
      return @
    # add data to a dang-store
    add: ->
      return add.apply(@stack, arguments)
    # get data from a dang-store
    get: (name) ->
      for data in @stack
        if data.get('name') is name
          return data

  return Dang
)

Data = require './data'

# Dang-store add method
add = (name,  value, expression) ->
  if typeof(name) is 'object'
    json = name
  else
    json =
      name: name
      value: value or undefined
      expression: expression or undefined

  # create a new data from a json object
  data = new Data(json)
  # attach dang store to data, for coupling
  data.stack = @
  # attach listeners to data
  data.attachListeners(@)
  # add data to dang-store array
  @push data
  # return data
  return _.last @