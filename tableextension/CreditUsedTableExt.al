tableextension 50100 CustomerExt extends Customer
{
    fields
    {
        field(50100; "Credit Allowed"; Decimal)
        {
            Caption = 'Credit Allowed';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                
                if "Credit Allowed" < "Credit Used" then
                    Error(
                        'Credit limit exceeded!\nCredit Allowed: %.2f\nCredit Used: %.2f',
                        "Credit Allowed", "Credit Used");
            end;
        }

        field(50101; "Credit Used"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line".Amount WHERE("Sell-to Customer No." = FIELD("No.")));
            Caption = 'Credit Used';
            Editable = false;
        }
       
        field(50103;"Salesyear";Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Sales year';
            
        }
    }

    
}
