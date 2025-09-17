page 50231 "Expense Claim Card"
{
    PageType = Card;
    SourceTable = "Expense Claim";
    Caption = 'Expense Claim';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Claim ID"; Rec."Claim ID") { ApplicationArea = All; }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        ClaimCategoryRec: Record "Claim Category";
                        SelectedCategoryCode: Code[20];
                    begin
                        if PAGE.RunModal(PAGE::"Claim Category List", ClaimCategoryRec) = ACTION::LookupOK then begin
                            SelectedCategoryCode := ClaimCategoryRec.Code;
                            Rec."Category Code" := SelectedCategoryCode;
                            Rec."Category Name" := ClaimCategoryRec.Name;
                            Rec.Subtype := ClaimCategoryRec.Subtype;
                        end else
                            Message('No Category selected.');
                    end;
                }
                field("Category Name"; Rec."Category Name") { ApplicationArea = All; Editable = false; }
                field("Employee No."; Rec."Employee No.") { ApplicationArea = All; }
                field("Claim Date"; Rec."Claim Date") { ApplicationArea = All; }
                field("Bill Date"; Rec."Bill Date") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Remarks; Rec.Remarks) { ApplicationArea = All; MultiLine = true; }
                field(Subtype; Rec.Subtype) { ApplicationArea = All; Editable = false; }

                field("Bill File Name"; Rec."Bill File Name")
                {
                    Caption = 'Uploaded File';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        if Rec."Bill Proof".HasValue then begin
                            Rec."Bill Proof".CreateInStream(InStr);

                            if Rec."Bill File Name" = '' then
                                Rec."Bill File Name" := Rec."Claim ID" + '_BillProof';


                            DownloadFromStream(InStr, '', '', '', Rec."Bill File Name");
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
            action(UploadBillProof)
            {
                Caption = 'Upload Bill Proof';
                ApplicationArea = All;

                trigger OnAction()
                var
                    FileName: Text;
                begin
                    if UploadIntoStream('Select a file', '', '', FileName, InStr) then begin
                        Rec."Bill Proof".CreateOutStream(OutStr);
                        CopyStream(OutStr, InStr);

                        Rec."Bill File Name" := FileName;
                        Rec.Modify(true);

                        Message('File "%1" uploaded.', FileName);
                    end;
                end;
            }
        }
    }

    var
        InStr: InStream;
        OutStr: OutStream;
}
