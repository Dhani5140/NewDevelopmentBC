codeunit 60100 "Get JISDOR Rate"
{
    trigger OnRun()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: Text;
        Json: JsonObject;
        Currency: Text;
        DateText: Text;
        RateText: Text;
        Rate: Decimal;
        Token: JsonToken;
        CurrencyExchRate: Record "Currency Exchange Rate";
        DateValue: Date;
    begin
        if Client.Get('https://getratebi.azurewebsites.net/api/GetJisdorRate?code=Dyid2a5mof-RYRwZP4MV_6BEDKjgdcooSXCfi0X7JTSBAzFuTGZiaA==', Response) then begin
            Response.Content().ReadAs(Content);

            if Json.ReadFrom(Content) then begin
                if Json.Get('Currency', Token) then
                    Currency := DelChr(Token.AsValue().AsText(), '=', ' '); // Trim manual

                if Json.Get('Date', Token) then
                    DateText := Token.AsValue().AsText();

                if Json.Get('Rate', Token) then
                    RateText := Token.AsValue().AsText();

                Evaluate(Rate, RateText);
                Evaluate(DateValue, CopyStr(DateText, 1, 10)); // convert string ke Date

                // Insert ke tabel Currency Exchange Rate
                CurrencyExchRate.Init();
                CurrencyExchRate."Currency Code" := Currency;
                CurrencyExchRate."Starting Date" := DateValue;
                CurrencyExchRate."Exchange Rate Amount" := 1;
                CurrencyExchRate."Relational Currency Code" := 'IDR';
                CurrencyExchRate."Relational Exch. Rate Amount" := Rate;
                CurrencyExchRate.Insert(true);
            end;
        end;
    end;
}