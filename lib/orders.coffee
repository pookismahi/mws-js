###
# Orders API requests and definitions for Amazon's MWS web services.
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
  FulfillmentChannels: ->
    new mws.Enum [
      'AFN'
      'MFN'
    ]
  OrderStatuses: ->
    new mws.Enum [
      'Pending'
      'Unshipped'
      'PartiallyShipped'
      'Shipped'
      'Canceled'
      'Unfulfillable'
    ]
  PaymentMethods: ->
    new mws.Enum [
      'COD'
      'CVS'
      'Other'
    ]

###
# Contains brief definitions for unique data type values.
# Can be used to explain input/output to users via tooltips, for example
# @type {Object}
###

exports.types =
  FulfillmentChannel:
    'AFN': 'Amazon Fulfillment Network'
    'MFN': 'Merchant\'s Fulfillment Network'
  OrderStatus:
    'Pending': 'Order placed but payment not yet authorized. Not ready for shipment.'
    'Unshipped': 'Payment has been authorized. Order ready for shipment, but no items shipped yet. Implies PartiallyShipped.'
    'PartiallyShipped': 'One or more (but not all) items have been shipped. Implies Unshipped.'
    'Shipped': 'All items in the order have been shipped.'
    'Canceled': 'The order was canceled.'
    'Unfulfillable': 'The order cannot be fulfilled. Applies only to Amazon-fulfilled orders not placed on Amazon.'
  PaymentMethod:
    'COD': 'Cash on delivery'
    'CVS': 'Convenience store payment'
    'Other': 'Any payment method other than COD or CVS'
  ServiceStatus:
    'GREEN': 'The service is operating normally.'
    'GREEN_I': 'The service is operating normally + additional info provided'
    'YELLOW': 'The service is experiencing higher than normal error rates or degraded performance.'
    'RED': 'The service is unabailable or experiencing extremely high error rates.'
  ShipServiceLevelCategory:
    'Expedited': 'Expedited shipping'
    'NextDay': 'Overnight shipping'
    'SecondDay': 'Second-day shipping'
    'Standard': 'Standard shipping'

###
# A collection of currently supported request constructors. Once created and 
# configured, the returned requests can be passed to an mws client `invoke` call
# @type {Object}
###

exports.requests =
  GetServiceStatus: ->
    new OrdersRequest 'GetServiceStatus'
  ListOrders: ->
    new OrdersRequest 'ListOrders',
      CreatedAfter: { name: 'CreatedAfter', type: 'Timestamp' }
      CreatedBefore: { name: 'CreatedBefore', type: 'Timestamp' }
      LastUpdatedAfter: { name: 'LastUpdatedAfter', type: 'Timestamp' }
      MarketplaceId: { name: 'MarketplaceId.Id', list: true, required: true }
      LastUpdatedBefore: { name: 'LastUpdatedBefore', type: 'Timestamp' }
      OrderStatus: { name: 'OrderStatus.Status', type: 'orders.OrderStatuses', list: true }
      FulfillmentChannel: { name: 'FulfillmentChannel.Channel', type: 'orders.FulfillmentChannels', list: true }
      PaymentMethod: { name: 'PaymentMethod.Method', type: 'orders.PaymentMethods', list: true }
      BuyerEmail: { name: 'BuyerEmail' }
      SellerOrderId: { name: 'SellerOrderId' }
      MaxResultsPerPage: { name: 'MaxResultsPerPage' }

  ListOrdersByNextToken: ->
    new OrdersRequest 'ListOrdersByNextToken', 
      NextToken: { name: 'NextToken', required: true }
  GetOrder: ->
    new OrdersRequest 'GetOrder', 
      AmazonOrderId: { name: 'AmazonOrderId.Id', required: true, list: true }
  ListOrderItems: ->
    new OrdersRequest 'ListOrderItems', 
      AmazonOrderId: { name: 'AmazonOrderId', required: true }
  ListOrderItemsByNextToken: ->
    new OrdersRequest 'ListOrderItemsByNextToken', 
      NextToken: { name: 'NextToken', required: true }

###
# Construct an Orders API request for mws.Client.invoke()
# 
# @param {String} action Action parameter of request
# @param {Object} params Schemas for all supported parameters
###
class OrdersRequest extends mws.Request
  constructor: (action, params = {}) ->
    super 
      name: 'Orders'
      group: 'Order Retrieval'
      path: '/Orders/2011-01-01'
      version: '2011-01-01'
      action: action
      params: params
