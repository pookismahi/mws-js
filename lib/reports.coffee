###
# Reports API requests and definitions for Amazon's MWS web services.
# For information on using, please see examples folder.
# 
# @author Robert Saunders
###
mws = require './mws' 

###
# Construct a Reports API request for mws.Client.invoke()
# 
# @param {String} action Action parameter of request
# @param {Object} params Schemas for all supported parameters
###
class ReportsRequest extends mws.Request
  constructor: (action, props = {}, params = {}) ->
    super 
      name: 'Reports'
      group: 'Reports & Report Scheduling'
      path: '/'
      version: '2009-01-01'
      legacy: true
      action: action
      params: params
      props: props

###
# Ojects to represent enum collections used by some request(s)
# @type {Object}
###
exports.enums =
  Schedules: -> 
    return new mws.Enum ['_15_MINUTES_', '_30_MINUTES_', '_1_HOUR_', '_2_HOURS_', '_4_HOURS_', '_8_HOURS_', '_12_HOURS_', '_72_HOURS_', '_1_DAY_', '_2_DAYS_', '_7_DAYS_', '_14_DAYS_', '_15_DAYS_', '_30_DAYS_', '_NEVER_']

  ReportProcessingStatuses: -> 
    return new mws.Enum ['_SUBMITTED_', '_IN_PROGRESS_', '_CANCELLED_', '_DONE_', '_DONE_NO_DATA_']

  ReportOptions: -> 
    return new mws.Enum ['ShowSalesChannel=true']

###
# A collection of currently supported request constructors. Once created and 
# configured, the returned requests can be passed to an mws client `invoke` call
# @type {Object}
###
exports.requests = 

  GetReport: (props) ->
    return new ReportsRequest 'GetReport', props, 
      ReportId: { name: 'ReportId', required: true }
    
  GetReportCount: (props) ->
    return new ReportsRequest 'GetReportCount', props, 
      ReportTypes: { name: 'ReportTypeList.Type',  list:  true}
      Acknowledged: { name: 'Acknowledged', type: 'Boolean' }
      AvailableFrom: { name: 'AvailableFromDate', type: 'Timestamp' }
      AvailableTo: { name: 'AvailableToDate', type: 'Timestamp' }

  GetReportList: (props) ->
    return new ReportsRequest 'GetReportList', props, 
      MaxCount: { name: 'MaxCount'  }
      ReportTypes: { name: 'ReportTypeList.Type',  list:  true}
      Acknowledged: { name: 'Acknowledged', type: 'Boolean' }
      AvailableFrom: { name: 'AvailableFromDate', type: 'Timestamp' }
      AvailableTo: { name: 'AvailableToDate', type: 'Timestamp' }
      ReportRequestIds: { name: 'ReportRequestIdList.Id', list: true }

  GetReportListByNextToken: (props) ->
    return new ReportsRequest 'GetReportListByNextToken', props, 
      NextToken: { name: 'NextToken', required: true }

  GetReportRequestCount: (props) ->
    return new ReportsRequest 'GetReportRequestCount', props, 
      RequestedFrom: { name: 'RequestedFromDate', type: 'Timestamp' }
      RequestedTo: { name: 'RequestedToDate', type: 'Timestamp' }
      ReportTypes: { name: 'ReportTypeList.Type', list: true }
      ReportProcessingStatuses: { name: 'ReportProcessingStatusList.Status', list: true, type: 'reports.ReportProcessingStatuses' }

  GetReportRequestList: (props) ->
    return new ReportsRequest 'GetReportRequestList', props, 
      MaxCount: { name: 'MaxCount' },
      RequestedFrom: { name: 'RequestedFromDate', type: 'Timestamp' }
      RequestedTo: { name: 'RequestedToDate', type: 'Timestamp' }
      ReportRequestIds: { name: 'ReportRequestIdList.Id', list: true }
      ReportTypes: { name: 'ReportTypeList.Type', list: true }
      ReportProcessingStatuses: { name: 'ReportProcessingStatusList.Status', list: true, type: 'reports.ReportProcessingStatuses' }

  GetReportRequestListByNextToken: (props) ->
    return new ReportsRequest 'GetReportRequestListByNextToken', props, 
      NextToken: { name: 'NextToken', required: true }
    
  CancelReportRequests: (props) ->
    return new ReportsRequest 'CancelReportRequests', props, 
      RequestedFrom: { name: 'RequestedFromDate', type: 'Timestamp' }
      RequestedTo: { name: 'RequestedToDate', type: 'Timestamp' }
      ReportRequestIds: { name: 'ReportRequestIdList.Id', list: true }
      ReportTypes: { name: 'ReportTypeList.Type', list: true }
      ReportProcessingStatuses: { name: 'ReportProcessingStatusList.Status', list: true, type: 'reports.ReportProcessingStatuses' }

  RequestReport: (props) ->
    return new ReportsRequest 'RequestReport', props, 
      ReportType: { name: 'ReportType', required: true }
      MarketplaceIds: { name: 'MarketplaceIdList.Id', list: true, required: false }
      StartDate: { name: 'StartDate', type: 'Timestamp' }
      EndDate: { name: 'EndDate', type: 'Timestamp' }
      ReportOptions: { name: 'ReportOptions', type: 'reports.ReportOptions' }

  ManageReportSchedule: (props) ->
    return new ReportsRequest 'ManageReportSchedule', props, 
      ReportType: { name: 'ReportType', required: true }
      Schedule: { name: 'Schedule', type: 'reports.Schedules', required: true }
      ScheduleDate: { name: 'ScheduleDate', type: 'Timestamp' }

  GetReportScheduleList: (props) ->
    return new ReportsRequest 'GetReportScheduleList', props, 
      ReportTypes: { name: 'ReportTypeList.Type', list: true }
    
  GetReportScheduleListByNextToken: (props) ->
    return new ReportsRequest 'GetReportScheduleListByNextToken', props, 
      NextToken: { name: 'NextToken', required: true }

  GetReportScheduleCount: (props) ->
    return new ReportsRequest 'GetReportScheduleCount', props, 
      ReportTypes: { name: 'ReportTypeList.Type', list: true }

  UpdateReportAcknowledgements: (props) ->
    return new ReportsRequest 'UpdateReportAcknowledgements', props, 
      ReportIds: { name: 'ReportIdList.Id', list: true, required: true }
      Acknowledged: { name: 'Acknowledged', type: 'Boolean' }
