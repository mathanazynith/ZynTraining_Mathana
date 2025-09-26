table 50108 "ZYN_Budget Tracker"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Budget Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Budget Id';
        }

        field(2; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
        }

        field(3; "To Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'To Date';
        }

        field(4; "Expense Category"; Code[20])
        {
            Caption = 'Expense Category';
            TableRelation = "ZYN_Expense Category"; 
            DataClassification = CustomerContent;
             trigger OnValidate()
            var
                BudgetRec: Record "ZYN_Budget Tracker";
            begin
                if ("From Date" <> 0D) and ("To Date" <> 0D) then begin
                    BudgetRec.Reset();
                    BudgetRec.SetRange("Expense Category", "Expense Category");
                    BudgetRec.SetRange("From Date", "From Date");
                    BudgetRec.SetRange("To Date", "To Date");
                    if BudgetRec.FindFirst() then
                        Error(
                          'A budget for category %1 already exists for this month (%2 - %3).',
                          "Expense Category", "From Date", "To Date");
                end;
            end;
        }

        field(5; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
    }

    keys
    {
        key(PK;  "Expense Category","From Date", "To Date")
        {
            Clustered = true;
        }
        
        
    }
    trigger OnInsert()
    var
        LastIndex: Record "ZYN_Budget Tracker";
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        
        if "Budget Id" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."Budget Id", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'BUD' + PadStr(Format(LastId), 3, '0');
            "Budget Id" := LastIdStr;
        end;
    end;
}