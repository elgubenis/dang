requireHelper = require './require_helper'
Dang = requireHelper 'index.js'

assert = require 'assert'

describe 'module behavior', ->
  store = null
  it 'should be able to create a store', ->
    store = new Dang
    assert.equal typeof(store.add), 'function'
    assert.equal typeof(store.get), 'function'

  describe 'store behavior', ->
    handle = null
    got = null

    it 'should be able to add data', ->
      handle = store.add name: 'a', value: 1
      store.add name: 'b', value: 2
      store.add name: 'c', value: 100
      assert.equal store.stack.length, 3

    it 'should also be able to add data in another fashion', ->
      store.add 'd', 100, 'b+c'
      assert.equal store.get('d').value(), 100

    it 'should be able to retrieve data', ->
      assert.equal handle.value(), 1

    it 'should be able to get data by name', ->
      got = store.get 'a'
      assert.equal got.value(), 1

    describe 'data behavior', ->
      it 'should be able to set values', ->
        handle.value 2
        assert.equal handle.value(), 2

      it 'should be able to set an expression property', ->
        got.set('expression', 'b+c')
        assert.equal got.get('expression'), 'b+c'

      it 'should be able to evaluate itself when its dependents change', (done) ->
        got.on 'change:value', ->
          assert got.value(), 200
          done()
        store.get('b').value(100)

describe 'standalone test', ->
  it 'should create a few datas and evaluate correctly', (done) ->
    store = new Dang

    store.add name: 'm', value: 1
    store.add name: 'c', value: 299792458
    store.add name: 'E', expression: 'm*c*c'

    store.get('E').on 'change:value', ->
      assert.equal store.get('E').value(), 89875517873681760
      done()

describe 'using result', ->
  it 'should be possible to evaluate ifs', (done) ->
    store = new Dang()

    store.add 'a', 99
    store.add 'b', 99
    store.add 'result', 0, 'if (this.a) { result(0); }'

    store.get('result').on 'change:value', ->
      done()