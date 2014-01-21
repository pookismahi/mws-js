qs = require("querystring")
https = require("https")
crypto = require("crypto")
xml2js = require("xml2js")
request = require("request")
_ = require("underscore")

###
Constructor for the main MWS client interface used to make api calls and
various data structures to encapsulate MWS requests, definitions, etc.

@param {String} accessKeyId     Id for your secret Access Key (required)
@param {String} secretAccessKey Secret Access Key provided by Amazon (required)
@param {String} merchantId      Aka SellerId, provided by Amazon (required)
@param {Object} options         Additional configuration options for this instance
###
exports.Client = class AmazonMwsClient
  constructor: (accessKeyId, secretAccessKey, merchantId, options) ->
    @host = options.host or "mws.amazonservices.com"
    @creds = crypto.createCredentials(options.creds or {})
    @appName = options.appName or "mws-js"
    @appVersion = options.appVersion or "0.1.0"
    @appLanguage = options.appLanguage or "JavaScript"
    @accessKeyId = accessKeyId or null
    @secretAccessKey = secretAccessKey or null
    @merchantId = merchantId or null

  ###
  The method used to invoke calls against MWS Endpoints. Recommended usage is
  through the invoke wrapper method when the api call you're invoking has a
  request defined in one of the submodules. However, you can use call() manually
  when a lower level of control is necessary (custom or new requests, for example).

  @param  {Object}   api      Settings object unique to each API submodule
  @param  {String}   action   Api `Action`, such as GetServiceStatus or GetOrder
  @param  {Object}   query    Any parameters belonging to the current action
  @param  {Function} callback Callback function to send any results recieved
  ###
  call: (api, action, query, callback) ->
    throw ("accessKeyId, secretAccessKey, and merchantId must be set") if not @secretAccessKey? or not @accessKeyId? or not @merchantId?
    requestOpts =
      method: "POST"
      uri: "https://" + @host + api.path

  
    # Check if we're dealing with a file (such as a feed) upload
    if api.upload
      requestOpts.body = query._BODY_
      requestOpts.headers =
        "Content-Type": query._FORMAT_
        "Content-MD5": crypto.createHash("md5").update(query._BODY_).digest("base64")

      delete query._BODY_
      delete query._FORMAT_
    
    # Add required parameters and sign the query
    query["Action"] = action
    query["Version"] = api.version
    query["Timestamp"] = (new Date()).toISOString()
    query["AWSAccessKeyId"] = @accessKeyId
    if api.legacy
      query["Merchant"] = @merchantId
    else
      query["SellerId"] = @merchantId
    query = @sign(api.path, query)
    unless api.upload
      requestOpts.form = query
    else
      requestOpts.qs = query
    
    # Make the initial request and define callbacks
    request requestOpts, (err, response, data) ->
      if err
        console.log "error: " + err
        console.log "error: " + response.statusCode
        return
      
      #console.log(data);
      if data.slice(0, 5) is "<?xml"
        xml2js.parseString data, explicitArray: false, (err, result) ->
          
          # Throw an error if there was a problem reported
          throw (err.Code + ": " + err.Message) if err?
          callback result

      else
        callback data



  ###
  Calculates the HmacSHA256 signature and appends it with additional signature
  parameters to the provided query object.

  @param  {String} path  Path of API call (used to build the string to sign)
  @param  {Object} query Any non-signature parameters that will be sent
  @return {Object}       Finalized object used to build query string of request
  ###
  sign: (path, query) ->
  
    # Configure the query signature method/version
    query["SignatureMethod"] = "HmacSHA256"
    query["SignatureVersion"] = "2"
    
    # Copy query keys, sort them, then copy over the values
    sorted = _.reduce(_.keys(query).sort(), (m, k) ->
      m[k] = query[k]
      m
    , {})
    stringToSign = ["POST", @host, path, qs.stringify(sorted)].join("\n")
    query["Signature"] = crypto.createHmac("sha256", @secretAccessKey).update(stringToSign, "utf8").digest("base64")
    query


  ###
  Suggested method for invoking a pre-defined mws request object.

  @param  {Object}   request  An instance of AmazonMwsRequest with params, etc.
  @param  {Function} callback Callback function used to process results/errors
  ###
  invoke: (request, callback) ->
    @call request.api, request.action, request.query(), callback


