tableextension 80121 "Transfer Rcpt. Header Ext" extends "Transfer Receipt Header"
{
    fields
    {
        field(50000; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Original No. from System"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
