report 50100 "Item List Report"
{
    Caption = 'Item List Report';
    ProcessingOnly = false;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'ItemListReport.RDL'; 

    dataset
    {
        dataitem(Item; Item)
        {
            column(No_; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Base_Unit_of_Measure; "Base Unit of Measure")
            {
            }
            column(Unit_Cost; "Unit Cost")
            {
            }
            column(Inventory; Inventory)
            {
            }
        }
    }
}