page 50234 "ZYN_Reject Reason Dialog"
{
    PageType = StandardDialog;
    Caption = 'Enter Rejection Reason';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Reason; ReasonTxt) 
                {
                    ApplicationArea = All;
                    Caption = 'Reason';
                    ToolTip = 'Enter the reason for rejecting the claim.';
                }
            }
        }
    }

    var
        ReasonTxt: Text[250];

    procedure GetReason(): Text[250]
    begin
        exit(ReasonTxt);
    end;
}
