###
# Products API requests and definitions for Amazon's MWS web services.
# For information on using, please see examples folder.
# 
# @author Robert Saunders
###

mws = require './mws'

###
# Ojects to represent enum collections used by some request(s)
# @type {Object}
###
exports.enums = 
  ItemConditions: ->
    new mws.Enum [ 'New', 'Used', 'Collectible', 'Refurbished', 'Club' ]

###
# Contains brief definitions for unique data type values.
# Can be used to explain input/output to users via tooltips, for example
# @type {Object}
###
exports.types =
  CompetitivePriceId:
    '1': 'New Buy Box Price'
    '2': 'Used Buy Box Price'
  ServiceStatus:
    'GREEN': 'The service is operating normally.'
    'GREEN_I': 'The service is operating normally + additional info provided'
    'YELLOW': 'The service is experiencing higher than normal error rates or degraded performance.'
    'RED': 'The service is unabailable or experiencing extremely high error rates.'

###
# A collection of currently supported request constructors. Once created and 
# configured, the returned requests can be passed to an mws client `invoke` call
# @type {Object}
###

exports.requests =
  GetServiceStatus: ->
    new ProductsRequest 'GetServiceStatus'
  ListMatchingProducts: ->
    new ProductsRequest 'ListMatchingProducts',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      Query: { name: 'Query', required: true }
      QueryContextId: { name: 'QueryContextId' } 
  GetMatchingProduct: ->
    new ProductsRequest 'GetMatchingProduct',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      ASINList: { name: 'ASINList.ASIN', list: true, required: true }
  GetMatchingProductForId: ->
    new ProductsRequest 'GetMatchingProductForId',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      IdType: { name: 'IdType', required: true }
      IdList: { name: 'IdList.Id', list: true, required: true }
  GetCompetitivePricingForSKU: ->
    new ProductsRequest 'GetCompetitivePricingForSKU',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      SellerSKUList: { name: 'SellerSKUList.SellerSKU', list: true, required: true }
  GetCompetitivePricingForASIN: ->
    new ProductsRequest 'GetCompetitivePricingForASIN',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      ASINList: { name: 'ASINList.ASIN', list: true, required: true }
  GetLowestOfferListingsForSKU: ->
    new ProductsRequest 'GetLowestOfferListingsForSKU',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      ItemCondition: { name: 'ItemCondition' }
      SellerSKUList: { name: 'SellerSKUList.SellerSKU', list: true, required: true }
  GetLowestOfferListingsForASIN: ->
    new ProductsRequest 'GetLowestOfferListingsForASIN',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      ItemCondition: { name: 'ItemCondition' }
      ASINList: { name: 'ASINList.ASIN', list: true, required: true }
  GetProductCategoriesForSKU: ->
    new ProductsRequest 'GetProductCategoriesForSKU',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      SellerSKU: { name: 'SellerSKU', required: true }
  GetProductCategoriesForASIN: ->
    new ProductsRequest 'GetProductCategoriesForASIN',
      MarketplaceId: { name: 'MarketplaceId', required: true }
      ASIN: { name: 'ASIN', required: true }

###
# Construct a Products API request for using with mws.Client.invoke()
# 
# @param {String} action Action parameter of request
# @param {Object} params Schemas for all supported parameters
###
class ProductsRequest extends mws.Request
  constructor: (action, params = {}) ->
    super 
      name: 'Products'
      group: 'Products'
      path: '/Products/2011-10-01'
      version: '2011-10-01'
      action: action
      params: params
