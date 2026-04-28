table 70003 TblCompItemMapping
{
    //DataClassification = ToBeClassified;

    fields
    {
        field(1; CustCode; Code[20])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Customer';
            TableRelation = Customer."No.";

        }

        field(2; CompGroupId; Code[20])
        {
            Caption = 'Complimentary Item Group';
            TableRelation = TblCompItemSetup.CompGroupId WHERE(CompAllCustomer = FILTER(= false));
        }

        field(3; CompMappingDesc; Text[300])
        {
            Caption = 'Description';
            //TableRelation = TblCompItemSetup.CompGroupId WHERE(CompAllCustomer = FILTER(= false));

        }
    }

    keys
    {
        key(PK1; CustCode, CompGroupId)
        {
            Clustered = true;
        }
    }

}