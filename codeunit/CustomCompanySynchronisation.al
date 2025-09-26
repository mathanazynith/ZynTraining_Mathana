codeunit 50275 "ZYN_CustomToSystemSynch"
{
    var
        isSync: Boolean;

    [EventSubscriber(ObjectType::Table, Database::"ZYN_CustomCompany", 'OnAfterInsertEvent', '', true, true)]
    local procedure CustomCompanyInserted(var Rec: Record "ZYN_CustomCompany"; RunTrigger: Boolean)
    var
        Company: Record Company;

    begin
        // Prevent recursion
        if isSync then
            exit;
        if not Company.Get(Rec.Name) then begin
            // Insert new system company
            isSync := true;
            Company.Init();
            Company.Name := Rec.Name;
            Company."Evaluation Company" := Rec."Evaluation Company";
            Company."Display Name" := Rec."Display Name";
            Company."Business Profile Id" := Rec."Business Profile Id";
            Company.Insert(true);
        end;
        isSync := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"ZYN_CustomCompany", 'OnAfterModifyEvent', '', true, true)]
    local procedure CustomCompanyModified(var Rec: Record "ZYN_CustomCompany"; RunTrigger: Boolean)
    var
        Company: Record Company;
    begin
        // Prevent recursion
        if isSync then
            exit;
        if Company.Get(Rec.Name) then begin
            // Update existing system company fields
            if (Company."Display Name" <> Rec."Display Name") or (Company."Evaluation Company" <> Rec."Evaluation Company") then begin
                isSync := true;
                Company."Evaluation Company" := Rec."Evaluation Company";
                Company."Display Name" := Rec."Display Name";
                Company."Business Profile Id" := Rec."Business Profile Id";
                Company.Modify(true);
            end;
        end;
        isSync := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"ZYN_CustomCompany", 'OnAfterDeleteEvent', '', true, true)]
    local procedure CustomCompanyDeleted(var Rec: Record "ZYN_CustomCompany"; RunTrigger: Boolean)
    var
        Company: Record Company;
    begin
        // Prevent recursion
        if Company.Get(Rec.Name) then
            Company.Delete(true);
    end;
}
