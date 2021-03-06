###
# Sellers API requests and definitions for Amazon's MWS web services.
# For information on using, please see examples folder.
# 
# @author Robert Saunders
###
mws = require './mws'

###
# Contains brief definitions for unique data type values.
# Can be used to explain input/output to users via tooltips, for example
# @type {Object}
###
exports.types =
  ServiceStatus:
    'GREEN':'The service is operating normally.'
    'GREEN_I':'The service is operating normally + additional info provided'
    'YELLOW':'The service is experiencing higher than normal error rates or degraded performance.'
    'RED':'The service is unabailable or experiencing extremely high error rates.' 

###
# A collection of currently supported request constructors. Once created and 
# configured, the returned requests can be passed to an mws client `invoke` call
# @type {Object}
###
exports.requests =
  GetServiceStatus: () ->
    new SellersRequest 'GetServiceStatus'

  ListMarketplaceParticipations: () ->
    new SellersRequest 'ListMarketplaceParticipations'

  ListMarketplaceParticipationsByNextToken: (props) ->
    new SellersRequest 'ListMarketplaceParticipationsByNextToken', props,
      NextToken: { name: 'NextToken', required: true }

###
# Construct a Sellers API request for mws.Client.invoke()
# 
# @param {String} action Action parameter of request
# @param {Object} params Schemas for all supported parameters
###
class SellersRequest extends mws.Request
  constructor: (action, props = {}, params = {}) ->
    super 
      name: 'Sellers'
      group: 'Sellers Retrieval'
      path: '/Sellers/2011-07-01'
      version: '2011-07-01'
      action: action
      params: params
      props: props

