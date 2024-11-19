@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_TB_EINVOICE
  as select from ztb_einvoice as eInvoice
{
  key uuid                  as Uuid,
      stax                  as Stax,
      sid                   as Sid,
      eformat               as eFormat,
      action                as Action,
      company               as Company,
      doc_ic                as DocIc,
      doc_id                as DocId,
      doc_on                as DocOn,
      doc_ot                as DocOt,
      doc_ou                as DocOu,
      doc_uc                as DocUc,
      doc_adt               as DocAdt,
      doc_aun               as DocAun,
      doc_idt               as DocIdt,
      org_on                as OrgOn,
      org_ot                as OrgOt,
      org_acc               as OrgAcc,
      org_add               as OrgAdd,
      org_seq               as OrgSeq,
      org_tel               as OrgTel,
      org_addr              as OrgAddr,
      org_bank              as OrgBank,
      org_mail              as OrgMail,
      org_paxo              as OrgPaxo,
      org_sign              as OrgSign,
      org_taxo              as OrgTaxo,
      org_paxoname          as OrgPaxoname,
      org_taxoname          as OrgTaxoname,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt

}
