page 50126 "ZYN_Posted Credit End  Text"
{
    PageType = ListPart;
    SourceTable = "ZYN_Extended Table";
    ApplicationArea = All;
    Caption = 'Text Added';
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

pageextension 50147 CreditEndExt extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Electronic Invoice")
        {
            group("AddedEnd Text")
            {
                part(PostedCreditInvoiceEndText; "ZYN_Posted Credit End  Text")
                {

                    SubPageLink = "Document No." = field("No."),
                    "Text Code Type"=const("End Text Code");
                    ApplicationArea = All;
                }
            }
        }
    }
}
