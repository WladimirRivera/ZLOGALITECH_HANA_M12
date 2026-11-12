@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Class 7.03: Connection dimension'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@ObjectModel.representativeKey: 'ConnectionId'
define view entity ZCDS_I_07_03_CONN_DIM
  as select from /dmo/connection
  association [1..1] to ZCDS_I_07_03_AIRLINE_DIM as _Airline on $projection.CarrierId = _Airline.CarrierId
{
      @ObjectModel.foreignKey.association: '_Airline'
  key carrier_id                                                              as CarrierId,
      @ObjectModel.text.element: ['Route']
  key connection_id                                                           as ConnectionId,
      @Semantics.text: true
      concat_with_space( airport_from_id, concat_with_space( '-', airport_to_id, 1 ), 1 ) as Route,
      airport_from_id                                                         as AirportFromId,
      airport_to_id                                                           as AirportToId,
      _Airline
}
