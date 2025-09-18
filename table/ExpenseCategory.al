table 50133 "Expense Category"
{
    Caption = 'Expense Category';
    DataClassification = ToBeClassified;

    fields
    {

        field(1; Name; code[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        
        field(3; "Remaining Budget"; Decimal)
        {
            Caption = 'Remaining Budget';
            Editable = false;
           
            FieldClass = FlowField;
            CalcFormula = lookup("Budget Tracker".Amount where("Expense Category" = field(Name)));
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown;Name)
        {
        }
    }


}