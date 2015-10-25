[![Build Status](https://travis-ci.org/elgubenis/varlidator.svg)](https://travis-ci.org/elgubenis/varlidator)
[![Code Climate](https://codeclimate.com/github/elgubenis/dang/badges/gpa.svg)](https://codeclimate.com/github/elgubenis/dang)
[![Test Coverage](https://codeclimate.com/github/elgubenis/dang/badges/coverage.svg)](https://codeclimate.com/github/elgubenis/dang/coverage)

# Dang
Data driven events, expression evaluation and more.


### Install
```sh
npm install dang --save
```

### Usage
```js
var store = new Dang();

store.add({ name: 'm', value: 1 });
store.add({ name: 'c', value: 299792458 });
store.add({ name: 'E', expression: 'm*c*c' });

store.get('E').on 'change:value', ->
    console.log 'E=mc2 is ', store.get('E').value()
```

### How to develop
```sh
npm install
grunt
```

### How to build (before publishing)
```sh
npm install
grunt build
```