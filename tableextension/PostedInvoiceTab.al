tableextension 50137 PostedSalesHeaderExt extends "Sales Invoice Header"
{
    fields
    {
        field(50118; "Begin Text Code"; Code[20])
        {
            Caption = 'Begin Text Code';
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
           
        }
         field(50126; "End Text Code"; Code[20])
        {
            Caption = 'End Text Code';
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
            
        }
        field(50127; "Begin invoice"; Code[20])
        {
            Caption = 'Begin invoice';
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
            
        }
        field(50128; "End invoice"; Code[20])
        {
            Caption = 'End invoice';
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text";
           
        }
    }
    
}

    
    
       



