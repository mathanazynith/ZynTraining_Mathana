table 50200 "Monthly Subscription Plan"
{
    Caption = 'Monthly Subscription Plan';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Plan ID"; Code[20])
        {
            Caption = 'Plan ID';
            DataClassification = CustomerContent;
        }

        field(2; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }

        field(3; "Fees"; Decimal)
        {
            Caption = 'Fees';
            DataClassification = CustomerContent;
        }

        field(4; "Status"; Enum "Plan Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            
            InitValue = Active;
        }

        field(5; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Plan ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        LastIndex: Record "Monthly Subscription Plan";
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        if "Plan ID" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."Plan ID", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'PLA' + PadStr(Format(LastId), 3, '0');
            "Plan ID" := LastIdStr;
        end;
    end;

    trigger OnDelete()
    begin
        
        InactivateSubscriptions("Plan ID");
    end;

    
    procedure InactivateSubscriptions(PlanId: Code[20])
    var
        Sub: Record Subscription;
    begin
        if PlanId = '' then
            exit;

        Sub.Reset();
        Sub.SetRange("Plan ID", PlanId);
        if Sub.FindSet() then
            repeat
                if Sub.Status <> Sub.Status::Inactive then begin
                    Sub.Status := Sub.Status::Inactive;
                    Sub.Modify(true);
                end;
            until Sub.Next() = 0;
    end;
}
