page 50130 "Customer List Extended"
{
    PageType = List;
    SourceTable = Customer;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Customer List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Name"; Rec.Name) { ApplicationArea = All; }
                field("Address"; Rec.Address) { ApplicationArea = All; }
                field("Post Code"; Rec."Post Code") { ApplicationArea = All; }
                field("State"; Rec."State Inscription") { ApplicationArea = All; }
                field("City"; Rec.City) { ApplicationArea = All; }
                field("Phone No."; Rec."Phone No.") { ApplicationArea = All; }
            }

            part(SalesOrders; "ZYN_Customer Sales Orders")
            {
                SubPageLink = "Sell-to Customer No." = field("No.");
                ApplicationArea = All;
            }

            part(SalesInvoices; "ZYN_Customer Sales Invoices")
            {
                SubPageLink = "Sell-to Customer No." = field("No.");
                ApplicationArea = All;
            }

            part(SalesCreditMemos; "ZYN_CustomerSalesCreditMemos")
            {
                SubPageLink = "Sell-to Customer No." = field("No.");
                ApplicationArea = All;
            }
        }
    }

}
