@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hierarchy demo: Organizational Unit'
define view entity zi_hana_org_unit
  as select from zhana_org_unit as OrgUnit

  association [0..1] to zi_hana_org_unit as _ToParent on $projection.parent_unit_id = _ToParent.org_unit_id

{
  key OrgUnit.org_unit_id    as org_unit_id,
      OrgUnit.parent_unit_id as parent_unit_id,
      OrgUnit.unit_name      as unit_name,
      OrgUnit.cost_center    as cost_center,

      _ToParent
}
