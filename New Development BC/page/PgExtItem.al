pageextension 50100 MyExtension extends "Item List"
{
    layout
    {

    }

    actions
    {
        addafter(History)
        {
            action(ExportXML)
            {
                Image = XMLFile;
                ApplicationArea = all;

                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    CustomerXml: XmlPort ItemXMLPort;
                    OutStr: OutStream;
                    InStr: InStream;
                    FileName: Text;
                begin
                    TempBlob.CreateOutStream(OutStr);
                    CustomerXml.SetDestination(OutStr);
                    CustomerXml.Export();
                    TempBlob.CreateInStream(InStr);
                    FileName := 'Item.xml';
                    File.DownloadFromStream(InStr, 'Download', '', '', FileName);
                end;
            }
        }
    }
}