page 50148 "Posted End Extended Text"
{
    PageType = ListPart;
    SourceTable = "ZYN_Extended Table";
    ApplicationArea = All;
    Caption = 'Extended Text';
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

pageextension 50144 PostedSalesEndExt extends "Posted sales Invoice"
{
    layout
    {
        addafter("Invoice Details")
        {
            group("Ending Text")
            {
                part(PostedSalesInvoiceEndText; "Posted End Extended Text")
                {
                    

                    SubPageLink = "Document No."=field("No."),
                                  "Text Code Type" = const("End Text Code");
                    ApplicationArea=All;
                }
           }
        }
    }
}