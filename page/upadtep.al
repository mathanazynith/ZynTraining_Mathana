page 50127 UpdateFieldCard
{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'Update Field Card';

    layout
    {
        area(content)
        {
            group("Update Field Information")
            {
                field("Table Name"; TableName)
                {
                    ApplicationArea = All;
                    TableRelation = "AllObjWithCaption"."Object ID" WHERE("Object Type" = CONST(Table));
                    trigger OnValidate()
                    begin
                        Clear(FieldID);
                        Clear(FieldName);
                        Clear(RecordName);
                        Clear(RecNo);
                        Clear(Values);
                        Clear(valID); 
                    end;
                }

                field("Field Name"; FieldName)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        RecRef: RecordRef;
                        FieldRef: FieldRef;
                        TempBuffer: Record "Buffer Field" temporary;
                        i: Integer;
                    begin
                        if TableName = 0 then
                            Error('Please select a table first.');

                        RecRef.Open(TableName);

                        for i := 1 to RecRef.FieldCount do begin
                            FieldRef := RecRef.FieldIndex(i);
                            TempBuffer.Init();
                            TempBuffer."Field ID" := FieldRef.Number;
                            TempBuffer."Field Name" := FieldRef.Caption();
                            TempBuffer.Insert();
                        end;

                        RecRef.Close();

                        if Page.RunModal(Page::"Field Buffer List", TempBuffer, SelectCust) = Action::LookupOK then begin
                            FieldID := TempBuffer."Field ID";
                            FieldName := TempBuffer."Field Name";
                        end;
                    end;
                }

                field("Record Name"; RecordName)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        RecRef: RecordRef;
                        FieldRef: FieldRef;
                        TempValueBuffer: Record "Buffer Field" temporary;
                        LineNo: Integer;
                    begin
                        if (TableName = 0) OR (FieldID = 0) then
                            Error('Please select a table and field first.');

                        RecRef.Open(TableName);
                        if not RecRef.FindSet() then
                            Error('No records found.');

                        LineNo := 0;
                        repeat
                            LineNo += 1;
                            TempValueBuffer.Init();
                            TempValueBuffer."Field ID" := LineNo;

                            FieldRef := RecRef.Field(FieldID);
                            TempValueBuffer."Field Name" := Format(FieldRef.Value);
                            TempValueBuffer."Record Id" := RecRef.RecordId(); 
                            TempValueBuffer.Insert();
                        until RecRef.Next() = 0;

                        RecRef.Close();

                        if Page.RunModal(Page::"Field Buffer List", TempValueBuffer, RecNo) = Action::LookupOK then begin
                            RecNo := TempValueBuffer."Field ID";
                            RecordName := TempValueBuffer."Field Name";
                            valID := TempValueBuffer."Record Id";
                        end;
                    end;
                }

                field("Changing Value"; Values)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        RecRef: RecordRef;
                        FieldRef: FieldRef;
                    begin
                        RecRef.Open(TableName);

                        if RecRef.Get(valID) then begin
                            FieldRef := RecRef.Field(FieldID);
                            FieldRef.Value := Values;
                            RecRef.Modify();
                            exit;
                        end;

                        RecRef.close();


                    end;


                }
            }
        }
    }

    var
        TableName: Integer;
        FieldID: Integer;
        FieldName: Text[100];
        RecordName: Text[100];
        Values: Text[100];
        SelectCust: Integer;
        RecNo: Integer;
        valID: RecordId; 
}
