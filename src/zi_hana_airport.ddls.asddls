@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Path expression demo: Airport'
define view entity zi_hana_airport
  as select from /dmo/airport as Airport
{
  key Airport.airport_id as AirportID,
      Airport.name       as AirportName,
      Airport.city       as City,
      Airport.country    as CountryCode
}
