@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition - Test'
@Metadata.ignorePropagatedAnnotations: false
define view entity ZCDS_TEST_HANA_M12_2
  as select from /DMO/I_Flight_R
{
key AirlineID,
key ConnectionID,
key FlightDate,
//Price,
//CurrencyCode,
//PlaneType,
//MaximumSeats,
OccupiedSeats,
/* Associations */
_Airline
}
