page 50144 "Posted Credit Extended Text"
{
    PageType = ListPart;
    SourceTable = "Extended Table";
    ApplicationArea = All;
    Caption = 'Text Displayed';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field("Text"; Rec.Text) { ApplicationArea = All; }
            }
        }
    }
}

pageextension 50135 PostedCreditExt extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Electronic Invoice")
        {
            group("Added Text")
            {
                part(PostedCreditInvText; "Posted Credit Extended Text")
                {

                    SubPageLink = "Document No." = field("No."),
                    "Text Code Type"=const("Begin Text Code " );
                   

                    ApplicationArea = All;
                }
            }
        }
    }
}