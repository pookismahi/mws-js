###
# Contructor for objects used to represent enumeration states. Useful
# when you need to make programmatic updates to an enumerated data type or
# wish to encapsulate enum states in a handy, re-usable variable.
# 
# @param {Array} choices An array of any possible values (choices)
###

exports.Enum = class EnumType
  constructor: (@_choices) ->
    for choice of _choices
      @[choices[choice]] = false

  ###
  # Enable one or more choices (accepts a variable number of arguments)
  # @return {Object} Current instance of EnumType for chaining
  ###
  enable: ->
    for arg of arguments
      @[arguments[arg]] = true
    this

  ###
  # Disable one or more choices (accepts a variable number of arguments)
  # @return {Object} Current instance of EnumType for chaining
  ###
  disable: ->
    for arg of arguments
      @[arguments[arg]] = false
    this


  ###
  # Toggles one or more choices (accepts a variable number of arguments)
  # @return {Object} Current instance of EnumType for chaining
  ###
  toggle: ->
    for arg of arguments
      @[arguments[arg]] = !@[arguments[arg]]
    this

  ###
  # Return all possible values without regard to current state
  # @return {Array} Choices passed to EnumType constructor
  ###
  all: ->
    @_choices

  ###
  # Return all enabled choices as an array (used to set list params, usually)
  # @return {Array} Choice values for each choice set to true 
  ###
  values: ->
    value = []
    for choice of @_choices
      if @[@_choices[choice]] == true
        value.push @_choices[choice]
    value

exports.Client = require './client'
exports.Request = require './request'
exports.Products = require './products'
exports.Feeds = require './feeds'
exports.Orders = require './orders'
exports.Reports = require './reports'
exports.FBA = require './fba'

