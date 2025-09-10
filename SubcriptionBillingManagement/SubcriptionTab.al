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
                    CalcEndDate();
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
                    CalcEndDate();
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
            InitValue = Active;
        }

        field(9; "Next Renewal Date"; Date)
        {
            Caption = 'Next Renewal Date';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(10; "Reminder Sent"; Boolean)
        {
            Caption = 'Reminder Sent';
            DataClassification = CustomerContent;
            InitValue = false;
        }
    }

    keys
    {
        key(PK; "Subscription ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        LastIndex: Record Subscription;
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        
        if "Subscription ID" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."Subscription ID", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'SUS' + PadStr(Format(LastId), 3, '0');
            "Subscription ID" := LastIdStr;
        end;

    
        if "Number of Months" > 0 then
            CalcEndDate();

    
        if "Next Billing Date" = 0D then
            "Next Billing Date" := "Start Date";

        
        UpdateNextRenewalDate();
    end;

    trigger OnModify()
    begin
        UpdateNextRenewalDate();
    end;

    local procedure CalcEndDate()
    begin
        if ("Start Date" <> 0D) and ("Number of Months" > 0) then
            "End Date" := CalcDate(StrSubstNo('<%1M>', "Number of Months"), "Start Date")
        else
            "End Date" := 0D;

    
        UpdateNextRenewalDate();
    end;

    local procedure UpdateNextRenewalDate()
    begin
        if "End Date" <> 0D then
            "Next Renewal Date" := CalcDate('<+1D>', "End Date")
        else
            "Next Renewal Date" := 0D;
    end;
}
