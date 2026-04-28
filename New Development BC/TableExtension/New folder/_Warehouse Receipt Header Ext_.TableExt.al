tableextension 80127 "Warehouse Receipt Header Ext" extends "Warehouse Receipt Header"
{
    fields
    {
        field(50000; "No. Surat Jalan"; Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdatePO(FieldNo("No. Surat Jalan"));
            end;
        }
        field(50001; "Tanggal Surat Jalan"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdatePO(FieldNo("Tanggal Surat Jalan"));
            end;
        }
        field(50002; "No. Polisi"; Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdatePO(FieldNo("No. Polisi"));
            end;
        }
        field(50003; "Shipping Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdatePO(FieldNo("Shipping Date"));
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
    procedure UpdatePO(FieldRef: Integer)
    var
        lRecPOHeader: Record "Purchase Header";
        lRecWRLine: Record "Warehouse Receipt Line";
        currDocNo: Code[20];
    begin
        lRecWRLine.RESET;
        lRecWRLine.SETRANGE(lRecWRLine."No.", Rec."No.");
        lRecWRLine.SETRANGE(lRecWRLine."Source Document", lRecWRLine."Source Document"::"Purchase Order");
        lRecWRLine.SetCurrentKey("Source No.");
        lRecWRLine.Ascending(TRUE);
        IF lRecWRLine.FIND('-') THEN BEGIN
            REPEAT
                IF currDocNo <> lRecWRLine."Source No." THEN BEGIN
                    lRecPOHeader.RESET;
                    lRecPOHeader.SETRANGE("No.", lRecWRLine."Source No.");
                    IF lRecPOHeader.FINDFIRST THEN BEGIN
                        case FieldRef of
                            FieldNo("No. Polisi"):
                                lRecPOHeader.VALIDATE("No. Polisi", "No. Polisi");
                            FieldNo("No. Surat Jalan"):
                                lRecPOHeader.VALIDATE("No. Surat Jalan", "No. Surat Jalan");
                            FieldNo("Tanggal Surat Jalan"):
                                lRecPOHeader.VALIDATE("Tanggal Surat Jalan", "Tanggal Surat Jalan");
                            FieldNo("Shipping Date"):
                                lRecPOHeader.VALIDATE("Shipping Date", "Shipping Date");
                        end;
                        lRecPOHeader.MODIFY(TRUE);
                    END;
                END;
                currDocNo := lRecWRLine."Source No.";
            UNTIL lRecWRLine.NEXT = 0;
        END;
    end;

    var
        myInt: Integer;
}
