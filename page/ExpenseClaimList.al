page 50229 "Expense Claim List"
{
    PageType = List;
    SourceTable = "Expense Claim";
    Caption = 'Expense Claim List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Expense Claim Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;

                field("Claim ID"; Rec."Claim ID")
                {
                    ApplicationArea = All;
                }
                field("Category"; Rec."Category Code")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Category Name"; Rec."Category Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Claim Date"; Rec."Claim Date")
                {
                    ApplicationArea = All;
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ApplicationArea = All;
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Remarks"; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
                field("Subtype"; Rec.Subtype)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CancelClaim)
            {
                Caption = 'Cancel Claim';
                Image = Delete;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ConfirmMsg: Label 'Are you sure you want to cancel this claim?';
                begin

                    if Rec.Status = Rec.Status::Approved then
                        Error('Approved claims cannot be cancelled.');
                    if Rec.Status = Rec.Status::Rejected then
                        Error('Rejected claims cannot be cancelled.');
                    if Rec.Status = Rec.Status::Cancelled then
                        Error('This claim is already cancelled.');

                    if Rec.Status <> Rec.Status::"Pending Approval" then
                        Error('Only claims in Pending Approval status can be cancelled.');


                    if Confirm(ConfirmMsg, false) then begin
                        Rec.Status := Rec.Status::Cancelled;
                        Rec.Modify(true);
                        Message('Claim %1 has been cancelled.', Rec."Claim ID");
                    end;
                end;
            }
        }
    }
}
