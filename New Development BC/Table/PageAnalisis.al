namespace PR;

using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Setup;


table 60102 AnalisisPage
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Dept Code"; Code[20])
        {
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));
        }
        field(2; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));

        }
        field(3; COA; Code[20])
        {
            Caption = 'Chart Of Account';
            TableRelation = "Gen. Product Posting Group";
        }
    }

    keys
    {
        key(Key1; "Dept Code")
        {
            Clustered = true;
        }
    }

}