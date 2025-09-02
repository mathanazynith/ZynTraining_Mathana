table 50136 "IncomeTracker"
{
    Caption = 'Income Tracker';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Income Id"; Code[20])
        {
            Caption = 'Income Id';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(5; InCategory; Code[20])
        {
            Caption = 'Income Category';
           
           TableRelation = "Income Category".Name;
            DataClassification = ToBeClassified;
           
        }
       
        
       
    }

    keys
    {
        key(PK; "Income Id")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(dropdown;InCategory)
        {
        }
        
    }
    trigger OnInsert()
    var
    LastIndex: Record "IncomeTracker";
    LastId: Integer;
    LastIdStr: Code[20];
    begin
        if "Income Id" = '' then begin
        if LastIndex.FindLast() then begin
            
            Evaluate(LastId, CopyStr(LastIndex."Income Id", 4)); 
        end else
            LastId := 0;
 
        LastId += 1;
 
        
        LastIdStr := 'Inc' + PadStr(Format(LastId), 3, '0');
        "Income Id" := LastIdStr;
        end;
    end;
   

}