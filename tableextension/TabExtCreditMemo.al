tableextension 50129 PostedSalesCreditExt extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50126; "Begin Text Code"; Code[20])
        {
            Caption = 'Begin Text Code';
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
            
        }
    }
}

tableextension 50134 PostedSalesCreditMemoExtend extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50131; "End Text Code"; Code[20])
        {
            Caption = 'End Text Code';
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
            
        }
    }
}