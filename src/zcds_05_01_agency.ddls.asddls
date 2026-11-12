@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Class 5.01: Agency - PFCG aspect'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_05_01_AGENCY
  as select from /dmo/agency
{
  key agency_id    as AgencyId,
      name         as AgencyName,
      city         as City,
      country_code as CountryCode
}
