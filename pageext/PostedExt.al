page 50146 "Posted Invoice Extended Text"
{
    PageType = ListPart;
    SourceTable = "Extended Table";
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

pageextension 50145 PostedSalesExt extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Invoice Details")
        {
            group("Standard Text")
            {
                part(PostedSalesInvText; "Posted Invoice Extended Text")
                {

                     SubPageLink = "Document No." = field("No."),
        
                                  "Text Code Type" = const("Begin Text Code ");
                                  ApplicationArea=All;
                }
                   

                   
                }
            }
        }
    }
