tableextension 50138 COMINFO extends "Company Information"
{
    fields
    {
        field(60100; Signature; Blob)
        {
            Caption = 'Signature';
            Subtype = Bitmap;

            trigger OnValidate()
            begin
            end;
        }
        field(60101; "Name PIC RFQ"; Text[200])
        {

        }
        field(60102; "Role PIC RFQ"; Text[100])
        {

        }
    }
    var
        PictureUpdated: Boolean;

}