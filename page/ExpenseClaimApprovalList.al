page 50233 "Expense Claim Approval List"
{
    PageType = List;
    SourceTable = "Expense Claim";
    Caption = 'Expense Claim Approval List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = where(Status = const("Pending Approval"));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Claim ID"; Rec."Claim ID") { ApplicationArea = All; }
                field("Category"; Rec."Category Code") { ApplicationArea = All; }
                field("Category Name"; Rec."Category Name") { ApplicationArea = All; }
                field("Subtype"; Rec.Subtype) { ApplicationArea = All; }
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Claim Date"; Rec."Claim Date") { ApplicationArea = All; }
                field("Bill Date"; Rec."Bill Date") { ApplicationArea = All; }
                field("Amount"; Rec.Amount) { ApplicationArea = All; }
                field("Status"; Rec.Status) { ApplicationArea = All; }
                field("Remarks"; Rec.Remarks) { ApplicationArea = All; }
                field("Rejection Reason"; Rec."Rejection Reason") { ApplicationArea = All; Editable = false; }

                field("Bill File Name"; Rec."Bill File Name")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        if Rec."Bill Proof".HasValue then begin
                            Rec."Bill Proof".CreateInStream(InStr);
                            if Rec."Bill File Name" = '' then
                                FileName := Rec."Claim ID" + '_BillProof'
                            else
                                FileName := Rec."Bill File Name";
                            DownloadFromStream(InStr, '', '', '', FileName);
                        end else begin
                            ErrorMsg := 'No file uploaded.';
                            Error(ErrorMsg);
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ApproveClaim)
            {
                Caption = 'Approve Claim';
                ApplicationArea = All;
                Image = Approve;

                trigger OnAction()
                var
                    ClaimCategoryRec: Record "Claim Category";
                    TempRec: Record "Expense Claim";
                    MaxBillDate: Date;
                begin
                    if Rec.Status <> Rec.Status::"Pending Approval" then begin
                        ErrorMsg := 'Only claims in Pending Approval status can be approved.';
                        Error(ErrorMsg);
                    end;

                    if not ClaimCategoryRec.Get(Rec."Category Code", Rec."Category Name", Rec.Subtype) then begin
                        ErrorMsg := StrSubstNo(
                          'Claim Category %1 / %2 / %3 does not exist.',
                          Rec."Category Code", Rec."Category Name", Rec.Subtype);
                        Error(ErrorMsg);
                    end;

                    if Rec.Amount > ClaimCategoryRec."Amount Limit" then begin
                        ErrorMsg := StrSubstNo(
                          'Amount exceeds the limit of %1 for this category.',
                          ClaimCategoryRec."Amount Limit");
                        Error(ErrorMsg);
                    end;

                    MaxBillDate := CalcDate('<-3M>', Rec."Claim Date");
                    if Rec."Bill Date" < MaxBillDate then begin
                        ErrorMsg:= 'Bill Date is more than 3 months before the Claim Date. Cannot approve.';
                        Error(ErrorMsg);
                    end;

                    TempRec.SetRange("Employee No.", Rec."Employee No.");
                    TempRec.SetRange("Category Code", Rec."Category Code");
                    TempRec.SetRange("Subtype", Rec.Subtype);
                    TempRec.SetRange("Bill Date", Rec."Bill Date");
                    TempRec.SetRange(Status, TempRec.Status::Approved);
                    if TempRec.FindFirst() then begin
                        ErrorMsg:= 'Duplicate approved claim exists for the same Employee, Category, Subtype, and Bill Date.';
                        Error(ErrorMsg);
                    end;

                    if Rec."Bill File Name" = '' then begin
                        ErrorMsg := 'Bill File Name is required to approve the claim.';
                        Error(ErrorMsg);
                    end;

                    Rec.Status := Rec.Status::Approved;
                    Rec.Modify(true);
                    Message('Claim %1 approved successfully.', Rec."Claim ID");

                    CurrPage.Update(false);
                end;
            }

             action(RejectClaim)
            {
                Caption = 'Reject Claim';
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                var
                    ReasonLocal: Text[250]; 
                begin
                    if Rec.Status <> Rec.Status::"Pending Approval" then
                        Error('Only claims in Pending Approval status can be rejected.');

                    if Confirm('Do you want to reject this claim?', false) then begin
                        if RejectReasonDlg.RunModal() = Action::OK then begin
                            ReasonLocal := RejectReasonDlg.GetReason();
                            if ReasonLocal = '' then
                                Error('Rejection reason is required.');

                            Rec.Status := Rec.Status::Rejected;
                            Rec."Rejection Reason" := ReasonLocal;
                            Rec.Modify(true);

                            Message('Claim %1 rejected. Reason: %2', Rec."Claim ID", ReasonLocal);
                            CurrPage.Update(false);
                        end;
                    end;
                end;
            }
        }
    }

    var
        ErrorMsg: Text;
        InStr: InStream;
        RejectReasonDlg: Page "Reject Reason Dialog";
        FileName: Text[250];
}
