@AbapCatalog.sqlViewName: 'ZCDS_03_01_BV'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS 03.01: CAST and CASE'
define view ZCDS_03_01_BASIC_VIEW
  as select from /dmo/flight
{
  key carrier_id                       as CarrierId,
  key connection_id                    as ConnectionId,
  key flight_date                      as FlightDate,
      plane_type_id                    as PlaneTypeId,
      seats_max                        as MaxSeats,
      seats_occupied                   as OccupiedSeats,
      cast( flight_date as abap.dats ) as FlightDateType,
      cast( case plane_type_id
        when 'A380' then 'Long Range'
        when 'B777' then 'Long Range'
        when 'B737' then 'Short Range'
        else 'Unknown'
      end as abap.char( 15 ) )         as PlaneCategory,
      case plane_type_id
        when 'A380' then 'Long Range'
        when 'B777' then 'Long Range'
        when 'B737' then 'Short Range'
        else 'Unknown'
      end                              as PlaneCategory2,
      cast( case
        when seats_occupied = 0 then 'Empty'
        when seats_occupied < seats_max then 'Available'
        else 'Full'
      end as abap.char( 15 ) )         as OccupancyStatus
}
