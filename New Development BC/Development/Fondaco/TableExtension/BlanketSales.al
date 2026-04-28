tableextension 70001 MIITextBSO extends "Sales Header"
{
    fields
    {
        field(70001; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                if IsHandled then
                    exit;

                if "Starting Date" <> 0D then begin
                    if "Starting Date" < "Order Date" then
                        Error(Text026, FieldCaption("Starting Date"), FieldCaption("Order Date"));

                    if ("Starting Date" > "Finishing Date") and
                       ("Finishing Date" <> 0D)
                    then
                        Error(Text007, FieldCaption("Starting Date"), FieldCaption("Finishing Date"));
                end;

                //Validate(EstimatedMonth);
            end;
        }
        field(70002; "Finishing Date"; Date)
        {
            Caption = 'Finishing Date';

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                if IsHandled then
                    exit;

                if "Finishing Date" <> 0D then begin
                    if "Finishing Date" < "Starting Date" then
                        Error(Text026, FieldCaption("Finishing Date"), FieldCaption("Starting Date"));

                    if "Finishing Date" < "Order Date" then
                        Error(
                          Text026,
                          FieldCaption("Finishing Date"),
                          FieldCaption("Order Date"));

                    if "Starting Date" = 0D then begin
                        "Starting Date" := "Finishing Date";
                    end;
                end;
                //Validate(EstimatedMonth);
            end;
        }
        field(70003; EstimatedMonth; Integer)
        {
            trigger OnValidate()
            begin
                if Rec."Starting Date" <> 0D then begin
                    if Rec."Finishing Date" <> 0D then begin
                        //Rec.EstimatedMonth := GetMonthDifference(Rec."Starting Date", Rec."Finishing Date");
                    end
                end
            end;
        }

        field(70004; Termin; Enum Termin)
        {
            trigger OnValidate()
            begin
                Rec."Prepayment %" := 100 / rec.Termin.AsInteger();
                Validate("Prepayment %");
            end;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    procedure GetMonthDifference(StartDate: Date; EndDate: Date): Integer
    var
        StartMonth: Integer;
        StartYear: Integer;
        EndMonth: Integer;
        EndYear: Integer;
    begin
        StartMonth := Date2DMY(StartDate, 2);
        StartYear := Date2DMY(StartDate, 3);
        EndMonth := Date2DMY(EndDate, 2);
        EndYear := Date2DMY(EndDate, 3);

        exit((EndYear - StartYear) * 12 + (EndMonth - StartMonth));
    end;

    var
        myInt: Integer;
        Text026: Label '%1 cannot be earlier than the %2.';
        Text007: Label '%1 cannot be greater than %2.';

}