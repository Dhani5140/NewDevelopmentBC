table 70001 MiiTabScheduleHeader
{
    Caption = 'Schedule Header';
    DataCaptionFields = "Schedule Description";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "No. of Periods"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Periods';
            NotBlank = true;

            trigger OnValidate()
            begin
                if "No. of Periods" < 1 then
                    Error(NumberofPeriodsErr);
            end;
        }
        field(3; "Amount to Installment"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount to Installment';

            trigger OnValidate()
            begin
                if "Initial Amount Installment" < 0 then begin// Negative amount
                    if "Amount to Installment" < "Initial Amount Installment" then
                        Error(AmountToInstallErr);
                    if "Amount to Installment" > 0 then
                        Error(AmountToInstallErr)
                end;

                if "Initial Amount Installment" >= 0 then begin// Positive amount
                    if "Amount to Installment" > "Initial Amount Installment" then
                        Error(AmountToInstallErr);
                    if "Amount to Installment" < 0 then
                        Error(AmountToInstallErr);
                end;

                if "Amount to Installment" = 0 then
                    Error(ZeroAmountToInstallErr);
            end;
        }
        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
        }
        field(5; "Initial Amount Installment"; Decimal)
        {
            Caption = 'Initial Amount Installment';
        }
        field(6; "Schedule Description"; Text[100])
        {
            Caption = 'Schedule Description';
        }
        field(7; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(8; "No."; Code[20])
        {
            Caption = 'Bank No.';
            TableRelation = "Bank Account"."No.";
        }
    }

    keys
    {
        key(key1; "Document No.")
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
    var

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