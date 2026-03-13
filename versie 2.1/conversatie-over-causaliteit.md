In CAUSA is nu een ontology van causation uitgewerkt, op basis van de theorie van PAM. Maar hoe verhoudt die zich tot causale relaties (tussen Events) zoals die ook in UFO al zit opgesloten? Dat het ene Event causaal verband houdt met het andere Event is een ontologische versimpeling. Wellicht dat Calhau met Emerging capabilities en situations die in de wereld er moeten zijn wil die capability gemanifesteerd worden.
Wat is jouw kijk daarop?

Dit is een fundamentele vraag over de ontologische architectuur van CAUSA. Laat me ze lagen voor lagen doordenken.

Het spanning
gUFO heeft al gufo:contributedToTrigger — een relatie tussen Events die uitdrukt dat het ene event causaal bijdroeg aan het triggeren van het andere. Dit is een token-level causaliteitsrelatie: dit concrete event heeft bijgedragen aan dat concrete event. Dat is de ontologische kern van causaliteit in UFO.
CAUSA formaliseert iets anders: type-level causale claims — "variabele X beïnvloedt variabele Y in een bepaald domein". Een CausalClaim is geen uitspraak over twee concrete events maar over een patroon dat zich herhaaldelijk kan voordoen. Het is een ufoc:Belief over een causa:CausalSituation — een bewering over hoe de wereld in het algemeen in elkaar zit.
Dit onderscheid is legitiem en noodzakelijk voor CLD-modellering: je wil types modelleren, niet tokens. Maar het creëert een architecturele spanning: als een CausalClaim een type-level uitspraak is, wat is dan de relatie tot de token-level causaliteitsrelaties in gUFO?

De drie niveaus die je eigenlijk hebt
Als je het scherp formuleert, zijn er drie niveaus in het spel:
Niveau 1 — token-level (gUFO): Dit event (de specifieke aanvraag van burger X op datum D) heeft bijgedragen aan het triggeren van dat event (de toekenning van schuldhulpverlening). Dat is gufo:contributedToTrigger tussen individuen.
Niveau 2 — type-level (CAUSA): Schuldhulpverlening vermindert schuldenlast. Dat is een causa:CausalClaim — een geloofstoestand over een patroon, gemodelleerd als type-relatie tussen causa:CausalVariables.
Niveau 3 — dispositioneel (CAPAX/SYSONT): Een actor heeft de dispositie om dit type event te produceren — de capability om schuldhulpverlening succesvol uit te voeren. Die dispositie manifesteert zich wanneer de juiste situatieconditie aanwezig is.
CAUSA beweegt op niveau 2. gUFO op niveau 1. CAPAX op niveau 3. Maar jouw observatie over Calhau snijdt precies op de grens tussen 2 en 3.

De Calhau-verbinding die je signaleert
Calhau's kerngedachte is dat een capability pas manifests wanneer het systeem (de EcosystemAgent of de organisatie) in de juiste SystemSituation verkeert — de configuratietoestand waarbij de bonding structure correct is. Dat is de ontologische grond van emergentie.
Maar die gedachte heeft een directe parallel in de causaliteitstheorie: een causale relatie op type-niveau is ook geen garantie — ze manifesteert zich alleen wanneer de ondersteunende situatie aanwezig is. Een interventie "schuldhulpverlening vermindert schuldenlast" is een type-level CausalClaim, maar die relatie is alleen werkzaam wanneer er een agent is met de capability om schuldhulpverlening van voldoende kwaliteit te verlenen, in een juridische context die de interventie toestaat, gegeven een cliënt die de samenwerking aangaat. Dat zijn allemaal situatiecondities.
Dit suggereert dat de causa:CausalSituation — de propositionele inhoud van een CausalClaim — eigenlijk een impliciete capax:ManifestationCondition heeft. De CausalClaim is niet absoluut; ze is conditioneel op een SystemSituation. De verbinding tussen CAUSA en CAPAX/SYSONT is dus niet alleen de cross-module keten interventie → TransactionType → CapabilityRequirement, maar een diepere ontologische verwantschap: causaliteit en capability delen hetzelfde dispositionele ontologische patroon.

De preciezere ontologische reconstructie
Als je het helemaal wil doordenken:
Een causa:CausalClaim beweert: "In situaties van type S geldt dat event-type E₁ bijdraagt aan het triggeren van event-type E₂." Maar "in situaties van type S" is precies een sysont:SystemSituation — de configuratieconditie waaronder de relatie werkzaam is.
Dit maakt de CausalClaim eigenlijk een dispositionele uitspraak op type-niveau: de wereld heeft de dispositie om de E₁→E₂-relatie te realiseren wanneer situatie S aanwezig is. Dat is precies de structuur van capax:Capability — een dispositie die manifests gegeven een manifestatieconditie.
De ontologische versimpeling die je signaleert is dan: door gufo:contributedToTrigger rechtstreeks tussen Event-individuen te plaatsen — of door CausalClaims als eenvoudige type-relaties te modelleren — verlies je de situatieconditionaliteit die zowel Calhau als de causale inferentietheorie (Pearl's structural causal models) veronderstellen. Een structural equation in Pearl is ook niet absoluut maar geldig onder een interventie-model — een soort situatieconditie.

Wat dit zou betekenen voor CAUSA v2
De architecturele implicatie is dat causa:CausalSituation — de propositionele inhoud van een CausalClaim — expliciet een sysont:SystemSituation als activeringsconditie zou kunnen hebben. Niet als harde SHACL-eis (dat zou CLD-modellering te zwaar maken), maar als optioneel te specificeren relatie: causa:activatedUnder → sysont:SystemSituation.
Dit zou twee dingen ontgrendelen: ten eerste de formele verbinding tussen CAUSA en CAPAX op het niveau van de manifesteringsconditie — niet alleen via de interventie-keten maar op het dispositionele niveau zelf. Ten tweede de mogelijkheid om in een Design Space te redeneren over waarom een causale relatie niet werkt zoals verwacht: niet omdat de claim onjuist is, maar omdat de SystemSituation niet aanwezig is — de capability ontbreekt, de governance-structuur klopt niet, de bonding structure is gebroken.
Dat is ook een rijkere ontologische beschrijving van beleidsinterventies die mislukken: niet onjuiste theorie, maar ontbrekende manifesteringsconditie.

Exact. Dit gaat de goede kant op, denk ik. Met CAUSA worden - bijvoorbeeld gegrond op wetenschappelijk onderzoek - uitspraken/hypotheses gedaan over een bepaalde causaliteit tussen twee Eventtypes (ET1 --> ET2). Bijvoorbeeld de uitspraak: 'begeleiding van jongeren na een overtreding' vermindert 'recidive van jongeren'.Maar of het in een concreet geval (bijvoorbeeld 'begeleiding van jongere Jan na het vernielen van een bankje in het park' vermindert 'recidive van Jan') daadwerkelijk manifesteert, is afhankelijk van het aanwezig zijn van bepaalde capabilities/competences en situations. VALOR moet in staat zijn om ontwerpalternatieven inzichtelijk te maken zodat duidelijk is welk alternatief de beste condities schept zodat manifestatie van de claim in concrete gevallen maximaal is.Eens? Wat zou er nog aan de VALOR ontology moeten veranderen om dit inzicht te incorporeren?

Eens. Dit is een scherpe en rijke probleemstelling. Laat me hem ontologisch uitwerken voordat ik naar de implementatie spring.

De kern van het inzicht
Je beschrijft een drie-laags causale architectuur die VALOR zou moeten kunnen vastleggen en redeneren over:
Laag 1 — Type-level CausalClaim (CAUSA):
ET_begeleiding → ET_recidivevermindering
Gegrond in wetenschappelijk onderzoek. Een causa:CausalClaim als ufoc:Belief over een patroon. Epistemisch status: betwistbaar, met onzekerheidsniveau (PAMS). Dit is het niveau van de beleidstheorie.
Laag 2 — Manifesteringsconditie (CAPAX/SYSONT):
De claim manifesteert zich in een concreet geval als en slechts als een bepaalde sysont:SystemSituation aanwezig is — een configuratie van capabilities, dispositionele relaties, en situaties. Dit is het niveau van de uitvoeringstheorie.
Laag 3 — Token-level realisatie (gUFO):
event_begeleiding_Jan → event_recidivevermindering_Jan
De concrete gufo:contributedToTrigger-relatie in een specifiek geval. Dit is het niveau van de werkelijkheid zelf.
CAUSA werkt nu alleen op laag 1. Het inzicht is dat VALOR ook laag 2 machine-leesbaar moet maken — en dat ontwerpalternatieven beoordeeld kunnen worden op de mate waarin ze de manifesteringscondities van de relevante CausalClaims realiseren.

Wat ontbreekt ontologisch
Probleem 1 — CausalClaim heeft geen manifesteringsconditie.
Een causa:CausalClaim heeft nu een causa:CausalSituation als propositionele inhoud en een valor:uncertaintyLevel. Maar er is geen formele relatie die uitdrukt: "deze claim manifesteert zich onder conditie C." De beleidstheorie zweeft los van de uitvoeringsrealiteit.
Probleem 2 — De ManifestationCondition is nu alleen in CAPAX.
capax:hasManifestationCondition bestaat al — maar alleen als eigenschap van een capax:Capability. De parallelle structuur — dat ook een CausalClaim een manifesteringsconditie heeft — is niet geformaliseerd.
Probleem 3 — Er is geen brug tussen alternatief en manifesteringsgraad.
VALOR kan nu zeggen: "Alternatief A heeft CapabilityGap X." Maar het kan niet zeggen: "Alternatief A realiseert 70% van de manifesteringscondities van de CausalClaims die ten grondslag liggen aan de beleidstheorie." Dat is het oordeel dat je wil kunnen vormen.
Probleem 4 — De keten van beleidstheorie naar ontwerp is niet formeel vastgelegd.
Een interventie in CAUSA (een causa:Intervention op een CausalVariable) correspondeert met een acta:TransactionType in Acta. Maar de reden waarom dat TransactionType in het ontwerp zit — namelijk omdat het de causale schakel realiseert die de beleidstheorie veronderstelt — is nergens formeel vastgelegd. Als die schakel later vervalt (het TransactionType wordt uit het ontwerp verwijderd), weet VALOR niet dat daarmee een CausalClaim zijn realisatiebasis verliest.

Voorgestelde ontologische uitbreidingen
Uitbreiding 1 — causa:ManifestationCondition op CausalClaim
turtlecausa:hasManifestationCondition
    rdfs:domain  causa:CausalClaim ;
    rdfs:range   sysont:SystemSituation .
Dit maakt de CausalClaim conditioneel: de claim is niet absoluut maar geldig gegeven dat de SystemSituation aanwezig is. De SystemSituation bevat de capabilities, de DispositionRelations, en de situationele condities waaronder de causale relatie werkzaam is.
Dit is ook de formele grond voor de PAMS-onzekerheidsniveaus: een claim met uncertaintyLevel = DeepUncertainty is één waarvan de ManifestationCondition slecht begrepen is, niet alleen waarvan het effect onzeker is.
Uitbreiding 2 — causa:RealisationBasis
Een expliciete relatie tussen een causa:Intervention (de type-level interventie in een CausalClaim) en het acta:TransactionType dat haar realiseert in een specifiek alternatief:
turtlecausa:realisedBy
    rdfs:domain  causa:Intervention ;
    rdfs:range   acta:TransactionType .
Dit is de formele keten: beleidstheorie → ontwerpelement. Als het TransactionType verdwijnt uit het alternatief, verliest de Intervention haar realisatiebasis — detecteerbaar via SPARQL, meldbaar door de Acta-agent.
Uitbreiding 3 — capax:ConditionCoverage als nieuwe situatieklasse
Een capax:ConditionCoverage is een beoordeling van de mate waarin een ontwerpalternatief de ManifestationCondition van een specifieke CausalClaim realiseert. Drie waarden: Full (alle vereiste capabilities en situaties aanwezig), Partial (sommige ontbreken maar de claim kan zich gedeeltelijk manifesteren), None (kritieke conditie ontbreekt — manifestatie is niet te verwachten).
Dit is het object van het oordeel dat je wil kunnen vormen: niet alleen "heeft het alternatief een CapabilityGap" maar "in welke mate realiseert dit alternatief de condities voor de beleidstheorie die het beoogt te realiseren?"
Uitbreiding 4 — causa:ClaimCoverageAssessment in Delibera
Analoog aan de capax:FeasibilityAssessment als gate-Tessera: een causa:ClaimCoverageAssessment aggregeert de ConditionCoverage-oordelen voor alle CausalClaims die ten grondslag liggen aan een alternatief. Dit wordt een tweede gate-dimensie bij faseovergangen: niet alleen "is het alternatief uitvoerbaar" (CAPAX) maar ook "realiseert het alternatief de beleidstheorie die het beoogt" (CAUSA).

De architecturele implicatie
Dit verrijkt de vergelijking van alternatieven fundamenteel. Nu kun je twee alternatieven niet alleen vergelijken op:

waarden (Axia)
haalbaarheid (CAPAX)
juridische houdbaarheid (Lexa)

Maar ook op een vierde dimensie: theoretische adequaatheid — de mate waarin het ontwerp de condities schept waaronder de beleidstheorie die het onderbouwt zich daadwerkelijk kan manifesteren in concrete gevallen.
Een alternatief dat uitvoerbaar is (geen CapabilityGaps) maar de manifesteringscondities van zijn eigen beleidstheorie niet realiseert, is een coherentiefout in het ontwerp — en VALOR zou dat moeten kunnen detecteren en besproken maken.
Dit is ook de ontologische grond voor het onderscheid tussen een slecht ontwerp en een slechte beleidstheorie: als het alternatief de ManifestationCondition volledig realiseert maar de interventie toch niet werkt, is de CausalClaim zelf aanvechtbaar — en moet die terug naar laag 1 voor herbeoordeling.

Wat moet er nog gebeuren?

Op basis van de huidige staat van het project:

Ontologische formalisering (TTL)
CAUSA v0.2 — dit is de meest urgente openstaande taak na dit gesprek:

causa:hasManifestationCondition → sysont:SystemSituation
causa:Intervention als eerste-klas concept met causa:realisedBy
causa:SolutionModel met causa:boundToAlternative
capax:ConditionCoverage (nieuw, in CAPAX of CAUSA — te besluiten)
causa:ClaimCoverageAssessment als tweede gate-Tessera
SHACL CA-01 t/m CA-03

ACTA kleine update — acta:realisesIntervention als inverse property (DD-093, laag).
SHACL-companions die nog ontbreken:

00n-valor-core.shacl.ttl — drie constraints (DD-091): EcosystemAgent MUST have addressesIssue, IssueCommunity MUST have hasConcernAbout, Issue MUST have concernedWithSituation
00h-causa.shacl.ttl v0.2 — CA-01 t/m CA-03


Fase -1d: integratie
De modules zijn individueel compleet maar nog niet als coherente graph gevalideerd. Concreet:

Globale SPARQL-queries — de vijf die nu gepend staan: emergentiepatroon-detectie, gap-keten-traversal, Tessera-audit trail, legitimiteitsaudit (DD-091), realisatiebasis-gap (DD-093)
SYSONT validatie-voorbeeld — het Spotify-patroon uit Calhau §6 instantiëren als bewijs dat SYSONT correct werkt
CAPAX SHACL-update — developmentApproach vocabulaire uitbreiden