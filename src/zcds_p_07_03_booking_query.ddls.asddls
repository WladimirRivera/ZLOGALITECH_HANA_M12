@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Class 7.03: Booking analytics query'
define transient view entity ZCDS_P_07_03_BOOKING_QUERY
  provider contract analytical_query
  as projection on ZCDS_I_07_03_BOOKING_CUBE
{
      @AnalyticsDetails.query.axis: #ROWS
      @UI.textArrangement: #TEXT_LAST
      CarrierId,

      @AnalyticsDetails.query.axis: #ROWS
      FlightYear,

      @AnalyticsDetails.query.axis: #FREE
      @UI.textArrangement: #TEXT_LAST
      ConnectionId,

      @AnalyticsDetails.query.axis: #FREE
      CustomerCountry,

      @AnalyticsDetails.query.axis: #FREE
      CurrencyCode,

      @AnalyticsDetails.query.axis: #COLUMNS
      NumberOfBookings,

      @AnalyticsDetails.query.axis: #COLUMNS
      FlightPrice,

      @EndUserText.label: 'Average Price per Booking'
      @AnalyticsDetails.query.axis: #COLUMNS
      @AnalyticsDetails.query.decimals: 2
      @Aggregation.default: #FORMULA
      @Semantics.amount.currencyCode: 'CurrencyCode'
      $projection.FlightPriceAmount / $projection.NumberOfBookings as AveragePrice,

      @AnalyticsDetails.query.hidden: true
      FlightPriceAmount
}
