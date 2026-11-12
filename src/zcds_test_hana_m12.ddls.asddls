@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition - Test'
@Metadata.ignorePropagatedAnnotations: false
define view entity zcds_test_hana_m12
  as select from /dmo/flight
{
key carrier_id as CarrierId,
key connection_id as ConnectionId,
key flight_date as FlightDate,
price as Price,
currency_code as CurrencyCode,
plane_type_id as PlaneTypeId,
seats_max as SeatsMax,
seats_occupied as SeatsOccupied
}
