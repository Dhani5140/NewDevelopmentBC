codeunit 80110 "Enumarands"
{
    trigger OnRun()
    begin
    end;

    var
        number: Decimal;
        "Ratus Ribuan": Integer;
        Output7: Text[20];
        "Sisa 7": Decimal;
        "Puluh Ribuan": Integer;
        "Sisa 8": Decimal;
        "output total": Text[255];
        Ribuan: Integer;
        "Sisa 9": Decimal;
        Output8: Text[20];
        Output9: Text[20];
        Ratusan: Integer;
        Puluhan: Integer;
        Satuan: Integer;
        Output10: Text[20];
        Output11: Text[20];
        Output12: Text[20];
        Output13: Text[30];
        output14: Text[30];
        "Sisa 10": Decimal;
        "sisa 11": Decimal;
        "sisa 12": Decimal;
        "Ratus Jutaan": Integer;
        "Puluh Jutaan": Integer;
        Jutaan: Integer;
        "Sisa 4": Decimal;
        "sisa 5": Decimal;
        "sisa 6": Decimal;
        output4: Text[20];
        output5: Text[20];
        output6: Text[20];
        "C-Billion": Integer;
        "X-Billion": Integer;
        Billion: Integer;
        "Sisa 1": Decimal;
        "Sisa 2": Decimal;
        "Sisa 3": Decimal;
        Output1: Text[20];
        Output2: Text[20];
        output3: Text[20];
        "Bahasa Indonesia": Boolean;
        perdec: Integer;
        "sisa 13": Decimal;
        percent: Integer;
        gBool_TenBillion: Boolean;
        gBool_Billion: Boolean;
        gBool_HundredMillion: Boolean;
        gBool_TenMillion: Boolean;
        gBool_Million: Boolean;
        gBool_HundredThousand: Boolean;
        gBool_TenThousand: Boolean;
        gBool_Thousand: Boolean;
        gBool_Hundred: Boolean;
        gBool_Puluhan: Boolean;

    procedure Terbilang(nilai: Decimal; currencycode: Code[10]; CurrencyText: Code[10]): Text[250]
    var
        myInt: Integer;
        lRecCurr: Record Currency;
    begin
        number := nilai;
        "output total" := '';
        "C-Billion" := 0;
        "X-Billion" := 0;
        Billion := 0;
        "Ratus Jutaan" := 0;
        "Puluh Jutaan" := 0;
        Jutaan := 0;
        "Ratus Ribuan" := 0;
        "Puluh Ribuan" := 0;
        Ribuan := 0;
        Ratusan := 0;
        Puluhan := 0;
        Satuan := 0;
        IF (currencycode = '') OR (currencycode = 'USD') THEN BEGIN
            "Bahasa Indonesia" := FALSE
        END
        ELSE
            "Bahasa Indonesia" := TRUE;
        CASE TRUE OF
            nilai > 100000000000.0:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 100000000000.0 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 100000000000.0 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 100000000000.0 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 100000000000.0 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 100000000000.0 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 100000000000.0 < 10000000):
                            gBool_Million := TRUE;
                        (nilai MOD 100000000000.0 < 100000000):
                            gBool_TenMillion := TRUE;
                        (nilai MOD 100000000000.0 < 1000000000):
                            gBool_HundredMillion := TRUE;
                        (nilai MOD 100000000000.0 < 10000000000.0):
                            gBool_Billion := TRUE;
                        (nilai MOD 100000000000.0 < 100000000000.0):
                            gBool_TenBillion := TRUE;
                    END;
                END;
            nilai > 10000000000.0:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 10000000000.0 = 0):
                            ;
                        (nilai MOD 10000000000.0 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 10000000000.0 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 10000000000.0 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 10000000000.0 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 10000000000.0 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 10000000000.0 < 10000000):
                            gBool_Million := TRUE;
                        (nilai MOD 10000000000.0 < 100000000):
                            gBool_TenMillion := TRUE;
                        (nilai MOD 10000000000.0 < 1000000000):
                            gBool_HundredMillion := TRUE;
                        (nilai MOD 10000000000.0 < 10000000000.0):
                            gBool_Billion := TRUE;
                    END;
                END;
            nilai > 1000000000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 1000000000 = 0):
                            ;
                        (nilai MOD 1000000000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 1000000000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 1000000000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 1000000000 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 1000000000 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 1000000000 < 10000000):
                            gBool_Million := TRUE;
                        (nilai MOD 1000000000 < 100000000):
                            gBool_TenMillion := TRUE;
                        (nilai MOD 1000000000 < 1000000000):
                            gBool_HundredMillion := TRUE;
                    END;
                END;
            nilai > 100000000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 100000000 = 0):
                            ;
                        (nilai MOD 100000000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 100000000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 100000000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 100000000 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 100000000 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 100000000 < 10000000):
                            gBool_Million := TRUE;
                        (nilai MOD 100000000 < 100000000):
                            gBool_TenMillion := TRUE;
                    END;
                END;
            nilai > 10000000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 10000000 = 0):
                            ;
                        (nilai MOD 10000000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 10000000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 10000000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 10000000 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 10000000 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 10000000 < 10000000):
                            gBool_Million := TRUE;
                    END;
                END;
            nilai > 1000000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 1000000 = 0):
                            ;
                        (nilai MOD 1000000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 1000000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 1000000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 1000000 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 1000000 < 1000000):
                            gBool_HundredThousand := TRUE;
                    END;
                END;
            nilai > 100000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 100000 = 0):
                            ;
                        (nilai MOD 100000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 100000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 100000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 100000 < 100000):
                            gBool_TenThousand := TRUE;
                    END;
                END;
            nilai > 10000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 10000 = 0):
                            ;
                        (nilai MOD 10000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 10000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 10000 < 10000):
                            gBool_Thousand := TRUE;
                    END;
                END;
            nilai > 1000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 1000 = 0):
                            ;
                        (nilai MOD 1000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 1000 < 1000):
                            gBool_Hundred := TRUE;
                    END;
                END;
            nilai > 100:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 100 = 0):
                            ;
                        (nilai MOD 100 < 100):
                            gBool_Puluhan := TRUE;
                    END;
                END;
        END;
        GetAndPlace(nilai);
        //1
        //Processing Hundreds of Billions -------------------------------------------
        "C-Billion" := nilai DIV 100000000000.0;
        "Sisa 1" := nilai - ("C-Billion" * 100000000000.0);
        IF "Bahasa Indonesia" THEN
            CASE "C-Billion" OF
                0:
                    Output1 := '';
                1:
                    Output1 := 'Seratus';
                2:
                    Output1 := 'Dua Ratus';
                3:
                    Output1 := 'Tiga Ratus';
                4:
                    Output1 := 'Empat Ratus';
                5:
                    Output1 := 'Lima Ratus';
                6:
                    Output1 := 'Enam Ratus';
                7:
                    Output1 := 'Tujuh Ratus';
                8:
                    Output1 := 'Delapan Ratus';
                9:
                    Output1 := 'Sembilan Ratus';
            END
        ELSE
            CASE "C-Billion" OF
                0:
                    Output1 := '';
                1:
                    Output1 := 'One Hundred';
                2:
                    Output1 := 'Two Hundred';
                3:
                    Output1 := 'Three Hundred';
                4:
                    Output1 := 'Four Hundred';
                5:
                    Output1 := 'Five Hundred';
                6:
                    Output1 := 'Six Hundred';
                7:
                    Output1 := 'Seven Hundred';
                8:
                    Output1 := 'Eight Hundred';
                9:
                    Output1 := 'Nine Hundred';
            END;
        IF gBool_TenBillion AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + Output1 + ' And '
        ELSE
            "output total" := "output total" + Output1;
        //2
        //Processing tens of Billions -----------------------------------------------
        "X-Billion" := "Sisa 1" DIV 10000000000.0;
        "Sisa 2" := "Sisa 1" - ("X-Billion" * 10000000000.0);
        IF "Bahasa Indonesia" THEN
            CASE "X-Billion" OF
                0:
                    Output2 := '';
                1:
                    Output2 := ' Sepuluh';
                2:
                    Output2 := ' Dua Puluh';
                3:
                    Output2 := ' Tiga Puluh';
                4:
                    Output2 := ' Empat Puluh';
                5:
                    Output2 := ' Lima Puluh';
                6:
                    Output2 := ' Enam Puluh';
                7:
                    Output2 := ' Tujuh Puluh';
                8:
                    Output2 := ' Delapan Puluh';
                9:
                    Output2 := ' Sembilan Puluh';
            END
        ELSE
            CASE "X-Billion" OF
                0:
                    Output2 := '';
                1:
                    Output2 := ' Ten';
                2:
                    Output2 := ' Twenty';
                3:
                    Output2 := ' Thirty';
                4:
                    Output2 := ' Forty';
                5:
                    Output2 := ' Fifty';
                6:
                    Output2 := ' Sixty';
                7:
                    Output2 := ' Seventy';
                8:
                    Output2 := ' Eighty';
                9:
                    Output2 := ' Ninety';
            END;
        IF gBool_Billion AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + Output2 + ' And '
        ELSE
            "output total" := "output total" + Output2;
        //3
        //Processing Billions -----------------------------------------------------
        Billion := "Sisa 2" DIV 1000000000;
        "Sisa 3" := "Sisa 2" - (Billion * 1000000000.0);
        IF "Bahasa Indonesia" THEN
            CASE Billion OF
                0:
                    output3 := '';
                1:
                    output3 := ' Satu';
                2:
                    output3 := ' Dua';
                3:
                    output3 := ' Tiga';
                4:
                    output3 := ' Empat';
                5:
                    output3 := ' Lima';
                6:
                    output3 := ' Enam';
                7:
                    output3 := ' Tujuh';
                8:
                    output3 := ' Delapan';
                9:
                    output3 := ' Sembilan';
            END
        ELSE
            CASE Billion OF
                0:
                    output3 := '';
                1:
                    output3 := ' One';
                2:
                    output3 := ' Two';
                3:
                    output3 := ' Three';
                4:
                    output3 := ' Four';
                5:
                    output3 := ' Five';
                6:
                    output3 := ' Six';
                7:
                    output3 := ' Seven';
                8:
                    output3 := ' Eight';
                9:
                    output3 := ' Nine';
            END;
        //Special case processing teens of Billions
        IF (("X-Billion" = 1) AND (Billion <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE Billion OF
                    1:
                        output3 := ' Sebelas';
                    2:
                        output3 := ' Dua Belas';
                    3:
                        output3 := ' Tiga Belas';
                    4:
                        output3 := ' Empat Belas';
                    5:
                        output3 := ' Lima Belas';
                    6:
                        output3 := ' Enam Belas';
                    7:
                        output3 := ' Tujuh Belas';
                    8:
                        output3 := ' Delapan Belas';
                    9:
                        output3 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE Billion OF
                    1:
                        output3 := ' Eleven';
                    2:
                        output3 := ' Twelve';
                    3:
                        output3 := ' Thirteen';
                    4:
                        output3 := ' Fourteen';
                    5:
                        output3 := ' Fifteen';
                    6:
                        output3 := ' Sixteen';
                    7:
                        output3 := ' Seventeen';
                    8:
                        output3 := ' Eighteen';
                    9:
                        output3 := ' Nineteen';
                END;
            END;
        //Putting the word milliar
        IF (nilai > 999999999) AND "Bahasa Indonesia" THEN
            "output total" := "output total" + output3 + ' Milliar'
        ELSE
            IF (nilai > 999999999) AND NOT "Bahasa Indonesia" THEN BEGIN
                IF gBool_HundredMillion THEN
                    "output total" := "output total" + output3 + ' Billion And '
                ELSE
                    "output total" := "output total" + output3 + ' Billion';
            END
            ELSE
                "output total" := "output total" + output3;
        //4
        //Processing hundreds of Millions -------------------------------------------
        "Ratus Jutaan" := "Sisa 3" DIV 100000000;
        "Sisa 4" := "Sisa 3" - ("Ratus Jutaan" * 100000000.0);
        IF "Bahasa Indonesia" THEN
            CASE "Ratus Jutaan" OF
                0:
                    output4 := '';
                1:
                    output4 := ' Seratus';
                2:
                    output4 := ' Dua Ratus';
                3:
                    output4 := ' Tiga Ratus';
                4:
                    output4 := ' Empat Ratus';
                5:
                    output4 := ' Lima Ratus';
                6:
                    output4 := ' Enam Ratus';
                7:
                    output4 := ' Tujuh Ratus';
                8:
                    output4 := ' Delapan Ratus';
                9:
                    output4 := ' Sembilan Ratus';
            END
        ELSE
            CASE "Ratus Jutaan" OF
                0:
                    output4 := '';
                1:
                    output4 := ' One Hundred';
                2:
                    output4 := ' Two Hundred';
                3:
                    output4 := ' Three Hundred';
                4:
                    output4 := ' Four Hundred';
                5:
                    output4 := ' Five Hundred';
                6:
                    output4 := ' Six Hundred';
                7:
                    output4 := ' Seven Hundred';
                8:
                    output4 := ' Eight Hundred';
                9:
                    output4 := ' Nine Hundred';
            END;
        IF gBool_TenMillion AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + output4 + ' And '
        ELSE
            "output total" := "output total" + output4;
        //5
        //Processing tens of Millions -----------------------------------------------
        "Puluh Jutaan" := "Sisa 4" DIV 10000000;
        "sisa 5" := "Sisa 4" - ("Puluh Jutaan" * 10000000.0);
        IF "Bahasa Indonesia" THEN
            CASE "Puluh Jutaan" OF
                0:
                    output5 := '';
                1:
                    output5 := ' Sepuluh';
                2:
                    output5 := ' Dua Puluh';
                3:
                    output5 := ' Tiga Puluh';
                4:
                    output5 := ' Empat Puluh';
                5:
                    output5 := ' Lima Puluh';
                6:
                    output5 := ' Enam Puluh';
                7:
                    output5 := ' Tujuh Puluh';
                8:
                    output5 := ' Delapan Puluh';
                9:
                    output5 := ' Sembilan Puluh';
            END
        ELSE
            CASE "Puluh Jutaan" OF
                0:
                    output5 := '';
                1:
                    output5 := ' Ten';
                2:
                    output5 := ' Twenty';
                3:
                    output5 := ' Thirty';
                4:
                    output5 := ' Forty';
                5:
                    output5 := ' Fifty';
                6:
                    output5 := ' Sixty';
                7:
                    output5 := ' Seventy';
                8:
                    output5 := ' Eighty';
                9:
                    output5 := ' Ninety';
            END;
        IF gBool_Million AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + output5 + ' And '
        ELSE
            "output total" := "output total" + output5;
        //6
        //Processing Millions -----------------------------------------------------
        Jutaan := "sisa 5" DIV 1000000;
        "sisa 6" := "sisa 5" - (Jutaan * 1000000.0);
        IF "Bahasa Indonesia" THEN
            CASE Jutaan OF
                0:
                    output6 := '';
                1:
                    output6 := ' Satu';
                2:
                    output6 := ' Dua';
                3:
                    output6 := ' Tiga';
                4:
                    output6 := ' Empat';
                5:
                    output6 := ' Lima';
                6:
                    output6 := ' Enam';
                7:
                    output6 := ' Tujuh';
                8:
                    output6 := ' Delapan';
                9:
                    output6 := ' Sembilan';
            END
        ELSE
            CASE Jutaan OF
                0:
                    output6 := '';
                1:
                    output6 := ' One';
                2:
                    output6 := ' Two';
                3:
                    output6 := ' Three';
                4:
                    output6 := ' Four';
                5:
                    output6 := ' Five';
                6:
                    output6 := ' Six';
                7:
                    output6 := ' Seven';
                8:
                    output6 := ' Eight';
                9:
                    output6 := ' Nine';
            END;
        //Special case processing teens of Millions
        IF (("Puluh Jutaan" = 1) AND (Jutaan <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE Jutaan OF
                    1:
                        output6 := ' Sebelas';
                    2:
                        output6 := ' Dua Belas';
                    3:
                        output6 := ' Tiga Belas';
                    4:
                        output6 := ' Empat Belas';
                    5:
                        output6 := ' Lima Belas';
                    6:
                        output6 := ' Enam Belas';
                    7:
                        output6 := ' Tujuh Belas';
                    8:
                        output6 := ' Delapan Belas';
                    9:
                        output6 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE Jutaan OF
                    1:
                        output6 := ' Eleven';
                    2:
                        output6 := ' Twelve';
                    3:
                        output6 := ' Thirteen';
                    4:
                        output6 := ' Fourteen';
                    5:
                        output6 := ' Fifteen';
                    6:
                        output6 := ' Sixteen';
                    7:
                        output6 := ' Seventeen';
                    8:
                        output6 := ' Eighteen';
                    9:
                        output6 := ' Nineteen';
                END;
            END;
        //Putting the word million or Juta
        IF ("Sisa 3" > 999999) AND "Bahasa Indonesia" THEN
            "output total" := "output total" + output6 + ' Juta'
        ELSE
            IF ("Sisa 3" > 999999) AND NOT "Bahasa Indonesia" THEN BEGIN
                IF gBool_HundredThousand THEN
                    "output total" := "output total" + output6 + ' Million And '
                ELSE
                    "output total" := "output total" + output6 + ' Million';
            END
            ELSE
                "output total" := "output total" + output6;
        //7
        //Processing hundreds of thousands -----------------------------------------
        "Ratus Ribuan" := "sisa 6" DIV 100000;
        "Sisa 7" := "sisa 6" - ("Ratus Ribuan" * 100000.0);
        IF "Bahasa Indonesia" THEN
            CASE "Ratus Ribuan" OF
                0:
                    Output7 := '';
                1:
                    Output7 := ' Seratus';
                2:
                    Output7 := ' Dua Ratus';
                3:
                    Output7 := ' Tiga Ratus';
                4:
                    Output7 := ' Empat Ratus';
                5:
                    Output7 := ' Lima Ratus';
                6:
                    Output7 := ' Enam Ratus';
                7:
                    Output7 := ' Tujuh Ratus';
                8:
                    Output7 := ' Delapan Ratus';
                9:
                    Output7 := ' Sembilan Ratus';
            END
        ELSE
            CASE "Ratus Ribuan" OF
                0:
                    Output7 := '';
                1:
                    Output7 := ' One Hundred';
                2:
                    Output7 := ' Two Hundred';
                3:
                    Output7 := ' Three Hundred';
                4:
                    Output7 := ' Four Hundred';
                5:
                    Output7 := ' Five Hundred';
                6:
                    Output7 := ' Six Hundred';
                7:
                    Output7 := ' Seven Hundred';
                8:
                    Output7 := ' Eight Hundred';
                9:
                    Output7 := ' Nine Hundred';
            END;
        IF gBool_TenThousand AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + Output7 + ' And '
        ELSE
            "output total" := "output total" + Output7;
        //8
        //Processing ten of thousands -----------------------------------------------
        "Puluh Ribuan" := "Sisa 7" DIV 10000;
        "Sisa 8" := "Sisa 7" - ("Puluh Ribuan" * 10000.0);
        IF "Bahasa Indonesia" THEN
            CASE "Puluh Ribuan" OF
                0:
                    Output8 := '';
                1:
                    Output8 := ' Sepuluh';
                2:
                    Output8 := ' Dua Puluh';
                3:
                    Output8 := ' Tiga Puluh';
                4:
                    Output8 := ' Empat Puluh';
                5:
                    Output8 := ' Lima Puluh';
                6:
                    Output8 := ' Enam Puluh';
                7:
                    Output8 := ' Tujuh Puluh';
                8:
                    Output8 := ' Delapan Puluh';
                9:
                    Output8 := ' Sembilan Puluh';
            END
        ELSE
            CASE "Puluh Ribuan" OF
                0:
                    Output8 := '';
                1:
                    Output8 := ' Ten';
                2:
                    Output8 := ' Twenty';
                3:
                    Output8 := ' Thirty';
                4:
                    Output8 := ' Forty';
                5:
                    Output8 := ' Fifty';
                6:
                    Output8 := ' Sixty';
                7:
                    Output8 := ' Seventy';
                8:
                    Output8 := ' Eighty';
                9:
                    Output8 := ' Ninety';
            END;
        IF gBool_Thousand AND NOT "Bahasa Indonesia" THEN ///// "output total" := "output total" + Output8 + ' And '
            "output total" := "output total" + Output8 + ' '
        ELSE
            "output total" := "output total" + Output8;
        //9
        //Processing thousands -----------------------------------------------------
        Ribuan := "Sisa 8" DIV 1000;
        "Sisa 9" := "Sisa 8" - (Ribuan * 1000.0);
        IF "Bahasa Indonesia" THEN
            CASE Ribuan OF
                0:
                    Output9 := '';
                1:
                    Output9 := ' Satu';
                2:
                    Output9 := ' Dua';
                3:
                    Output9 := ' Tiga';
                4:
                    Output9 := ' Empat';
                5:
                    Output9 := ' Lima';
                6:
                    Output9 := ' Enam';
                7:
                    Output9 := ' Tujuh';
                8:
                    Output9 := ' Delapan';
                9:
                    Output9 := ' Sembilan';
            END
        ELSE
            CASE Ribuan OF
                0:
                    Output9 := '';
                1:
                    Output9 := ' One';
                2:
                    Output9 := ' Two';
                3:
                    Output9 := ' Three';
                4:
                    Output9 := ' Four';
                5:
                    Output9 := ' Five';
                6:
                    Output9 := ' Six';
                7:
                    Output9 := ' Seven';
                8:
                    Output9 := ' Eight';
                9:
                    Output9 := ' Nine';
            END;
        //Special case processing teens of Thousands
        IF (("Puluh Ribuan" = 1) AND (Ribuan <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE Ribuan OF
                    1:
                        Output9 := ' Sebelas';
                    2:
                        Output9 := ' Dua Belas';
                    3:
                        Output9 := ' Tiga Belas';
                    4:
                        Output9 := ' Empat Belas';
                    5:
                        Output9 := ' Lima Belas';
                    6:
                        Output9 := ' Enam Belas';
                    7:
                        Output9 := ' Tujuh Belas';
                    8:
                        Output9 := ' Delapan Belas';
                    9:
                        Output9 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE Ribuan OF
                    1:
                        Output9 := ' Eleven';
                    2:
                        Output9 := ' Twelve';
                    3:
                        Output9 := ' Thirteen';
                    4:
                        Output9 := ' Fourteen';
                    5:
                        Output9 := ' Fifteen';
                    6:
                        Output9 := ' Sixteen';
                    7:
                        Output9 := ' Seventeen';
                    8:
                        Output9 := ' Eighteen';
                    9:
                        Output9 := ' Nineteen';
                END;
            END;
        //Putting The word Thousand or Ribu
        IF ("sisa 6" > 999) AND "Bahasa Indonesia" AND ((("Puluh Ribuan" <> 0) OR ("Ratus Ribuan" <> 0)) OR (Ribuan > 1)) THEN
            "output total" := "output total" + Output9 + ' Ribu'
        ELSE
            IF ("sisa 6" > 999) AND "Bahasa Indonesia" AND ("Puluh Ribuan" = 0) AND ("Ratus Ribuan" = 0) AND (Ribuan = 1) THEN
                "output total" := "output total" + ' Seribu'
            ELSE
                IF ("sisa 6" > 999) AND NOT "Bahasa Indonesia" THEN BEGIN
                    IF gBool_Hundred THEN
                        "output total" := "output total" + Output9 + ' Thousand And'
                    ELSE
                        "output total" := "output total" + Output9 + ' Thousand';
                END
                ELSE
                    "output total" := "output total" + Output9;
        //10
        //Processing hundreds -----------------------------------------------------
        Ratusan := "Sisa 9" DIV 100;
        "Sisa 10" := "Sisa 9" - (Ratusan * 100.0);
        IF "Bahasa Indonesia" THEN
            CASE Ratusan OF
                0:
                    Output10 := '';
                1:
                    Output10 := ' Seratus';
                2:
                    Output10 := ' Dua Ratus';
                3:
                    Output10 := ' Tiga Ratus';
                4:
                    Output10 := ' Empat Ratus';
                5:
                    Output10 := ' Lima Ratus';
                6:
                    Output10 := ' Enam Ratus';
                7:
                    Output10 := ' Tujuh Ratus';
                8:
                    Output10 := ' Delapan Ratus';
                9:
                    Output10 := ' Sembilan Ratus';
            END
        ELSE
            CASE Ratusan OF
                0:
                    Output10 := '';
                1:
                    Output10 := ' One Hundred';
                2:
                    Output10 := ' Two Hundred';
                3:
                    Output10 := ' Three Hundred';
                4:
                    Output10 := ' Four Hundred';
                5:
                    Output10 := ' Five Hundred';
                6:
                    Output10 := ' Six Hundred';
                7:
                    Output10 := ' Seven Hundred';
                8:
                    Output10 := ' Eight Hundred';
                9:
                    Output10 := ' Nine Hundred';
            END;
        IF gBool_Puluhan AND NOT "Bahasa Indonesia" THEN BEGIN
            "output total" := "output total" + Output10 + ' And ';
        END
        ELSE BEGIN
            "output total" := "output total" + Output10;
        END;
        //11
        //Processing tens ---------------------------------------------------------
        Puluhan := "Sisa 10" DIV 10;
        "sisa 11" := "Sisa 10" - (Puluhan * 10);
        IF "Bahasa Indonesia" THEN
            CASE Puluhan OF
                0:
                    Output11 := '';
                1:
                    Output11 := ' Sepuluh';
                2:
                    Output11 := ' Dua Puluh';
                3:
                    Output11 := ' Tiga Puluh';
                4:
                    Output11 := ' Empat Puluh';
                5:
                    Output11 := ' Lima Puluh';
                6:
                    Output11 := ' Enam Puluh';
                7:
                    Output11 := ' Tujuh Puluh';
                8:
                    Output11 := ' Delapan Puluh';
                9:
                    Output11 := ' Sembilan Puluh';
            END
        ELSE
            CASE Puluhan OF
                0:
                    Output11 := '';
                1:
                    Output11 := ' Ten';
                2:
                    Output11 := ' Twenty';
                3:
                    Output11 := ' Thirty';
                4:
                    Output11 := ' Forty';
                5:
                    Output11 := ' Fifty';
                6:
                    Output11 := ' Sixty';
                7:
                    Output11 := ' Seventy';
                8:
                    Output11 := ' Eighty';
                9:
                    Output11 := ' Ninety';
            END;
        "output total" := "output total" + Output11;
        //12
        //Processing singles ----------------------------------------------------------
        Satuan := "sisa 11" DIV 1;
        "sisa 12" := "sisa 11" - Satuan;
        IF "Bahasa Indonesia" THEN
            CASE Satuan OF
                0:
                    Output12 := '';
                1:
                    Output12 := ' Satu';
                2:
                    Output12 := ' Dua';
                3:
                    Output12 := ' Tiga';
                4:
                    Output12 := ' Empat';
                5:
                    Output12 := ' Lima';
                6:
                    Output12 := ' Enam';
                7:
                    Output12 := ' Tujuh';
                8:
                    Output12 := ' Delapan';
                9:
                    Output12 := ' Sembilan';
            END
        ELSE
            CASE Satuan OF
                0:
                    Output12 := '';
                1:
                    Output12 := ' One';
                2:
                    Output12 := ' Two';
                3:
                    Output12 := ' Three';
                4:
                    Output12 := ' Four';
                5:
                    Output12 := ' Five';
                6:
                    Output12 := ' Six';
                7:
                    Output12 := ' Seven';
                8:
                    Output12 := ' Eight';
                9:
                    Output12 := ' Nine';
            END;
        //Special case processing teens
        IF ((Puluhan = 1) AND (Satuan <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE Satuan OF
                    1:
                        Output12 := ' Sebelas';
                    2:
                        Output12 := ' Dua Belas';
                    3:
                        Output12 := ' Tiga Belas';
                    4:
                        Output12 := ' Empat Belas';
                    5:
                        Output12 := ' Lima Belas';
                    6:
                        Output12 := ' Enam Belas';
                    7:
                        Output12 := ' Tujuh Belas';
                    8:
                        Output12 := ' Delapan Belas';
                    9:
                        Output12 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE Satuan OF
                    1:
                        Output12 := ' Eleven';
                    2:
                        Output12 := ' Twelve';
                    3:
                        Output12 := ' Thirteen';
                    4:
                        Output12 := ' Fourteen';
                    5:
                        Output12 := ' Fifteen';
                    6:
                        Output12 := ' Sixteen';
                    7:
                        Output12 := ' Seventeen';
                    8:
                        Output12 := ' Eighteen';
                    9:
                        Output12 := ' Nineteen';
                END;
            END;
        IF "Bahasa Indonesia" THEN
            "output total" := "output total" + Output12
        ELSE
            "output total" := "output total" + Output12;
        //fractional 13
        perdec := "sisa 12" DIV 0.1;
        "sisa 13" := "sisa 12" - (perdec * 0.1);
        IF "Bahasa Indonesia" THEN BEGIN
            "output total" := "output total";
            CASE perdec OF
                0:
                    Output13 := ' ';
                1:
                    Output13 := ' Satu';
                2:
                    Output13 := ' Dua';
                3:
                    Output13 := ' Tiga';
                4:
                    Output13 := ' Empats';
                5:
                    Output13 := ' Lima';
                6:
                    Output13 := ' Enam';
                7:
                    Output13 := ' Tujuh';
                8:
                    Output13 := ' Delapan';
                9:
                    Output13 := ' Sembilan';
            END
        END
        ELSE BEGIN
            "output total" := "output total";
            CASE perdec OF
                0:
                    Output13 := ' Zero';
                1:
                    Output13 := ' Ten';
                2:
                    Output13 := ' Twenty';
                3:
                    Output13 := ' Thirty';
                4:
                    Output13 := ' Forty';
                5:
                    Output13 := ' Fifty';
                6:
                    Output13 := ' Sixty';
                7:
                    Output13 := ' Seventy';
                8:
                    Output13 := ' Eighty';
                9:
                    Output13 := ' Ninety';
            END;
        END;
        IF "sisa 12" > 0 THEN
            IF "Bahasa Indonesia" THEN
                "output total" := "output total" + ' poin' + Output13
            ELSE
                //#001
                //"output total" := "output total" + ' and' + Output13;
                "output total" := "output total" + ' point' + Output13;
        //#001 End
        //fractional 14
        percent := "sisa 13" DIV 0.01;
        IF "Bahasa Indonesia" THEN
            CASE percent OF
                0:
                    output14 := '';
                1:
                    output14 := ' Satu';
                2:
                    output14 := ' Dua';
                3:
                    output14 := ' Tiga';
                4:
                    output14 := ' Empat';
                5:
                    output14 := ' Lima';
                6:
                    output14 := ' Enam';
                7:
                    output14 := ' Tujuh';
                8:
                    output14 := ' Delapan';
                9:
                    output14 := ' Sembilan';
            END
        ELSE
            CASE percent OF
                0:
                    output14 := '';
                1:
                    output14 := ' One';
                2:
                    output14 := ' Two';
                3:
                    output14 := ' Three';
                4:
                    output14 := ' Four';
                5:
                    output14 := ' Five';
                6:
                    output14 := ' Six';
                7:
                    output14 := ' Seven';
                8:
                    output14 := ' Eight';
                9:
                    output14 := ' Nine';
            END;
        //Special case processing teens
        IF ((perdec = 1) AND (percent <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 5));
                CASE percent OF
                    1:
                        output14 := ' Sebelas';
                    2:
                        output14 := ' Dua Belas';
                    3:
                        output14 := ' Tiga Belas';
                    4:
                        output14 := ' Empat Belas';
                    5:
                        output14 := ' Lima Belas';
                    6:
                        output14 := ' Enam Belas';
                    7:
                        output14 := ' Tujuh Belas';
                    8:
                        output14 := ' Delapan Belas';
                    9:
                        output14 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE percent OF
                    1:
                        output14 := ' Eleven';
                    2:
                        output14 := ' Twelve';
                    3:
                        output14 := ' Thirteen';
                    4:
                        output14 := ' Fourteen';
                    5:
                        output14 := ' Fifteen';
                    6:
                        output14 := ' Sixteen';
                    7:
                        output14 := ' Seventeen';
                    8:
                        output14 := ' Eighteen';
                    9:
                        output14 := ' Nineteen';
                END;
            END;
        IF ("sisa 12" > 0) THEN
            IF "Bahasa Indonesia" THEN
                "output total" := "output total" + output14
            ELSE
                "output total" := "output total" + output14; //#002 + ' Cent';
        //mhd
        // IF CurrencyText = 'IDR' THEN BEGIN
        //     "output total" := "output total" + ' Rupiah'
        // END ELSE BEGIN
        //     IF (currencycode = '') OR (currencycode = 'USD') THEN
        //         "output total" := "output total" + ' US Dollar'
        //     ELSE BEGIN
        //         lRecCurr.GET(currencycode);
        //     END;
        //     //mhd
        //     //"output total" := "output total" + ' ' + lRecCurr.Terbilang;
        // END;
        IF (CurrencyText = '') OR (CurrencyText = 'IDR') THEN BEGIN
            "output total" := "output total" + ' Rupiah';
        END
        ELSE BEGIN
            lRecCurr.RESET;
            lRecCurr.SETRANGE(lRecCurr."Code", CurrencyText);
            IF lRecCurr.FINDFIRST THEN BEGIN
                "output total" := "output total" + ' ' + lRecCurr.Description;
            END
            ELSE BEGIN
                "output total" := "output total";
            END;
        END;
        EXIT("output total");
    end;

    local procedure GetAndPlace(pDec_Nilai: Decimal)
    var
        myInt: Integer;
    begin
        CASE TRUE OF
            gBool_Puluhan:
                EXIT;
            gBool_Hundred:
                BEGIN
                    IF (pDec_Nilai MOD 100 < 100) THEN BEGIN
                        IF (pDec_Nilai MOD 100 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_Puluhan := TRUE;
                            gBool_Hundred := FALSE;
                        END;
                    END;
                END;
            gBool_Thousand:
                BEGIN
                    IF (pDec_Nilai MOD 1000 < 1000) THEN BEGIN
                        IF (pDec_Nilai MOD 1000 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_Hundred := TRUE;
                            gBool_Thousand := FALSE;
                            GetAndPlace(pDec_Nilai);
                        END;
                    END;
                END;
            gBool_TenThousand:
                BEGIN
                    IF (pDec_Nilai MOD 10000 < 10000) THEN BEGIN
                        IF (pDec_Nilai MOD 10000 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_Thousand := TRUE;
                            gBool_TenThousand := FALSE;
                            GetAndPlace(pDec_Nilai);
                        END;
                    END;
                END;
            gBool_HundredThousand:
                BEGIN
                    IF (pDec_Nilai MOD 100000 < 100000) THEN BEGIN
                        IF (pDec_Nilai MOD 100000 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_TenThousand := TRUE;
                            gBool_HundredThousand := FALSE;
                            GetAndPlace(pDec_Nilai);
                        END;
                    END;
                END;
            gBool_Million:
                BEGIN
                    IF (pDec_Nilai MOD 1000000 < 1000000) THEN BEGIN
                        IF (pDec_Nilai MOD 1000000 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_HundredThousand := TRUE;
                            gBool_Million := FALSE;
                            GetAndPlace(pDec_Nilai);
                        END;
                    END;
                END;
            gBool_TenMillion:
                BEGIN
                    IF (pDec_Nilai MOD 10000000 < 10000000) THEN BEGIN
                        IF (pDec_Nilai MOD 10000000 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_Million := TRUE;
                            gBool_TenMillion := FALSE;
                            GetAndPlace(pDec_Nilai);
                        END;
                    END;
                END;
            gBool_HundredMillion:
                BEGIN
                    IF (pDec_Nilai MOD 100000000 < 100000000) THEN BEGIN
                        IF (pDec_Nilai MOD 100000000 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_TenMillion := TRUE;
                            gBool_HundredMillion := FALSE;
                            GetAndPlace(pDec_Nilai);
                        END;
                    END;
                END;
            gBool_Billion:
                BEGIN
                    IF (pDec_Nilai MOD 1000000000 < 1000000000) THEN BEGIN
                        IF (pDec_Nilai MOD 100000000 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_HundredMillion := TRUE;
                            gBool_Billion := FALSE;
                            GetAndPlace(pDec_Nilai);
                        END;
                    END;
                END;
            gBool_TenBillion:
                BEGIN
                    IF (pDec_Nilai MOD 10000000000.0 < 10000000000.0) THEN BEGIN
                        IF (pDec_Nilai MOD 1000000000 = 0) THEN
                            EXIT
                        ELSE BEGIN
                            gBool_Billion := TRUE;
                            gBool_TenBillion := FALSE;
                            GetAndPlace(pDec_Nilai);
                        END;
                    END;
                END;
        END;
    end;

    procedure Terbilang2(nilai: Decimal; currencycode: Code[10]; CurrencyText: Code[10]): Text[250]
    var
        myInt: Integer;
        lRecCurr: Record Currency;
    begin
        number := nilai;
        "output total" := '';
        "C-Billion" := 0;
        "X-Billion" := 0;
        Billion := 0;
        "Ratus Jutaan" := 0;
        "Puluh Jutaan" := 0;
        Jutaan := 0;
        "Ratus Ribuan" := 0;
        "Puluh Ribuan" := 0;
        Ribuan := 0;
        Ratusan := 0;
        Puluhan := 0;
        Satuan := 0;
        //IF (currencycode = '') OR (currencycode = 'IDR') THEN
        //   BEGIN
        "Bahasa Indonesia" := TRUE;
        //   END
        //ELSE
        //   "Bahasa Indonesia" := FALSE;
        CASE TRUE OF
            nilai > 100000000000.0:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 100000000000.0 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 100000000000.0 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 100000000000.0 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 100000000000.0 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 100000000000.0 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 100000000000.0 < 10000000):
                            gBool_Million := TRUE;
                        (nilai MOD 100000000000.0 < 100000000):
                            gBool_TenMillion := TRUE;
                        (nilai MOD 100000000000.0 < 1000000000):
                            gBool_HundredMillion := TRUE;
                        (nilai MOD 100000000000.0 < 10000000000.0):
                            gBool_Billion := TRUE;
                        (nilai MOD 100000000000.0 < 100000000000.0):
                            gBool_TenBillion := TRUE;
                    END;
                END;
            nilai > 10000000000.0:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 10000000000.0 = 0):
                            ;
                        (nilai MOD 10000000000.0 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 10000000000.0 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 10000000000.0 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 10000000000.0 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 10000000000.0 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 10000000000.0 < 10000000):
                            gBool_Million := TRUE;
                        (nilai MOD 10000000000.0 < 100000000):
                            gBool_TenMillion := TRUE;
                        (nilai MOD 10000000000.0 < 1000000000):
                            gBool_HundredMillion := TRUE;
                        (nilai MOD 10000000000.0 < 10000000000.0):
                            gBool_Billion := TRUE;
                    END;
                END;
            nilai > 1000000000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 1000000000 = 0):
                            ;
                        (nilai MOD 1000000000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 1000000000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 1000000000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 1000000000 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 1000000000 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 1000000000 < 10000000):
                            gBool_Million := TRUE;
                        (nilai MOD 1000000000 < 100000000):
                            gBool_TenMillion := TRUE;
                        (nilai MOD 1000000000 < 1000000000):
                            gBool_HundredMillion := TRUE;
                    END;
                END;
            nilai > 100000000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 100000000 = 0):
                            ;
                        (nilai MOD 100000000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 100000000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 100000000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 100000000 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 100000000 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 100000000 < 10000000):
                            gBool_Million := TRUE;
                        (nilai MOD 100000000 < 100000000):
                            gBool_TenMillion := TRUE;
                    END;
                END;
            nilai > 10000000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 10000000 = 0):
                            ;
                        (nilai MOD 10000000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 10000000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 10000000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 10000000 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 10000000 < 1000000):
                            gBool_HundredThousand := TRUE;
                        (nilai MOD 10000000 < 10000000):
                            gBool_Million := TRUE;
                    END;
                END;
            nilai > 1000000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 1000000 = 0):
                            ;
                        (nilai MOD 1000000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 1000000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 1000000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 1000000 < 100000):
                            gBool_TenThousand := TRUE;
                        (nilai MOD 1000000 < 1000000):
                            gBool_HundredThousand := TRUE;
                    END;
                END;
            nilai > 100000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 100000 = 0):
                            ;
                        (nilai MOD 100000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 100000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 100000 < 10000):
                            gBool_Thousand := TRUE;
                        (nilai MOD 100000 < 100000):
                            gBool_TenThousand := TRUE;
                    END;
                END;
            nilai > 10000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 10000 = 0):
                            ;
                        (nilai MOD 10000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 10000 < 1000):
                            gBool_Hundred := TRUE;
                        (nilai MOD 10000 < 10000):
                            gBool_Thousand := TRUE;
                    END;
                END;
            nilai > 1000:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 1000 = 0):
                            ;
                        (nilai MOD 1000 < 100):
                            gBool_Puluhan := TRUE;
                        (nilai MOD 1000 < 1000):
                            gBool_Hundred := TRUE;
                    END;
                END;
            nilai > 100:
                BEGIN
                    CASE TRUE OF
                        (nilai MOD 100 = 0):
                            ;
                        (nilai MOD 100 < 100):
                            gBool_Puluhan := TRUE;
                    END;
                END;
        END;
        GetAndPlace(nilai);
        //1
        //Processing Hundreds of Billions -------------------------------------------
        "C-Billion" := nilai DIV 100000000000.0;
        "Sisa 1" := nilai - ("C-Billion" * 100000000000.0);
        IF "Bahasa Indonesia" THEN
            CASE "C-Billion" OF
                0:
                    Output1 := '';
                1:
                    Output1 := 'Seratus';
                2:
                    Output1 := 'Dua Ratus';
                3:
                    Output1 := 'Tiga Ratus';
                4:
                    Output1 := 'Empat Ratus';
                5:
                    Output1 := 'Lima Ratus';
                6:
                    Output1 := 'Enam Ratus';
                7:
                    Output1 := 'Tujuh Ratus';
                8:
                    Output1 := 'Delapan Ratus';
                9:
                    Output1 := 'Sembilan Ratus';
            END
        ELSE
            CASE "C-Billion" OF
                0:
                    Output1 := '';
                1:
                    Output1 := 'One Hundred';
                2:
                    Output1 := 'Two Hundred';
                3:
                    Output1 := 'Three Hundred';
                4:
                    Output1 := 'Four Hundred';
                5:
                    Output1 := 'Five Hundred';
                6:
                    Output1 := 'Six Hundred';
                7:
                    Output1 := 'Seven Hundred';
                8:
                    Output1 := 'Eight Hundred';
                9:
                    Output1 := 'Nine Hundred';
            END;
        IF gBool_TenBillion AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + Output1 + ' And '
        ELSE
            "output total" := "output total" + Output1;
        //2
        //Processing tens of Billions -----------------------------------------------
        "X-Billion" := "Sisa 1" DIV 10000000000.0;
        "Sisa 2" := "Sisa 1" - ("X-Billion" * 10000000000.0);
        IF "Bahasa Indonesia" THEN
            CASE "X-Billion" OF
                0:
                    Output2 := '';
                1:
                    Output2 := ' Sepuluh';
                2:
                    Output2 := ' Dua Puluh';
                3:
                    Output2 := ' Tiga Puluh';
                4:
                    Output2 := ' Empat Puluh';
                5:
                    Output2 := ' Lima Puluh';
                6:
                    Output2 := ' Enam Puluh';
                7:
                    Output2 := ' Tujuh Puluh';
                8:
                    Output2 := ' Delapan Puluh';
                9:
                    Output2 := ' Sembilan Puluh';
            END
        ELSE
            CASE "X-Billion" OF
                0:
                    Output2 := '';
                1:
                    Output2 := ' Ten';
                2:
                    Output2 := ' Twenty';
                3:
                    Output2 := ' Thirty';
                4:
                    Output2 := ' Forty';
                5:
                    Output2 := ' Fifty';
                6:
                    Output2 := ' Sixty';
                7:
                    Output2 := ' Seventy';
                8:
                    Output2 := ' Eighty';
                9:
                    Output2 := ' Ninety';
            END;
        IF gBool_Billion AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + Output2 + ' And '
        ELSE
            "output total" := "output total" + Output2;
        //3
        //Processing Billions -----------------------------------------------------
        Billion := "Sisa 2" DIV 1000000000;
        "Sisa 3" := "Sisa 2" - (Billion * 1000000000.0);
        IF "Bahasa Indonesia" THEN
            CASE Billion OF
                0:
                    output3 := '';
                1:
                    output3 := ' Satu';
                2:
                    output3 := ' Dua';
                3:
                    output3 := ' Tiga';
                4:
                    output3 := ' Empat';
                5:
                    output3 := ' Lima';
                6:
                    output3 := ' Enam';
                7:
                    output3 := ' Tujuh';
                8:
                    output3 := ' Delapan';
                9:
                    output3 := ' Sembilan';
            END
        ELSE
            CASE Billion OF
                0:
                    output3 := '';
                1:
                    output3 := ' One';
                2:
                    output3 := ' Two';
                3:
                    output3 := ' Three';
                4:
                    output3 := ' Four';
                5:
                    output3 := ' Five';
                6:
                    output3 := ' Six';
                7:
                    output3 := ' Seven';
                8:
                    output3 := ' Eight';
                9:
                    output3 := ' Nine';
            END;
        //Special case processing teens of Billions
        IF (("X-Billion" = 1) AND (Billion <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE Billion OF
                    1:
                        output3 := ' Sebelas';
                    2:
                        output3 := ' Dua Belas';
                    3:
                        output3 := ' Tiga Belas';
                    4:
                        output3 := ' Empat Belas';
                    5:
                        output3 := ' Lima Belas';
                    6:
                        output3 := ' Enam Belas';
                    7:
                        output3 := ' Tujuh Belas';
                    8:
                        output3 := ' Delapan Belas';
                    9:
                        output3 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE Billion OF
                    1:
                        output3 := ' Eleven';
                    2:
                        output3 := ' Twelve';
                    3:
                        output3 := ' Thirteen';
                    4:
                        output3 := ' Fourteen';
                    5:
                        output3 := ' Fifteen';
                    6:
                        output3 := ' Sixteen';
                    7:
                        output3 := ' Seventeen';
                    8:
                        output3 := ' Eighteen';
                    9:
                        output3 := ' Nineteen';
                END;
            END;
        //Putting the word milliar
        IF (nilai > 999999999) AND "Bahasa Indonesia" THEN
            "output total" := "output total" + output3 + ' Milliar'
        ELSE
            IF (nilai > 999999999) AND NOT "Bahasa Indonesia" THEN BEGIN
                IF gBool_HundredMillion THEN
                    "output total" := "output total" + output3 + ' Billion And '
                ELSE
                    "output total" := "output total" + output3 + ' Billion';
            END
            ELSE
                "output total" := "output total" + output3;
        //4
        //Processing hundreds of Millions -------------------------------------------
        "Ratus Jutaan" := "Sisa 3" DIV 100000000;
        "Sisa 4" := "Sisa 3" - ("Ratus Jutaan" * 100000000.0);
        IF "Bahasa Indonesia" THEN
            CASE "Ratus Jutaan" OF
                0:
                    output4 := '';
                1:
                    output4 := ' Seratus';
                2:
                    output4 := ' Dua Ratus';
                3:
                    output4 := ' Tiga Ratus';
                4:
                    output4 := ' Empat Ratus';
                5:
                    output4 := ' Lima Ratus';
                6:
                    output4 := ' Enam Ratus';
                7:
                    output4 := ' Tujuh Ratus';
                8:
                    output4 := ' Delapan Ratus';
                9:
                    output4 := ' Sembilan Ratus';
            END
        ELSE
            CASE "Ratus Jutaan" OF
                0:
                    output4 := '';
                1:
                    output4 := ' One Hundred';
                2:
                    output4 := ' Two Hundred';
                3:
                    output4 := ' Three Hundred';
                4:
                    output4 := ' Four Hundred';
                5:
                    output4 := ' Five Hundred';
                6:
                    output4 := ' Six Hundred';
                7:
                    output4 := ' Seven Hundred';
                8:
                    output4 := ' Eight Hundred';
                9:
                    output4 := ' Nine Hundred';
            END;
        IF gBool_TenMillion AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + output4 + ' And '
        ELSE
            "output total" := "output total" + output4;
        //5
        //Processing tens of Millions -----------------------------------------------
        "Puluh Jutaan" := "Sisa 4" DIV 10000000;
        "sisa 5" := "Sisa 4" - ("Puluh Jutaan" * 10000000.0);
        IF "Bahasa Indonesia" THEN
            CASE "Puluh Jutaan" OF
                0:
                    output5 := '';
                1:
                    output5 := ' Sepuluh';
                2:
                    output5 := ' Dua Puluh';
                3:
                    output5 := ' Tiga Puluh';
                4:
                    output5 := ' Empat Puluh';
                5:
                    output5 := ' Lima Puluh';
                6:
                    output5 := ' Enam Puluh';
                7:
                    output5 := ' Tujuh Puluh';
                8:
                    output5 := ' Delapan Puluh';
                9:
                    output5 := ' Sembilan Puluh';
            END
        ELSE
            CASE "Puluh Jutaan" OF
                0:
                    output5 := '';
                1:
                    output5 := ' Ten';
                2:
                    output5 := ' Twenty';
                3:
                    output5 := ' Thirty';
                4:
                    output5 := ' Forty';
                5:
                    output5 := ' Fifty';
                6:
                    output5 := ' Sixty';
                7:
                    output5 := ' Seventy';
                8:
                    output5 := ' Eighty';
                9:
                    output5 := ' Ninety';
            END;
        IF gBool_Million AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + output5 + ' And '
        ELSE
            "output total" := "output total" + output5;
        //6
        //Processing Millions -----------------------------------------------------
        Jutaan := "sisa 5" DIV 1000000;
        "sisa 6" := "sisa 5" - (Jutaan * 1000000.0);
        IF "Bahasa Indonesia" THEN
            CASE Jutaan OF
                0:
                    output6 := '';
                1:
                    output6 := ' Satu';
                2:
                    output6 := ' Dua';
                3:
                    output6 := ' Tiga';
                4:
                    output6 := ' Empat';
                5:
                    output6 := ' Lima';
                6:
                    output6 := ' Enam';
                7:
                    output6 := ' Tujuh';
                8:
                    output6 := ' Delapan';
                9:
                    output6 := ' Sembilan';
            END
        ELSE
            CASE Jutaan OF
                0:
                    output6 := '';
                1:
                    output6 := ' One';
                2:
                    output6 := ' Two';
                3:
                    output6 := ' Three';
                4:
                    output6 := ' Four';
                5:
                    output6 := ' Five';
                6:
                    output6 := ' Six';
                7:
                    output6 := ' Seven';
                8:
                    output6 := ' Eight';
                9:
                    output6 := ' Nine';
            END;
        //Special case processing teens of Millions
        IF (("Puluh Jutaan" = 1) AND (Jutaan <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE Jutaan OF
                    1:
                        output6 := ' Sebelas';
                    2:
                        output6 := ' Dua Belas';
                    3:
                        output6 := ' Tiga Belas';
                    4:
                        output6 := ' Empat Belas';
                    5:
                        output6 := ' Lima Belas';
                    6:
                        output6 := ' Enam Belas';
                    7:
                        output6 := ' Tujuh Belas';
                    8:
                        output6 := ' Delapan Belas';
                    9:
                        output6 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE Jutaan OF
                    1:
                        output6 := ' Eleven';
                    2:
                        output6 := ' Twelve';
                    3:
                        output6 := ' Thirteen';
                    4:
                        output6 := ' Fourteen';
                    5:
                        output6 := ' Fifteen';
                    6:
                        output6 := ' Sixteen';
                    7:
                        output6 := ' Seventeen';
                    8:
                        output6 := ' Eighteen';
                    9:
                        output6 := ' Nineteen';
                END;
            END;
        //Putting the word million or Juta
        IF ("Sisa 3" > 999999) AND "Bahasa Indonesia" THEN
            "output total" := "output total" + output6 + ' Juta'
        ELSE
            IF ("Sisa 3" > 999999) AND NOT "Bahasa Indonesia" THEN BEGIN
                IF gBool_HundredThousand THEN
                    "output total" := "output total" + output6 + ' Million And '
                ELSE
                    "output total" := "output total" + output6 + ' Million';
            END
            ELSE
                "output total" := "output total" + output6;
        //7
        //Processing hundreds of thousands -----------------------------------------
        "Ratus Ribuan" := "sisa 6" DIV 100000;
        "Sisa 7" := "sisa 6" - ("Ratus Ribuan" * 100000.0);
        IF "Bahasa Indonesia" THEN
            CASE "Ratus Ribuan" OF
                0:
                    Output7 := '';
                1:
                    Output7 := ' Seratus';
                2:
                    Output7 := ' Dua Ratus';
                3:
                    Output7 := ' Tiga Ratus';
                4:
                    Output7 := ' Empat Ratus';
                5:
                    Output7 := ' Lima Ratus';
                6:
                    Output7 := ' Enam Ratus';
                7:
                    Output7 := ' Tujuh Ratus';
                8:
                    Output7 := ' Delapan Ratus';
                9:
                    Output7 := ' Sembilan Ratus';
            END
        ELSE
            CASE "Ratus Ribuan" OF
                0:
                    Output7 := '';
                1:
                    Output7 := ' One Hundred';
                2:
                    Output7 := ' Two Hundred';
                3:
                    Output7 := ' Three Hundred';
                4:
                    Output7 := ' Four Hundred';
                5:
                    Output7 := ' Five Hundred';
                6:
                    Output7 := ' Six Hundred';
                7:
                    Output7 := ' Seven Hundred';
                8:
                    Output7 := ' Eight Hundred';
                9:
                    Output7 := ' Nine Hundred';
            END;
        IF gBool_TenThousand AND NOT "Bahasa Indonesia" THEN
            "output total" := "output total" + Output7 + ' And '
        ELSE
            "output total" := "output total" + Output7;
        //8
        //Processing ten of thousands -----------------------------------------------
        "Puluh Ribuan" := "Sisa 7" DIV 10000;
        "Sisa 8" := "Sisa 7" - ("Puluh Ribuan" * 10000.0);
        IF "Bahasa Indonesia" THEN
            CASE "Puluh Ribuan" OF
                0:
                    Output8 := '';
                1:
                    Output8 := ' Sepuluh';
                2:
                    Output8 := ' Dua Puluh';
                3:
                    Output8 := ' Tiga Puluh';
                4:
                    Output8 := ' Empat Puluh';
                5:
                    Output8 := ' Lima Puluh';
                6:
                    Output8 := ' Enam Puluh';
                7:
                    Output8 := ' Tujuh Puluh';
                8:
                    Output8 := ' Delapan Puluh';
                9:
                    Output8 := ' Sembilan Puluh';
            END
        ELSE
            CASE "Puluh Ribuan" OF
                0:
                    Output8 := '';
                1:
                    Output8 := ' Ten';
                2:
                    Output8 := ' Twenty';
                3:
                    Output8 := ' Thirty';
                4:
                    Output8 := ' Forty';
                5:
                    Output8 := ' Fifty';
                6:
                    Output8 := ' Sixty';
                7:
                    Output8 := ' Seventy';
                8:
                    Output8 := ' Eighty';
                9:
                    Output8 := ' Ninety';
            END;
        IF gBool_Thousand AND NOT "Bahasa Indonesia" THEN ///// "output total" := "output total" + Output8 + ' And '
            "output total" := "output total" + Output8 + ' '
        ELSE
            "output total" := "output total" + Output8;
        //9
        //Processing thousands -----------------------------------------------------
        Ribuan := "Sisa 8" DIV 1000;
        "Sisa 9" := "Sisa 8" - (Ribuan * 1000.0);
        IF "Bahasa Indonesia" THEN
            CASE Ribuan OF
                0:
                    Output9 := '';
                1:
                    Output9 := ' Satu';
                2:
                    Output9 := ' Dua';
                3:
                    Output9 := ' Tiga';
                4:
                    Output9 := ' Empat';
                5:
                    Output9 := ' Lima';
                6:
                    Output9 := ' Enam';
                7:
                    Output9 := ' Tujuh';
                8:
                    Output9 := ' Delapan';
                9:
                    Output9 := ' Sembilan';
            END
        ELSE
            CASE Ribuan OF
                0:
                    Output9 := '';
                1:
                    Output9 := ' One';
                2:
                    Output9 := ' Two';
                3:
                    Output9 := ' Three';
                4:
                    Output9 := ' Four';
                5:
                    Output9 := ' Five';
                6:
                    Output9 := ' Six';
                7:
                    Output9 := ' Seven';
                8:
                    Output9 := ' Eight';
                9:
                    Output9 := ' Nine';
            END;
        //Special case processing teens of Thousands
        IF (("Puluh Ribuan" = 1) AND (Ribuan <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE Ribuan OF
                    1:
                        Output9 := ' Sebelas';
                    2:
                        Output9 := ' Dua Belas';
                    3:
                        Output9 := ' Tiga Belas';
                    4:
                        Output9 := ' Empat Belas';
                    5:
                        Output9 := ' Lima Belas';
                    6:
                        Output9 := ' Enam Belas';
                    7:
                        Output9 := ' Tujuh Belas';
                    8:
                        Output9 := ' Delapan Belas';
                    9:
                        Output9 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE Ribuan OF
                    1:
                        Output9 := ' Eleven';
                    2:
                        Output9 := ' Twelve';
                    3:
                        Output9 := ' Thirteen';
                    4:
                        Output9 := ' Fourteen';
                    5:
                        Output9 := ' Fifteen';
                    6:
                        Output9 := ' Sixteen';
                    7:
                        Output9 := ' Seventeen';
                    8:
                        Output9 := ' Eighteen';
                    9:
                        Output9 := ' Nineteen';
                END;
            END;
        //Putting The word Thousand or Ribu
        IF ("sisa 6" > 999) AND "Bahasa Indonesia" AND ((("Puluh Ribuan" <> 0) OR ("Ratus Ribuan" <> 0)) OR (Ribuan > 1)) THEN
            "output total" := "output total" + Output9 + ' Ribu'
        ELSE
            IF ("sisa 6" > 999) AND "Bahasa Indonesia" AND ("Puluh Ribuan" = 0) AND ("Ratus Ribuan" = 0) AND (Ribuan = 1) THEN
                "output total" := "output total" + ' Seribu'
            ELSE
                IF ("sisa 6" > 999) AND NOT "Bahasa Indonesia" THEN BEGIN
                    IF gBool_Hundred THEN
                        "output total" := "output total" + Output9 + ' Thousand And'
                    ELSE
                        "output total" := "output total" + Output9 + ' Thousand';
                END
                ELSE
                    "output total" := "output total" + Output9;
        //10
        //Processing hundreds -----------------------------------------------------
        Ratusan := "Sisa 9" DIV 100;
        "Sisa 10" := "Sisa 9" - (Ratusan * 100.0);
        IF "Bahasa Indonesia" THEN
            CASE Ratusan OF
                0:
                    Output10 := '';
                1:
                    Output10 := ' Seratus';
                2:
                    Output10 := ' Dua Ratus';
                3:
                    Output10 := ' Tiga Ratus';
                4:
                    Output10 := ' Empat Ratus';
                5:
                    Output10 := ' Lima Ratus';
                6:
                    Output10 := ' Enam Ratus';
                7:
                    Output10 := ' Tujuh Ratus';
                8:
                    Output10 := ' Delapan Ratus';
                9:
                    Output10 := ' Sembilan Ratus';
            END
        ELSE
            CASE Ratusan OF
                0:
                    Output10 := '';
                1:
                    Output10 := ' One Hundred';
                2:
                    Output10 := ' Two Hundred';
                3:
                    Output10 := ' Three Hundred';
                4:
                    Output10 := ' Four Hundred';
                5:
                    Output10 := ' Five Hundred';
                6:
                    Output10 := ' Six Hundred';
                7:
                    Output10 := ' Seven Hundred';
                8:
                    Output10 := ' Eight Hundred';
                9:
                    Output10 := ' Nine Hundred';
            END;
        IF gBool_Puluhan AND NOT "Bahasa Indonesia" THEN BEGIN
            "output total" := "output total" + Output10 + ' And ';
        END
        ELSE BEGIN
            "output total" := "output total" + Output10;
        END;
        //11
        //Processing tens ---------------------------------------------------------
        Puluhan := "Sisa 10" DIV 10;
        "sisa 11" := "Sisa 10" - (Puluhan * 10);
        IF "Bahasa Indonesia" THEN
            CASE Puluhan OF
                0:
                    Output11 := '';
                1:
                    Output11 := ' Sepuluh';
                2:
                    Output11 := ' Dua Puluh';
                3:
                    Output11 := ' Tiga Puluh';
                4:
                    Output11 := ' Empat Puluh';
                5:
                    Output11 := ' Lima Puluh';
                6:
                    Output11 := ' Enam Puluh';
                7:
                    Output11 := ' Tujuh Puluh';
                8:
                    Output11 := ' Delapan Puluh';
                9:
                    Output11 := ' Sembilan Puluh';
            END
        ELSE
            CASE Puluhan OF
                0:
                    Output11 := '';
                1:
                    Output11 := ' Ten';
                2:
                    Output11 := ' Twenty';
                3:
                    Output11 := ' Thirty';
                4:
                    Output11 := ' Forty';
                5:
                    Output11 := ' Fifty';
                6:
                    Output11 := ' Sixty';
                7:
                    Output11 := ' Seventy';
                8:
                    Output11 := ' Eighty';
                9:
                    Output11 := ' Ninety';
            END;
        "output total" := "output total" + Output11;
        //12
        //Processing singles ----------------------------------------------------------
        Satuan := "sisa 11" DIV 1;
        "sisa 12" := "sisa 11" - Satuan;
        IF "Bahasa Indonesia" THEN
            CASE Satuan OF
                0:
                    Output12 := ' ';
                1:
                    Output12 := ' Satu';
                2:
                    Output12 := ' Dua';
                3:
                    Output12 := ' Tiga';
                4:
                    Output12 := ' Empat';
                5:
                    Output12 := ' Lima';
                6:
                    Output12 := ' Enam';
                7:
                    Output12 := ' Tujuh';
                8:
                    Output12 := ' Delapan';
                9:
                    Output12 := ' Sembilan';
            END
        ELSE
            CASE Satuan OF
                0:
                    Output12 := '';
                1:
                    Output12 := ' One';
                2:
                    Output12 := ' Two';
                3:
                    Output12 := ' Three';
                4:
                    Output12 := ' Four';
                5:
                    Output12 := ' Five';
                6:
                    Output12 := ' Six';
                7:
                    Output12 := ' Seven';
                8:
                    Output12 := ' Eight';
                9:
                    Output12 := ' Nine';
            END;
        //Special case processing teens
        IF ((Puluhan = 1) AND (Satuan <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE Satuan OF
                    1:
                        Output12 := ' Sebelas';
                    2:
                        Output12 := ' Dua Belas';
                    3:
                        Output12 := ' Tiga Belas';
                    4:
                        Output12 := ' Empat Belas';
                    5:
                        Output12 := ' Lima Belas';
                    6:
                        Output12 := ' Enam Belas';
                    7:
                        Output12 := ' Tujuh Belas';
                    8:
                        Output12 := ' Delapan Belas';
                    9:
                        Output12 := ' Sembilan Belas';
                END;
            END
            ELSE BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 4));
                CASE Satuan OF
                    1:
                        Output12 := ' Eleven';
                    2:
                        Output12 := ' Twelve';
                    3:
                        Output12 := ' Thirteen';
                    4:
                        Output12 := ' Fourteen';
                    5:
                        Output12 := ' Fifteen';
                    6:
                        Output12 := ' Sixteen';
                    7:
                        Output12 := ' Seventeen';
                    8:
                        Output12 := ' Eighteen';
                    9:
                        Output12 := ' Nineteen';
                END;
            END;
        IF "Bahasa Indonesia" THEN
            "output total" := "output total" + Output12
        ELSE
            "output total" := "output total" + Output12;
        //fractional 13
        perdec := "sisa 12" DIV 0.1;
        "sisa 13" := "sisa 12" - (perdec * 0.1);
        IF "Bahasa Indonesia" THEN BEGIN
            "output total" := "output total";
            CASE perdec OF
                0:
                    Output13 := ' Nol';
                1:
                    Output13 := ' Sepuluh';
                2:
                    Output13 := ' Dua Puluh';
                3:
                    Output13 := ' Tiga Puluh';
                4:
                    Output13 := ' Empat Puluh';
                5:
                    Output13 := ' Lima Puluh';
                6:
                    Output13 := ' Enam Puluh';
                7:
                    Output13 := ' Tujuh Puluh';
                8:
                    Output13 := ' Delapan Puluh';
                9:
                    Output13 := ' Sembilan Puluh';
            END;
        END;
        IF "sisa 12" > 0 THEN
            IF "Bahasa Indonesia" THEN
                "output total" := "output total" + ' Koma' + Output13
            ELSE
                "output total" := "output total" + ' Koma' + Output13;
        //fractional 14
        percent := "sisa 13" DIV 0.01;
        IF "Bahasa Indonesia" THEN
            CASE percent OF
                0:
                    output14 := '';
                1:
                    output14 := ' Satu';
                2:
                    output14 := ' Dua';
                3:
                    output14 := ' Tiga';
                4:
                    output14 := ' Empat';
                5:
                    output14 := ' Lima';
                6:
                    output14 := ' Enam';
                7:
                    output14 := ' Tujuh';
                8:
                    output14 := ' Delapan';
                9:
                    output14 := ' Sembilan';
            END;
        //Special case processing teens
        IF ((perdec = 1) AND (percent <> 0)) THEN
            IF "Bahasa Indonesia" THEN BEGIN
                "output total" := COPYSTR("output total", 1, (STRLEN("output total") - 8));
                CASE percent OF
                    1:
                        output14 := ' Sebelas';
                    2:
                        output14 := ' Dua Belas';
                    3:
                        output14 := ' Tiga Belas';
                    4:
                        output14 := ' Empat Belas';
                    5:
                        output14 := ' Lima Belas';
                    6:
                        output14 := ' Enam Belas';
                    7:
                        output14 := ' Tujuh Belas';
                    8:
                        output14 := ' Delapan Belas';
                    9:
                        output14 := ' Sembilan Belas';
                END;
            END;
        "output total" := "output total" + output14;
        IF (currencycode = '') OR (currencycode = 'IDR') THEN
            "output total" := "output total" + ' Rupiah'
        ELSE BEGIN
            lRecCurr.RESET;
            lRecCurr.SETRANGE(lRecCurr."Code", CurrencyText);
            IF lRecCurr.FINDFIRST THEN BEGIN
                "output total" := "output total" + ' ' + lRecCurr.Description;
            END
            ELSE BEGIN
                "output total" := "output total";
            END;
        END;
        EXIT("output total");
    end;
}
