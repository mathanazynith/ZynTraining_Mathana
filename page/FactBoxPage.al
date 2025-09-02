page 50137 "Customer Overview FactBox"
{
    PageType = CardPart;
    ApplicationArea = All;
    Caption = 'Customer Overview';
    SourceTable = Customer;

    layout
    {  
        area(content)
        {
            group(ContactInfo)
            {
                Caption = 'Linked Contact';
                Visible = HasContact;
  
                field("Contact No."; ContactNo)
                {
                    ApplicationArea = All;  
                    Editable = false;
                      trigger OnDrillDown()
                    
                    begin
                        Page.Run(PAGE::"Contact Card", Contact);
                    end;
                }
                field("Contact Name"; ContactName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            cuegroup(OpenDocs)
            {
                Caption = 'Open Documents';

                field(OpenInvoicesCount; OpenInvoicesCount)
                {
                    Caption = 'Open Invoices';
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                       SalesHeader: Record "Sales Header";
                    begin
                       SalesHeader.Reset();
                       SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                       SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                       SalesHeader.SetRange(Status, SalesHeader.Status::Open);
                       PAGE.Run(PAGE::"Sales Invoice List",SalesHeader); 
                    end;  

                }

                field(OpenOrdersCount; OpenOrdersCount)
                {
                    Caption = 'Open Orders';
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.Reset();
                        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
                        PAGE.Run(PAGE::"Sales Order List", SalesHeader);
                    end;
                }
            }
        }
    }

    var
        Contact: Record Contact;
        
        SalesHeader: Record "Sales Header";
        ContactNo: Code[20];
        ContactName: Text[100];
        OpenInvoicesCount: Integer;
        OpenOrdersCount: Integer;
        HasContact: Boolean;

    trigger OnAfterGetRecord()
    begin
        Clear(ContactNo);
        Clear(ContactName);
        HasContact := false;

        
        if Rec."Primary Contact No." <> '' then begin
            if Contact.Get(Rec."Primary Contact No.") then begin
                ContactNo := Contact."No.";
                ContactName := Contact.Name;
                HasContact := true;
            end;
        end;

        
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        OpeninvoicesCount := SalesHeader.Count;

        
        SalesHeader.Reset();
        SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        OpenOrdersCount := SalesHeader.Count;
    end;
}
