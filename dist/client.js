// Generated by CoffeeScript 2.0.2
(function() {
  var AmazonMwsClient, _, crypto, https, qs, request, tls, xml2js;

  qs = require('querystring');

  https = require('https');

  crypto = require('crypto');

  tls = require('tls');

  xml2js = require('xml2js');

  request = require('request');

  _ = require('underscore');

  /*
  Constructor for the main MWS client interface used to make api calls and
  various data structures to encapsulate MWS requests, definitions, etc.

  @param {String} accessKeyId     Id for your secret Access Key (required)
  @param {String} secretAccessKey Secret Access Key provided by Amazon (required)
  @param {String} merchantId      Aka SellerId, provided by Amazon (required)
  @param {Object} options         Additional configuration options for this instance
  */
  module.exports = AmazonMwsClient = class AmazonMwsClient {
    constructor(accessKeyId, secretAccessKey, merchantId, {
        host: host,
        appLanguage: appLanguage,
        appVersion: appVersion,
        appName: appName,
        credentials
      }) {
      var createCredentials;
      this.accessKeyId = accessKeyId;
      this.secretAccessKey = secretAccessKey;
      this.merchantId = merchantId;
      this.host = host;
      this.appLanguage = appLanguage;
      this.appVersion = appVersion;
      this.appName = appName;
      // handle the differences between node v10 and v12
      createCredentials = tls.createSecureContext || crypto.createCredentials;
      if (this.host == null) {
        this.host = "mws.amazonservices.com";
      }
      this.creds = createCredentials(credentials || {});
      if (this.appName == null) {
        this.appName = "mws-js";
      }
      if (this.appVersion == null) {
        this.appVersion = "0.1.0";
      }
      if (this.appLanguage == null) {
        this.appLanguage = "JavaScript";
      }
    }

    /*
    The method used to invoke calls against MWS Endpoints. Recommended usage is
    through the invoke wrapper method when the api call you're invoking has a
    request defined in one of the submodules. However, you can use call() manually
    when a lower level of control is necessary (custom or new requests, for example).

    @param  {Object}   api      Settings object unique to each API submodule
    @param  {String}   action   Api `Action`, such as GetServiceStatus or GetOrder
    @param  {Object}   query    Any parameters belonging to the current action
    @param  {Function} callback Callback function to send any results recieved
    */
    call(api, action, query, callback) {
      var requestOpts, upload;
      if ((this.secretAccessKey == null) || (this.accessKeyId == null) || (this.merchantId == null)) {
        throw "accessKeyId, secretAccessKey, and merchantId must be set";
      }
      requestOpts = {
        method: "POST",
        uri: `https://${this.host}${api.path}`
      };
      // Check if we're dealing with a file (such as a feed) upload
      upload = query._BODY_ != null;
      if (upload) {
        requestOpts.body = query._BODY_;
        requestOpts.headers = {
          "Content-Type": query._FORMAT_,
          "Content-MD5": crypto.createHash("md5").update(query._BODY_).digest("base64")
        };
        delete query._BODY_;
        delete query._FORMAT_;
      }
      
      // Add required parameters and sign the query
      query["Action"] = action;
      query["Version"] = api.version;
      query["Timestamp"] = (new Date()).toISOString();
      query["AWSAccessKeyId"] = this.accessKeyId;
      if (api.legacy) {
        query["Merchant"] = this.merchantId;
      } else {
        query["SellerId"] = this.merchantId;
      }
      query = this.sign(api.path, query);
      if (!upload) {
        requestOpts.form = query;
      } else {
        requestOpts.qs = query;
      }
      
      // Make the initial request and define callbacks
      return request(requestOpts, function(err, response, data) {
        if (err) {
          console.log("error: " + err);
          console.log("error: " + response.statusCode);
          return;
        }
        
        // if the first character is <, assume we've got some xml to parse
        if (data.charAt(0) === '<') {
          return xml2js.parseString(data, {
            explicitArray: false
          }, function(err, result) {
            if (err != null) {
              
              // Throw an error if there was a problem reported
              throw err.Code + ': ' + err.Message;
            }
            return callback(result);
          });
        } else {
          return callback(data);
        }
      });
    }

    /*
    Calculates the HmacSHA256 signature and appends it with additional signature
    parameters to the provided query object.

    @param  {String} path  Path of API call (used to build the string to sign)
    @param  {Object} query Any non-signature parameters that will be sent
    @return {Object}       Finalized object used to build query string of request
    */
    sign(path, query) {
      var sorted, stringToSign;
      
      // Configure the query signature method/version
      query["SignatureMethod"] = "HmacSHA256";
      query["SignatureVersion"] = "2";
      
      // Copy query keys, sort them, then copy over the values
      sorted = _.reduce(_.keys(query).sort(), function(m, k) {
        m[k] = query[k];
        return m;
      }, {});
      stringToSign = ["POST", this.host, path, qs.stringify(sorted)].join("\n").replace(/[!'()*]/g, function(c) {
        return '%' + c.charCodeAt(0).toString(16).toUpperCase();
      });
      query["Signature"] = crypto.createHmac("sha256", this.secretAccessKey).update(stringToSign, "utf8").digest("base64");
      return query;
    }

    /*
    Suggested method for invoking a pre-defined mws request object.

    @param  {Object}   request  An instance of AmazonMwsRequest with params, etc.
    @param  {Function} callback Callback function used to process results/errors
    */
    invoke(request, callback) {
      return this.call(request.api, request.action, request.query(), callback);
    }

  };

}).call(this);
