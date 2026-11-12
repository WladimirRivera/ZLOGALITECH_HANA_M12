@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 6.02: Connection - projection'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: { typeName:       'Connection',
                  typeNamePlural: 'Connections',
                  title:          { type: #STANDARD, value: 'ConnectionId' },
                  description:    { type: #STANDARD, value: 'CarrierName' } }
define root view entity ZCDS_P_06_02_CONNECTION
  provider contract transactional_query
  as projection on ZCDS_I_06_02_CONNECTION
{
      @UI.facet: [{ id:       'Connection',
                    purpose:  #STANDARD,
                    type:     #IDENTIFICATION_REFERENCE,
                    label:    'Connection',
                    position: 10 }]
      @UI: { lineItem:       [{ position: 10 }],
             identification: [{ position: 10 }],
             selectionField: [{ position: 10 }] }
      @ObjectModel.text.element: ['CarrierName']
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Carrier_StdVH', element: 'AirlineID' } }]
  key CarrierId,

      @UI: { lineItem:       [{ position: 20 }],
             identification: [{ position: 20 }] }
  key ConnectionId,

      @UI: { lineItem:       [{ position: 30 }],
             identification: [{ position: 30 }],
             selectionField: [{ position: 20 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Airport_StdVH', element: 'AirportID' } }]
      AirportFromId,

      @UI: { lineItem:       [{ position: 40 }],
             identification: [{ position: 40 }],
             selectionField: [{ position: 30 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Airport_StdVH', element: 'AirportID' } }]
      AirportToId,

      @UI.identification: [{ position: 50 }]
      DepartureTime,

      @UI.identification: [{ position: 60 }]
      ArrivalTime,

      @UI: { lineItem:       [{ position: 50 }],
             identification: [{ position: 70 }] }
      Distance,

      @UI.hidden: true
      DistanceUnit,

      @UI.hidden: true
      _Carrier.Name as CarrierName
}
