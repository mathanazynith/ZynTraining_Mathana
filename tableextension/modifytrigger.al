tableextension 50113 CustomerChangeExt extends Customer
{
    trigger OnBeforeModify()
    begin
        GenericFieldChangeLogger(Rec, xRec);
    end;

    local procedure GenericFieldChangeLogger(NewRec: Record Customer; OldRec: Record Customer)
    var
        ModifyLog: Record "Modify Log";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        FieldRef: FieldRef;
        xFieldRef: FieldRef;
        i: Integer;
        Fieldname: Text;
        begin
        RecRef.GetTable(NewRec);
        xRecRef.GetTable(OldRec);

        for i := 1 to RecRef.FieldCount do begin
            FieldRef := RecRef.FieldIndex(i);
            xFieldRef := xRecRef.FieldIndex(i);
            Fieldname := FieldRef.Name;
            

            begin
                if format(FieldRef.Value) <> format(xFieldRef.Value) then begin
                ModifyLog.Init();
                ModifyLog."Entry No." := 0; 
                ModifyLog."Customer No." := NewRec."No."; 
                
                ModifyLog."Field change." := FieldRef.Caption;
                ModifyLog."Old Field" := Format(xFieldRef.Value);
                ModifyLog."New Field" := Format(FieldRef.Value);
                ModifyLog."User ID" := UserId;
            
                ModifyLog.Insert();
            end;
            end;
            end;
        end;

}
