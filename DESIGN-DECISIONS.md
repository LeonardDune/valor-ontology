# VALOR-O Ontologie — Ontwerpbeslissingen

**Versie:** 0.2  
**Datum:** februari 2026  
**Status:** Levend document — wordt bijgewerkt bij elke module

---

## Leeswijzer

Dit document legt vast **waarom** VALOR-O is zoals het is: welke keuzes zijn gemaakt, welke alternatieven zijn overwogen, welke bronnen de beslissing onderbouwen, en waar VALOR-O bewust afwijkt van de bronontologieën. Elk besluit heeft een unieke ID (`DD-NNN`). TTL-comments verwijzen naar deze IDs.

Bronafkortingen die in dit document en in de TTL-comments worden gebruikt:

| Afkorting | Volledige referentie |
|-----------|---------------------|
| **gUFO-spec** | Almeida et al. (2019), *gUFO: A Lightweight Implementation of the Unified Foundational Ontology*, https://nemo-ufes.github.io/gufo/ |
| **UFO-B-2013** | Guizzardi et al. (2013), *Towards Ontological Foundations for the Conceptual Modeling of Events*, ER 2013, LNCS 8217, pp. 327–341 |
| **UFO-B-2019** | Almeida, Falbo & Guizzardi (2019), *Events as Entities in Ontology-Driven Conceptual Modeling*, ER 2019 |
| **UFO-C-2013** | Guizzardi et al. (2013), *UFO-C: A Foundational Ontology for Social Entities* |
| **UFO-L-2015** | Guizzardi et al. (2015), *UFO-L: An Ontological Account of Legal Relationships* |
| **OntoUML-2018** | Guizzardi et al. (2018), *Endurant Types in Ontology-Driven Conceptual Modeling: Towards OntoUML 2.0*, ER 2018 |
| **COoDM** | Guizzardi, Carneiro & Porello (2020), *A Core Ontology on Decision Making*, ONTOBRAS 2020 |
| **COVER** | Guizzardi et al. (2022), *The Common Ontology of Value and Risk*, Applied Ontology |
| **Weigand-2024** | Weigand, Johannesson & Andersson (2024), *Ontological Analysis of Policy-Based Decision Making*, VMBO 2024 |
| **Almeida-DEMO** | Almeida et al. (2013), *Revisiting the DEMO Transaction Pattern with UFO*, EEWC 2013 |

---

## Module 00a — gUFO Core

### DD-001 · Curated subset, geen volledige owl:imports

**Besluit:** VALOR-O declareert de gUFO-concepten die het gebruikt als lokale klasse- en eigenschap-declaraties in `00a-gufo-core.ttl`, in plaats van een enkele `owl:imports <https://nemo-ufes.github.io/gufo/gufo.ttl>`.

**Rationale:** Het gUFO-bestand is ~2500 triple's groot en bevat veel concepten die VALOR-O niet gebruikt (volledige taxonomie van Types, alle kwaliteitsstructuren, etc.). Een lokale curated subset maakt de ontologie begrijpelijker voor nieuwe deelnemers en minder afhankelijk van externe bereikbaarheid. Bovendien maakt het inline documentatie per concept mogelijk.

**Afwijking:** Strikt gezien zou `owl:imports` de semantisch correcte keuze zijn. De lokale declaraties zijn geen re-publicatie (ze bevatten geen axioma's die de gUFO-specificatie tegenspreken) maar een subset-documentatie.

**Productie-instructie:** In een productieomgeving met live GraphDB kan de body van `00a-gufo-core.ttl` worden vervangen door `owl:imports <https://nemo-ufes.github.io/gufo/gufo.ttl>`.

**Bron:** gUFO-spec §1.

---

### DD-002 · OWL 2 Punning als standaardpatroon

**Besluit:** Elke domeinontologie-klasse met een `gufo:ontoumlStereotype`-annotatie krijgt ook een `rdf:type`-assertie naar het corresponderende gUFO-type (bijv. `rdf:type gufo:Kind`).

**Rationale:** In OntoUML is een concept zoals `Person` tegelijkertijd:
- een `owl:Class` (voor de subklasse-hiërarchie en OWL-restricties — first-order gebruik)
- een instantie van `gufo:Kind` (voor het uitdrukken van type-hiërarchische relaties — second-order gebruik)

OWL 2 staat dit toe via *punning*: dezelfde URI kan in één ontologie zowel als klasse als als individu fungeren (OWL 2 §5.8.2). Zonder dit patroon kan GraphDB de SPARQL-query `?x rdf:type gufo:Kind` niet beantwoorden voor domeinconcepten.

**Stereotype → gUFO-type mapping:**

| OntoUML stereotype | gUFO instantietype |
|--------------------|-------------------|
| `kind` | `gufo:Kind` |
| `subkind` | `gufo:SubKind` |
| `role` | `gufo:Role` |
| `phase` | `gufo:Phase` |
| `category` | `gufo:Category` |
| `mixin` | `gufo:Mixin` |
| `roleMixin` | `gufo:RoleMixin` |
| `relator` | `gufo:Relator` |
| `mode` | `gufo:NonQualitativeIntrinsicAspect` |
| `quality` | `gufo:QualitativeIntrinsicAspect` |
| `event` | `gufo:EventType` |
| `situation` | `gufo:SituationType` |
| `historicalRole` | `gufo:Role` (geen apart gUFO-type; historicalRole is een OntoUML-2019 toevoeging) |

**Afwijking:** gUFO zelf gebruikt punning intern, maar documenteert het niet als vereiste voor domeinontologieën. VALOR-O maakt het tot een harde conventie (gehandhaafd door SHACL-constraint G7).

**Bron:** gUFO-spec §2.2; OntoUML-2018 §3; UFO-B-2019 §2.

---

### DD-003 · gUFO-primitieven zijn uitgesloten van punning-verplichting

**Besluit:** De klassen in `00a-gufo-core.ttl` zelf (`gufo:Kind`, `gufo:Event`, `gufo:Relator`, etc.) krijgen **geen** `rdf:type gufo:Kind`-assertie.

**Rationale:** Deze klassen *zijn* de type-hiërarchie — ze zijn de gUFO-primitieven, niet instanties ervan. `gufo:Kind` is zelf een `owl:Class` en een instantie van `gufo:Type` (in de volledige gUFO-spec), maar in VALOR-O's curated subset declarareren we deze second-order relaties niet. De SHACL-constraint G7 sluit de `https://nemo-ufes.github.io/gufo/`-namespace expliciet uit.

**Bron:** gUFO-spec §2 (Taxonomy of Types).

---

### DD-004 · gufo:Participation — terminologisch conflict met UFO-B

**Besluit:** `gufo:Participation` in `00a-gufo-core.ttl` behoudt zijn gUFO-betekenis: een subklasse van `gufo:Event` die de deelname van een endurant aan een event representeert als een event-entiteit. Dit is **niet** hetzelfde als de *afgeleide* UFO-B Participation (§3.2 in UFO-B-2013).

**Achtergrond:** UFO-B-2013 §3.2 definieert Participation als een *afgeleid* concept: het maximale deel van een event dat exclusief afhangt van één object (`P4: ∀e:Event Participation(e) ↔ ∃!o:Object excDepends(e,o)`). Dit is een *derived class* — ze bestaat als projectie op de event-mereologie, niet als een primitieve klasse.

De gUFO-implementatie kiest ervoor `gufo:Participation` wél als concrete klasse te declareren (een subklasse van `gufo:Event`), en `gufo:participatedIn` / `gufo:hasParticipant` als de verbinding met `gufo:Object`. Dit is een vereenvoudiging ten opzichte van de volledige UFO-B-axiomatisering.

**Consequentie voor VALOR-O:** In `00b-ufo-b.ttl` declareren we de UFO-B-notie van `participationOf` als afgeleide eigenschap, maar vermijden we het gebruik van de naam `Participation` als aparte klasse om verwarring te voorkomen. In de module-documentatie wordt het onderscheid expliciet gemaakt.

**Afwijking ten opzichte van UFO-B-2013:** UFO-B-2013 behandelt Participation als afgeleide klasse (P4/P5). gUFO maakt er een concrete klasse van. VALOR-O volgt gUFO hier voor pragmatische redenen (GraphDB-compatibiliteit, SPARQL-expressiviteit).

**Bron:** UFO-B-2013 §3.2 (P1–P5); gUFO-spec §3.3.

---

### DD-005 · Allen-relaties als SPARQL-queries, niet als OWL-properties

**Besluit:** De zeven Allen-tijdrelaties (`before`, `meets`, `overlaps`, `starts`, `during`, `finishes`, `equals`) worden **niet** als OWL-objectproperties gedeclareerd in `00b-ufo-b.ttl`. Ze worden gedocumenteerd als SPARQL-queries in de module-header en in het SHACL-bestand als `sh:sparql`-constraints.

**Rationale:**
1. Alle Allen-relaties zijn volledig afleidbaar uit `gufo:hasBeginPoint` en `gufo:hasEndPoint` (UFO-B-2013 §3.3, axioma's T7–T13). UFO-B-2019 §3.1 bevestigt dit expliciet en biedt ze als OCL-operaties aan, niet als nieuwe properties.
2. `gufo:overlaps` als OWL-property zou conflicteren met de mereologische overlaps-relatie uit de event-mereologie (M7 in UFO-B-2013).
3. Als OWL-properties zouden ze bij elke update afgeleid moeten worden — dit is beter als SPARQL `CONSTRUCT` of `FILTER`.

**Afwijking ten opzichte van UFO-B-2013:** UFO-B-2013 lijst de Allen-relaties als named relations (T7–T13). VALOR-O behandelt ze als afgeleide queries. Dit volgt het advies van UFO-B-2019.

**SPARQL-definities (gedocumenteerd in `00b-ufo-b.ttl`):**
```sparql
# before(e, e') ↔ end(e) < begin(e')
FILTER (?end1 < ?begin2)

# meets(e, e') ↔ end(e) = begin(e')
FILTER (?end1 = ?begin2)

# overlaps, starts, during, finishes, equals: analoog
```

**Bron:** UFO-B-2013 §3.3 (T7–T13); UFO-B-2019 §3.1.

---

## Module 00b — UFO-B Events

### DD-006 · UFO-B als aparte module, niet geïntegreerd in gUFO Core

**Besluit:** UFO-B krijgt een eigen module `00b-ufo-b.ttl` in plaats van de event-concepten toe te voegen aan `00a-gufo-core.ttl`.

**Rationale:** gUFO bevat al een basisrepresentatie van events (`gufo:Event`, `gufo:broughtAbout`, etc.). De UFO-B-uitbreidingen zijn substantieel (AtomicEvent, ComplexEvent, Disposition, directlyCauses, activates, manifestedBy) en hebben eigen SHACL-constraints die modulair beheerd moeten worden. Bovendien is UFO-B de bron voor de Causa-perspective-ontologie; die koppeling wordt expliciet gemaakt via de module-import-structuur.

**Bron:** UFO-B-2013 §1; VALOR Product Plan §2.3 (laag 2).

---

### DD-007 · AtomicEvent en ComplexEvent als disjuncte partitie van Event

**Besluit:** `ufob:AtomicEvent` en `ufob:ComplexEvent` worden gedeclareerd als `owl:disjointWith` en samen als complete partitie van `gufo:Event` via een `owl:AllDisjointClasses`-blok.

**Rationale:** UFO-B-2013 axioma's M1/M2 stellen:
- `∀e:Event AtomicEvent(e) ↔ ¬∃e':Event has-part(e,e')`  (M1)
- `∀e:Event ComplexEvent(e) ↔ ¬AtomicEvent(e)`  (M2)

Dit is een equivalentiedefinitie (bi-conditioneel), niet alleen een subklasse-relatie. In OWL DL is volledige bi-conditionele axiomatisering beperkt (dit vereist closed-world assumption), maar de disjointness en completeness zijn uitdrukbaar.

**OWL-representatie (keuze):** We gebruiken `owl:complementOf` voor de definitie van AtomicEvent en `owl:disjointUnionOf` voor de partitie. Dit is de maximaal expressieve OWL 2-representatie van M1/M2.

**Afwijking:** De volledige bi-conditionele M1/M2 is in OWL niet volledig uitdrukbaar zonder open-world relaxatie. De SHACL-constraint B1 compenseert dit: `ComplexEvent` vereist ten minste 2 disjuncte delen (Weak Supplementation, M6).

**Bron:** UFO-B-2013 §3.1 (M1–M2, M6).

---

### DD-008 · Disposition als subklasse van IntrinsicMode

**Besluit:** `ufob:Disposition` is een subklasse van `gufo:IntrinsicMode` (niet van `gufo:Quality`).

**Rationale:** UFO-B-2013 §3.5 stelt: "UFO's notion of particularized tropes includes both qualities [...] and dispositions." Disposities zijn tropes die niet noodzakelijk een waarde in een kwaliteitsstructuur hebben (ze zijn niet meetbaar in de zin van temperatuur of massa), maar ze inheren wel in objecten en zijn entiteitsspecifiek. `gufo:IntrinsicMode` is de juiste superklasse: het is de gUFO-categorie voor niet-kwaliteitsmatige intrinsieke aspecten.

**Afwijking ten opzichte van gUFO-spec:** gUFO noemt `gufo:IntrinsicMode` de thuisplek voor disposities impliciet (als counterpart van `gufo:Quality`), maar declareert `Disposition` niet zelf. VALOR-O introduceert `ufob:Disposition` als een VALOR-O-toevoeging bovenop gUFO.

**Bron:** UFO-B-2013 §3.5 (D1–D4); gUFO-spec §3.2.

---

### DD-009 · gufo:contributedToTrigger vs. strict UFO-B triggers

**Besluit:** VALOR-O gebruikt `gufo:contributedToTrigger` (al aanwezig in gUFO Core) als de OWL-property die het dichtstbij UFO-B `triggers` ligt, maar documenteert expliciet dat de semantiek zwakker is.

**Achtergrond:** UFO-B-2013 axioma S3 stelt: `∀e:Event ∃!s:Situation triggers(s,e)` — er is precies één triggerende situatie per event. gUFO's `gufo:contributedToTrigger` is meervoudig (geen functionaliteitsbeperking). De uniqueness-constraint is uitgedrukt als SHACL-constraint B3 (maximaal 1 `wasTriggeredBy` per event).

**Afwijking:** gUFO verzwakt de UFO-B-axiomatisering bewust voor practical expressivity. VALOR-O compenseert dit via SHACL.

**Bron:** UFO-B-2013 §3.4 (S3–S4); gUFO-spec §3.3.

---

### DD-010 · directlyCauses en causes als afgeleide properties

**Besluit:** `ufob:directlyCauses` en `ufob:causes` worden gedeclareerd als `owl:ObjectProperty` met expliciete domein/range, maar *niet* als `owl:TransitiveProperty` voor `causes` in de OWL-axiomatisering.

**Rationale:** UFO-B-2013 S7 definieert `causes` als transitieve sluiting van `directlyCauses`. In OWL is transitieve closure in combinatie met andere axiomen (irreflexiviteit, asymmetrie) problematisch voor beslisbaarheid (OWL DL §11). VALOR-O declareert de transitieve intentie als `rdfs:comment` en implementeert de transitieve sluiting als SPARQL property path (`ufob:directlyCauses+`) in de Causa-SPARQL-bibliotheek.

**Afwijking:** UFO-B-2013 axiomatiseert causes als transitief en asymmetrisch in first-order logic. VALOR-O offert volledige OWL-uitdrukkbaarheid op voor GraphDB-compatibiliteit.

**Bron:** UFO-B-2013 §3.4 (S6–S7).

---

### DD-011 · historicalRole als nieuw stereotype, afkomstig van UFO-B-2019

**Besluit:** `gufo:ontoumlStereotype "historicalRole"` wordt toegevoegd aan `00b-ufo-b.ttl` als aanvulling op de bestaande stereotype-set in gUFO Core.

**Rationale:** UFO-B-2019 §3.2 introduceert `«historicalRole»` als een nieuw OntoUML-stereotype: een Role die een endurant speelt *in virtue of* deelname aan een past event. Dit verschilt fundamenteel van een gewone `«role»` (die wordt gespeeld in virtue of een bestaand relator). In VALOR zijn Participants die hebben bijgedragen aan afgesloten DesignPhases historische roldragers — dit onderscheid is cruciaal voor de provenancemodellering.

**Bron:** UFO-B-2019 §3.2 (Figures 5–7).

---

### DD-012 · participational en temporal als relatie-stereotypen

**Besluit:** `"participational"` en `"temporal"` worden als waarden van `gufo:ontoumlStereotype` gedocumenteerd voor object-properties in `00b-ufo-b.ttl`.

**Rationale:** UFO-B-2019 §3.3 introduceert twee soorten event-decomposities die verschillende semantieken hebben:
- `«participational»`: decomposities naar wie er participeert (Pribbenow's *portions* — intern geconstrueerde delen op basis van dependentie-eigenschap). Het maximale deel van een event dat exclusief afhangt van één endurant.
- `«temporal»`: decomposities naar tijdssegmenten (Pribbenow's *segments* — extern geconstrueerde delen op basis van temporele referentie).

Beide zijn mereologische relaties tussen events, maar met verschillende kardinaliteits- en disjointness-consequenties. In VALOR's Causa-perspectief zijn beide relevant: een interventie-event kan worden gedecomponeerd in participaties (wie doet wat) en in temporele segmenten (wanneer).

**Bron:** UFO-B-2019 §3.3; Pribbenow (1999) in de referentielijst van UFO-B-2019.

---

## Module 00c — UFO-C Social Entities

*(Hernoemd van 00b naar 00c na invoeging van UFO-B-module)*

### DD-013 · SocialCommitment als Relator, niet als Event

**Besluit:** `ufoc:SocialCommitment` is een subklasse van `gufo:Relator` (een endurant), niet van `gufo:Event` (een perdurant).

**Rationale:** Een commitment bestaat zolang hij niet is nagekomen of herroepen — hij *duurt*. Een event (de handeling waarmee de commitment wordt aangegaan) is wat de commitment in het leven roept (`ufoc:CommitmentCreationAction`). Dit onderscheid volgt UFO-C-2013 en is ook het centrale inzicht van Almeida-DEMO: "de DEMO-transactiestructuur wordt gemodelleerd als een commitment-Relator, niet als een event-sequentie."

**Bron:** UFO-C-2013 §3; Almeida-DEMO §4.

---

### DD-014 · Norm als mode van InstitutionalAgent, niet als zelfstandige entiteit

**Besluit:** `ufoc:Norm` is een subklasse van `ufoc:SocialObject`, die op zijn beurt een subklasse is van `gufo:IntrinsicMode`. Een Norm inhereert in een `ufoc:InstitutionalAgent` (de instelling die de norm draagt en handhaaft).

**Rationale:** UFO-C-2013 modelleert sociale objecten (waaronder normen) als intrinsieke modi van collectieve agents. Een norm bestaat niet onafhankelijk van de institutionele context die haar erkent en handhaaft. Dit onderscheidt de norm (de abstracte sociale entiteit) van het normDocument (het fysieke of digitale artefact).

**Afwijking:** Sommige rechtsontologieën modelleren normen als zelfstandige abstracte objecten (abstract individuals). VALOR-O volgt UFO-C/UFO-L hier: normen zijn ontologisch afhankelijk van de institutie die hen draagt.

**Bron:** UFO-C-2013 §4; UFO-L-2015 §3.

---

### DD-015 · Concern als fundering van het Issue-concept

**Besluit:** `ufoc:Concern` wordt als aparte subklasse van `ufoc:IntentionalMode` gedeclareerd (naast `ufoc:Belief`, `ufoc:Desire`, `ufoc:Goal`).

**Rationale:** Het VALOR-concept `valor:Issue` (een maatschappelijk vraagstuk) is ontologisch gefundeerd als een `gufo:Situation` waarover meerdere agents een `ufoc:Concern` hebben. Concern is conceptueel onderscheiden van Desire (een wens dat iets anders zou zijn) en van Goal (een concrete doelstelling): het drukt een toestand van betrokken zorg uit, niet noodzakelijk met een uitgewerkte oplossing. Dit onderscheid is relevant voor de beginfasen van VALOR's Design Lifecycle (Verkenning, Empathize).

**Bron:** VALOR Product Plan §1.4 (kernbegrip Issue); UFO-C-2013 §3.2 (intentionele modi).

---

## Module 00d — UFO-L Legal Relations

*(Hernoemd van 00c naar 00d na invoeging van UFO-B-module)*

### DD-016 · Policy vs. PolicyDocument — Weigand 2024-onderscheid

**Besluit:** `ufol:Policy` is een bundel van `ufol:RightMode`s en `ufol:DutyMode`s die inhereert in een `ufoc:InstitutionalAgent` via een `ufol:DelegationAuthority`. `ufol:PolicyDocument` is een afzonderlijk `ufol:InformationLegalObject` dat de Policy *beschrijft* maar er niet mee identiek is.

**Rationale:** Weigand-2024 maakt dit onderscheid expliciet: "Policy is a bundle of rights and duties [...] distinct from the policy document as artifact." Dit is ontologisch fundamenteel: beleidswijzigingen kunnen de Policy veranderen zonder dat het document verandert, en vice versa. In VALOR is dit onderscheid operationeel: Tesserae kunnen verwijzen naar `ufol:Policy` (de normatieve entiteit) als bewijs, niet naar het document.

**Bron:** Weigand-2024 §3.

---

### DD-017 · Hohfeld-implementatie met enforceability-gradaties

**Besluit:** `ufol:ClaimRightRelator` krijgt een `ufol:hasEnforceability`-eigenschap met drie waarden: `StrongClaim`, `ClaimAfterDefault`, `WeakClaim`.

**Rationale:** Niet alle rechten zijn even sterk afdwingbaar in de publieke dienstverlening. Een burger heeft een sterke aanspraak op een beschikking binnen de wettelijke termijn (`StrongClaim`), maar slechts een zwakke aanspraak op een specifieke uitkomst van een discretionaire bevoegdheid (`WeakClaim`). Dit onderscheid is relevant voor de Lexa-perspectief in VALOR: het bepaalt welk type normative Tessera kan worden geclaim als "schending" versus "niet-ideaal".

**Afwijking ten opzichte van UFO-L-2015:** UFO-L modelleert rechten binair. VALOR-O voegt de enforceability-gradatie toe als VALOR-specifieke extensie.

**Bron:** UFO-L-2015 §3 (Hohfeld); Weigand-2024 §4; VALOR Product Plan §4.3 (Lexa).

---

### DD-018 · LegalObject als verplicht gegeven bij elke LegalRelator

**Besluit:** Elke `ufol:LegalRelator`-instantie moet via `ufol:hasLegalObject` verbonden zijn met precies één `ufol:LegalObject`. Dit is SHACL-constraint L2.

**Rationale:** Gebaseerd op de Wetsanalyse-methode (TNO/ICTU): elke juridische betrekking betreft altijd een *object* — een recht op iets, een plicht tot iets. Het ontbreken van een LegalObject is een modelleerinconsistentie. In de praktijk van de Wetsanalyse is het identificeren van het object (element 2 in het analyseschema) een van de meest onderscheidende stappen.

**Bron:** Enserink et al. (2022), *Policy Analysis of Multi-Actor Systems* §7 (Wetsanalyse).

---

## Sectie-overschrijdende beslissingen

### DD-019 · Module-nummering na invoeging UFO-B

**Besluit:** Na invoeging van `00b-ufo-b.ttl` schuift de nummering op:

| Oud | Nieuw | Module |
|-----|-------|--------|
| 00a | 00a | gUFO Core |
| *(nieuw)* | 00b | UFO-B Events |
| 00b | 00c | UFO-C Social |
| 00c | 00d | UFO-L Legal |

Alle `owl:imports`-verwijzingen en SHACL-bestandsnamen worden dienovereenkomstig bijgewerkt.

---

### DD-020 · Taal van rdfs:comment: Engels voor termen, Nederlands voor domeinuitleg

**Besluit:** Klasse- en eigenschaftslabels zijn tweetalig (`@en` en `@nl`). `rdfs:comment`-annotaties zijn primair in het Nederlands (`@nl`) voor domeininhoudelijke uitleg, en in het Engels (`@en`) voor technische/ontologische toelichting.

**Rationale:** VALOR richt zich op Nederlandse publieke dienstverlening. Deelnemers die de Forma-view inspecteren zijn overwegend Nederlandstalig. Technische comments voor ontologie-engineers zijn in het Engels conform wetenschappelijke conventie.

---

### DD-021 · SHACL-severities: Violation vs. Warning

**Besluit:** SHACL-constraints hebben `sh:severity sh:Violation` als de constraint een ontologisch principe uitdrukt dat nooit mag worden geschonden (bijv. G7 punning, B1 weak supplementation, L1 Hohfeld-mediation). `sh:severity sh:Warning` wordt gebruikt voor constraints die een Best Practice uitdrukken maar waarvan onderbouwde afwijking mogelijk is (bijv. het ontbreken van een `rdfs:label` in een andere taal).

**Bron:** W3C SHACL Specification §2.1.

---

### DD-022 · Hoe gaan we om met open-world assumption in SHACL

**Besluit:** SHACL-constraints zijn bewust geformuleerd als minimale verplichtingen (minstens X), niet als volledige specificaties (precies X), tenzij de bronontologie een functionaliteitsaxioma stelt dat in OWL uitdrukbaar is.

**Rationale:** GraphDB is een open-world triplestore. SHACL in open-world context valideert wat er *is* opgegeven, niet wat er *niet* is. Een constraint `sh:minCount 1` is zinvol; `sh:maxCount 1` is alleen zinvol als het een functionele property is die niet verder wordt gespecialiseerd in latere modules.

**Uitzondering:** Voor UFO-B-axioma's S3/S4 (precies 1 triggerende situatie; precies 1 brought-about situatie per event) gebruiken we `sh:maxCount 1` omdat de functionaliteit een kernaxioma is, niet een Best Practice.

**Bron:** UFO-B-2013 §3.4 (S3, S4); W3C SHACL §4.1.

---

*Dit document wordt bijgewerkt bij elke nieuwe module. Versie-history wordt bijgehouden via Git-commits.*
