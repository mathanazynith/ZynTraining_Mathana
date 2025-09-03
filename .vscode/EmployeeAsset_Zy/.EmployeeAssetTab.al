table 50196 "Employee Asset"
{
    Caption = 'Employee Asset';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            TableRelation = "Employee Table"."Employee ID";
            DataClassification = CustomerContent;
        }

        field(2; "Serial No."; Code[40])
        {
            Caption = 'Serial No.';
            TableRelation = Assets."Serial No.";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcAvailability();
            end;
        }

        field(3; Status; Enum "Asset Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalcAvailability();
            end;
        }

        field(4; "Assigned Date"; Date)
        {
            Caption = 'Assigned Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalcAvailability();
            end;
        }

        field(5; "Returned Date"; Date)
        {
            Caption = 'Returned Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalcAvailability();
            end;
        }

        field(6; "Lost Date"; Date)
        {
            Caption = 'Lost Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalcAvailability();
            end;
        }

        field(7; Availability; Boolean)
        {
            Caption = 'Availability';
            Editable = false;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Employee ID", "Serial No.") { Clustered = true; }
    }

    procedure CalcAvailability()
    var
        AssetRec: Record Assets;
        EmpAsset: Record "Employee Asset";
        ValidUntil: Date;
        LatestReturnDate: Date;
    begin
        Availability := false;

        if ("Serial No." = '') or not AssetRec.Get("Serial No.") then
            exit;

        // Valid until 5 years from Procured Date
        if AssetRec."Procured Date" <> 0D then
            ValidUntil := CalcDate('+5Y', AssetRec."Procured Date")
        else
            ValidUntil := DMY2Date(31, 12, 9999);

        LatestReturnDate := GetLatestReturnDate("Serial No.");

        case Status of
            Status::Assigned:
                begin
                    // Prevent assigning asset already assigned
                    EmpAsset.Reset();
                    EmpAsset.SetRange("Serial No.", "Serial No.");
                    EmpAsset.SetRange(Status, EmpAsset.Status::Assigned);
                    if EmpAsset.FindFirst() then
                        if EmpAsset."Employee ID" <> "Employee ID" then
                            Error('Asset %1 is already assigned to employee %2.',
                                  "Serial No.", EmpAsset."Employee ID");

                    // Prevent assigning asset that was lost
                    EmpAsset.Reset();
                    EmpAsset.SetRange("Serial No.", "Serial No.");
                    EmpAsset.SetRange(Status, EmpAsset.Status::Lost);
                    if EmpAsset.FindFirst() then
                        Error('Asset %1 has been marked as Lost and cannot be re-assigned.', "Serial No.");

                    if ("Assigned Date" <> 0D) and ("Assigned Date" <= ValidUntil) then
                        Availability := true;
                end;

            Status::Returned:
                begin
                    if ("Returned Date" <> 0D) and ("Returned Date" <= ValidUntil) then
                        Availability := true;
                end;

            Status::Lost:
                begin
                    Availability := false;

                    if "Lost Date" = 0D then
                        Error('Lost assets must have a Lost Date.');
                end;
        end;

        // Expired assets are never available
        if (ValidUntil <> 0D) and (Today > ValidUntil) then
            Availability := false;
    end;

    local procedure GetLatestReturnDate(SerialNo: Code[40]): Date
    var
        EA: Record "Employee Asset";
    begin
        EA.Reset();
        EA.SetRange("Serial No.", SerialNo);
        EA.SetRange(Status, EA.Status::Returned);
        EA.SetCurrentKey("Returned Date");
        if EA.FindLast() then
            exit(EA."Returned Date");
        exit(0D);
    end;

    trigger OnDelete()
    begin
        case Status of
            Status::Assigned:
                Error('You cannot delete this record because the asset %1 is still assigned to employee %2.',
                      "Serial No.", "Employee ID");

            Status::Returned,
            Status::Lost:
                exit;
        end;
    end;
}
