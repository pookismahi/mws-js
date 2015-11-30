_ = require 'underscore'

###
Constructor for general MWS request objects, wrapped by api submodules to keep
things DRY, yet familiar despite whichever api is being implemented.

@param {Object} options Settings to apply to new request instance.
###
module.exports = class AmazonMwsRequest
  constructor: (options) ->
    @api =
      path: options.path or "/"
      version: options.version or "2009-01-01"
      legacy: options.legacy or false

    @action = options.action or "GetServiceStatus"
    @params = options.params or {}

    @setMultiple options.props if options.props 

  ###
  Handles the casting, renaming, and setting of individual request params.

  @param {String} param Key of parameter (not ALWAYS the same as the param name!)
  @param {Mixed} value Value to assign to parameter
  @return {Object} Current instance to allow function chaining
  ###
  set: (param, value) ->
    p = @params[param]
    console.log "Invalid parameter #{param} in MWS request" if !p
    v = p.value = {}
    
    # Handles the actual setting based on type
    setValue = (name, val) ->
      switch p.type
        when 'Timestamp'
          v[name] = val.toISOString()
        when 'Boolean'
          v[name] = (if val then 'true' else 'false')
        when 'Complex'
          for subKey, subVal of val
            v["#{name}.#{subKey}"] = subVal
        else 
          v[name] = val
    
    # Lists need to be sequentially numbered and we take care of that here
    if p.list
      i = 0
      setValue p.name + ".1", value  if (typeof (value) is "string") or (typeof (value) is "number")
      if typeof (value) is "object"
        if Array.isArray(value)
          i = value.length - 1
          while i >= 0
            setValue p.name + "." + (i + 1), value[i]
            i--
        else
          for key of value
            setValue p.name + "." + (++i), value[key]
    else
      setValue p.name, value

    this

  setMultiple: (conf) ->
    _.each conf, (value, key) =>
      @set key, value
    this

  ###
  Builds a query object and checks for required parameters.

  @return {Object} KvP's of all provided parameters (used by invoke())
  ###
  query: ->
    q = {}
    for param of @params
      value = @params[param].value
      name = @params[param].name
      complex = (@params[param].type is "Complex")
      required = @params[param].required
      
      #console.log("v  " + value + "\nn " + name + "\nr " + required);
      throw "ERROR: Missing required parameter, #{name}!" if param.required and not value?

      for key, val of value
        q[key] = val
    q
