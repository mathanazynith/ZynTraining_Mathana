table 50300 "Recurring Sales Invoice"
{
    Caption = 'Recurring Sales Invoice';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Recurring Invoice ID"; Code[20])
        {
            Caption = 'Recurring Invoice ID';
            DataClassification = CustomerContent;
        }

        field(2; "Subscription ID"; Code[20])
        {
            Caption = 'Subscription ID';
            TableRelation = Subscription."Subscription ID";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                SetAmountsFromSubscription();
            end;
        }

        field(3; "Plan Amount"; Decimal)
        {
            Caption = 'Plan Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(4; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            InitValue = Invoice; 
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Recurring Invoice ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        LastIndex: Record "Recurring Sales Invoice";
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        
        if "Recurring Invoice ID" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."Recurring Invoice ID", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'INV' + PadStr(Format(LastId), 3, '0');
            "Recurring Invoice ID" := LastIdStr;
        end;

        
        SetAmountsFromSubscription();
    end;

    procedure SetAmountsFromSubscription()
    var
        Sub: Record Subscription;
        Plan: Record "Monthly Subscription Plan";
    begin
        "Plan Amount" := 0;

        if ("Subscription ID" <> '') and Sub.Get("Subscription ID") then
            if Plan.Get(Sub."Plan ID") then
                "Plan Amount" := Plan.Fees;
    end;
}
