page 80125 "Mapping COA Expense"
{
    PageType = List;
    SourceTable = "Mapping COA Expense";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    Caption = 'Code';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = '1,2,1';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = '1,2,2';
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Caption = '1,2,6';
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Caption = '1,2,7';
                }
                field("Unit Group Dimension"; Rec."Unit Group Dimension")
                {
                    ApplicationArea = All;
                    Caption = 'Additional Dimension 2';
                }
                field("MR Usage Category"; Rec."MR Usage Category")
                {
                    ApplicationArea = All;
                    Caption = 'Additional Dimension 1';
                }
                field("Gen Bus. Posting Group"; Rec."Gen Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen Prod. Posting Group"; Rec."Gen Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Inventory Adjmt. Account"; Rec."Inventory Adjmt. Account")
                {
                    ApplicationArea = All;
                }
                field("Copy to Gen. Posting Setup"; Rec."Copy to Gen. Posting Setup")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Copy to Gen. Post Setup")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CopyDocument;
                Caption = 'Copy to Gen. Posting Setup';

                trigger OnAction()
                var
                begin
                    copyToGenPostingSetup();
                    CurrPage.UPDATE;
                end;
            }
        }
    }
    procedure copyToGenPostingSetup()
    var
        lRecGenSetup: Record "General Posting Setup";
        lRecGenSetupIns: Record "General Posting Setup";
        lRecGenSetupMod: Record "General Posting Setup";
        lRec: Record "Mapping COA Expense";
    begin
        lRec.RESET;
        lRec.SETRANGE("Copy to Gen. Posting Setup", FALSE);
        IF lRec.FIND('-') THEN BEGIN
            REPEAT
                lRecGenSetup.RESET;
                lRecGenSetup.SETRANGE("Gen. Bus. Posting Group", lRec."Gen Bus. Posting Group");
                lRecGenSetup.SETRANGE("Gen. Prod. Posting Group", lRec."Gen Prod. Posting Group");
                lRecGenSetup.SETRANGE("Inventory Adjmt. Account", lRec."Inventory Adjmt. Account");
                IF NOT lRecGenSetup.FIND('-') THEN BEGIN
                    lRecGenSetupMod.RESET;
                    lRecGenSetupMod.SETRANGE("Gen. Bus. Posting Group", lRec."Gen Bus. Posting Group");
                    lRecGenSetupMod.SETRANGE("Gen. Prod. Posting Group", lRec."Gen Prod. Posting Group");
                    IF lRecGenSetupMod.FIND('-') THEN BEGIN
                        lRecGenSetupMod.VALIDATE("Inventory Adjmt. Account", lRec."Inventory Adjmt. Account");
                        lRecGenSetupMod.MODIFY(TRUE);
                    END
                    ELSE BEGIN
                        lRecGenSetupIns.INIT;
                        lRecGenSetupIns.VALIDATE("Gen. Bus. Posting Group", lRec."Gen Bus. Posting Group");
                        lRecGenSetupIns.VALIDATE("Gen. Prod. Posting Group", lRec."Gen Prod. Posting Group");
                        lRecGenSetupIns.INSERT(TRUE);
                        lRecGenSetupIns.VALIDATE("Inventory Adjmt. Account", lRec."Inventory Adjmt. Account");
                        lRecGenSetupIns.MODIFY(TRUE);
                    END;
                END;
                lRec."Copy to Gen. Posting Setup" := TRUE;
                lRec.MODIFY;
            UNTIL lRec.NEXT = 0;
        END;
    end;
}
