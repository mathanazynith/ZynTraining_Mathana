page 50229 "ZYN_Expense Claim List"
{
    PageType = List;
    SourceTable = "ZYN_Expense Claim";
    Caption = 'Expense Claim List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "ZYN_Expense Claim Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;

                field("Claim ID"; Rec."Claim ID") { ApplicationArea = All; }
                field("Category"; Rec."Category Code") { ApplicationArea = All; }
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Category Name"; Rec."Category Name") { ApplicationArea = All; Editable = false; }
                field("Claim Date"; Rec."Claim Date") { ApplicationArea = All; }
                field("Bill Date"; Rec."Bill Date") { ApplicationArea = All; }
                field("Amount"; Rec.Amount) { ApplicationArea = All; }
                field("Status"; Rec.Status) { ApplicationArea = All; }
                field("Remarks"; Rec.Remarks) { ApplicationArea = All; }
                field("Subtype"; Rec.Subtype) { ApplicationArea = All; }
                field("Rejection Reason"; Rec."Rejection Reason") { ApplicationArea = All; Editable = false;  }
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
                    if Rec.Status = Rec.Status::Approved then begin
                        ErrorMsg := 'Approved claims cannot be cancelled.';
                        Error(ErrorMsg);
                    end;

                    if Rec.Status = Rec.Status::Rejected then begin
                        ErrorMsg := 'Rejected claims cannot be cancelled.';
                        Error(ErrorMsg);
                    end;

                    if Rec.Status = Rec.Status::Cancelled then begin
                        ErrorMsg := 'This claim is already cancelled.';
                        Error(ErrorMsg);
                    end;

                    if Rec.Status <> Rec.Status::"Pending Approval" then begin
                        ErrorMsg := 'Only claims in Pending Approval status can be cancelled.';
                        Error(ErrorMsg);
                    end;

                    if Confirm(ConfirmMsg, false) then begin
                        Rec.Status := Rec.Status::Cancelled;
                        Rec.Modify(true);
                        Message('Claim %1 has been cancelled.', Rec."Claim ID");
                    end;
                end;
            }
        }
    }

    var
        ErrorMsg: Text;
}
