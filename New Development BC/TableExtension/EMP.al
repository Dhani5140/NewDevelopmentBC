tableextension 50116 emp2 extends Employee
{
    fields
    {
        field(60100; "Sign In"; Blob)
        {
            Caption = 'Sign In';
            Subtype = Bitmap;

            trigger OnValidate()
            begin
                PictureUpdated := true;
            end;
        }
    }
    var
        PictureUpdated: Boolean;
}