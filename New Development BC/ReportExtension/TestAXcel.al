report 60106 excelx
{
    ExcelLayout = 'test2.xlsx';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("RFQ Vendor List"; "RFQ Vendor List")
        {
            column(CompanyPicture; gRecCompany.Picture)
            {
            }
            column(CompanyAddress; gRecCompany.Address)
            {
            }
            column(CompanyAdd2; gRecCompany."Address 2")
            {
            }

            column(compname; gRecCompany.Name)
            {

            }
            column(signature; gRecCompany.Signature)
            {

            }
            column(RolePIC; gRecCompany."Role PIC RFQ")
            {

            }
            column(NamePIC; gRecCompany."Name PIC RFQ")
            {

            }
            column(Vendor_No_; "Vendor No.")
            {

            }
            column(Vendor_Name; "Vendor Name")
            {

            }



            column(Ship_to_Code; "Ship-to Code")
            {

            }
            column(Ship_to_Name; "Ship-to Name")
            {

            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {

            }
            column(Payment_Terms_Name; "Payment Terms Name")
            {

            }

            column(RFQ_No_; "RFQ No.")
            {

            }
            column(Shipping_Date; "Shipping Date")
            {

            }



            dataitem("RFQ Line"; "RFQ Line")
            {
                DataItemLink = "RFQ No." = field("RFQ No.");

                column(No_; "No.")
                {

                }

                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(ven_add; ven_add)
                {

                }

                column(ven_add2; ven_add2)
                {

                }
                column(city; city)
                {

                }

                column(phone; phone)
                {

                }
                column(Unit_of_Measure; "Unit of Measure")
                {

                }

                column(Original_Qty_PR; "Original Qty PR")
                {

                }


                dataitem("RFQ Header"; "RFQ Header")
                {
                    DataItemLink = "RFQ No." = field("RFQ No.");

                    column(Document_Date; "Document Date")
                    {

                    }
                    column(Employee_Name; "Employee Name")
                    {

                    }

                    column(signin; signin)
                    {

                    }

                }


            }

            trigger OnAfterGetRecord()
            begin
                vdr.SetRange("No.", "RFQ Vendor List"."Vendor No.");
                if vdr.FindSet() then begin
                    ven_add := vdr.Address;
                    ven_add2 := vdr."Address 2";
                    city := vdr.City;
                    phone := vdr."Phone No.";
                end;
                emp.SetRange("No.", "RFQ Header".Employee);
                if emp.FindSet() then begin
                    "RFQ Header".signin := emp."Sign In";
                end;


            end;







        }


    }

    trigger OnInitReport()
    begin
        gRecCompany.GET();
        gRecCompany.CalcFields(Picture, Signature);
        gRowNo := 0;


    end;

    var
        gRecCompany: Record "Company Information";
        myInt: Integer;
        vendor: code[20];
        gRowNo: integer;
        vdr: Record Vendor;
        ven_add: Text[100];
        ven_add2: text[50];
        city: text[20];
        phone: text[20];
        cname: text[100];
        emp: Record Employee;









}
