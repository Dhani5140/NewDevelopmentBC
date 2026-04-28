page 52234 ImageUploadPage
{
    PageType = Document;
    ApplicationArea = All;
    SourceTable = ImageTable;
    Caption = 'Image Upload';
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Image ID"; Rec."Image ID")
                {
                    ApplicationArea = All;
                }
                field("Image Name"; Rec."Image Name")
                {
                    ApplicationArea = All;
                }
                field("Image Media"; Rec."Image Media")
                {
                    ApplicationArea = All;
                    Caption = 'Upload Image';
                    ToolTip = 'Upload an image file';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(UploadImage)
            {
                ApplicationArea = All;
                Caption = 'Upload Image';

                trigger OnAction()
                var
                    InStream: InStream;
                    TempBlob: Codeunit "Temp Blob";
                    FileName: Text;
                    Description: Text;
                begin
                    // Meminta file dari pengguna
                    if UploadIntoStream('Select an image file to upload', '', 'All Files (*.*)|*.*', FileName, InStream) then begin
                        // Cek apakah InStream memiliki data
                        if InStream.Length > 0 then begin
                            // Menetapkan deskripsi untuk media
                            Description := 'Uploaded Image: ' + FileName;

                            // Menyimpan stream ke Media
                            Rec."Image Media".ImportStream(InStream, Description);
                            Commit();
                            Message('Image uploaded successfully.');
                        end else
                            Message('Failed to read file data. Please try again.');
                    end else
                        Message('No image selected.');
                end;
            }
        }
    }
}