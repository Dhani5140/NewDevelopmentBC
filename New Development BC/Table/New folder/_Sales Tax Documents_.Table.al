table 80121 "Sales Tax Documents"
{
    // version DIS.TAX
    CaptionML = ENU = 'Sales Tax Documents', ENA = 'Sales Header';
    DataCaptionFields = "No.", "Sell-to Customer No.";

    fields
    {
        field(1; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type', ENA = 'Document Type';
            OptionCaptionML = ENU = 'Invoice,Credit Memo', ENA = 'Invoice,CR/Adj Note';
            OptionMembers = Invoice,"Credit Memo";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            CaptionML = ENU = 'Sell-to Customer No.', ENA = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(3; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            CaptionML = ENU = 'Bill-to Customer No.', ENA = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(5; "Bill-to Name"; Text[100])
        {
            CaptionML = ENU = 'Bill-to Name', ENA = 'Bill-to Name';
            TableRelation = Customer;
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Customer: Record "Customer";
            begin
            end;
        }
        field(6; "Bill-to Name 2"; Text[100])
        {
            CaptionML = ENU = 'Bill-to Name 2', ENA = 'Bill-to Name 2';
        }
        field(7; "Bill-to Address"; Text[100])
        {
            CaptionML = ENU = 'Bill-to Address', ENA = 'Bill-to Address';
        }
        field(8; "Bill-to Address 2"; Text[100])
        {
            CaptionML = ENU = 'Bill-to Address 2', ENA = 'Bill-to Address 2';
        }
        field(87; "Bill-to Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Bill-to Country/Region Code', ENA = 'Bill-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(9; "Bill-to City"; Text[100])
        {
            CaptionML = ENU = 'Bill-to City', ENA = 'Bill-to City';
            TableRelation = IF ("Bill-to Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Bill-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Bill-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; "Bill-to Contact"; Text[100])
        {
            CaptionML = ENU = 'Bill-to Contact', ENA = 'Bill-to Contact';

            trigger OnLookup();
            var
                Contact: Record "Contact";
            begin
            end;
        }
        field(11; "Your Reference"; Text[100])
        {
            CaptionML = ENU = 'Your Reference', ENA = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            CaptionML = ENU = 'Ship-to Code', ENA = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate();
            var
                ShipToAddr: Record "Ship-to Address";
            begin
            end;
        }
        field(13; "Ship-to Name"; Text[100])
        {
            CaptionML = ENU = 'Ship-to Name', ENA = 'Ship-to Name';
        }
        field(14; "Ship-to Name 2"; Text[100])
        {
            CaptionML = ENU = 'Ship-to Name 2', ENA = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[100])
        {
            CaptionML = ENU = 'Ship-to Address', ENA = 'Ship-to Address';
        }
        field(16; "Ship-to Address 2"; Text[1000])
        {
            CaptionML = ENU = 'Ship-to Address 2', ENA = 'Ship-to Address 2';
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Ship-to Country/Region Code', ENA = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(17; "Ship-to City"; Text[100])
        {
            CaptionML = ENU = 'Ship-to City', ENA = 'Ship-to City';
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18; "Ship-to Contact"; Text[100])
        {
            CaptionML = ENU = 'Ship-to Contact', ENA = 'Ship-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            AccessByPermission = TableData 110 = R;
            CaptionML = ENU = 'Order Date', ENA = 'Order Date';
        }
        field(20; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ENA = 'Posting Date';
        }
        field(21; "Shipment Date"; Date)
        {
            CaptionML = ENU = 'Shipment Date', ENA = 'Shipment Date';
        }
        field(22; "Posting Description"; Text[100])
        {
            CaptionML = ENU = 'Posting Description', ENA = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            CaptionML = ENU = 'Payment Terms Code', ENA = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ENA = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            CaptionML = ENU = 'Payment Discount %', ENA = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            CaptionML = ENU = 'Pmt. Discount Date', ENA = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            CaptionML = ENU = 'Shipment Method Code', ENA = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            CaptionML = ENU = 'Location Code', ENA = 'Location Code';
            TableRelation = "Location" WHERE("Use As In-Transit" = CONST(False));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ENA = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(False));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ENA = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(False));
        }
        field(31; "Customer Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Customer Posting Group', ENA = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code', ENA = 'Currency Code';
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ENA = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(34; "Customer Price Group"; Code[10])
        {
            CaptionML = ENU = 'Customer Price Group', ENA = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            CaptionML = ENU = 'Prices Including VAT', ENA = 'Prices Including GST';

            trigger OnValidate();
            var
                SalesLine: Record "Sales Line";
                Currency: Record "Currency";
                RecalculatePrice: Boolean;
            begin
            end;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            AccessByPermission = TableData 19 = R;
            CaptionML = ENU = 'Invoice Disc. Code', ENA = 'Invoice Disc. Code';
        }
        field(40; "Customer Disc. Group"; Code[20])
        {
            CaptionML = ENU = 'Customer Disc. Group', ENA = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(41; "Language Code"; Code[10])
        {
            CaptionML = ENU = 'Language Code', ENA = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Salesperson Code"; Code[20])
        {
            CaptionML = ENU = 'Salesperson Code', ENA = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate();
            var
                ApprovalEntry: Record "Approval Entry";
            begin
            end;
        }
        field(45; "Order Class"; Code[10])
        {
            CaptionML = ENU = 'Order Class', ENA = 'Order Class';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Sales Comment Line" WHERE("No." = FIELD("No."), "Document Line No." = CONST(0)));
            CaptionML = ENU = 'Comment', ENA = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            CaptionML = ENU = 'No. Printed', ENA = 'No. Printed';
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            CaptionML = ENU = 'On Hold', ENA = 'On Hold';
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            CaptionML = ENU = 'Applies-to Doc. Type', ENA = 'Applies-to Doc. Type';
            OptionCaptionML = ENU = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund', ENA = ' ,Payment,Invoice,CR/Adj Note,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            CaptionML = ENU = 'Applies-to Doc. No.', ENA = 'Applies-to Doc. No.';

            trigger OnLookup();
            var
                GenJnlLine: Record "Gen. Journal Line";
                GenJnlApply: Codeunit "Gen. Jnl.-Apply";
                ApplyCustEntries: Page "Apply Customer Entries";
            begin
            end;
        }
        field(94; "Bal. Account Type"; Option)
        {
            CaptionML = ENU = 'Bal. Account Type', ENA = 'Bal. Account Type';
            OptionCaptionML = ENU = 'G/L Account,Bank Account', ENA = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(55; "Bal. Account No."; Code[20])
        {
            CaptionML = ENU = 'Bal. Account No.', ENA = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(56; "Recalculate Invoice Disc."; Boolean)
        {
            CalcFormula = Exist("Sales Line" WHERE("Document No." = FIELD("No."), "Recalculate Invoice Disc." = CONST(True)));
            CaptionML = ENU = 'Recalculate Invoice Disc.', ENA = 'Recalculate Invoice Disc.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; Ship; Boolean)
        {
            CaptionML = ENU = 'Ship', ENA = 'Ship';
            Editable = false;
        }
        field(58; Invoice; Boolean)
        {
            CaptionML = ENU = 'Invoice', ENA = 'Invoice';
        }
        field(59; "Print Posted Documents"; Boolean)
        {
            CaptionML = ENU = 'Print Posted Documents', ENA = 'Print Posted Documents';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line".Amount WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount', ENA = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount Including VAT', ENA = 'Amount Including GST';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Shipping No."; Code[20])
        {
            CaptionML = ENU = 'Shipping No.', ENA = 'Shipping No.';
        }
        field(63; "Posting No."; Code[20])
        {
            CaptionML = ENU = 'Posting No.', ENA = 'Posting No.';
        }
        field(64; "Last Shipping No."; Code[20])
        {
            CaptionML = ENU = 'Last Shipping No.', ENA = 'Last Shipping No.';
            Editable = false;
            TableRelation = "Sales Shipment Header";
        }
        field(65; "Last Posting No."; Code[20])
        {
            CaptionML = ENU = 'Last Posting No.', ENA = 'Last Posting No.';
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(66; "Prepayment No."; Code[20])
        {
            CaptionML = ENU = 'Prepayment No.', ENA = 'Prepayment No.';
        }
        field(67; "Last Prepayment No."; Code[20])
        {
            CaptionML = ENU = 'Last Prepayment No.', ENA = 'Last Prepayment No.';
            TableRelation = "Sales Invoice Header";
        }
        field(68; "Prepmt. Cr. Memo No."; Code[20])
        {
            CaptionML = ENU = 'Prepmt. Cr. Memo No.', ENA = 'Prepmt. CR/Adj Note No.';
        }
        field(69; "Last Prepmt. Cr. Memo No."; Code[20])
        {
            CaptionML = ENU = 'Last Prepmt. Cr. Memo No.', ENA = 'Last Prepmt. CR/Adj Note No.';
            TableRelation = "Sales Cr.Memo Header";
        }
        field(70; "VAT Registration No."; Text[20])
        {
            CaptionML = ENU = 'VAT Registration No.', ENA = 'Exemption Certificate No.';

            trigger OnValidate();
            var
                Customer: Record "Customer";
                VATRegistrationLog: Record "VAT Registration Log";
                VATRegistrationNoFormat: Record "VAT Registration No. Format";
                VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
                ResultRecRef: RecordRef;
                ApplicableCountryCode: Code[10];
            begin
            end;
        }
        field(71; "Combine Shipments"; Boolean)
        {
            CaptionML = ENU = 'Combine Shipments', ENA = 'Combine Shipments';
        }
        field(73; "Reason Code"; Code[10])
        {
            CaptionML = ENU = 'Reason Code', ENA = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            CaptionML = ENU = 'Gen. Bus. Posting Group', ENA = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            CaptionML = ENU = 'EU 3-Party Trade', ENA = 'EU 3-Party Trade';
        }
        field(76; "Transaction Type"; Code[10])
        {
            CaptionML = ENU = 'Transaction Type', ENA = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            CaptionML = ENU = 'Transport Method', ENA = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'VAT Country/Region Code', ENA = 'GST Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(79; "Sell-to Customer Name"; Text[100])
        {
            CaptionML = ENU = 'Sell-to Customer Name', ENA = 'Sell-to Customer Name';
            TableRelation = Customer;
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Customer: Record "Customer";
                IdentityManagement: Codeunit "Identity Management";
            begin
            end;
        }
        field(80; "Sell-to Customer Name 2"; Text[100])
        {
            CaptionML = ENU = 'Sell-to Customer Name 2', ENA = 'Sell-to Customer Name 2';
        }
        field(81; "Sell-to Address"; Text[100])
        {
            CaptionML = ENU = 'Sell-to Address', ENA = 'Sell-to Address';
        }
        field(82; "Sell-to Address 2"; Text[100])
        {
            CaptionML = ENU = 'Sell-to Address 2', ENA = 'Sell-to Address 2';
        }
        /*
        field(90;"Sell-to Country/Region Code";Code[10])
        {
            CaptionML = ENU='Sell-to Country/Region Code',
                        ENA='Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        */
        field(83; "Sell-to City"; Text[100])
        {
            CaptionML = ENU = 'Sell-to City', ENA = 'Sell-to City';
            TableRelation = IF ("Sell-to Country/Region Code" = CONST()) "Post Code".City
            ELSE
            IF ("Sell-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Sell-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(84; "Sell-to Contact"; Text[100])
        {
            CaptionML = ENU = 'Sell-to Contact', ENA = 'Sell-to Contact';

            trigger OnLookup();
            var
                Contact: Record "Contact";
            begin
            end;
        }
        field(85; "Bill-to Post Code"; Code[20])
        {
            CaptionML = ENU = 'Bill-to Post Code', ENA = 'Bill-to Postcode';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(86; "Bill-to County"; Text[100])
        {
            CaptionML = ENU = 'Bill-to County', ENA = 'Bill-to State';
        }
        /*
        field(87;"Bill-to Country/Region Code";Code[10])
        {
            CaptionML = ENU='Bill-to Country/Region Code',
                        ENA='Bill-to Country/Region Code';
            TableRelation = Country/Region;
        }
        */
        field(88; "Sell-to Post Code"; Code[20])
        {
            CaptionML = ENU = 'Sell-to Post Code', ENA = 'Sell-to Postcode';
            TableRelation = IF ("Sell-to Country/Region Code" = CONST()) "Post Code"
            ELSE
            IF ("Sell-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Sell-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89; "Sell-to County"; Text[100])
        {
            CaptionML = ENU = 'Sell-to County', ENA = 'Sell-to State';
        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Sell-to Country/Region Code', ENA = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            CaptionML = ENU = 'Ship-to Post Code', ENA = 'Ship-to Postcode';
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code"
            ELSE
            IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(92; "Ship-to County"; Text[100])
        {
            CaptionML = ENU = 'Ship-to County', ENA = 'Ship-to State';
        }
        field(97; "Exit Point"; Code[10])
        {
            CaptionML = ENU = 'Exit Point', ENA = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98; Correction; Boolean)
        {
            CaptionML = ENU = 'Correction', ENA = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date', ENA = 'Document Date';
        }
        field(100; "External Document No."; Code[35])
        {
            CaptionML = ENU = 'External Document No.', ENA = 'External Document No.';
        }
        field(101; "Area"; Code[10])
        {
            CaptionML = ENU = 'Area', ENA = 'Area';
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            CaptionML = ENU = 'Transaction Specification', ENA = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            CaptionML = ENU = 'Payment Method Code', ENA = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate();
            var
                SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
            begin
            end;
        }
        field(105; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData 5790 = R;
            CaptionML = ENU = 'Shipping Agent Code', ENA = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(106; "Package Tracking No."; Text[30])
        {
            CaptionML = ENU = 'Package Tracking No.', ENA = 'Package Tracking No.';
        }
        field(107; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series', ENA = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Posting No. Series"; Code[20])
        {
            CaptionML = ENU = 'Posting No. Series', ENA = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(109; "Shipping No. Series"; Code[20])
        {
            CaptionML = ENU = 'Shipping No. Series', ENA = 'Shipping No. Series';
            TableRelation = "No. Series";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            CaptionML = ENU = 'Tax Area Code', ENA = 'US Tax Area Code';
            TableRelation = "Tax Area";
            ValidateTableRelation = false;
        }
        field(115; "Tax Liable"; Boolean)
        {
            CaptionML = ENU = 'Tax Liable', ENA = 'US Tax Liable';
        }
        field(116; "VAT Bus. Posting Group"; Code[20])
        {
            CaptionML = ENU = 'VAT Bus. Posting Group', ENA = 'GST Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(117; Reserve; Option)
        {
            AccessByPermission = TableData 27 = R;
            CaptionML = ENU = 'Reserve', ENA = 'Reserve';
            InitValue = Optional;
            OptionCaptionML = ENU = 'Never,Optional,Always', ENA = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(118; "Applies-to ID"; Code[50])
        {
            CaptionML = ENU = 'Applies-to ID', ENA = 'Applies-to ID';

            trigger OnValidate();
            var
                TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
                CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
            begin
            end;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            CaptionML = ENU = 'VAT Base Discount %', ENA = 'GST Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(120; Status; Option)
        {
            CaptionML = ENU = 'Status', ENA = 'Status';
            Editable = false;
            OptionCaptionML = ENU = 'Open,Released,Pending Approval,Pending Prepayment', ENA = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            CaptionML = ENU = 'Invoice Discount Calculation', ENA = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaptionML = ENU = 'None,%,Amount', ENA = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Invoice Discount Value', ENA = 'Invoice Discount Value';
            Editable = false;
        }
        field(123; "Send IC Document"; Boolean)
        {
            CaptionML = ENU = 'Send IC Document', ENA = 'Send IC Document';
        }
        field(124; "IC Status"; Option)
        {
            CaptionML = ENU = 'IC Status', ENA = 'IC Status';
            OptionCaptionML = ENU = 'New,Pending,Sent', ENA = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125; "Sell-to IC Partner Code"; Code[20])
        {
            CaptionML = ENU = 'Sell-to IC Partner Code', ENA = 'Sell-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126; "Bill-to IC Partner Code"; Code[20])
        {
            CaptionML = ENU = 'Bill-to IC Partner Code', ENA = 'Bill-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129; "IC Direction"; Option)
        {
            CaptionML = ENU = 'IC Direction', ENA = 'IC Direction';
            OptionCaptionML = ENU = 'Outgoing,Incoming', ENA = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;
        }
        field(130; "Prepayment %"; Decimal)
        {
            CaptionML = ENU = 'Prepayment %', ENA = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(131; "Prepayment No. Series"; Code[20])
        {
            CaptionML = ENU = 'Prepayment No. Series', ENA = 'Prepayment No. Series';
            TableRelation = "No. Series";
        }
        field(132; "Compress Prepayment"; Boolean)
        {
            CaptionML = ENU = 'Compress Prepayment', ENA = 'Compress Prepayment';
            InitValue = true;
        }
        field(133; "Prepayment Due Date"; Date)
        {
            CaptionML = ENU = 'Prepayment Due Date', ENA = 'Prepayment Due Date';
        }
        field(134; "Prepmt. Cr. Memo No. Series"; Code[20])
        {
            CaptionML = ENU = 'Prepmt. Cr. Memo No. Series', ENA = 'Prepmt. CR/Adj Note No. Series';
            TableRelation = "No. Series";
        }
        field(135; "Prepmt. Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Prepmt. Posting Description', ENA = 'Prepmt. Posting Description';
        }
        field(136; "Prepayment Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(137; "Prepayment Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(138; "Prepmt. Pmt. Discount Date"; Date)
        {
            CaptionML = ENU = 'Prepmt. Pmt. Discount Date', ENA = 'Prepmt. Pmt. Discount Date';
        }
        field(139; "Prepmt. Payment Terms Code"; Code[10])
        {
            CaptionML = ENU = 'Prepmt. Payment Terms Code', ENA = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate();
            var
                PaymentTerms: Record "Payment Terms";
            begin
            end;
        }
        field(140; "Prepmt. Payment Discount %"; Decimal)
        {
            CaptionML = ENU = 'Prepmt. Payment Discount %', ENA = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(151; "Quote No."; Code[20])
        {
            CaptionML = ENU = 'Quote No.', ENA = 'Quote No.';
            Editable = false;
        }
        field(152; "Quote Valid Until Date"; Date)
        {
            CaptionML = ENU = 'Quote Valid Until Date', ENA = 'Quote Valid Until Date';
        }
        field(153; "Quote Sent to Customer"; DateTime)
        {
            CaptionML = ENU = 'Quote Sent to Customer', ENA = 'Quote Sent to Customer';
            Editable = false;
        }
        field(154; "Quote Accepted"; Boolean)
        {
            CaptionML = ENU = 'Quote Accepted', ENA = 'Quote Accepted';
        }
        field(155; "Quote Accepted Date"; Date)
        {
            CaptionML = ENU = 'Quote Accepted Date', ENA = 'Quote Accepted Date';
            Editable = false;
        }
        field(160; "Job Queue Status"; Option)
        {
            CaptionML = ENU = 'Job Queue Status', ENA = 'Job Queue Status';
            Editable = false;
            OptionCaptionML = ENU = ' ,Scheduled for Posting,Error,Posting', ENA = ' ,Scheduled for Posting,Error,Posting';
            OptionMembers = " ","Scheduled for Posting",Error,Posting;

            trigger OnLookup();
            var
                JobQueueEntry: Record "Job Queue Entry";
            begin
            end;
        }
        field(161; "Job Queue Entry ID"; Guid)
        {
            CaptionML = ENU = 'Job Queue Entry ID', ENA = 'Job Queue Entry ID';
            Editable = false;
        }
        field(165; "Incoming Document Entry No."; Integer)
        {
            CaptionML = ENU = 'Incoming Document Entry No.', ENA = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate();
            var
                IncomingDocument: Record "Incoming Document";
            begin
            end;
        }
        // field(166; "Last Email Sent Time"; DateTime)
        // {
        //     CalcFormula = Max("O365 Document Sent History"."Created Date-Time" WHERE("Document No." = FIELD("No."),
        //                                                                               Posted = CONST(false)));
        //     CaptionML = ENU = 'Last Email Sent Time',
        //                 ENA = 'Last Email Sent Time';
        //     FieldClass = FlowField;
        // }
        // field(167; "Last Email Sent Status"; Option)
        // {
        //     CalcFormula = Lookup("O365 Document Sent History"."Job Last Status" WHERE("Document No." = FIELD("No."),
        //                                                                                Posted = CONST(False),
        //                                                                                "Created Date-Time" = FIELD("Last Email Sent Time")));
        //     CaptionML = ENU = 'Last Email Sent Status',
        //                 ENA = 'Last Email Sent Status';
        //     FieldClass = FlowField;
        //     OptionCaptionML = ENU = 'Not Sent,In Process,Finished,Error',
        //                       ENA = 'Not Sent,In Process,Finished,Error';
        //     OptionMembers = "Not Sent","In Process",Finished,Error;
        // }
        // field(168; "Sent as Email"; Boolean)
        // {
        //     CalcFormula = Exist("O365 Document Sent History" WHERE("Document No." = FIELD("No."),
        //                                                             Posted = CONST(False),
        //                                                             "Job Last Status" = CONST(Finished)));
        //     CaptionML = ENU = 'Sent as Email',
        //                 ENA = 'Sent as Email';
        //     FieldClass = FlowField;
        // }
        // field(169; "Last Email Notif Cleared"; Boolean)
        // {
        //     CalcFormula = Lookup("O365 Document Sent History".NotificationCleared WHERE("Document No." = FIELD("No."),
        //                                                                                  Posted = CONST(False),
        //                                                                                  "Created Date-Time" = FIELD("Last Email Sent Time")));
        //     CaptionML = ENU = 'Last Email Notif Cleared',
        //                 ENA = 'Last Email Notif Cleared';
        //     FieldClass = FlowField;
        // }
        field(200; "Work Description"; BLOB)
        {
            CaptionML = ENU = 'Work Description', ENA = 'Work Description';
        }
        field(300; "Amt. Ship. Not Inv. (LCY)"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Shipped Not Invoiced (LCY)" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount Shipped Not Invoiced (LCY) Incl. VAT', ENA = 'Amount Shipped Not Invoiced (LCY) Incl. GST';
            Editable = false;
            FieldClass = FlowField;
        }
        field(301; "Amt. Ship. Not Inv. (LCY) Base"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Shipped Not Inv. (LCY) No VAT" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Amount Shipped Not Invoiced (LCY)', ENA = 'Amount Shipped Not Invoiced (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID', ENA = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(600; "Payment Service Set ID"; Integer)
        {
            CaptionML = ENU = 'Payment Service Set ID', ENA = 'Payment Service Set ID';
        }
        field(1200; "Direct Debit Mandate ID"; Code[35])
        {
            CaptionML = ENU = 'Direct Debit Mandate ID', ENA = 'Direct Debit Mandate ID';
            TableRelation = "SEPA Direct Debit Mandate" WHERE("Customer No." = FIELD("Bill-to Customer No."), Closed = CONST(False), Blocked = CONST(False));
        }
        field(1305; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Inv. Discount Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Invoice Discount Amount', ENA = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            CalcFormula = Max("Sales Header Archive"."Version No." WHERE("No." = FIELD("No."), "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence")));
            CaptionML = ENU = 'No. of Archived Versions', ENA = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            CaptionML = ENU = 'Doc. No. Occurrence', ENA = 'Doc. No. Occurrence';
        }
        field(5050; "Campaign No."; Code[20])
        {
            CaptionML = ENU = 'Campaign No.', ENA = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5051; "Sell-to Customer Template Code"; Code[10])
        {
            CaptionML = ENU = 'Sell-to Customer Template Code', ENA = 'Sell-to Customer Template Code';
        }
        field(5052; "Sell-to Contact No."; Code[20])
        {
            CaptionML = ENU = 'Sell-to Contact No.', ENA = 'Sell-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup();
            var
                Cont: Record "Contact";
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate();
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record "Contact";
                Opportunity: Record "Opportunity";
            begin
            end;
        }
        field(5053; "Bill-to Contact No."; Code[20])
        {
            CaptionML = ENU = 'Bill-to Contact No.', ENA = 'Bill-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup();
            var
                Cont: Record "Contact";
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate();
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record "Contact";
            begin
            end;
        }
        field(5054; "Bill-to Customer Template Code"; Code[10])
        {
            CaptionML = ENU = 'Bill-to Customer Template Code', ENA = 'Bill-to Customer Template Code';
        }
        field(5055; "Opportunity No."; Code[20])
        {
            CaptionML = ENU = 'Opportunity No.', ENA = 'Opportunity No.';
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            CaptionML = ENU = 'Responsibility Center', ENA = 'Responsibility Centre';
            TableRelation = "Responsibility Center";
        }
        field(5750; "Shipping Advice"; Option)
        {
            AccessByPermission = TableData 110 = R;
            CaptionML = ENU = 'Shipping Advice', ENA = 'Shipping Advice';
            OptionCaptionML = ENU = 'Partial,Complete', ENA = 'Partial,Complete';
            OptionMembers = Partial,Complete;
        }
        field(5751; "Shipped Not Invoiced"; Boolean)
        {
            AccessByPermission = TableData 110 = R;
            CalcFormula = Exist("Sales Line" WHERE("Document No." = FIELD("No."), "Qty. Shipped Not Invoiced" = FILTER(<> 0)));
            CaptionML = ENU = 'Shipped Not Invoiced', ENA = 'Shipped Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752; "Completely Shipped"; Boolean)
        {
            CalcFormula = Min("Sales Line"."Completely Shipped" WHERE("Document No." = FIELD("No."), Type = FILTER(<> ' '), "Location Code" = FIELD("Location Filter")));
            CaptionML = ENU = 'Completely Shipped', ENA = 'Completely Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5753; "Posting from Whse. Ref."; Integer)
        {
            AccessByPermission = TableData 14 = R;
            CaptionML = ENU = 'Posting from Whse. Ref.', ENA = 'Posting from Whse. Ref.';
        }
        field(5754; "Location Filter"; Code[10])
        {
            CaptionML = ENU = 'Location Filter', ENA = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5755; Shipped; Boolean)
        {
            AccessByPermission = TableData 110 = R;
            CalcFormula = Exist("Sales Line" WHERE("Document No." = FIELD("No."), "Qty. Shipped (Base)" = FILTER(<> 0)));
            CaptionML = ENU = 'Shipped', ENA = 'Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            AccessByPermission = TableData 99000880 = R;
            CaptionML = ENU = 'Requested Delivery Date', ENA = 'Requested Delivery Date';
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            AccessByPermission = TableData 99000880 = R;
            CaptionML = ENU = 'Promised Delivery Date', ENA = 'Promised Delivery Date';
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            AccessByPermission = TableData 110 = R;
            CaptionML = ENU = 'Shipping Time', ENA = 'Shipping Time';
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            AccessByPermission = TableData 7320 = R;
            CaptionML = ENU = 'Outbound Whse. Handling Time', ENA = 'Outbound Whse. Handling Time';
        }
        field(5794; "Shipping Agent Service Code"; Code[10])
        {
            CaptionML = ENU = 'Shipping Agent Service Code', ENA = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));
        }
        field(5795; "Late Order Shipping"; Boolean)
        {
            AccessByPermission = TableData 110 = R;
            CalcFormula = Exist("Sales Line" WHERE("Sell-to Customer No." = FIELD("Sell-to Customer No."), "Document No." = FIELD("No."), "Shipment Date" = FIELD("Date Filter"), "Outstanding Quantity" = FILTER(<> 0)));
            CaptionML = ENU = 'Late Order Shipping', ENA = 'Late Order Shipping';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5796; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter', ENA = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5800; Receive; Boolean)
        {
            CaptionML = ENU = 'Receive', ENA = 'Receive';
        }
        field(5801; "Return Receipt No."; Code[20])
        {
            CaptionML = ENU = 'Return Receipt No.', ENA = 'Return Receipt No.';
        }
        field(5802; "Return Receipt No. Series"; Code[20])
        {
            CaptionML = ENU = 'Return Receipt No. Series', ENA = 'Return Receipt No. Series';
            TableRelation = "No. Series";
        }
        field(5803; "Last Return Receipt No."; Code[20])
        {
            CaptionML = ENU = 'Last Return Receipt No.', ENA = 'Last Return Receipt No.';
            Editable = false;
            TableRelation = "Return Receipt Header";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            CaptionML = ENU = 'Allow Line Disc.', ENA = 'Allow Line Disc.';
        }
        field(7200; "Get Shipment Used"; Boolean)
        {
            CaptionML = ENU = 'Get Shipment Used', ENA = 'Get Shipment Used';
            Editable = false;
        }
        field(8000; Id; Guid)
        {
            CaptionML = ENU = 'Id', ENA = 'Id';
        }
        field(9000; "Assigned User ID"; Code[50])
        {
            CaptionML = ENU = 'Assigned User ID', ENA = 'Assigned User ID';
            TableRelation = "User Setup";
        }
        field(11612; Adjustment; Boolean)
        {
            CaptionML = ENU = 'Adjustment', ENA = 'Adjustment';
            Editable = false;
        }
        field(11613; "BAS Adjustment"; Boolean)
        {
            CaptionML = ENU = 'BAS Adjustment', ENA = 'BAS Adjustment';
            Editable = false;
        }
        field(11614; "Adjustment Applies-to"; Code[20])
        {
            CaptionML = ENU = 'Adjustment Applies-to', ENA = 'Adjustment Applies-to';
        }
        field(28040; "WHT Business Posting Group"; Code[20])
        {
            CaptionML = ENU = 'WHT Business Posting Group', ENA = 'WHT Business Posting Group';
            //TableRelation = "WHT Business Posting Group";
        }
        field(28070; "Tax Document Type"; Option)
        {
            CaptionML = ENU = 'Tax Document Type', ENA = 'Tax Document Type';
            OptionCaptionML = ENU = ' ,Document Post,Group Batch,Prompt', ENA = ' ,Document Post,Group Batch,Prompt';
            OptionMembers = " ","Document Post","Group Batch",Prompt;
        }
        field(28071; "Printed Tax Document"; Boolean)
        {
            CaptionML = ENU = 'Printed Tax Document', ENA = 'Printed Tax Document';
            Editable = false;
        }
        field(28072; "Posted Tax Document"; Boolean)
        {
            CaptionML = ENU = 'Posted Tax Document', ENA = 'Posted Tax Document';
            Editable = false;
        }
        field(28073; "Tax Document Marked"; Boolean)
        {
            CaptionML = ENU = 'Tax Document Marked', ENA = 'Tax Document Marked';
            Editable = false;
        }
        field(73700; "Tax Type"; Option)
        {
            OptionMembers = Retail,"Tax Document"," Non Tax";
        }
        field(73701; "NPWP Name"; Text[150])
        {
        }
        field(73702; "NPWP Address"; Text[150])
        {
        }
        field(73703; "NPWP Address 2"; Text[150])
        {
        }
        field(73704; "No. KTP"; Code[20])
        {
        }
        field(73705; "Transaction Code"; Option)
        {
            OptionMembers = "01","02","03","04","05","06","07","08","09";
        }
        field(73706; "Status Code"; Option)
        {
            OptionMembers = "0","1";
        }
        field(73707; "Tax No."; Code[30])
        {
        }
        field(73708; "Tax-Document Post"; Option)
        {
            OptionMembers = Post,Batch,Prompt;
        }
        field(73709; Pick; Boolean)
        {
        }
        field(73710; "Amount Invoice"; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line".Amount WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(73711; "Amount Credit Memo"; Decimal)
        {
            CalcFormula = Sum("Sales Cr.Memo Line".Amount WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(73712; "Amount Incl. VAT Invoice"; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(73713; "Amount Incl. VAT Credit Memo"; Decimal)
        {
            CalcFormula = Sum("Sales Cr.Memo Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(73714; Exported; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(73715; "Exported Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(73716; "Return Tax No."; Code[30])
        {
        }
        field(73717; "No. SPPKP"; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(73720; "Keterangan Tambahan"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Kawasan Bebas","Tempat Penimbunan Berikat","Hibah dan Bantuan Luar Negeri",Avtur,Lainnya,"Kontraktor Perjanjian Karya Pengusahaan Pertambangan Batubara Generasi I";
        }
        field(73721; "Additional Document No"; Code[20])
        {

            DataClassification = ToBeClassified;
        }
        field(73722; "Additional Notes"; Text[150])
        {

            DataClassification = ToBeClassified;
        }
        field(73723; "Pick Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(73724; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(73725; "Faktur Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(73726; "Faktur Pajak No"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(73727; "Tahun Pajak"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73728; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(73729; "Amount Prepayment DPP"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(73730; "Amount Prepayment PPN"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(73731; "Amount Prepayment PPNBM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73732; "Customer No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(73733; "NPWP No."; Text[20])
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
        key(Key2; "No.", "Document Type")
        {
        }
        key(Key3; "Document Type", "Sell-to Customer No.")
        {
        }
        key(Key4; "Document Type", "Bill-to Customer No.")
        {
        }
        key(Key5; "Document Type", "Combine Shipments", "Bill-to Customer No.", "Currency Code", "EU 3-Party Trade", "Dimension Set ID")
        {
        }
        key(Key6; "Sell-to Customer No.", "External Document No.")
        {
        }
        key(Key7; "Document Type", "Sell-to Contact No.")
        {
        }
        key(Key8; "Bill-to Contact No.")
        {
        }
        key(Key9; "Incoming Document Entry No.")
        {
        }
        key(Key10; "Document Date")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "No.", "Sell-to Customer Name", Amount, "Sell-to Contact", "Amount Including VAT")
        {
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnRename()
    begin

    end;

    trigger OnDelete();
    var
        CustInvoiceDisc: Record "Cust. Invoice Disc.";
        PostSalesDelete: Codeunit "PostSales-Delete";
        ArchiveManagement: Codeunit "ArchiveManagement";
    begin
    end;

    var
        Text003: TextConst ENU = 'You cannot rename a %1.', ENA = 'You cannot rename a %1.';
        ConfirmChangeQst: TextConst Comment = '%1 = a Field Caption like Currency Code', ENU = 'Do you want to change %1?', ENA = 'Do you want to change %1?';
        Text005: TextConst ENU = 'You cannot reset %1 because the document still has one or more lines.', ENA = 'You cannot reset %1 because the document still has one or more lines.';
        Text006: TextConst ENU = 'You cannot change %1 because the order is associated with one or more purchase orders.', ENA = 'You cannot change %1 because the order is associated with one or more purchase orders.';
        Text007: TextConst ENU = '%1 cannot be greater than %2 in the %3 table.', ENA = '%1 cannot be greater than %2 in the %3 table.';
        Text009: TextConst ENU = 'Deleting this document will cause a gap in the number series for shipments. An empty shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?', ENA = 'Deleting this document will cause a gap in the number series for shipments. An empty shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text012: TextConst ENU = 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ENA = 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text014: TextConst ENU = 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ENA = 'Deleting this document will cause a gap in the number series for posted CR/Adj Notes. An empty posted CR/Adj Note %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text015: TextConst ENU = 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\Do you want to change %1?', ENA = 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\Do you want to change %1?';
        Text017: TextConst ENU = 'You must delete the existing sales lines before you can change %1.', ENA = 'You must delete the existing sales lines before you can change %1.';
        Text018: TextConst ENU = 'You have changed %1 on the sales header, but it has not been changed on the existing sales lines.\', ENA = 'You have changed %1 on the sales header, but it has not been changed on the existing sales lines.\';
        Text019: TextConst ENU = 'You must update the existing sales lines manually.', ENA = 'You must update the existing sales lines manually.';
        Text020: TextConst ENU = 'The change may affect the exchange rate used in the price calculation of the sales lines.', ENA = 'The change may affect the exchange rate used in the price calculation of the sales lines.';
        Text021: TextConst ENU = 'Do you want to update the exchange rate?', ENA = 'Do you want to update the exchange rate?';
        Text022: TextConst ENU = 'You cannot delete this document. Your identification is set up to process from %1 %2 only.', ENA = 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text024: TextConst ENU = 'You have modified the %1 field. The recalculation of VAT may cause penny differences, so you must check the amounts afterward. Do you want to update the %2 field on the lines to reflect the new value of %1?', ENA = 'You have modified the %1 field. The recalculation of GST may cause small differences, so you must check the amounts afterwards. Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ENA = 'Your identification is set up to process from %1 %2 only.';
        Text028: TextConst ENU = 'You cannot change the %1 when the %2 has been filled in.', ENA = 'You cannot change the %1 when the %2 has been filled in.';
        Text030: TextConst ENU = 'Deleting this document will cause a gap in the number series for return receipts. An empty return receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?', ENA = 'Deleting this document will cause a gap in the number series for return receipts. An empty return receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text031: TextConst ENU = 'You have modified %1.\\', ENA = 'You have modified %1.\\';
        Text032: TextConst ENU = 'Do you want to update the lines?', ENA = 'Do you want to update the lines?';
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record "Customer";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCommentLine: Record "Sales Comment Line";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeaderPrepmt: Record "Sales Invoice Header";
        SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        RespCenter: Record "Responsibility Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record "Location";
        WhseRequest: Record "Warehouse Request";
        CompanyInfo: Record "Company Information";
        UserSetupMgt: Codeunit "User Setup Management";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        DimMgt: Codeunit "DimensionManagement";
        IdentityManagement: Codeunit "Identity Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        //PostCodeCheck : Codeunit "Post Code Check"; not found
        //BASManagement : Codeunit "BAS Management";
        PostingSetupMgt: Codeunit "PostingSetupManagement";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        VATAmount: Decimal;
        Text035: TextConst ENU = 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?', ENA = 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?';
        Text037: TextConst ENU = 'Contact %1 %2 is not related to customer %3.', ENA = 'Contact %1 %2 is not related to customer %3.';
        Text038: TextConst ENU = 'Contact %1 %2 is related to a different company than customer %3.', ENA = 'Contact %1 %2 is related to a different company than customer %3.';
        Text039: TextConst ENU = 'Contact %1 %2 is not related to a customer.', ENA = 'Contact %1 %2 is not related to a customer.';
        Text040: TextConst ENU = 'A won opportunity is linked to this order.\It has to be changed to status Lost before the Order can be deleted.\Do you want to change the status for this opportunity now?', ENA = 'A won opportunity is linked to this order.\It has to be changed to status Lost before the Order can be deleted.\Do you want to change the status for this opportunity now?';
        Text044: TextConst ENU = 'The status of the opportunity has not been changed. The program has aborted deleting the order.', ENA = 'The status of the opportunity has not been changed. The program has aborted deleting the order.';
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        Text045: TextConst ENU = 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.', ENA = 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text048: TextConst ENU = 'Sales quote %1 has already been assigned to opportunity %2. Would you like to reassign this quote?', ENA = 'Sales quote %1 has already been assigned to opportunity %2. Would you like to reassign this quote?';
        Text049: TextConst ENU = 'The %1 field cannot be blank because this quote is linked to an opportunity.', ENA = 'The %1 field cannot be blank because this quote is linked to an opportunity.';
        InsertMode: Boolean;
        HideCreditCheckDialogue: Boolean;
        Text051: TextConst ENU = 'The sales %1 %2 already exists.', ENA = 'The sales %1 %2 already exists.';
        Text053: TextConst ENU = 'You must cancel the approval process if you wish to change the %1.', ENA = 'You must cancel the approval process if you wish to change the %1.';
        Text056: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ENA = 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text057: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ENA = 'Deleting this document will cause a gap in the number series for prepayment CR/Adj Notes. An empty prepayment CR/Adj Note %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text061: TextConst ENU = '%1 is set up to process from %2 %3 only.', ENA = '%1 is set up to process from %2 %3 only.';
        Text062: TextConst ENU = 'You cannot change %1 because the corresponding %2 %3 has been assigned to this %4.', ENA = 'You cannot change %1 because the corresponding %2 %3 has been assigned to this %4.';
        Text064: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ENA = 'You may have changed a dimension.\\Do you want to update the lines?';
        UpdateDocumentDate: Boolean;
        Text066: TextConst ENU = 'You cannot change %1 to %2 because an open inventory pick on the %3.', ENA = 'You cannot change %1 to %2 because an open inventory pick on the %3.';
        Text070: TextConst ENU = 'You cannot change %1  to %2 because an open warehouse shipment exists for the %3.', ENA = 'You cannot change %1  to %2 because an open warehouse shipment exists for the %3.';
        BilltoCustomerNoChanged: Boolean;
        SelectNoSeriesAllowed: Boolean;
        PrepaymentInvoicesNotPaidErr: TextConst Comment = 'You cannot post the document of type Order with the number 1001 before all related prepayment invoices are posted.', ENU = 'You cannot post the document of type %1 with the number %2 before all related prepayment invoices are posted.', ENA = 'You cannot post the document of type %1 with the number %2 before all related prepayment invoices are posted.';
        Text072: TextConst ENU = 'There are unpaid prepayment invoices related to the document of type %1 with the number %2.', ENA = 'There are unpaid prepayment invoices related to the document of type %1 with the number %2.';
        Text1500000: TextConst ENU = '%1 and %2 must be identical or %1 must be Blank.', ENA = '%1 and %2 must be identical or %1 must be Blank.';
        DeferralLineQst: TextConst ENU = 'Do you want to update the deferral schedules for the lines?', ENA = 'Do you want to update the deferral schedules for the lines?';
        SynchronizingMsg: TextConst ENU = 'Synchronizing ...\ from: Sales Header with %1\ to: Assembly Header with %2.', ENA = 'Synchronising ...\ from: Sales Header with %1\ to: Assembly Header with %2.';
        EstimateTxt: TextConst ENU = 'Estimate', ENA = 'Estimate';
        ShippingAdviceErr: TextConst ENU = 'This order must be a complete shipment.', ENA = 'This order must be a complete shipment.';
        PostedDocsToPrintCreatedMsg: TextConst ENU = 'One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.', ENA = 'One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.';
        DocumentNotPostedClosePageQst: TextConst ENU = 'The document has not been posted.\Are you sure you want to exit?', ENA = 'The document has not been posted.\Are you sure you want to exit?';
        SelectCustomerTemplateQst: TextConst ENU = 'Do you want to select the customer template?', ENA = 'Do you want to select the customer template?';
        ModifyCustomerAddressNotificationLbl: TextConst ENU = 'Update the address', ENA = 'Update the address';
        DontShowAgainActionLbl: TextConst ENU = 'Don''t show again', ENA = 'Don''t show again';
        DontShowAgainFunctionTok: TextConst ENU = 'HideNotificationForCurrentUser', ENA = 'HideNotificationForCurrentUser';
        UpdateAddressWithSellToAddressFunctionTok: TextConst ENU = 'CopySellToCustomerAddressFieldsFromSalesDocument', ENA = 'CopySellToCustomerAddressFieldsFromSalesDocument';
        UpdateAddressWithBilltoAddressTok: TextConst ENU = 'CopyBillToCustomerAddressFieldsFromSalesDocument', ENA = 'CopyBillToCustomerAddressFieldsFromSalesDocument';
        ModifyCustomerAddressNotificationMsg: TextConst Comment = '%1=customer name', ENU = 'The address you entered for %1 is different from the customer''s existing address.', ENA = 'The address you entered for %1 is different from the customer''s existing address.';
        ValidVATNoMsg: TextConst ENU = 'The VAT registration number is valid.', ENA = 'The Exemption Certification number is valid.';
        InvalidVatRegNoMsg: TextConst ENU = 'The VAT registration number is not valid. Try entering the number again.', ENA = 'The Exemption Certification number is not valid. Try entering the number again.';
        SellToCustomerTxt: TextConst ENU = 'Sell-to Customer', ENA = 'Sell-to Customer';
        BillToCustomerTxt: TextConst ENU = 'Bill-to Customer', ENA = 'Bill-to Customer';
        ModifySellToCustomerAddressNotificationNameTxt: TextConst ENU = 'Update Sell-to Customer Address', ENA = 'Update Sell-to Customer Address';
        ModifySellToCustomerAddressNotificationDescriptionTxt: TextConst ENU = 'Warn if the sell-to address on sales documents is different from the customer''s existing address.', ENA = 'Warn if the sell-to address on sales documents is different from the customer''s existing address.';
        ModifyBillToCustomerAddressNotificationNameTxt: TextConst ENU = 'Update Bill-to Customer Address', ENA = 'Update Bill-to Customer Address';
        ModifyBillToCustomerAddressNotificationDescriptionTxt: TextConst ENU = 'Warn if the bill-to address on sales documents is different from the customer''s existing address.', ENA = 'Warn if the bill-to address on sales documents is different from the customer''s existing address.';
}
