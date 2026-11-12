@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 6.03: Booking - search + VH'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@UI.headerInfo: { typeName:       'Booking',
                  typeNamePlural: 'Bookings',
                  title:          { type: #STANDARD, value: 'BookingId' },
                  description:    { type: #STANDARD, value: 'CustomerName' } }
define root view entity ZCDS_P_06_03_BOOKING
  provider contract transactional_query
  as projection on ZCDS_I_06_03_BOOKING
{
      @UI.facet: [{ id:       'Booking',
                    purpose:  #STANDARD,
                    type:     #IDENTIFICATION_REFERENCE,
                    label:    'Booking',
                    position: 10 }]
      @UI: { lineItem:       [{ position: 10 }],
             identification: [{ position: 10 }],
             selectionField: [{ position: 10 }] }
      @Search.defaultSearchElement: true
  key TravelId,

      @UI: { lineItem:       [{ position: 20 }],
             identification: [{ position: 20 }] }
  key BookingId,

      @UI.identification: [{ position: 30 }]
      BookingDate,

      @UI: { lineItem:       [{ position: 30 }],
             identification: [{ position: 40 }],
             selectionField: [{ position: 20 }] }
      @ObjectModel.foreignKey.association: '_Customer'
      @ObjectModel.text.element: ['CustomerName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZCDS_06_03_CUSTOMER_VH', element: 'CustomerId' } }]
      CustomerId,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.5
      @Search.ranking: #HIGH
      @UI.hidden: true
      _Customer.LastName as CustomerName,

      @UI: { lineItem:       [{ position: 40 }],
             identification: [{ position: 50 }],
             selectionField: [{ position: 30 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Carrier_StdVH', element: 'AirlineID' } }]
      CarrierId,

      @UI: { lineItem:       [{ position: 50 }],
             identification: [{ position: 60 }],
             selectionField: [{ position: 40 }] }
      @Consumption.valueHelpDefinition: [{ entity:            { name: '/DMO/I_Connection_StdVH', element: 'ConnectionID' },
                                           additionalBinding: [{ localElement: 'CarrierId', element: 'AirlineID' }] }]
      ConnectionId,

      @UI: { lineItem:       [{ position: 60 }],
             identification: [{ position: 70 }] }
      FlightDate,

      @UI: { lineItem:       [{ position: 70 }],
             identification: [{ position: 80 }] }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,

      @UI.hidden: true
      CurrencyCode,

      _Customer
}
