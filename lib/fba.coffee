###
# Fulfillment API requests and definitions for Amazon's MWS web services.
# Currently untested, for the most part because I don't have an account
# with Fulfillment By Amazon services.
# 
# @author Robert Saunders
###

mws = require './mws'

###
# Ojects to represent enum collections used by some request(s)
# @type {Object}
###
exports.enums = 
  ResponseGroups: -> 
    new mws.Enum ['Basic', 'Detailed'] 

  ShippingSpeedCategories: -> 
    new mws.Enum ['Standard', 'Expedited', 'Priority']

  FulfillmentPolicies: -> 
    new mws.Enum ['FillOrKill', 'FillAll', 'FillAllAvailable']

###
# A collection of currently supported request constructors. Once created and 
# configured, the returned requests can be passed to an mws client `invoke` call
# @type {Object}
###
exports.requests =

  inbound:
    GetServiceStatus: (props) ->
      new FbaInboundRequest 'GetServiceStatus', props
    
    CreateInboundShipment: (props) ->
      new FbaInboundRequest 'CreateInboundShipment', props,
        ShipmentId: { name: 'ShipmentId', required: true}
        Shipmentname: { name: 'InboundShipmentHeader.ShipmentName', required: true }
        ShipFromName: { name: 'InboundShipmentHeader.ShipFromAddress.Name', required: true }
        ShipFromAddressLine1: { name: 'InboundShipmentHeader.ShipFromAddress.AddressLine1', required: true }
        ShipFromAddressLine2: { name: 'InboundShipmentHeader.ShipFromAddress.AddressLine2', required: false }
        ShipFromAddressCity: { name: 'InboundShipmentHeader.ShipFromAddress.City', required: true }
        ShipFromDistrictOrCounty: { name: 'InboundShipmentHeader.ShipFromAddress.DistrictOrCounty', required: false }
        ShipFromStateOrProvince: { name: 'InboundShipmentHeader.ShipFromAddress.StateOrProvinceCode', required: true }
        ShipFromPostalCode: { name: 'InboundShipmentHeader.ShipFromAddress.PostalCode', required: true }
        ShipFromCountryCode: { name: 'InboundShipmentHeader.ShipFromAddress.CountryCode', required: true }
        DestinationFulfillmentCenterId: { name: 'InboundShipmentHeader.DestinationFulfillmentCenterId', required: true }
        ShipmentStatus: { name: 'InboundShipmentHeader.ShipmentStatus' }
        LabelPrepPreference: { name: 'InboundShipmentHeader.LabelPrepPreference' }
        InboundShipmentItems: { name: 'InboundShipmentItems.member', type: 'Complex', list: true, required: true }

    CreateInboundShipmentPlan: (props) ->
      new FbaInboundRequest 'CreateInboundShipmentPlan', props,
        LabelPrepPreference: { name: 'LabelPrepPreference', required: true }
        ShipFromName: { name: 'ShipFromAddress.Name' }
        ShipFromAddressLine1: { name: 'ShipFromAddress.AddressLine1' }
        ShipFromCity: { name: 'ShipFromAddress.City' }
        ShipFromStateOrProvince: { name: 'ShipFromAddress.StateOrProvinceCode' }
        ShipFromPostalCode: { name: 'ShipFromAddress.PostalCode' }
        ShipFromCountryCode: { name: 'ShipFromAddress.CountryCode' }
        ShipFromAddressLine2: { name: 'ShipFromAddress.AddressLine2' }
        ShipFromDistrictOrCounty: { name: 'ShipFromAddress.DistrictOrCounty' }
        InboundShipmentPlanRequestItems: { name: 'InboundShipmentPlanRequestItems.member', type: 'Complex', list:true, required: true }

    ListInboundShipmentItems: (props) ->
      new FbaInboundRequest 'ListInboundShipmentItems', props,
        ShipmentId: { name: 'ShipmentId', required: true }
        LastUpdatedAfter: { name: 'LastUpdatedAfter', type: 'Timestamp' }
        LastUpdatedAfter: { name: 'LastUpdatedBefore', type: 'Timestamp' }
  
    ListInboundShipmentItemsByNextToken: (props) ->
      new FbaInboundRequest 'ListInboundShipmentItemsByNextToken', props,
        NextToken: { name: 'NextToken', required: true }

    ListInboundShipments: (props) ->
      new FbaInboundRequest 'ListInboundShipments', props,
        ShipmentStatuses: { name: 'ShipmentStatusList.member', list: true, required: false }
        ShipmentIds: { name: 'ShipmentIdList.member', list: true, required: false }
        LastUpdatedAfter: { name: 'LastUpdatedAfter', type: 'Timestamp' }
        LastUpdatedBefore: { name: 'LastUpdatedBefore', type: 'Timestamp' }
 
    ListInboundShipmentsByNextToken: (props) ->
      new FbaInboundRequest 'ListInboundShipmentsByNextToken', props,
        NextToken: { name: 'NextToken', required: true }

    UpdateInboundShipment: (props) ->
      new FbaInboundRequest 'UpdateInboundShipment', props,
        ShipmentId: { name: 'ShipmentId', required: true }
        ShipmentName: { name: 'InboundShipmentHeader.ShipmentName', required: true }
        ShipFromName: { name: 'InboundShipmentHeader.ShipFromAddress.Name', required: true }
        ShipFromAddressLine1: { name: 'InboundShipmentHeader.ShipFromAddress.AddressLine1', required: true }
        ShipFromAddressLine2: { name: 'InboundShipmentHeader.ShipFromAddress.AddressLine2', required: false }
        ShipFromAddressCity: { name: 'InboundShipmentHeader.ShipFromAddress.City', required: true }
        ShipFromDistrictOrCounty: { name: 'InboundShipmentHeader.ShipFromAddress.DistrictOrCounty', required: false }
        ShipFromStateOrProvince: { name: 'InboundShipmentHeader.ShipFromAddress.StateOrProvinceCode', required: true }
        ShipFromPostalCode: { name: 'InboundShipmentHeader.ShipFromAddress.PostalCode', required: true }
        ShipFromCountryCode: { name: 'InboundShipmentHeader.ShipFromAddress.CountryCode', required: true }
        DestinationFulfillmentCenterId: { name: 'InboundShipmentHeader.DestinationFulfillmentCenterId', required: true }
        ShipmentStatus: { name: 'InboundShipmentHeader.ShipmentStatus' }
        LabelPrepPreference: { name: 'InboundShipmentHeader.LabelPrepPreference' }
        InboundShipmentItems: { name: 'InboundShipmentItems.member', type: 'Complex', list: true, required: true }

  inventory: 
    GetServiceStatus: (props) ->
      new FbaInventoryRequest 'GetServiceStatus', props

    ListInventorySupply: (props) ->
      new FbaInventoryRequest 'ListInventorySupply', props,                 
        SellerSkus: { name: 'SellerSkus.member', list: true }
        QueryStartDateTime: { name: 'QueryStartDateTime', type: 'Timestamp' }
        ResponseGroup: { name: 'ResponseGroup' }
    
    ListInventorySupplyByNextToken: (props) ->
      new FbaInventoryRequest 'ListInventorySupplyByNextToken', props,
        NextToken: { name: 'NextToken', required: true }

  outbound: 
    GetServiceStatus: (props) ->
      new FbaOutboundRequest 'GetServiceStatus', props
 
    CancelFulfillmentOrder: (props) ->
      new FbaOutboundRequest 'CancelFulfillmentOrder', props,
        SellerFulfillmentOrderId: { name: 'SellerFulfillmentOrderId', required: true }

    CreateFulfillmentOrder: (props) ->
      new FbaOutboundRequest 'CreateFulfillmentOrder', props,
        SellerFulfillmentOrderId: { name: 'SellerFulfillmentOrderId', required: true }
        ShippingSpeedCategory: { name: 'ShippingSpeedCategory', required: true, type: 'fba.ShippingSpeedCategory' }
        DisplayableOrderId: { name: 'DisplayableOrderId', required: true }
        DisplayableOrderDateTime: { name: 'DisplayableOrderDateTime' }
        DisplayableOrderComment: { name: 'DisplayableOrderComment' }
        FulfillmentPolicy: { name: 'FulfillmentPolicy', required: false, type: 'fba.FulfillmentPolicy' }
        FulfillmentMethod: { name: 'FulfillmentMethod', required: false }
        NotificationEmails: { name: 'NotificationEmailList.member', required: false, list: true }
        Name: { name: 'DestinationAddress.Name' }
        AddressLine1: { name: 'DestinationAddress.Line1' }
        AddressLine2: { name: 'DestinationAddress.Line2' }
        AddressLine3: { name: 'DestinationAddress.Line3' }
        City: { name: 'DestinationAddress.City' }
        StateOrProvince: { name: 'DestinationAddress.StateOrProvinceCode' }
        PostalCode: { name: 'DestinationAddress.PostalCode' }
        Country: { name: 'DestinationAddress.CountryCode' }
        DistrictOrCounty: { name: 'DestinationAddress.DistrictOrCounty' }
        PhoneNumber: { name: 'DestinationAddress.PhoneNumber' }
        LineItems: { name: 'Items.member', type: 'Complex', list: true, required: true }

    GetFulfillmentOrder: (props) ->
      new FbaOutboundRequest 'GetFulfillmentOrder', props,
        SellerFulfillmentOrderId: { name: 'SellerFulfillmentOrderId', required: true }

    GetFulfillmentPreview: (props) ->
      new FbaOutboundRequest 'GetFulfillmentPreview', props,
        Name: { name: 'Address.Name' }
        AddressLine1: { name: 'Address.Line1' }
        AddressLine2: { name: 'Address.Line2' }
        AddressLine3: { name: 'Address.Line3' }
        City: { name: 'Address.City' }
        StateOrProvince: { name: 'Address.StateOrProvinceCode' }
        PostalCode: { name: 'Address.PostalCode' }
        Country: { name: 'Address.CountryCode' }
        DistrictOrCounty: { name: 'Address.DistrictOrCounty' }
        PhoneNumber: { name: 'Address.PhoneNumber' }
        LineItems: { name: 'Items.member', type: 'Complex', list: true, required: true }
        ShippingSpeeds: { name: 'ShippingSpeedCategories.member', list: true, type: 'fba.ShippingSpeedCategory' }

    ListAllFulfillmentOrders: (props) ->
      new FbaOutboundRequest 'ListAllFulfillmentOrders', props,
        QueryStartDateTime: { name: 'QueryStartDateTime', required: true, type: 'Timestamp' }
        FulfillentMethods: { name: 'FulfillmentMethod.member', list: true } 

    ListAllFulfillmentOrdersByNextToken: (props) ->
      new FbaOutboundRequest 'ListAllFulfillmentOrdersByNextToken', props,
        NextToken: { name: 'NextToken', required: true }


###
# Construct a mws fulfillment api request for mws.Client.invoke()
# @param {String} group  Group name (category) of request
# @param {String} path   Path of associated group
# @param {String} action Action request will be calling
# @param {Object} params Schema of possible request parameters
###
class FulfillmentRequest extends mws.Request 
  constructor: (group, path, action, props, params) ->
    super
      name: 'Fulfillment'
      group: group
      path: path
      version: '2010-10-01'
      legacy: false
      action: action
      params: params
      props: props


class FbaInboundRequest extends FulfillmentRequest
  constructor: (action, props = {}, params = {}) ->
    super 'Inbound Shipments', '/FulfillmentInboundShipment/2010-10-01', action, props, params

class FbaInventoryRequest extends FulfillmentRequest 
  constructor: (action, props = {}, params = {}) ->
    super 'Inventory', '/FulfillmentInventory/2010-10-01', action, props, params

class FbaOutboundRequest extends FulfillmentRequest
  constructor: (action, props = {}, params = {}) ->
    super 'Outbound Shipments', '/FulfillmentOutboundShipment/2010-10-01', action, props, params

