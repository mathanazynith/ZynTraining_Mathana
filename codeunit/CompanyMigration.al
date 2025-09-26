codeunit 50276 "Zyn_UpgradeSystemCompanies"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        TagId: Label 'MIGRATE_SYSTEM_COMPANIES_V9', Locked = true;
        SysCompany: Record Company;
        CustomCompany: Record "ZYN_CustomCompany";
    begin
        if UpgradeTag.HasUpgradeTag(TagId) then
            exit;
        SysCompany.Reset();
        if SysCompany.FindSet() then
            repeat
                // Insert only if not already in custom table
                if not CustomCompany.Get(SysCompany.Name) then begin
                    CustomCompany.Init();
                    CustomCompany.Name := SysCompany.Name;
                    CustomCompany."Evaluation Company" := SysCompany."Evaluation Company";
                    CustomCompany."Display Name" := SysCompany."Display Name";
                    CustomCompany."Business Profile Id" := SysCompany."Business Profile Id";
                    CustomCompany.Id := SysCompany.Id;
                    CustomCompany."Skip Sync" := true;
                    CustomCompany.Insert(true);
                end;
            until SysCompany.Next() = 0;

        UpgradeTag.SetUpgradeTag(TagId);
    end;
}
