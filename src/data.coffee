EventEmitter = require 'eventemitter3'
_ = require 'lodash'

class Data extends EventEmitter
  constructor: (json) ->
    @properties = {}
    if json.value
      @value(json.value)
    delete json.value
    _.assign @properties, json
  get: (name) ->
    return @properties[name] or undefined
  value: (value) ->
    if value or value is 0
      @val = value
      @emit 'change:value'
    return @val
  set: (name, value) ->
    @properties[name] = value
    if name is 'expression'
      @attachListeners(@stack)
    return
  evaluate: ->
    expression = @get('expression')
    if expression
      if expression.indexOf('return') is -1
        expression = 'return ' + expression
      myEval.call(@stack, expression, (result) =>
        @value(result)
      )
  attachListeners: (originalStack) ->
    expression = @get('expression')

    # remove myself from the stack
    stack = originalStack.filter (item) =>
      return item.get('name') isnt @get('name')

    # if the data object has an expression (depends on others)
    if expression
      # go through the whole stack and check every name
      # if a name is inside the expression, its a dependency of the current data
      for foreign in stack
        if expression.indexOf(foreign.get('name')) > -1
          @evaluate()
          # console.log foreign.get('name'), 'is a dependency to', @get('name')
          # this foreign-data is a dependency of data, listen to its changes
          # and if it does change, evaluate the local-data's expression
          foreign.on 'change:value', =>
            @evaluate()

    return

module.exports = Data

createScope = (stack) ->
  scope = {}
  for data in stack
    val = data.value()
    scope[data.get('name')] = val
  return scope

myEval = _.debounce (exp, cb) ->
  scope = createScope(@)
  x = (new Function 'with(this) { ' + exp + ' }').call(scope)
  cb(x)
, 0


