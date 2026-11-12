@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 7.01: Booking - consumption'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #CONSUMPTION
@UI.headerInfo: { typeName: 'Booking', typeNamePlural: 'Bookings' }
define view entity ZCDS_P_07_01_BOOKING
  as select from ZCDS_I_07_01_BOOKING_COMP
{
      @UI.lineItem: [{ position: 10 }]
  key TravelId,
      @UI.lineItem: [{ position: 20 }]
  key BookingId,
      @UI.lineItem: [{ position: 30 }]
      @UI.selectionField: [{ position: 10 }]
      CarrierId,
      @UI.lineItem: [{ position: 40 }]
      CarrierName,
      @UI.lineItem: [{ position: 50 }]
      ConnectionId,
      @UI.lineItem: [{ position: 60 }]
      AirportFromId,
      @UI.lineItem: [{ position: 70 }]
      AirportToId,
      @UI.lineItem: [{ position: 80 }]
      @UI.selectionField: [{ position: 20 }]
      FlightDate,
      @UI.lineItem: [{ position: 90 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode
}
