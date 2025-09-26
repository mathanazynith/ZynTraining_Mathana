table 50271 "ZYN_CustomCompany"
{
    Caption = 'ZYN Companies';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the unique identifier for the company. This value cannot be changed after creation.';

            trigger OnValidate()
            begin
                OnBeforeModify();
            end;
        }
        field(2; "Evaluation Company"; Boolean)
        {
            Caption = 'Evaluation Company';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether this company is marked as an evaluation company.';
        }
        field(3; "Display Name"; Text[250])
        {
            Caption = 'Display Name';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the display name of the company.';
        }
        field(4; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the unique system-generated GUID for this company.';
        }
        field(5; "Business Profile Id"; Text[250])
        {
            Caption = 'Business Profile Id';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the business profile identifier associated with the company.';
        }
        field(6; "Skip Sync"; Boolean)
        {
            Caption = 'Skip Sync';
            DataClassification = SystemMetadata;
            Editable = false;
            ToolTip = 'Specifies whether this company should be skipped during synchronization.';
        }
        field(7; "Is Master"; Boolean)
        {
            Caption = 'Is Master Company';
            ToolTip = 'Specifies whether this company is the master company. Only one company can be set as master.';

            trigger OnValidate()
            begin
                ValidateIsMaster();
            end;
        }
        field(8; "Master Company Name"; Text[30])
        {
            Caption = 'Master Company Name';
            TableRelation = "ZYN_CustomCompany".Name WHERE("Is Master" = CONST(true));
            ToolTip = 'Specifies the master company this company belongs to. Leave blank if this is a standalone company.';
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }

    local procedure OnBeforeModify()
    begin
        if XRec.Name <> '' then
            Error(PrimaryKeyErr);
    end;

    local procedure ValidateIsMaster()
    var
        CompanyRec: Record "ZYN_CustomCompany";
    begin
        if "Is Master" then begin
            CompanyRec.Reset();
            CompanyRec.SetRange("Is Master", true);
            if CompanyRec.FindFirst() and (CompanyRec.Name <> Rec.Name) then
                Error(MasterExistsErr, CompanyRec.Name);
        end;
    end;

    var
        PrimaryKeyErr: Label 'Changing the primary key (Name) is not allowed.';
        MasterExistsErr: Label 'Only one company can be set as Master. Master is already "%1".';
}
