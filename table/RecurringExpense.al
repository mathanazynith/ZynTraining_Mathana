table 50150 "ZYN_Recurring Expense"
{
    Caption = 'Recurring Expense';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Recurring ID"; Code[20])
        {
            Caption = 'Recurring ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Category Code"; Code[20])
        {
            Caption = 'Category';
            TableRelation = "ZYN_Expense Category".Name;
        }

        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
        }

        field(4; Cycle; Enum "ZYN_Expense Cycle")
        {
            Caption = 'Cycle';
            trigger OnValidate()
            begin
                CalcNextCycleDate();
            end;
        }

        field(6; "Start Date"; Date)
        {
            Caption = 'Start Date';
            trigger OnValidate()
            begin
                CalcNextCycleDate();
            end;
        }

        field(7; "Next Cycle Date"; Date)
        {
            Caption = 'Next Cycle Date';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Recurring ID") { Clustered = true; }
    
    }
    trigger OnInsert()
    var
        LastIndex: Record "ZYN_Recurring Expense";
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        
        if "Recurring ID" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."Recurring ID", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'BUD' + PadStr(Format(LastId), 3, '0');
            "Recurring ID" := LastIdStr;
        end;
    end;

    trigger OnModify()
    begin
        CalcNextCycleDate();
    end;

        local procedure CalcNextCycleDate()
    var
        NextDate: Date;
    begin
        if ("Start Date" = 0D) then
            exit;

        case Cycle of
            Cycle::Weekly:        NextDate := CalcDate('<+1W>', "Start Date");
            Cycle::Monthly:       NextDate := CalcDate('<+1M>', "Start Date");
            Cycle::Quarterly:     NextDate := CalcDate('<+3M>', "Start Date");
            Cycle::"Half Yearly": NextDate := CalcDate('<+6M>', "Start Date");
            Cycle::Yearly:        NextDate := CalcDate('<+1Y>', "Start Date");
        end;

        "Next Cycle Date" := NextDate;
    end;
} 