pageextension 70014 PgExtFAGL extends "Fixed Asset G/L Journal"
{
    layout
    {
        addafter(Description)
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = all;
            }
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    Fadepre: Record "FA Depreciation Book";
                begin
                    if Rec."FA Posting Type" = Rec."FA Posting Type"::Disposal then begin
                        if Rec.Quantity >= 0 then begin
                            Error('Disposal cannot be positive');
                        end;

                        Fadepre.SetRange("FA No.", Rec."Account No.");
                        if Fadepre.FindSet() then begin
                            Fadepre.CalcFields("Remaining Quantity");
                            if ABS(Rec.Quantity) > Fadepre."Remaining Quantity" then begin
                                Error('You Cannot post because remaining quantity = %1', Fadepre."Remaining Quantity");
                            end;
                        end;
                    end;
                end;
            }
        }
    }
}