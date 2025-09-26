pageextension 50112 CustomerCardExtExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            group("Credit Info")
            {
                field("Credit Allowed"; Rec."Credit Allowed")
                {
                    ApplicationArea = All;
                }
                field("Credit Used"; Rec."Credit Used")
                {
                    ApplicationArea = All;
                }

                  field("Sales Year"; Rec."Salesyear")
            {
                ApplicationArea = All;
            }
                 
 
            
            
        }
    }
}
}