table 50137 "ZYN_Expense Tracker"
{
    Caption = 'Expense Tracker';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Expense Id"; Code[20])
        {
            Caption = 'Expense Id';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(5; Category; Code[20])
        {
            Caption = 'Category';
           
           TableRelation = "ZYN_Expense Category".Name;
            DataClassification = ToBeClassified;
            trigger OnValidate()
var
    ExpenseCategory: Record "ZYN_Expense Category";
    Budget: Record "ZYN_Budget Tracker";
    Expense: Record "ZYN_Expense Tracker";
    WorkDt: Date;
    start : date;
    enddt:date;
begin
    
    WorkDt := WorkDate;
    start := DMY2Date(1, Date2DMY(WorkDt, 2), Date2DMY(WorkDt, 3));
    enddt := CalcDate('<CM>', start);
    

    
    Budget.Reset();
    Budget.SetRange("Expense Category", Rec."Category");
    Budget.SetRange("From Date", start, enddt);
    Budget.CalcSums(Amount);

    
    Expense.Reset();
    Expense.SetRange("Category", Rec."Category");
    Expense.SetRange(Date, start, enddt);
    Expense.CalcSums(Amount);

    
    RemainingBudget := Budget.Amount - Expense.Amount;
end;

           
        }
        field(6; "RemainingBudget"; Decimal)
        {
            Caption = 'Remaining Budget (Month)';
            Editable = false;
            DataClassification = ToBeClassified;
            
        
    }
    }
        
        
        
        
       
    

    keys
    {
        key(PK; "Expense Id")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(dropdown;Category)
        {
        }
        
    }
    trigger OnInsert()
    var
    LastIndex: Record "ZYN_Expense Tracker";
    LastId: Integer;
    LastIdStr: Code[20];
    begin
        if "Expense Id" = '' then begin
        if LastIndex.FindLast() then begin
            
            Evaluate(LastId, CopyStr(LastIndex."Expense Id", 4)); 
        end else
            LastId := 0;
 
        LastId += 1;
 
        
        LastIdStr := 'Exp' + PadStr(Format(LastId), 3, '0');
        "Expense Id" := LastIdStr;
        end;
    end;
   

}