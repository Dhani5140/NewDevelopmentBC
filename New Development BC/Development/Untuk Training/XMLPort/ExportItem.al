xmlport 50100 ItemXMLPort
{
    Direction = Export;
    Format = Xml;

    schema
    {
        textelement(Items)
        {
            tableelement(Item; Item)
            {
                RequestFilterFields = "No.";
                XmlName = 'item';
                fieldattribute(No; Item."No.")
                {

                }
                fieldattribute(Name; Item.Description)
                {

                }
                fieldattribute(Inventory; Item.Inventory)
                {

                }
                fieldelement(Type; Item.Type)
                {

                }
            }
        }
    }
}