table 70004 TblCompItemSetup
{
    //DataClassification = ToBeClassified;

    fields
    {
        field(501051; CompGroupId; Code[20])
        {
            Caption = 'Complimentary Group Id';
            //DataClassification = ToBeClassified;
        }

        field(501052; CompGroupDesc; Text[300])
        { Caption = 'Description'; }
        field(501053; CompMainItem; Code[20])
        {
            Caption = 'Main Item Code';
            TableRelation = Item."No.";
        }

        field(501054; ComplimentaryItem1; Code[20])
        {
            Caption = 'Complimentary Item Code';
            TableRelation = Item."No.";
        }

        field(501055; ComplimentaryItem2; Code[20])
        {
            Caption = 'Complimentary Item Code 2';
            TableRelation = Item."No.";
        }

        field(501056; "Main Item Qty"; Decimal)
        {
            Caption = 'Main Item Qty';
        }

        field(501057; "Complimentary Qty1"; Decimal)
        {
            Caption = 'Complimentary Item Qty';
        }

        field(501058; CompStartDate; DateTime)
        {
            Caption = 'Start Date';
        }

        field(501059; CompEndDate; DateTime)
        {
            Caption = 'End Date';
        }

        field(501060; CompActive; Boolean)
        {
            Caption = 'Active';
        }

        field(501061; CompAllCustomer; Boolean)
        {
            Caption = 'All Customer';
        }

        field(501062; CompMethod; Option)
        {
            OptionMembers = "FIXED","CUMMULATIVE";
            Caption = 'Method';
        }

        field(501063; CompBeginDate; Date)
        {
            Caption = 'Start Date';
        }

        field(501064; CompEndingDate; Date)
        {
            Caption = 'End Date';
        }


    }

    keys
    {
        key(PKComp; CompGroupId)
        {
            Clustered = true;
        }
    }

    procedure FilterCompByDate(NewSourceNo: Code[20]; DateBegin: Date; DateEnd: Date)
    var
        datec: text;
    begin
        Reset;

        // SetRange("Source Type", NewSourceType);
        // SetRange("Source No.", NewSourceNo);
        // SetRange(Usage, NewUsage);
        SetFilter(CompBeginDate, '>=%1&<=%2', DateBegin, DateEnd);
    end;

}