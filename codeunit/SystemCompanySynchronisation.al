codeunit 50101 "ZYN_SystemToCustomSynch"
{
    var
        isSync: Boolean;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterInsertEvent', '', true, true)]
    local procedure SystemCompanyInserted(var Rec: Record Company; RunTrigger: Boolean)
    var
        CustomCompany: Record "ZYN_CustomCompany";
    begin
        if isSync then
            exit;

        if CustomCompany.Get(Rec.Name) then begin
            // Update existing custom company
            CustomCompany."Evaluation Company" := Rec."Evaluation Company";
            CustomCompany."Display Name" := Rec."Display Name";
            CustomCompany."Business Profile Id" := Rec."Business Profile Id";
            CustomCompany.Id := Rec.Id;
        end else begin
            // Insert new
            isSync := true;
            CustomCompany.Init();
            CustomCompany.Name := Rec.Name;
            CustomCompany."Evaluation Company" := Rec."Evaluation Company";
            CustomCompany."Display Name" := Rec."Display Name";
            CustomCompany."Business Profile Id" := Rec."Business Profile Id";
            CustomCompany.Id := Rec.Id;
            CustomCompany."Skip Sync" := true;
            CustomCompany.Insert(true);
            isSync := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterModifyEvent', '', true, true)]
    local procedure SystemCompanyModified(var Rec: Record Company; RunTrigger: Boolean)
    var
        CustomCompany: Record "ZYN_CustomCompany";
    begin
        if isSync then
            exit;

        if CustomCompany.Get(Rec.Name) then begin
            if (CustomCompany."Display Name" <> Rec."Display Name") or 
               (CustomCompany."Evaluation Company" <> Rec."Evaluation Company") then begin
                isSync := true;
                CustomCompany."Evaluation Company" := Rec."Evaluation Company";
                CustomCompany."Display Name" := Rec."Display Name";
                CustomCompany."Business Profile Id" := Rec."Business Profile Id";
                CustomCompany.Id := Rec.Id;
                CustomCompany.Modify(true);
                isSync := false;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Company, 'OnAfterDeleteEvent', '', true, true)]
    local procedure SystemCompanyDeleted(var Rec: Record Company; RunTrigger: Boolean)
    var
        CustomCompany: Record "ZYN_CustomCompany";
    begin
        if isSync then
            exit;

        // Use Rec.Name for deletion
        if CustomCompany.Get(Rec.Name) then begin
            isSync := true;
            CustomCompany.Delete(true);
            isSync := false;
        end;
    end;
}
