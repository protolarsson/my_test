# Mycronic
---

## Förberedelser
### Installera
- Visual Studio 2013
- EPiServer CMS Visual Studio Extension enligt nedan (från http://world.episerver.com/download/Items/EPiServer-CMS/visual-studio-cms-extensions/).
    1. To install from Visual Studio, select Tools > Extensions and Updates.
    2. In the extensions window, select Online, and type "episerver" in the search box.
    3. Select EPiServer CMS Visual Studio Extension and click Install (or "Update" if already > installed).
- Web Essentials (http://vswebessentials.com/)

### Verktyg

**ReSharper**  
För att få konsekvet kodstil, och en rad andra funktioner, kör vi [ReSharper](http://www.jetbrains.com/resharper/).

**MSpec**  
ReSharper har en testkörare som med fördel används för att köra projektets MSpec-tester. För att detta ska funka behöver du installera MSpec-extension från ReSharpers Extension Manager (som du hittar i ReSharper-menyn i Visual Studio).

---

## Sätt upp utvecklingsmiljö

### Setup
- Klona githubrepot på https://github.com/prototypsthlm/mycronic.git om du inte redan gjort det
- Ladda ner en databasfilen dbMycronic.bak från https://sites.google.com/a/prototyp.se/wiki/projekt/mycronic
- Installera databasen (i skrivande stund handlar det om en ny, ren EPi-databas)
 - Ladda ner en databasfilen 'dbMycronic.bak' från https://sites.google.com/a/prototyp.se/wiki/projekt/mycronic
 - Starta SQL Server Management Studio
 - Logga in på din SQL server
 - Högerklicka på "Databases" och välj "Restore Database"
 - Markera "Device" och lägg till backup-filen (dbMycronic.bak)
 - Tryck sedan på "OK". En databas med namnet "dbMycronic" ska nu ha skapats under "Databases"
- !!! (KOMMER ÄNDRAS) Uppdatera din connectionStrings-nod i web.config. Exempel (din data source kommer inte vara samma):
```
<connectionStrings>
    <add name="EPiServerDB" connectionString="Data Source=STEFANLARSS1395\SQLEXPRESS;Initial Catalog=dbMycronic;Integrated Security=True;MultipleActiveResultSets=True"
        providerName="System.Data.SqlClient" />
  </connectionStrings>
```
- Öppna C:\Windows\System32\drivers\etc\hosts som administratör och lägg till:
```
127.0.0.1       mycronic.local
```
- Öppna IIS Manager
 - lägg till en site med en physical path till källkodens mycronic-mapp
 - lägg binding mot hosts-domänen ovan
- Öppna Visual Studio som Admin
- Öppna mycronic.sln
- Öppna properties för mycronic-projektet
 - Under Web
   - Under serverinställningarna, markera Local IIS Server (inte IIS Express)
   - Sätt Project URL till http://mycronic.local
- Skapa databasanvändare
  - När du kör siten första gången får du (om inget annat är fel) förmodligen felet `Login failed for user 'IIS APPPOOL\mycronic'.` (exakt usernamn beror på ditt sitenamn i IIS) För att fixa detta:
  - gå in i SQL Server Management Studio, högerklicka på Security och välj New->Login
  - Sätt Login name till _exakt_ samma usernamn som visades i felet. T.ex. `IIS APPPOOL\mycronic` (inga citattecken)
  - Gå till User Mapping, checkboxa databasen, sätt rollen db_owner.
  - Spara. Öppna Security/Logins/[den_login_du_skapade], dubbelkolla att User Mappings-rollen du satte i föregående steg faktiskt sparades. SQL Server Managern ljuger ofta om detta när man skapar en ny user.
- Bekräfta att du kommer åt http://mycronic.local/episerver

### Setup Q&A
- När jag går till sajten får jag ett 500.19-fel med felkod: 0x80070005.
  - Rättighetsproblem. Måste lägga till din "app pool"-användare:
  - Högerklicka på sajtens www-mapp och välj "Properties"
  - Välj fliken "Security"
  - Klicka på "Edit..." och sedan "Add".
  - Skriv: "IIS APPPOOL\\[SAJTENS_APP_POOL_NAMN]" och klicka på "Check Names" följt av OK.
  - Markera användaren du nyss la till i steget ovan och kryssa för "Allow" för "Modify". 
  - Klicka på "OK" och gå till sajten igen. Förhoppningsvis ska problemet vara löst.

---

