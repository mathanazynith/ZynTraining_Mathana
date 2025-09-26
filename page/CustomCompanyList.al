page 50271 "ZYN_CustomCompanyList"
{
    Caption = 'ZynithCompanies';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZYN_CustomCompany";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique company name.';
                }
                field("Evaluation Company"; Rec."Evaluation Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this company is for evaluation purposes.';
                }
                field("Display Name"; Rec."Display Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the descriptive display name of the company.';
                }
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique system identifier (GUID) for the company.';
                }
                field("Business Profile Id"; Rec."Business Profile Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business profile identifier for integration.';
                }
                field("Is Master"; Rec."Is Master")
                {
                    ApplicationArea = All;
                }
                field("Master Company Name"; Rec."Master Company Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
