table 50110 Subscription
{
    Caption = 'Subscription';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Subscription ID"; Code[20])
        {
            Caption = 'Subscription ID';
            DataClassification = CustomerContent;
        }

        field(2; "Plan ID"; Code[20])
        {
            Caption = 'Plan ID';
            TableRelation = "Monthly Subscription Plan"."Plan ID";
            DataClassification = CustomerContent;
        }

        field(3; "Subscriber ID"; Code[20])
        {
            Caption = 'Subscriber ID';
            TableRelation = Customer."No.";
            DataClassification = CustomerContent;
        }

        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Number of Months" > 0 then
                    CalcEndDate;
                if "Next Billing Date" = 0D then
                    "Next Billing Date" := "Start Date";
            end;
        }

        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
            Editable = false; 
            DataClassification = CustomerContent;
        }

        field(6; "Number of Months"; Integer)
        {
            Caption = 'Number of Months';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Start Date" <> 0D then
                    CalcEndDate;
            end;
        }

        field(7; "Next Billing Date"; Date)
        {
            Caption = 'Next Billing Date';
            DataClassification = CustomerContent;
        }

        field(8; "Status"; Enum "Subscription Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            InitValue=Active;
        }
    }

    keys
    {
        key(PK; "Subscription ID")
        {
            Clustered = true;
        }
    }

    local procedure CalcEndDate()
    begin
        if ("Start Date" <> 0D) and ("Number of Months" > 0) then
            "End Date" := CalcDate(StrSubstNo('<%1M>', "Number of Months"), "Start Date");
    end;
    trigger OnInsert()
    var
        LastIndex: Record "Subscription";
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        
        if "Subscription Id" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."Subscription Id", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'SUS' + PadStr(Format(LastId), 3, '0');
            "Subscription Id" := LastIdStr;
        end;
    end;
}
