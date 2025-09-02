report 50127 "Posted Sales Invoice Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Posted sales invoice report';
    DefaultLayout = RDLC;
    RDLCLayout = 'PostedSalesInvoiceReport.RDL';

    dataset
    {
        dataitem(InvHeader; "Sales Invoice Header")
        {
            column(No_; "No.") { }
            column(SellToCustomerNo; "Sell-to Customer No.") { }
            column(SellToCustomerName; "Sell-to Customer Name") { }
            column(PostingDate;Format("Posting Date")) { }
            column(DocumentDate; "Document Date") { }
            column(SellToAddress; "Sell-to Address") { }
            column(company; "CompanyName") { }
            column(Address; info.Address) { }
            column(logo; info.Picture) { }

           
            dataitem(ExtBegin; "Extended Table")
            {
                DataItemLink = "Document No." = field("No.");
               
                DataItemTableView = 
                    sorting("Line No.") 
                    where(
                        "Text Code Type" = const("Text Code Enum"::"Begin Text Code "),
                        Text = filter(<> '')
                    );

                column(BeginLineNo; "Line No.") { }
                column(BeginLineText; Text) { }
            }

                       dataitem(InvLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(LineNo; "Line No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(UnitPrice; "Unit Price") { }
                column(LineAmount; "Line Amount") { }
            }

                        dataitem(ExtEnd; "Extended Table")
            {
                DataItemLink = "Document No." = field("No.");
               
                DataItemTableView = 
                    sorting("Line No.") 
                    where(
                        "Text Code Type" = const("Text Code Enum"::"End Text Code"),
                        Text = filter(<> '')
                    );

                column(EndLineNo; "Line No.") { }
                column(EndLineText; Text) { }
            }
        }
        
      
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
             DataItemLinkReference = InvHeader;
            DataItemLink = "Document No." = field("No.");

            column(CusDescription; Description)
            {
            }
            column(Amount; Amount)
            {
            }
            column(RemainingAmount; "Remaining Amount")
            {
            }
        }
    }

    var
        info: Record "Company Information";

    trigger OnPreReport()
    begin
        if info.Get() then
            info.CalcFields(Picture);
    end;
}
