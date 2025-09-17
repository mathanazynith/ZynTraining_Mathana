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
                        end else
                            Message('No file uploaded.');
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
                    if Rec.Status <> Rec.Status::"Pending Approval" then
                        Error('Only claims in Pending Approval status can be approved.');

                    if not ClaimCategoryRec.Get(Rec."Category Code", Rec."Category Name", Rec.Subtype) then
                        Error('Claim Category %1 / %2 / %3 does not exist.',
                              Rec."Category Code", Rec."Category Name", Rec.Subtype);

                    if Rec.Amount > ClaimCategoryRec."Amount Limit" then
                        Error('Amount exceeds the limit of %1 for this category.', ClaimCategoryRec."Amount Limit");

                    MaxBillDate := CalcDate('<-3M>', Rec."Claim Date");
                    if Rec."Bill Date" < MaxBillDate then
                        Error('Bill Date is more than 3 months before the Claim Date. Cannot approve.');

                    TempRec.SetRange("Employee No.", Rec."Employee No.");
                    TempRec.SetRange("Category Code", Rec."Category Code");
                    TempRec.SetRange("Subtype", Rec.Subtype);
                    TempRec.SetRange("Bill Date", Rec."Bill Date");
                    TempRec.SetRange(Status, TempRec.Status::Approved);
                    if TempRec.FindFirst() then
                        Error('Duplicate approved claim exists for the same Employee, Category, Subtype, and Bill Date.');

                    if Rec."Bill File Name" = '' then
                        Error('Bill File Name is required to approve the claim.');

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
                begin
                    if Rec.Status <> Rec.Status::"Pending Approval" then
                        Error('Only claims in Pending Approval status can be rejected.');

                    Rec.Status := Rec.Status::Rejected;
                    Rec.Modify(true);
                    Message('Claim %1 has been rejected.', Rec."Claim ID");

                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        InStr: InStream;
        FileName: Text;
}
