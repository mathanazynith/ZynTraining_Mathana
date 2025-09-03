table 50186 "Asset Type"
{
   Caption='Asset Type';
   DataClassification=ToBeClassified;
   fields
   {
    // field(1; "Code"; Code[20])
    //     {
    //         Caption = 'Code';
    //         DataClassification = ToBeClassified;
    //     }
    field(2;"Category";enum "Asset Category")
    {
        DataClassification=ToBeClassified;
        Caption='Category';
    }
    field(3;"Name"; code[20])
    {
        DataClassification=ToBeClassified;
        Caption='Name';
    }
   }
   keys 
   {
    key (PK;"Name")
    {
    Clustered=true;
    }
    
   }
//    fieldgroups
//     {
//         fieldgroup(DropDown;Name)
//         {
//         }
//     }
}