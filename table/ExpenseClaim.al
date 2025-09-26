table 50226 "ZYN_Expense Claim"
{
    Caption = 'Expense Claim';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Claim ID"; Code[20])
        {
            Caption = 'Claim ID';
            Editable = false;
            DataClassification = CustomerContent;
        }
    field(2; "Category Code"; Code[20])
        {    
            Caption = 'Category Code';
            DataClassification = CustomerContent;
        }

        field(3; "Category Name"; Text[100])
        {
            Caption = 'Category Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; Subtype; Text[50])
        {
            Caption = 'Subtype';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(5; "Employee No."; Code[40])
        {
            Caption = 'Employee No.';
            TableRelation = "ZYN_Employee Table"."Employee Id";
            DataClassification = CustomerContent;
        }

        field(6; "Claim Date"; Date)
        {
            Caption = 'Claim Date';
            DataClassification = CustomerContent;
        }

        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateClaimAmount;
            end;
        }

        field(8; Status; Enum "ZYN_Expense Claim Status")
        {
            Caption = 'Status';
            InitValue = "Pending Approval";
            Editable = false;
        }

        field(9; "Bill Proof"; Blob)
        {
            Caption = 'Bill Proof';
            Subtype = Memo;
        }

        field(10; Remarks; Text[40])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }

        field(11; "Bill Date"; Date)
        {
            Caption = 'Bill Date';
            DataClassification = CustomerContent;
        }
        field(12; "Bill File Name"; Text[250])
        {
            Caption = 'Bill File Name';
            DataClassification = ToBeClassified;
        }
        field(13; "Rejection Reason"; Text[100])
        {
            Caption = 'Rejection Reason';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Claim ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        LastIndex: Record "ZYN_Expense Claim";
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        if "Claim ID" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."Claim ID", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'CLA' + PadStr(Format(LastId), 3, '0');
            "Claim ID" := LastIdStr;
        end;
    end;

    local procedure ValidateClaimAmount()
    var
        ClaimCategoryRec: Record "ZYN_Claim Category";
        ExistingClaim: Record "ZYN_Expense Claim";
        ClaimYear: Integer;
        YearlyUsed: Decimal;
        StartOfYear: Date;
        EndOfYear: Date;
        ErrMsgCategory: Text;
        ErrMsgLimit: Text;
    begin
        ClaimYear := Date2DMY("Claim Date", 3);

        ErrMsgCategory := 'Claim Category %1 / %2 / %3 does not exist.';
        ErrMsgLimit := 'Amount exceeds yearly limit. For Category %1 (%2), yearly limit is %3, already used %4, remaining %5.';
        if not ClaimCategoryRec.Get("Category Code", "Category Name", Subtype) then
            Error(ErrMsgCategory, "Category Code", "Category Name", Subtype);
        YearlyUsed := 0;
        ExistingClaim.Reset();
        ExistingClaim.SetRange("Employee No.", "Employee No.");
        ExistingClaim.SetRange("Category Code", "Category Code");
        ExistingClaim.SetRange(Subtype, Subtype);
        ExistingClaim.SetRange(Status, ExistingClaim.Status::Approved);

        StartOfYear := CalcDate('<CY>', "Claim Date");
        EndOfYear := CalcDate('<CY+1Y-1D>', "Claim Date");
        ExistingClaim.SetFilter("Claim Date", '%1..%2', StartOfYear, EndOfYear);

        if ExistingClaim.FindSet() then
            repeat
                YearlyUsed += ExistingClaim.Amount;
            until ExistingClaim.Next() = 0;


        if (YearlyUsed + Amount) > ClaimCategoryRec."Amount Limit" then
            Error(
              ErrMsgLimit,
              "Category Code", Subtype,
              ClaimCategoryRec."Amount Limit",
              YearlyUsed,
              ClaimCategoryRec."Amount Limit" - YearlyUsed);
    end;
}
