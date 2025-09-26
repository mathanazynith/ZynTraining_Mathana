page 50113 "ZYN_Log List card"
{
    PageType = Card;
    SourceTable = "ZYN_Visit Log";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(general)
            {
                Caption = 'Log Entry Details';
                field("Entry No."; Rec."Entry No.") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Visit Date"; Rec."Visit Date") { }
                field(Purpose; Rec.Purpose) { }
                field("Notes"; Rec."Notes") { }
            }

        }
    }


}

















