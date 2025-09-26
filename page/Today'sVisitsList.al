page 50120 "Today's Visits List"
{
    PageType = List;
    SourceTable = "ZYN_Visit Log";
    ApplicationArea = All;
    Caption = 'Customer Visits';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No.";Rec. "Entry No.") { ApplicationArea = All; }
                field("Customer No.";Rec. "Customer No.") { ApplicationArea = All; }
                field("Visit Date"; Rec."Visit Date") { ApplicationArea = All; }
            }
        }
    }

    trigger OnInit()
    var
        Today: Date;
    begin
        Today := WorkDate();
        Rec.SetRange("Visit Date", Today);
    end;
}
