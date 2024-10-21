## Lýsing á gagnaöflun
Við gerð þessa mælaborðs voru sótt gögn úr gagnagrunningu isfolkid.db. Hann samanstendur af töflunum alvarpid, children, marriage, storytel_isfolkid, books, family, special_events og storytel_iskisur sem innihalda allar ýmiss gögn um bókaseríuna Sagan um ísfólkið.  upplýsingum tengdum ísfólkinu. Töflurnar í gagnagrunninum eru `alvarpid` og `storytel_iskisur`, sem geyma gögn um hvaðvarpsþætti um ísfólkið,`books` og `storytel_isfolkid`, geyma gögn um bækurnar og hljóðbækurnar, `family`, `children` og `marriage` sem geyma gögn um fjölskyldutengsl, börn og hjónabönd ísfólksins og `special_events` sem geymir upplýsingar um stór atvik sem gerast í bókunum.
Þessar töflur voru skoðaðar og séð hvernig hvaða upllýsingar og állyktanir var hægt að draga úr þeim, til að mynda hvernig ýmsir hlutir þróuðust og breyttust tíma og fleira til þess að reyna að sýna einhverja sögu sem að myndi fanga athygli markhópsins.
.

## Börn ísfólksins

Til að skoða Börn ísfólksins langaði okkur að sjá

**hversu mörg börn fæddust á hverju ári**
Til að finna hversu mörg börn fæddust á hverju ári var SQL fyrirspurnin `dbGetQuery()` til að sækja fjölda barna sem fæddust á hverju ári úr family- og children-töflunum. Hún skoðar dálkinn `child_birth_year` og telur hversu mörg börn eru fædd hvert ár og vistar það í dálkinn `num_children_born`
Til þess að skoða niðurstöðurnar var `geom_line()` notað til að teikna línu sem tengir saman fjölda barna á hverju ári og `geom_point()` notað til að setja punkta á línuna fyrir hvert ár

Á grafnu má sjá að flest árin voru tvö börn fædd en flöktir þó mikið upp og niður. Minnst var 1 barn fætt og mest 6 á einu ári.

**Meðalaldur foreldra við fæðingu**
Til þess að kanna meðalaldur foreldra þegar að þau eignuðumst börn var SQL fyrirspurnin `(dbGetQuery())` notuð til að sækja gögn úr gagnagrunninum family. Hún finnur fæðingarár barna (`child_birth_year`) og reiknar út meðalaldur móður og föður þegar barnið fæddist með `AVG()`. Gögnin eru svo hópuð eftir fæðingarári barnsins og röðuð í tímaröð með `GROUP BY` og `ORDER BY`.
Til að skoða niðurstöðurnar var búið til punktarit með `geom_point()` sem aðm sýnir punkta fyrir meðalaldur mæðra og feðra á hverju ári og svo `geom_smooth()` sem setur inn línur sem sýnir þróun aldurs mæðra og feðra yfir tíma.

Það sést vel á grafinu að meðalaldur feðra er nánast alltaf meiri en mæðra. Bilið milli þeirra minnkar þó örlítið þegar að fer að líða á en feðurnir eru alltaf eldri.

**Fjöldi barna á hjónaband**
TIl þess að kanna fjölda barna í hverju hjónabandi var SQL fyrirspurnin `(dbGetQuery())` notuð til að tengja töflurnar marriage og children og telja hversu mörg börn eru í hverju hjónabandi. Úr þvi var búin til tafla með dálkunum `children_count` og `number_of_marriages`. Til þess að skoða niðurstöðurnar var búið til súlurit með ´geom_bar()´ sem sýnir hversu mörg hjónabönd eiga hvern fjölda af börnum.

Á niðurstöðunum má sjá að langflestir eiga tvö börn en mesti fjöldi barna frá einu hjónabandi eru 10 börn.