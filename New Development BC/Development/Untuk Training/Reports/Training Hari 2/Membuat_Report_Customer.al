// report 52222 MyReport
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultRenderingLayout = "Report Customer";

//     dataset
//     {
//         dataitem(Customer; Customer)
//         {

//             column(No_; "No.")
//             {

//             }
//             column(Name; Name)
//             {

//             }
//             column(Name_2; "Name 2")
//             {

//             }

//             dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
//             {
//                 DataItemLinkReference = Customer;
//                 DataItemLink = "Customer No." = field("No.");


//                 column(Original_Amount; "Original Amount")
//                 {

//                 }
//             }
//         }
//     }

//     requestpage
//     {
//         AboutTitle = 'Teaching tip title';
//         AboutText = 'Teaching tip content';
//         layout
//         {
//             area(Content)
//             {
//                 group(GroupName)
//                 {
//                 }
//             }
//         }

//         actions
//         {
//             area(processing)
//             {
//                 action(LayoutName)
//                 {

//                 }
//             }
//         }
//     }

//     rendering
//     {
//         layout("Report Customer")
//         {
//             Type = Excel;
//             LayoutFile = 'mySpreadsheet.xlsx';
//         }
//     }

//     var
//         myInt: Integer;
// }