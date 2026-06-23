table 70002 MiiTabScheduleLine
{
    Caption = 'Schedule Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the posting date.';
        }

        field(3; "Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }

        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
        }

        field(5; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description.';
        }
        field(6; Status; Enum Schedule)
        {

        }
        field(7; Post; Boolean)
        {

        }
        field(8; CustLedgerNo; Code[20])
        {
            TableRelation = "Cust. Ledger Entry"."Document No.";
        }
    }

    keys
    {
        key(key1; "Document No.", "Posting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        AmountToInstallErr: Label 'The installed amount cannot be greater than the document line amount.';
        ZeroAmountToInstallErr: Label 'The installed amount cannot be 0.';
        NumberofPeriodsErr: Label 'You must specify one or more periods.';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}