@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 7.03: Booking cube'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
define view entity ZCDS_I_07_03_BOOKING_CUBE
  as select from /dmo/booking
  association [0..1] to ZCDS_I_07_03_AIRLINE_DIM  as _Airline    on  $projection.CarrierId = _Airline.CarrierId
  association [0..1] to ZCDS_I_07_03_CONN_DIM     as _Connection on  $projection.CarrierId    = _Connection.CarrierId
                                                                 and $projection.ConnectionId = _Connection.ConnectionId
  association [0..1] to ZCDS_I_07_03_CUSTOMER_DIM as _Customer   on  $projection.CustomerId = _Customer.CustomerId
{
  key travel_id                     as TravelId,
  key booking_id                    as BookingId,

      @EndUserText.label: 'Airline'
      @ObjectModel.foreignKey.association: '_Airline'
      carrier_id                    as CarrierId,

      @EndUserText.label: 'Connection'
      @ObjectModel.foreignKey.association: '_Connection'
      connection_id                 as ConnectionId,

      @EndUserText.label: 'Customer'
      @ObjectModel.foreignKey.association: '_Customer'
      customer_id                   as CustomerId,

      @EndUserText.label: 'Flight Date'
      flight_date                   as FlightDate,

      @EndUserText.label: 'Flight Year'
      substring( flight_date, 1, 4 ) as FlightYear,

      @EndUserText.label: 'Flight Month'
      substring( flight_date, 5, 2 ) as FlightMonth,

      @EndUserText.label: 'Customer Country'
      _Customer.CountryCode          as CustomerCountry,

      @EndUserText.label: 'Number of Bookings'
      @Aggregation.default: #SUM
      cast( 1 as abap.int4 )         as NumberOfBookings,

      @EndUserText.label: 'Flight Price'
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price                   as FlightPrice,

      @EndUserText.label: 'Flight Price (decimal)'
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CurrencyCode'
      curr_to_decfloat_amount( flight_price ) as FlightPriceAmount,

      @EndUserText.label: 'Currency'
      currency_code                  as CurrencyCode,

      _Airline,
      _Connection,
      _Customer
}
