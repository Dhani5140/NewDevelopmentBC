codeunit 60109 GetDocument
{
    procedure CreateRFQLine(PRLine: Record PPBLine; DocNo: Code[20])
    var
        Rfq_Line: Record Rfqline;
    begin
        Rfq_Line.Init();
        Rfq_Line."No." := DocNo;
        Rfq_Line."Line No." := GetLastLine(DocNo);
        Rfq_Line.Insert(true);
        Rfq_Line.Validate("Item No.", PRLine."No.");
        Rfq_Line.Validate(Quantity, PRLine.Quantity);
        Rfq_Line.Modify(true);
    end;

    local procedure GetLastLine(DocNo: Code[20]): Integer
    var
        Rfq_line1: Record Rfqline;
    begin
        Rfq_line1.Reset();
        Rfq_line1.SetRange("No.", DocNo);
        IF Rfq_line1.FindLast() then
            exit(Rfq_line1."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;

}