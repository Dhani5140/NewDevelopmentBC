codeunit 52231 "Image Management"
{
    // Caption = 'Image Management';

    procedure ImportItemPicture(Item: Record Item)
    var
        PicInStream: InStream;
        FromFileName: Text;
        OverrideImageQst: Label 'The existing picture will be replaced. Continue?';
    begin
        with Item do begin
            // Cek apakah field Picture sudah berisi gambar
            if Picture.Count() > 0 then
                if not Confirm(OverrideImageQst) then
                    exit;

            // Dialog untuk mengunggah file ke dalam stream
            if File.UploadIntoStream('Import', '', 'All Files (*.*)|*.*',
                                     FromFileName, PicInStream) then begin
                Clear(Picture); // Kosongkan gambar yang ada
                Picture.ImportStream(PicInStream, FromFileName); // Impor gambar dari stream
                Modify(true); // Simpan perubahan ke database
            end;
        end;
    end;

}
