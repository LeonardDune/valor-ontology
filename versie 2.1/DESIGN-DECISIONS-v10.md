# VALOR-O Ontologie — Ontwerpbeslissingen

**Versie:** 0.6  
**Datum:** maart 2026  
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
| **DEMOSL** | Dietz, J.L.G. & Mulder, H.B.F. (2020), *Enterprise Ontology*, Springer — DEMO Specification Language §4 |
| **Calhau-2024** | Calhau, R.F. (2024), *Ontological Foundations for Capability and Competence Modeling in Enterprise Architecture*, PhD thesis, UFES — CREON (Ch. 5), DIECO (Ch. 4), CORE-O (Ch. 8) |
| **VSD-2019** | Friedman, B. & Hendry, D. (2019), *Value Sensitive Design: Shaping Technology with Moral Imagination*, MIT Press — Values Hierarchy (Ch. 4) |
| **PAMS** | Enserink, B. et al. (2022), *Policy Analysis of Multi-Actor Systems*, 2nd ed., TU Delft OPEN Books — PAMS-onzekerheidslevels |

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

### DD-014 · Norm als mode van SocialAgent (v0.2: was InstitutionalAgent)

**Besluit:** `ufoc:Norm` is een subklasse van `ufoc:SocialObject`, die op zijn beurt een subklasse is van `gufo:IntrinsicMode`. Een Norm inhereert in een `ufoc:SocialAgent` — de instantie (institutie of collectief) die de norm draagt en handhaaft.

**Rationale:** UFO-C-2013 modelleert sociale objecten (waaronder normen) als intrinsieke modi van sociale agents. Een norm bestaat niet onafhankelijk van de sociale context die haar erkent en handhaaft. De initiële modellering (v0.1) specificeerde `InstitutionalAgent` als bearer — dit was te restrictief. Met de correctie van de Agent-taxonomie in v0.2 (DD-083) wordt duidelijk dat normen ook kunnen inheren in `CollectiveSocialAgents`: sociale normen, gebruiken en samenwerkingsafspraken bestaan bij gratie van collectieve erkenning zonder formeel institutioneel kader. De range wordt daarom verbreed naar `ufoc:SocialAgent`.

**Nuance:** Juridische normen (UFO-L: `ufol:LegalNorm`) inheren wél specifiek in `InstitutionalAgents` — dat vereist formeel gezag. De verbreding naar `SocialAgent` geldt voor de algemene `ufoc:Norm`; de SHACL-constraint in `00c-ufo-l.shacl.ttl` (L6a: Policy inhereert in InstitutionalAgent) blijft ongewijzigd.

**Bron:** UFO-C-2013 §4; DD-083 (Agent-taxonomie v0.2).

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

---

## Module 00e — COoDM (Decision Making)

### DD-023 · ValueExperience als gufo:Event

**Besluit:** `valor:ValueExperience` is een subklasse van `gufo:Event`, niet van `gufo:Quality` of `gufo:IntrinsicMode`.

**Rationale:** Een waardebeleving is een *gebeurtenis* — ze heeft een tijdstip, een participant, en een begin- en eindpunt. Ze is niet een blijvende eigenschap van een agent. Dit volgt de COVER-ontologie (Guizzardi et al. 2022) die ValueExperience als event modelleert.

**Bron:** COVER §4.2; COoDM §3.1.

---

### DD-024 · ValueAscription als gufo:Relator

**Besluit:** `valor:ValueAscription` is een subklasse van `gufo:Relator`, niet van `gufo:IntrinsicMode`.

**Rationale:** Een waarde-toeschrijving medieert altijd tussen minimaal twee entiteiten: de agent die de waarde toeschrijft en het object of de situatie waaraan de waarde wordt toegeschreven. Dit relator-patroon volgt de structuur van COVER en UFO-C.

**Bron:** COVER §4.3; Sales et al. (2017) Value Ascription Ontology.

---

### DD-025 · ValueType als gufo:EventType

**Besluit:** `valor:ValueType` is een subklasse van `gufo:EventType` — het type waarvan ValueExperience-events instanties zijn.

**Rationale:** Als ValueExperience een event is, is ValueType het overeenkomstige event-type (conform gUFO's type-individual-hiërarchie). Dit maakt ValueType SPARQL-bevraagbaar als classificator van ValueExperience-events.

**Bron:** COVER §4.2; gUFO-spec §2.2 (Taxonomy of Types).

---

## Module 00f — COVER (Value Ontology)

### DD-026 · ValueProposition als ufoc:SocialObject

**Besluit:** `cover:ValueProposition` is een subklasse van `ufoc:SocialObject`, niet van `gufo:AbstractIndividual`.

**Rationale:** Een waardepropositie is een sociaal geconstitueerd object: het bestaat omdat een aanbieder het articuleert en een stakeholder het (potentieel) erkent. Ze is ontologisch afhankelijk van de institutionele context. Dit volgt de COVER-analyse van waardepropositie als communicatieve daad met normatieve lading.

**Bron:** COVER §5.1; UFO-C-2013 §4.

---

### DD-027 · VAComponent-subtypen: Benefits en Sacrifices als disjuncte subkinds

**Besluit:** `cover:Benefit` en `cover:Sacrifice` zijn disjuncte subklassen van `cover:VAComponent` (Value Ascription Component). Een component kan niet tegelijk een voordeel en een offer zijn.

**Rationale:** De disjunctie is inhoudelijk gemotiveerd: hetzelfde object of dezelfde situatie kan voor verschillende stakeholders een Benefit én een Sacrifice zijn, maar niet als één en hetzelfde component. De waardepolariteit zit in de stakeholder-relatie, niet in het component zelf.

**Bron:** COVER §5.2.

---

## Module 00g — ACTA (DEMO Transactions)

### DD-028 · LegalRelator als grondslag voor transacties

**Besluit:** `acta:TransactionResult` is tegelijk een `ufol:LegalRelator`: de transactie *creëert* een rechtsbetrekking als resultaat (`acta:createsLegalRelator`) én de transactie is *gegrond* in een bestaande rechtsbetrekking (`acta:groundedIn`).

**Rationale:** In DEMO-terminologie is de productiehandeling het realiseren van een belofte (C-act). Die belofte heeft juridische werking: ze schept een rechtsbetrekking tussen initiator en executor. Dit verbindt ACTA (transactioneel) met LEXA (normatief) via een gedeeld LegalRelator-patroon.

**Bron:** Almeida-DEMO §4; UFO-L-2015 §3.

---

### DD-029 · TransactionType vs. TransactionExecution: type-individual-onderscheid

**Besluit:** `acta:TransactionType` is een `gufo:EventType`; `acta:TransactionExecution` is een `gufo:Event` (instantie van dat type). Het type-individual-onderscheid is strikt: SHACL-constraints valideren dat requirements alleen aan types worden gekoppeld, niet aan executies.

**Rationale:** Capabilities en requirements zijn eigenschappen van transactietypes (het ontwerp), niet van individuele executies (het gedrag). Dit onderscheid is fundamenteel voor CAPAX en voor de beoordeelbaarheid van ontwerpalternatieven.

**Bron:** gUFO-spec §2.2; Almeida-DEMO §3.

---

## Module 00h — CAUSA (Causal Loop Diagrams)

### DD-030 · CausalClaim als specialisatie van ufoc:Belief

**Besluit:** `causa:CausalClaim` is een subklasse van `ufoc:Belief`. De propositionele inhoud (`gufo:hasPropositionalContent`) is een `causa:CausalSituation`.

**Rationale:** Causale claims zijn epistemische entiteiten: ze zijn overtuigingen van agents over causale verbanden in de wereld. UFO-C beschikt al over `ufoc:Belief` als IntrinsicMode met propositionele inhoud. Geen nieuwe foundationale types nodig — de bestaande UFO-C-structuur volstaat.

**Bron:** UFO-C-2013 §3.2; VALOR Product Plan §12.4 (CAUSA).

---

### DD-031 · Twee-fasen, twee-niveaus deliberatiestructuur in CAUSA

**Besluit:** CAUSA onderscheidt twee fasen (Probleemfase: ExplanatoryModels; Oplossingsfase: SolutionModels) en twee niveaus (claim-niveau en model-niveau). Dit is de architecturale ruggengraat van de module.

**Rationale:** Design Thinking onderscheidt expliciet probleemruimte (begrijpen en definiëren) en oplossingsruimte (ideëren en prototypen). Op elk niveau kunnen claims worden gedaan: over individuele causale verbanden (claim-niveau) en over het geïntegreerde causale model (model-niveau).

**Bron:** VALOR Product Plan §6.2 (Fase 1 en 2); PAMS §3 (CLD-methodologie).

---

### DD-032 · FeedbackLoop als gufo:Situation

**Besluit:** `causa:FeedbackLoop` is een subklasse van `gufo:Situation`, niet van `gufo:Event` of `gufo:AbstractIndividual`.

**Rationale:** Een feedback loop is een bestaande toestand in de wereld (of in een model) — ze *is* aanwezig als een bepaald patroon van causale verbanden bestaat. Ze is geen event (ze treedt niet op) en geen abstracte entiteit (ze is herkenbaar in concrete causale grafen). Als Situation is ze SPARQL-detecteerbaar via property-path-queries.

**Bron:** Meadows (2008) *Thinking in Systems* Ch. 1; PAMS §3.2.

---

### DD-033 · PAMS-onzekerheidsniveaus als gecontroleerd vocabulaire

**Besluit:** `causa:UncertaintyLevel` hanteert vijf niveaus conform PAMS: `Statistical`, `Scenario`, `Recognized`, `Deep`, `Ignorance`.

**Rationale:** PAMS biedt een gevalideerde taxonomie van onzekerheid voor beleidsanalyse. Opname als gecontroleerd vocabulaire maakt onzekerheid vergelijkbaar en communiceerbaar in Delibera.

**Bron:** PAMS §5 (onzekerheidstaxonomie).

---

## Module 00i — SOCIA (Actor Analysis / i*)

### DD-034 · IntentionalDependency als specialisatie van ufoc:SocialCommitment

**Besluit:** `socia:IntentionalDependency` is een subklasse van `ufoc:SocialCommitment`. De vier i*-dependumtypen (Goal, Task, Resource, Softgoal) worden onderscheiden op basis van het type propositionele inhoud van het commitment.

**Rationale:** Een intentionele afhankelijkheid is een commitment van een depender aan een dependee om een bepaald dependum te leveren. De UFO-C SocialCommitment-structuur met propositionele inhoud is precies de juiste ontologische grondslag — geen nieuwe foundationale typen nodig.

**Bron:** UFO-C-2013 §4; Yu (1995) i* framework Ch. 2.

---

### DD-035 · Vier dependumtypen als disjuncte subkinds

**Besluit:** `socia:GoalDependency`, `socia:TaskDependency`, `socia:ResourceDependency`, `socia:SoftgoalDependency` zijn disjuncte subklassen van `socia:IntentionalDependency`, onderscheiden door het type propositionele inhoud.

**Rationale:** i* onderscheidt deze vier typen op semantische gronden: een goaldependency betreft een gewenste situatie; een taskdependency een specifieke uitvoeringswijze; een resourcedependency een entiteit; een softgoaldependency een kwaliteitskenmerk. Het onderscheid is ontologisch relevant, niet slechts notationeel.

**Bron:** Yu (1995) §3.1–3.4.

---

## Module-overschrijdende beslissingen (vervolg)

### DD-036 · TransactionResult als ValueObject: ACTA→COVER-koppeling

**Besluit:** `acta:TransactionResult` kan tevens fungeren als `cover:ValueObject` — de gedeelde entiteit die TransactionExecution (ACTA) verbindt met ValueExperience (COVER). Geen vertaallaag nodig.

**Rationale:** Het resultaat van een transactie (bijv. een beschikking, een saneringsplan) is precies het object waaraan een stakeholder waarde beleeft. Door hetzelfde individu als zowel TransactionResult als ValueObject te typeren (OWL 2 multiple classification) is de koppeling direct en zonder duplicatie.

**Bron:** COVER §5.3; Almeida-DEMO §4; gUFO-spec §2.1 (multiple instantiation).

---

### DD-037 · Integratieprincipe: gedeelde entiteiten, geen vertaallayers

**Besluit:** Cross-module integratie in VALOR-O wordt gerealiseerd door hetzelfde individu te laten deelnemen aan meerdere modules (via OWL 2 multiple classification), niet door aparte "bridge"-klassen of vertaalmechanismen.

**Rationale:** Een vertaallaag introduceert redundantie, kan leiden tot inconsistentie, en verbreekt de semantische traceerbaarheid. Gedeelde entiteiten zijn SPARQL-bevraagbaar vanuit elk perspectief zonder extra queries.

**Afwijking:** Dit vereist disciplineerd gebruik van OWL 2 punning en zorgvuldig beheer van naamruimten. Het risico op onbedoelde classificatie-conflicten wordt beheerd via SHACL.

**Bron:** gUFO-spec §2.1 (multiple instantiation); VALOR Product Plan §2.1 (architectuurprincipe).

---

## Module 00j — CAPAX (Capability & Feasibility)

### DD-066 · Capability als gufo:Disposition — niet een goal, rol of proces

**Besluit:** `capax:Capability` is een subklasse van `gufo:Disposition` (een `gufo:NonQualitativeIntrinsicAspect`). Ze is geen `ufoc:Goal`, geen `ufoc:SocialRole`, en geen `gufo:Event`.

**Rationale:** Calhau (2024) §5.2.1 beargumenteert op basis van UFO-dispositietheorie dat capabilities *eigenschappen* zijn die *kunnen worden gerealiseerd* maar die bestaan als potentialiteit ook wanneer ze niet worden gerealiseerd. Dit onderscheidt capabilities principieel van doelen (intentionele toestanden), rollen (relationele eigenschappen) en processen (events). De dispositie-grondslag maakt het mogelijk om capability gaps te formaliseren als situaties waarin een vereiste dispositie afwezig is — het fundament van CAPAX's haalbaarheidslogica.

**Bron:** Calhau-2024 §5.2.1 (CREON); gUFO-spec §3.2 (Disposition); UFO-C-2013 §3.

---

### DD-067 · CapabilityRequirement als ufoc:SocialObject op TransactionType-niveau

**Besluit:** `capax:CapabilityRequirement` is een subklasse van `ufoc:SocialObject` en inhereerrt aan een `acta:TransactionType` (via `capax:requiredForTransactionType` als specialisatie van `gufo:inheresIn`), niet aan een concrete actor.

**Rationale:** Een capabiliteitseis is een normatief sociaal object: hij bestaat omdat een gemeenschap van ontwerpers en stakeholders hem erkent, en hij kan worden betwist, herzien en gedelegeerd — precies de eigenschappen van SocialObjects in UFO-C. Door de eis aan het TransactionType te koppelen (het ontwerp), niet aan een concrete actor, wordt de scheiding bewaard tussen de vraag "wat vereist dit transactietype?" en "beschikt deze actor hierover?" (die laatste vraag beantwoordt CapabilityGap).

**Verbinding met AXIA-VSD:** Een `axia:ValueBasedDesignRequirement` met `requirementType = 'Capability'` genereert een CapabilityRequirement via `axia:generatesCapabilityRequirement` — de formele AXIA→CAPAX-brug.

**Bron:** Calhau-2024 §5.3; UFO-C-2013 §4; DD-074.

---

### DD-068 · CapabilityGap als gufo:Situation — eerste-klas ontologisch object

**Besluit:** `capax:CapabilityGap` is een subklasse van `gufo:Situation`. Een capabiliteitstekort is een bestaande toestand in de wereld — niet een annotatie, niet een eigenschap, niet een score.

**Rationale:** Als `gufo:Situation` is een CapabilityGap: (a) citeerbaar als Tessera-inhoud (as-is claim in de ontwerp-workflow), (b) deelnemer in argumentatienetwerken in Delibera, (c) voorzien van epistemische status via de VALOR epistemische module, en (d) formeel traceerbaar als input voor FeasibilityAssessments. Dit geeft capabiliteitstekorten ontologisch gewicht: ze moeten formeel worden geadresseerd voordat een alternatief een faseovergang mag maken.

**Bron:** Calhau-2024 §5.4 (CapabilityGap als ontologisch construct); gUFO-spec §3.4 (Situation).

---

### DD-069 · Scope-beperking: geen competence-ontologie in CAPAX

**Besluit:** CAPAX modelleert *niet* de interne structuur van competences (kennis, vaardigheden, attitudes per Calhau CORE-O). De CORE-O-hiërarchie (IndividualCompetence → Knowledge + Skill + Attitude) valt buiten VALOR's ontwerp-scope.

**Rationale:** VALOR is een platform voor de *design space* — de vraag "welke capabilities zijn vereist en aanwezig?" is relevant voor haalbaarheidstoetsing. De vraag "hoe is een competence opgebouwd uit kennis, vaardigheidsniveaus en attitudinele componenten?" is een HR-managementvraag die buiten VALOR's deliberatieproces valt. CAPAX biedt `capax:CapabilityDevelopmentNeed` als brug naar het implementatiedomein zonder dat domein zelf te modelleren.

**Afwijking ten opzichte van Calhau:** Calhau-2024 (CORE-O, Ch. 8) biedt een volledige competence-ontologie. VALOR neemt hiervan alleen het dispositie-concept over als grondslag voor Capability, niet de competence-taxonomie.

**Bron:** Calhau-2024 §8 (CORE-O); VALOR Product Plan §4.4 (scope publieke dienstverlening).

---

### DD-070 · FeasibilityAssessment als gufo:Situation — gate-criterium bij faseovergang

**Besluit:** `capax:FeasibilityAssessment` is een subklasse van `gufo:Situation`. Ze aggregeert alle CapabilityGaps voor een ontwerpalternatief en fungeert als formele poort-Tessera bij faseovergangen in Delibera.

**Rationale:** Een haalbaarheidsbeoordeling is een toestand van het ontwerp: het *is* op dit moment haalbaar, niet-haalbaar, of haalbaar onder condities. Als Situation is ze betwistbaar, reviseerbaar en epistemisch statusdragend — precies de eigenschappen die nodig zijn voor een democratisch deliberatieproces. De SHACL-constraint FEA-1 t/m FEA-4 borgen de interne consistentie van de beoordeling.

**Procesgevolg:** Een `valor:PhaseTransition` (Delibera) vereist dat het relevante alternatief een FeasibilityAssessment heeft met `epistemicStatus = 'Accepted'` voordat het mag doorstromen. Een 'NotFeasible'-oordeel dat wordt aangenomen, sluit het alternatief met een traceerbare rationale.

**Bron:** gUFO-spec §3.4; VALOR Product Plan §6.2 (faseovergang-criteria).

---

## Module 00k — AXIA-VSD (Value Sensitive Design — Values Hierarchy)

### DD-071 · ValueCriterion en ValueBasedDesignRequirement als ufoc:SocialObject

**Besluit:** Zowel `axia:ValueCriterion` als `axia:ValueBasedDesignRequirement` zijn subklassen van `ufoc:SocialObject` (via `gufo:NonQualitativeIntrinsicAspect`).

**Rationale:** Waardecriteria en ontwerpeisen zijn sociaal geconstitueerde normatieve objecten: ze bestaan omdat een gemeenschap van ontwerpers en stakeholders ze erkent, kunnen worden betwist, herzien en gedelegeerd. Dit is precies het ontologisch profiel van SocialObjects in UFO-C. Ze zijn geen Beliefs (doxastisch) — ze zijn normatief. De vergelijking met UFO-L-normen is van toepassing: zoals een Norm plichten koppelt aan actoren, koppelt een ValueCriterion normatieve standaarden aan waarden.

**Onderscheid met COVER:** COVER modelleert hoe waarden worden *beleefd* (fenomenologische richting: ValueType → ValueExperience). AXIA-VSD modelleert hoe waarden *ontwerpeisen stellen* (normatieve richting: ValueType → ValueCriterion → ValueBasedDesignRequirement). Beide dimensies zijn nodig; ze zijn complementair, niet redundant.

**Bron:** VSD-2019 Ch. 4 (Values Hierarchy); UFO-C-2013 §4; UFO-L-2015 §3; COVER §4.

---

### DD-072 · ValueCriterion inhereerrt aan cover:ValueType

**Besluit:** `axia:ValueCriterion` inhereerrt aan `cover:ValueType` via `axia:criterionFromValue` (specialisatie van `gufo:inheresIn`). Het criterium is *over* de waarde, niet over een agent of ontwerpalternatief.

**Rationale:** Door het criterium aan het ValueType te koppelen (niet aan een agent of alternatief) wordt het criterium herbruikbaar over meerdere Design Spaces. Hetzelfde privacycriterium geldt voor alle ontwerpalternatieven die de waarde Privacy raken — het hoeft niet per alternatief opnieuw te worden geformuleerd. De concretisering per alternatief gebeurt in `axia:ValueBasedDesignRequirement` (DD-073).

**Juridische verankering:** Een ValueCriterion kan tegelijk worden afgeleid van een waarde én gegrond zijn in een juridische norm (UFO-L). De twee grondslagen zijn additief: het criterium bestaat zodra één van beide geldt. Dit maakt AXIA-VSD ook bruikbaar voor compliance-analyse.

**Bron:** VSD-2019 Ch. 4; COVER §4.2; UFO-L-2015 §3.

---

### DD-073 · ValueBasedDesignRequirement inhereerrt aan DesignAlternative

**Besluit:** `axia:ValueBasedDesignRequirement` inhereerrt aan `valor:DesignAlternative` via `axia:appliesToAlternative` (specialisatie van `gufo:inheresIn`). Hetzelfde criterium kan voor verschillende alternatieven verschillende concrete eisen genereren.

**Rationale:** De concretisering van een abstract waardecriterium is altijd contextafhankelijk: het criterium "Privacy moet worden gerespecteerd" vertaalt voor Alternatief A (geautomatiseerde signalering) naar andere concrete eisen dan voor Alternatief B (menselijke beoordeling). Door de requirement aan het alternatief te koppelen, is de contextuele variatie direct representeerbaar zonder het criterium te dupliceren.

**Implicatie voor SPARQL:** Een SPARQL-query kan voor elk alternatief alle geldende waardegerichte eisen opvragen, en voor elke eis de waardeketen (waarde → criterium → eis → alternatief) volledig traceren.

**Bron:** VSD-2019 Ch. 4; DD-072.

---

### DD-074 · AXIA→CAPAX-brug via axia:generatesCapabilityRequirement — één richting

**Besluit:** De brug van AXIA-VSD naar CAPAX loopt via de property `axia:generatesCapabilityRequirement` (domein: `axia:ValueBasedDesignRequirement`, bereik: `capax:CapabilityRequirement`). De brug is unidirectioneel: CAPAX back-refereert niet naar AXIA-VSD. Traceerbaarheid in de CAPAX-richting wordt geborgd via `capax:requirementSource` (vrij tekstveld).

**Rationale:** Strakke bidirectionele koppeling tussen modules introduceert circulaire afhankelijkheden en bemoeilijkt modulair gebruik van CAPAX zonder AXIA-VSD. Door de verbinding als unidirectionele property te modelleren, blijft CAPAX bruikbaar als zelfstandige module terwijl de derivatieketen vanuit AXIA-VSD volledig traceerbaar is.

**Trigger:** SHACL-constraint VSD-7 verplicht dat een `ValueBasedDesignRequirement` met `requirementType = 'Capability'` minstens één CapabilityRequirement genereert — zodat de brug niet optioneel is als het type dit vereist.

**Bron:** VSD-2019 Ch. 4; DD-067; DD-073.

---

### DD-075 · ValueHierarchy als gufo:Collection

**Besluit:** `axia:ValueHierarchy` is een subklasse van `gufo:Collection`. Ze is geen Situation (geen waarheidscondities), geen Event (treedt niet op), en geen AbstractIndividual.

**Rationale:** Een waardehiërarchie is een benoemde verzameling van drie typen leden (ValueTypes, ValueCriteria, ValueBasedDesignRequirements) zonder vaste interne structuur. Ze bestaat zolang haar leden worden onderhouden. `gufo:Collection` is het correcte gUFO-concept voor gehelen zonder rigide mereologische structuur.

**Gebruik:** De ValueHierarchy dient primair voor documentatie, export en traceerbaarheid — niet als inferentie-constructie. Ze is optioneel: VALOR-O functioneert volledig zonder ValueHierarchy-instanties.

**Bron:** gUFO-spec §3.1 (Collection); VSD-2019 Ch. 4 (Values Hierarchy als analytisch instrument).

---

### DD-076 · Derivatieketen als acyclische gerichte graaf (DAG)

**Besluit:** De volledige derivatieketen `cover:ValueType → axia:ValueCriterion → axia:ValueBasedDesignRequirement → capax:CapabilityRequirement → capax:CapabilityGap → capax:FeasibilityAssessment` is ontworpen als een acyclische gerichte graaf. Cyclische derivaties zijn verboden (gehandhaafd door SHACL-constraint VSD-9).

**Rationale:** Cyclische derivaties — waarbij een eis terug leidt tot de waarde die hem voortbracht — zijn semantisch zinloos en maken de redeneergeschiedenis onnavolgbaar. Als DAG is de keten volledig SPARQL-traverseerbaar in beide richtingen (van waarde naar faseovergang, en van faseovergang terug naar de waarde die de eis genereerde).

**Volledige keten (SPARQL-navigeerbaar):**
```
cover:ValueType
  ← [axia:criterionFromValue]        axia:ValueCriterion
      ← [axia:requirementFromCriterion]  axia:ValueBasedDesignRequirement
          → [axia:appliesToAlternative]      valor:DesignAlternative
          → [axia:generatesCapabilityRequirement]
              → capax:CapabilityRequirement
                  ← [capax:gapConcernsRequirement]  capax:CapabilityGap
                      ← [capax:includesGap]  capax:FeasibilityAssessment
                          → epistemicStatus 'Accepted' (Delibera gate)
```

**Parallelle verbindingen:**
- `ufol:Norm ← [axia:groundedInNorm] ─ axia:ValueCriterion` (juridische verankering via LEXA)
- `cover:ValueType ← cover:ValueExperience [gufo:inheresIn] ← ufoc:Agent` (waardebeleving via COVER)

**Bron:** VSD-2019 Ch. 4; DD-071 t/m DD-075; VALOR Product Plan §2.1.

---

## Module 00l — NEXUS (Ecosystem Capability & Collaborative Capability)

### DD-077 · EcosystemAgent als subkind van ufoc:CollectiveSocialAgent (v0.2)

**Besluit:** `nexus:EcosystemAgent` is een subklasse van `ufoc:CollectiveSocialAgent` — niet van `ufoc:InstitutionalAgent` zoals aanvankelijk gemodelleerd in v0.1 van NEXUS.

**Rationale:** De UFO-C spec (ontology.com.br/ufo/ufo-c/spec/) onderscheidt `SocialAgent` in twee subkinds: `InstitutionalAgent` (erkend via externe institutionele structuur, intern hiërarchisch gezag) en `CollectiveSocialAgent` (erkend door de leden zelf, geen extern institutioneel kader vereist, geen intern hiërarchisch gezag). Een publiek service ecosysteem past ontologisch in de tweede categorie: het bestaat doordat zijn leden — autonome InstitutionalAgents — elkaar wederzijds erkennen als partners. Er is geen vereiste van rechtspersoonlijkheid, geen wettelijk statuut, geen interne gezagsstructuur. De initiële modellering als subkind van `InstitutionalAgent` was onjuist: die klasse impliceert externe institutionele erkenning en intern gezag.

**Cascade:** Deze correctie vereist ook DD-083 (UFO-C uitbreiden met SocialAgent en CollectiveSocialAgent). De C6-SHACL-constraint wordt bijgewerkt van `Physical ∨ Institutional` naar `Physical ∨ Social`, en nieuwe C9-constraint valideert `Social = Institutional ∨ CollectiveSocial`.

**Bron:** UFO-C spec §Agent (ontology.com.br/ufo/ufo-c/spec/); Osborne et al. (2022).

---

### DD-083 · UFO-C Agent-taxonomie uitgebreid met SocialAgent en CollectiveSocialAgent

**Besluit:** Module `00b-ufo-c.ttl` wordt bijgewerkt (v0.2) met de volledige Agent-taxonomie per UFO-C spec:

```
ufoc:Agent
├── ufoc:PhysicalAgent
└── ufoc:SocialAgent          ← NIEUW in v0.2
    ├── ufoc:InstitutionalAgent   (was directe subklasse van Agent)
    └── ufoc:CollectiveSocialAgent  ← NIEUW in v0.2
```

**Consequenties per bestand:**

`00b-ufo-c.ttl`: `SocialAgent` en `CollectiveSocialAgent` toegevoegd; `InstitutionalAgent` hergeclassificeerd als subkind van `SocialAgent`; disjointness bijgewerkt (Physical ⊥ Social; Institutional ⊥ CollectiveSocial); commentaar op `SocialObject` en `Norm` bijgewerkt (range nu `SocialAgent`).

`00b-ufo-c.shacl.ttl`: C6 bijgewerkt (Physical ∨ Social); C8 bijgewerkt (Norm.inheresIn → SocialAgent); C9 nieuw (SocialAgent = Institutional ∨ CollectiveSocial).

`00l-nexus.ttl`: `EcosystemAgent rdfs:subClassOf ufoc:CollectiveSocialAgent` (was InstitutionalAgent).

**Bron:** UFO-C spec §Agent (ontology.com.br/ufo/ufo-c/spec/); correctie van DD-077 v0.1.

---

### DD-078 · CollaborativeCapability als subtype van capax:Capability

**Besluit:** `nexus:CollaborativeCapability` is een subklasse van `capax:Capability` (en daarmee van `gufo:Disposition`). De bearer is altijd een `nexus:EcosystemAgent`. De manifestatieconditie is altijd een `nexus:CollaborationCondition` — niet alleen een triggerende situatie.

**Rationale:** Door te erven van `capax:Capability` participeert CollaborativeCapability volledig in de bestaande CAPAX-derivatieketen (CapabilityRequirement → CapabilityGap → FeasibilityAssessment → Delibera-gate). Geen nieuwe poortmechanismen nodig: de bestaande VALOR-O haalbaarheidslogica werkt ook voor ecosysteem-capabilities. Het enige ontologisch nieuwe: de manifestatieconditie is niet zomaar een `gufo:Situation` maar specifiek een `nexus:CollaborationCondition` — een situatie die vereist dat zowel een actief CollaborationCommitment als een operationele CollaborationArchitecture aanwezig zijn.

**Emergentie-interpretatie:** Calhau's DIECO modelleert intra-organisationele emergentie via managementgezag. NEXUS modelleert inter-organisationele emergentie via gecoördineerde transactionele interdependentie. `nexus:contributingCapability` legt de emergentiestructuur vast: welke organisatorische capabilities dragen bij? Maar de emergentie-mechanisme is de CollaborationCondition, niet een hiërarchisch gezagsproces.

**Bron:** Calhau-2024 §4 (DIECO emergentie); Osborne et al. (2022) §4 (co-productie als ecosysteem-fenomeen); DD-066 (Capability als gufo:Disposition).

---

### DD-079 · CollaborationCommitment als multilaterale ufoc:SocialCommitment

**Besluit:** `nexus:CollaborationCommitment` is een subklasse van `ufoc:SocialCommitment`. Het is multilateraal: elke deelnemende organisatie is tegelijk committed agent én claimant agent. Gemodelleerd via `nexus:hasParticipatingOrganisation` (n ≥ 2) in plaats van het bilaterale patroon van UFO-C.

**Rationale:** UFO-C's SocialCommitment is bilateraal (één committed, één claimant). Een samenwerkingscommitment is per definitie multilateraal: organisatie A committeert zich aan B én C, en mag omgekeerd coördinatie van B én C verwachten. Dit is ontologisch onderscheiden van een keten van bilaterale commitments — het is een enkelvoudig relator dat meerdere agents mediatiseert.

**Grondslag voor EcosystemAgent:** Het CollaborationCommitment is de constitutieve akte van het EcosystemAgent: het ecosysteem bestaat als agent doordat dit commitment bestaat en actief is. Vervalt het commitment (bijv. een organisatie stapt uit), dan is het EcosystemAgent in zijn huidige samenstelling ontologisch beëindigd.

**Verbinding met LEXA:** Een CollaborationCommitment kan juridisch verankerd zijn via `nexus:groundedInNorm` (een convenant, subsidievoorwaarde, bestuursakkoord als `ufol:Norm`). Juridische verankering is niet vereist — vrijwillige samenwerking is een geldig CollaborationCommitment.

**Bron:** UFO-C-2013 §3 (SocialCommitment); DD-013 (SocialCommitment als Relator).

---

### DD-080 · CollaborationCondition als gufo:Situation — de dubbele conditie

**Besluit:** `nexus:CollaborationCondition` is een subklasse van `gufo:Situation`. Ze geldt wanneer TWee condities gelijktijdig vervuld zijn: (a) een actief CollaborationCommitment én (b) een operationele CollaborationArchitecture.

**Rationale:** Beide componenten zijn noodzakelijk en geen van beide is voldoende:
- Commitment zonder Architectuur: de organisaties hebben afgesproken samen te werken, maar er is geen concreet transactienetwerk — de capability kan niet worden gemobiliseerd.
- Architectuur zonder Commitment: er is een transactienetwerk ontworpen, maar de organisaties hebben zich er niet aan gecommitteerd — de capability is niet betrouwbaar beschikbaar.

Als `gufo:Situation` is de CollaborationCondition citeerbaar als Tessera (to-be): "deze conditie zal gelden wanneer ons ontwerp is geïmplementeerd." Dit maakt de samenwerkingsconditie ZELF een onderdeel van VALOR's deliberatieproces — ze is niet een randvoorwaarde buiten het ontwerp, maar een ontwerpdoel.

**Implicatie voor VALOR:** De dubbele conditie impliceert dat een ontwerp altijd beide aspecten moet specificeren: het commitment (wie committeert zich aan wat) en de architectuur (hoe wordt het commitment geoperationaliseerd in transacties). Een ontwerpalternatief dat alleen één van beide specificeert is ontologisch onvolledig.

**Bron:** gUFO-spec §3.4 (Situation); DD-068 (Situation als eerste-klas ontologisch object).

---

### DD-081 · EcosystemCapabilityGap vereist GovernanceDevelopmentNeed — nooit uitsluitend HR

**Besluit:** `nexus:EcosystemCapabilityGap` is een subklasse van `capax:CapabilityGap`. Elke EcosystemCapabilityGap vereist per definitie ten minste één `nexus:GovernanceDevelopmentNeed`. Een uitsluitend HR-gerichte `capax:CapabilityDevelopmentNeed` is niet voldoende als respons op een ecosysteem-gap.

**Rationale:** Een EcosystemCapabilityGap is kwalitatief anders dan een organisatorische gap:
- Organisatorische gap: een organisatie ontbreekt een dispositie → respons: HR (opleiding, werving, reorganisatie)
- Ecosysteem-gap: het ecosysteem ontbreekt een dispositie, doordat de CollaborationCondition niet geldt → respons: governance-ontwerp (commitment afsluiten, architectuur ontwerpen, governance-orgaan oprichten)

Geen enkele deelnemende organisatie kan een EcosystemCapabilityGap sluiten via interne HR-beslissingen. De gap is structureel inter-organisationeel; de oplossing moet dat ook zijn.

**SHACL-afdwinging:** NEX-14 valideert dat elke EcosystemCapabilityGap wordt geadresseerd door een GovernanceDevelopmentNeed. Dit is een harde constraint, niet een waarschuwing: een FeasibilityAssessment met een EcosystemCapabilityGap zonder GovernanceDevelopmentNeed is ontologisch onvolledig.

**Bron:** DD-068 (CapabilityGap als Situation); Osborne et al. (2022) §5 (ecosystem governance als voorwaarde voor waardecreatie).

---

### DD-082 · CollaborationArchitecture als gufo:Situation — de transactionele operationalisering

**Besluit:** `nexus:CollaborationArchitecture` is een subklasse van `gufo:Situation`. Ze is een structurele toestand van het transactienetwerk die ofwel al geldt (as-is) ofwel ontworpen wordt om te gelden (to-be). Ze is niet een Event (treedt niet op), niet een Agent (handelt niet).

**Rationale:** De CollaborationArchitecture beschrijft *hoe het netwerk geconfigureerd is* — welke transactietypes bestaan, welke rollen zijn toegewezen, hoe informatiestromen lopen. Dit is een toestand, niet een handeling. Als Situation is ze:
- Citeerbaar als Tessera in het Acta-perspectief (to-be: "zo wordt de samenwerking ingericht")
- SPARQL-bevraagbaar in relatie tot CollaborationCommitment en CollaborativeCapability
- Formeel valideerbaar: voldoet de architectuur aan de eisen van het commitment?

**Verbinding met ACTA:** De CollaborationArchitecture omvat `acta:TransactionType`s en `acta:ActorRole`s — ze *is* de ACTA-representatie van de samenwerking. Dit maakt de NEXUS↔ACTA-koppeling direct: een ontwerpalternatief in Acta-perspectief IS de CollaborationArchitecture.

**Bron:** gUFO-spec §3.4; Almeida-DEMO §3 (TransactionType als ontwerp-eenheid); DD-029.

---

### DD-084 · Emergentie-taxonomie in CAPAX: resultant vs. emergent + DispositionRelation

**Besluit:** CAPAX v0.2 introduceert drie nieuwe elementen:
1. `capax:emergenceNature` op `OrganizationalCapability` — gecontroleerd vocabulaire: `'Resultant'` | `'Emergent'` | `'Unknown'`
2. `capax:DispositionRelation` als `gufo:Relator` — formaliseert de onderlinge afhankelijkheden tussen capabilities die samen bijdragen aan een emergente capability
3. `capax:dispositionRelationType` op `DispositionRelation` — gecontroleerd vocabulaire: `'Reciprocal'` | `'Additional'` | `'Enabling'`

**Rationale:** Bunge (1979) onderscheidt resultante eigenschappen (mathematisch afleidbaar uit de som van componenteigenschappen) van emergente eigenschappen (superveniëren op de bonding structure, niet reduceerbaar naar de delen). Dit onderscheid heeft directe praktische relevantie voor VALOR: bij een **resultante** capability-gap volstaat werving of inhuur; bij een **emergente** capability-gap is structurele herorganisatie of governance-ontwerp vereist. Zonder dit onderscheid wordt in VALOR ten onrechte een `CapabilityDevelopmentNeed` van type "Werving" aangemaakt voor een gap die alleen via `'StructuralRedesign'` of `'GovernanceRedesign'` kan worden gedicht.

De `DispositionRelation` is gebaseerd op Barton et al. (2017) en Calhau et al. (2023): drie fundamenteel verschillende relatie-typen tussen disposities verklaren *hoe* emergentie werkt — reciprocaliteit (wederzijdse activering), additiviteit (noodzakelijke combinatie) en enabling (eenzijdige activering). Deze typen zijn nodig om een EcosystemCapabilityGap volledig te diagnosticeren.

**Scope-beperking:** CAPAX modelleert de *types* en het *bestaan* van dispositionele relaties. De structurele inbedding (FunctionalRole, BondingRelation als materiële relatie, volledige SystemSituation-ontologie conform Calhau et al. 2023 Fig. 2-4) is toekomstig werk in module `00m-sysont`.

**Bron:** Bunge (1979) Ontology II §3 (resultant vs. emergent properties); Calhau et al. (2023) EDOC §4 (capability emergence modeling); Barton et al. (2017) disposition-parthood taxonomy.

---

### DD-085 · CollaborationCondition als SystemSituation-conform concept (NEXUS v0.3)

**Besluit:** De `nexus:CollaborationCondition` wordt in v0.3 herontwikkeld als de **SystemSituation van het ecosysteem** in de zin van Bunge (1979) en Calhau et al. (2023). Ze is niet langer een externe checklist van twee condities (commitment ∧ architectuur) maar de **configuratietoestand** van het ecosysteem als geheel — de toestand waarin de deelnemende organisaties de juiste bonding structure met elkaar hebben.

Drie constitutieve elementen (alle drie vereist):
- **(a)** actief `CollaborationCommitment` (normatieve laag — intentioneel)
- **(b)** operationele `CollaborationArchitecture` (structurele laag — transactioneel)
- **(c)** de juiste `DispositionRelation`s tussen bijdragende capabilities van leden (dispositieve laag — emergentiegrond)

**Rationale:** De kerninsight van Bunge's systemisme — en Calhau's toepassing ervan — is dat emergentie niet optreedt uit de aanwezigheid van condities, maar uit de *configuratie van bonding relations*. Een ecosysteem met commitment én architectuur maar met de verkeerde dispositionele relaties tussen lidcapabilities zal de CollaborativeCapability **niet** genereren. Dit is precies waarom samenwerkingen mislukken ondanks goede intenties en formele overeenkomsten: de bonding structure deugt niet. VALOR-O moet dit onderscheid modelleerbaar maken zodat het *aanwijsbaar* wordt in Delibera als betwistbare Tessera.

**Consequenties:**
- `nexus:conditionGroundedInDispositionRelations` als nieuwe property op `CollaborationCondition`
- `nexus:hasDispositionRelation` op `CollaborativeCapability` — verplicht voor volledige emergentie-analyse
- SHACL NEX-20 (nieuw): een `GovernanceDevelopmentNeed` bij een `EcosystemCapabilityGap` MOET verwijzen naar ten minste één `capax:DispositionRelation` — diagnosticeert welke bonding relation ontbreekt of onjuist is geconfigureerd
- `nexus:CollaborativeCapability`: `emergenceNature` is per definitie altijd `'Emergent'` — inter-organisationele capabilities zijn nooit resultant

**Bron:** Bunge (1979) Ontology II §3 (CESM, bonding structure); Calhau et al. (2023) EDOC §4 (SystemSituation, DispositionRelation types); Barton et al. (2017); DD-080, DD-082, DD-084.

---

## Module 00m — SYSONT (System Core Ontology)

### DD-086 · System als gufo:FunctionalComplex met vier criteria

**Besluit:** `sysont:System` is een `gufo:FunctionalComplex` met `gufo:ontoumlStereotype "category"`. Een System wordt onderscheiden van een 'gewoon' FunctionalComplex door vier criteria (Calhau et al. 2023 §4, Bunge 1979):
(i) complexiteitsgraad (meerdere componenten en verbindingen);
(ii) geïntegreerde bonding structure;
(iii) heterogene, complementaire FunctionalRoles van componenten;
(iv) emergentie van nieuwe eigenschappen en gedrag.

`sysont:Component` is een `gufo:Mixin` — de meest brede UFO-categorie, omdat componenten van elk type kunnen zijn (personen, tools, procedures, informatiesystemen). `sysont:Subsystem` specialiseert `System` voor het geval van geneste systeemhiërarchie.

**Scope-positie:** SYSONT modelleert systemen op het type-niveau (klassen) als fundament voor emergentie-redenering. Instantie-niveau modellering (welke concrete organisatie is component van welk concreet ecosysteem) gebeurt in NEXUS en CAPAX.

**SHACL:** SYS-1 (System ≥ 2 Components), SYS-2 (Component isComponentOf ≥ 1 System), SYS-12 (Subsystem isComponentOf ≥ 1 hoger System).

**Bron:** Calhau et al. (2023) §4 Fig. 2; Bunge (1979) §3 (CESM-model); Guizzardi (2005) §4 (FunctionalComplex, Mixin).

---

### DD-087 · BondingRelation als gufo:MaterialRelation; NonBondingRelation als gufo:ComparativeRelation

**Besluit:** Twee fundamenteel verschillende relatie-typen worden formeel onderscheiden:

- `sysont:BondingRelation` is een `gufo:MaterialRelation` (`gufo:ontoumlStereotype "material"`): causale beïnvloeding waarbij energie, materie of informatie stroomt. Vereist een mediator (UFO-Relator). Specialisaties: `InternalConnection` (binnen het System) en `ExternalConnection` (naar ExternalEntities in de Environment).
- `sysont:NonBondingRelation` is een `gufo:ComparativeRelation` (`gufo:ontoumlStereotype "comparative"`): vergelijkende of constitutieve constraints zonder causale beïnvloeding. Geen mediator; direct formele relatie.

**Cascade:** `capax:DispositionRelation` (DD-084) is een specialisatie van `sysont:BondingRelation` — een dispositierelatie IS een bondingrelatie op het niveau van disposities. De mediator IS de afhankelijke dispositie die de component aanneemt in System-verband (integratiebrug B1 in SYSONT §5).

**SHACL:** SYS-3 (BondingRelation ≥ 2 isConnectedWith), SYS-4 (NonBondingRelation ≥ 2 isContrastedWith), SYS-16 (InternalConnection binnen System), SYS-17 (ExternalConnection heeft ExternalEntity).

**Bron:** Bunge (1979) §3 (bonding vs. non-bonding distinction); Calhau et al. (2023) §4 Fig. 2; Guizzardi (2005) §5 (MaterialRelation, ComparativeRelation).

---

### DD-088 · FunctionalRole als gufo:Role; MomentType als type-niveau brug

**Besluit:** `sysont:FunctionalRole` is een `gufo:Role` (`gufo:ontoumlStereotype "role"`): het anti-rigide, relationele type dat de 'positie' van een Component in een System beschrijft. Een Component instantiëert een FunctionalRole contingent — alleen zolang hij deel is van het specifieke System in de vereiste configuratie.

`sysont:MomentType` is een `gufo:Kind` op type-niveau: het specificeert welk type eigenschap (kwaliteit, modus, dispositie) een Component moet bezitten om een FunctionalRole te vervullen. `MomentType` is de brug tussen het type-niveau (systeemontwerp: welke eigenschappen zijn vereist?) en het instantie-niveau (welke concrete capabilities heeft deze Component?).

**Verbinding met CAPAX:** Een `capax:CapabilityRequirement` correspondeert functioneel met een `sysont:MomentType` op type-niveau: beide specificeren wat vereist is van een actor/component. Het onderscheid: CapabilityRequirement is een sociaal object dat inhereert aan een `acta:TransactionType`; MomentType is een type-niveau specificatie van de vereiste eigenschap in het systeemontwerp.

**Verbinding met NEXUS:** `nexus:EcosystemAgent`-leden vervullen FunctionalRoles in het ecosysteem-als-System. De `CollaborationArchitecture` (DD-082) specificeert welke FunctionalRoles aanwezig moeten zijn voor de `CollaborationCondition` te gelden.

**SHACL:** SYS-5 (FunctionalRole isCharacterizedBy ≥ 1 MomentType), SYS-13 (FunctionalRole isBondedTo vereist instantiëring).

**Bron:** Calhau et al. (2023) §4 Fig. 3; Compagno et al. (aangehaald in Calhau 2023) — twee betekenissen van 'functie'; Guizzardi (2005) §4 (Role als anti-rigide type).

---

### DD-089 · SystemSituation en SystemMoment als emergentie-mechanisme; vier integratiebuggen

**Besluit:** Twee kernconcepten formaliseren het emergentie-mechanisme van Bunge (1979) en Calhau et al. (2023):

- `sysont:SystemSituation` (`gufo:Situation`): de configuratietoestand van het System — de verzameling componenten én hun onderlinge bonding structure op een bepaald tijdstip. IS de ontologische grond van emergentie: zonder de juiste SystemSituation geen emergente eigenschappen.
- `sysont:SystemMoment` (`gufo:Moment`, `gufo:ontoumlStereotype "category"`): een eigenschap van het System als geheel, niet van individuele componenten. Twee disjuncte subtypen:
  - `EmergentSystemMoment`: superveniëert op de bonding structure; heeft `emergesIn` (SystemSituation, verplicht) en `emergesFrom` (component-momenten, verplicht)
  - `ResultantSystemMoment`: mathematisch afleidbaar uit de sum van componenteigenschappen; heeft **geen** `emergesIn` (situatie-onafhankelijk)

**Vier integratiebuggen (SYSONT §5):**
- **B1:** `capax:DispositionRelation rdfs:subClassOf sysont:BondingRelation` — dispositierelatie is bondingrelatie op dispositieniveau
- **B2:** `nexus:CollaborationCondition rdfs:subClassOf sysont:SystemSituation` — samenwerkingsconditie is de SystemSituation van het ecosysteem
- **B3:** `nexus:CollaborativeCapability rdfs:subClassOf sysont:EmergentSystemMoment` — collaboratieve capability is altijd emergent
- **B4:** `sysont:hasEmergentManifestationCondition` specialiseert `capax:hasManifestationCondition` voor emergente OrganizationalCapabilities naar SystemSituation

**SHACL:** SYS-6 t/m SYS-9, SYS-14, SYS-15.

**Bron:** Bunge (1977) §4 (resultant vs. emergent properties); Bunge (1979) §3 (CESM, historical dependence); Calhau et al. (2023) §4 Fig. 4 (SystemMoment, SystemSituation, emergesIn/emergesFrom).

---

### DD-090 · EmergencePattern als herbruikbaar systeemontwerp-artefact

**Besluit:** `sysont:EmergencePattern` (`gufo:Kind`, type-niveau) formaliseert herbruikbare configuratiepatronen die specificeren welke FunctionalRoles, MomentTypes, BondingRelations en NonBondingRelations samen een bepaald type EmergentSystemMoment mogelijk maken.

**Rationale:** Calhau et al. (2023) §5 introduceren het patroon-concept als de praktische vertaalstap van systeemtheorie naar organisatieontwerp. In VALOR is dit direct bruikbaar: een ontwerpalternatief voor een publiek service ecosysteem kan worden getoetst aan een EmergencePattern voor het gewenste type CollaborativeCapability. Als het ecosysteem-ontwerp niet aan het patroon voldoet, volgt een `EcosystemCapabilityGap` met een `GovernanceDevelopmentNeed` die specifiek de ontbrekende FunctionalRole of BondingRelation adresseert.

**Verbinding met Delibera:** Een EmergencePattern is een Tessera-niveau object: het is een to-be claim over de vereiste configuratie. Als de `CollaborationCondition.satisfiesPattern` een specifiek patroon, is dat de formele grond voor de claim dat de CollaborativeCapability aanwezig zal zijn na implementatie.

**SHACL:** SYS-10 (EmergencePattern ≥ 2 FunctionalRoles), SYS-11 (EmergencePattern ≥ 1 patternYieldsSystemMoment), SYS-18 (satisfiesPattern volledigheidscheck).

**Bron:** Calhau et al. (2023) §5 (capability emergence patterns); Calhau et al. (2023) §6 (Spotify squad als instantie van EmergencePattern).

---

### DD-091 · CollectiveIntentionalCommunity: twee modi van collectieve intentionaliteit

**Aanleiding:** Reflectie op de structurele verwantschap tussen de groep agents die een Issue erkent (geconstitueerd door gedeeld `ufoc:Concern`) en de `nexus:EcosystemAgent` die handelt om het Issue aan te pakken (geconstitueerd door `nexus:CollaborationCommitment`). Beide zijn instantiaties van hetzelfde diepere patroon — collectieve intentionaliteit geconstitueerd door een gedeelde betrekking tot een externe situatie — maar met een fundamenteel verschillende constitutieve modus.

**Besluit:** Introduceer een abstracte `«category»` `valor:CollectiveIntentionalCommunity` als gemeenschappelijke abstractie, met twee specialisaties:

**(a) `valor:IssueCommunity`** (`«subkind»`, cognitieve modus)
- Constitutief moment: gedeeld `ufoc:Concern` (een `gufo:IntrinsicMode` van elke deelnemende agent)
- Bestaansmodus: passief — de gemeenschap hoeft niets te doen; ze bestaat zodra de wederzijds erkende gedeelde zorg aanwezig is
- Functie: constitueert het `valor:Issue` als `ufoc:SocialObject` (via `valor:hasConcernAbout`)
- Typisch breder dan het EcosystemAgent: burgers, uitvoerders, maatschappelijke organisaties, beleidsmakers
- Normatieve rol: legitimeringsbron van het ecosysteem; het ecosysteem handelt NAMENS de IssueCommunity

**(b) `nexus:EcosystemAgent`** (`«subkind»`, conatieve modus)
- Constitutief moment: `nexus:CollaborationCommitment` (een `gufo:Relator` die normatieve verwachtingen schept)
- Bestaansmodus: actief — de gemeenschap bestaat om iets te produceren (`CollaborativeCapability`)
- Functie: adresseert het Issue (via `nexus:addressesIssue`) en produceert de CollaborativeCapability die het Issue aanpakt
- Typisch smaller dan de IssueCommunity: uitvoerende organisaties die handelen
- Legitimeringsvereiste: moet het Issue adresseren dat door een IssueCommunity wordt erkend

**Ontologisch onderscheid constitutieve modi:**

| Kenmerk | IssueCommunity | EcosystemAgent |
|---|---|---|
| Constitutief moment | `ufoc:Concern` (IntrinsicMode) | `CollaborationCommitment` (Relator) |
| Ontologische categorie van constitutieve akte | Epistemic / cognitief | Normatief / conative |
| Bestaansmodus | Passief — erkent | Actief — handelt |
| Handelingsdoel | Geen (erkent situatie) | CollaborativeCapability produceren |
| Typische omvang | Breed (samenleving) | Smal (uitvoerende coalitie) |

**Nieuwe property:** `nexus:addressesIssue` (domain: `nexus:EcosystemAgent`, range: `valor:Issue`)
- Legitimeringspijl: formaliseert dat het CollaborationCommitment genormeerd is door het gedeelde Concern van de IssueCommunity
- Geen constitutieve relatie (EcosystemAgent wordt geconstitueerd door CollaborationCommitment, niet door het Issue)
- Detecteerbaar via SPARQL: een EcosystemAgent zonder `addressesIssue` mist democratische legitimering
- De overlap tussen IssueCommunity-leden en EcosystemAgent-leden is een proxy voor de inclusiviteitsgraad van het ecosysteem

**Theoretische grondslag:** Searle (1995) — collectieve intentionaliteit als constitutief mechanisme voor sociale realiteit. In UFO-termen: de abstracte category `CollectiveIntentionalCommunity` is een `ufoc:CollectiveSocialAgent` wiens constitutief moment een gedeelde intentionele toestand is met betrekking tot een externe `gufo:Situation`.

**Cascade:**
- `nexus:EcosystemAgent`: `rdfs:subClassOf` gewijzigd van `ufoc:CollectiveSocialAgent` naar `valor:CollectiveIntentionalCommunity`
  (informatieverlies: geen — `CollectiveIntentionalCommunity rdfs:subClassOf ufoc:CollectiveSocialAgent`)
- NEXUS module bijgewerkt naar v0.4
- Nieuwe module `00n-valor-core.ttl` v0.1: `CollectiveIntentionalCommunity`, `IssueCommunity`, `Issue`, `hasConcernAbout`, `concernedWithSituation`, `addressesIssue`, `hasRespondingEcosystem`, `isAddressedInDesignSpace`, legitimiteitsquery-patroon

**Bron:** Searle, J.R. (1995), *The Construction of Social Reality*, Free Press; Guizzardi et al. (2013) UFO-C — Concern, SocialObject; Osborne et al. (2022) Public Service Ecosystem — legitimeringsbasis van service-ecosystemen; VALOR-O reflectie 2026-03-12.

---

---

### DD-092 · Drie causale niveaus en de ManifestationCondition-architectuur in CAUSA v2

**Aanleiding:** Reflectie op de spanning tussen (a) `gufo:contributedToTrigger` als token-level causaliteitsrelatie tussen event-individuen in gUFO, (b) `causa:CausalClaim` als type-level patroonuitspraak in CAUSA, en (c) de observatie — via Calhau et al. (2023) — dat een capability zich alleen manifesteert wanneer het systeem in de juiste `sysont:SystemSituation` verkeert. De parallelle structuur: ook een type-level CausalClaim is conditioneel op een configuratie van capabilities en situaties.

**Besluit:** CAUSA v2 formaliseert een drie-laags causale architectuur:

**(1) Token-level (gUFO/UFO-B):** `gufo:contributedToTrigger` tussen concrete event-individuen. Werkelijkheidslaag; niet modelleerbaar vooraf. Niet gewijzigd.

**(2) Type-level (CAUSA):** `causa:CausalClaim` als `ufoc:Belief`-specialisatie over een patroon tussen EventTypes. Beleidstheorielaag; gegrond in onderzoek, betwistbaar, met PAMS-onzekerheidsniveau. Ongewijzigd van v1.

**(3) Manifesteringslaag (CAUSA v2):** De condities waaronder de type-level claim zich in concrete token-level gevallen realiseert. Nieuw in v2: formeel vastgelegd via `causa:hasManifestationCondition` → `sysont:SystemSituation`.

**Kern van het inzicht:** Een CausalClaim op type-niveau — "begeleiding van jongeren na overtreding vermindert recidive" — is een conditionele bewering. Of zij zich manifesteert in het concrete geval (begeleiding van Jan na het vernielen van een bankje vermindert recidivekans van Jan) is afhankelijk van het aanwezig zijn van een specifieke configuratie van capabilities, dispositionele relaties en situatiecondities. VALOR moet in staat zijn om ontwerpalternatieven inzichtelijk te maken zodat duidelijk is welk alternatief de beste condities schept voor maximale manifestatie van de CausalClaims die de beleidstheorie onderbouwen.

**Nieuwe concepten:**

`causa:hasManifestationCondition` (ObjectProperty)
- Domain: `causa:CausalClaim`; Range: `sysont:SystemSituation`
- Semantiek: de SystemSituation die aanwezig moet zijn opdat de CausalClaim zich in concrete gevallen realiseert. Optioneel — een CausalClaim zonder ManifestationCondition asserteert universele geldigheid (zelden empirisch verdedigbaar).
- Relatie tot PAMS-onzekerheid: een claim met `uncertaintyLevel = DeepUncertainty` is typisch één waarvan de ManifestationCondition slecht begrepen is — niet alleen het effect is onzeker, maar de condities zelf ook.
- Relatie tot CAPAX: de ManifestationCondition bevat typisch capability-eisen; de CAUSA-engine evalueert in hoeverre een alternatief de SystemSituation realiseert.

`causa:Intervention` (EventType, eerste-klas concept in SolutionModel)
- Een type interventie-event dat een `causa:CausalVariable` beïnvloedt, in de context van een specifiek ontwerpalternatief.
- Nieuw: `causa:realisedBy` (domain: `causa:Intervention`, range: `acta:TransactionType`) — zie DD-093.

`capax:ConditionCoverage` (nieuwe situatieklasse)
- Beoordeling van de mate waarin een ontwerpalternatief de `causa:ManifestationCondition` van een specifieke `causa:CausalClaim` realiseert.
- Drie waarden: `Full`, `Partial`, `None`.
- Berekend door de CAUSA-engine op basis van capability-data in de graph.

`causa:ClaimCoverageAssessment` (nieuwe situatieklasse, analoog aan `capax:FeasibilityAssessment`)
- Aggregeert alle `capax:ConditionCoverage`-beoordelingen voor de CausalClaims in het SolutionModel van een alternatief.
- Drie waarden: `FullyCovered`, `PartiallyCovered`, `NotCovered`.
- **Tweede gate-Tessera** bij faseovergangen: `epistemicStatus = Accepted` is vereist naast de FeasibilityAssessment.

**Diagnostische vierveldsmatrix:**

| FeasibilityAssessment | ClaimCoverageAssessment | Diagnose |
|---|---|---|
| Feasible | FullyCovered | Uitvoerbaar én theoretisch adequaat — kan door |
| Feasible | NotCovered | Coherentiefout: capabilities aanwezig maar beleidstheorie kan niet manifesteren |
| NotFeasible | FullyCovered | Theoretisch adequaat maar capabilities ontbreken — ontwikkelingsopgave |
| NotFeasible | NotCovered | Fundamentele herontwerpopgave |

**Diagnostisch onderscheid slecht ontwerp vs. slechte beleidstheorie:**
`FullyCovered` + interventie werkt toch niet in de praktijk → CausalClaim zelf aanvechtbaar; Tessera terug naar `Proposed`.
`NotCovered` + interventie werkt niet → beleidstheorie niet gefalsifieerd; uitvoering inadequaat.
VALOR houdt deze twee beoordelingen formeel gescheiden.

**Cascade:**
- `00h-causa.ttl` → v0.2: nieuwe properties `causa:hasManifestationCondition`, `causa:realisedBy`; nieuwe klassen `capax:ConditionCoverage`, `causa:ClaimCoverageAssessment`; `causa:Intervention` eerste-klas; `causa:SolutionModel` krijgt `causa:boundToAlternative`
- SHACL: CA-01 (`ClaimCoverageAssessment` MUST reference ≥1 `ConditionCoverage`), CA-02 (`Intervention` SHOULD have `realisedBy`), CA-03 (faseovergang MUST have `ClaimCoverageAssessment` per alternatief)
- Nieuwe backend-component: CAUSA-engine (RealisatiebasisCheck, ConditionCoverage-berekening, ClaimCoverageAssessment-aggregatie, gate-check)
- Delibera: twee gate-Tesserae verplicht bij faseovergang (FeasibilityAssessment + ClaimCoverageAssessment)

**Bron:** Pearl, J. (2009), *Causality* §7 — structural causal models en interventie-condities; Calhau et al. (2023) §4 — ManifestationCondition als activeringsconditie voor capabilities; Enserink et al. (2022) PAMS; VALOR-O reflectie 2026-03-13.

---

### DD-093 · causa:realisedBy als formele keten van beleidstheorie naar ontwerpelement

**Aanleiding:** DD-092 introduceert `causa:realisedBy` als cross-module property van `causa:Intervention` naar `acta:TransactionType`. De ontologische status en implicaties verdienen een eigen besluit omdat ze de structurele koppeling tussen CAUSA en ACTA vastleggen.

**Besluit:**

**Semantiek:** Een `causa:Intervention` (type-level beschrijving van welk handelen een CausalVariable beïnvloedt) wordt *gerealiseerd* door een `acta:TransactionType` (de transactionele ontwerprealisatie in een specifiek alternatief). De relatie drukt uit: "dit TransactionType is de ontwerpvorm van deze Intervention."

**Richting van afhankelijkheid:** CAUSA → ACTA. De beleidstheorie stelt de eis; het transactieontwerp realiseert haar. Een TransactionType zonder `acta:realisesIntervention` is legitiem (uitvoeringstransacties zonder directe beleidstheorie-grondslag). Een Intervention zonder `realisedBy` in een alternatief heeft geen ontwerprealisatie — detecteerbaar als ontbrekende schakel.

**Behoud van realisatiebasis:** Wanneer een TransactionType wordt verwijderd uit een alternatief terwijl een `causa:realisedBy`-relatie ernaar bestaat, verliest de Intervention haar realisatiebasis. De CAUSA-engine detecteert dit en stelt een waarschuwings-Tessera voor. Dit is het VALOR-mechanisme waarmee incoherentie tussen beleidstheorie en ontwerp vroeg detecteerbaar wordt.

**Meervoudige realisatie:** Een Intervention MAY door meerdere TransactionTypes worden gerealiseerd (gedistribueerde realisatie). Een TransactionType MAY meerdere Interventions realiseren (multifunctionele transactie). Bij verlies van een TransactionType dat meerdere Interventions realiseert weegt de impact navenant zwaarder in de ClaimCoverageAssessment.

**Ontologische status:** Geen constitutieve relatie in gUFO-zin. Het is functioneel equivalent aan een `gufo:MaterialRelation` op type-niveau: de realisatie medieert Intervention en TransactionType zonder hen te fuseren. Ze blijven categorisch onderscheiden — de Intervention is een beleidstheorie-object, het TransactionType een organisatie-ontwerp-object.

**Cascade:**
- `00h-causa.ttl` v0.2: `causa:realisedBy` toegevoegd
- `00g-acta.ttl`: inverse `acta:realisesIntervention` (optioneel, voor query-gemak)
- SPARQL-query realisatiebasis-gap: per alternatief — welke Interventions in het SolutionModel hebben geen `realisedBy`?
- Acta-agent vraagstrategie uitgebreid: "Dit TransactionType heeft geen gekoppelde Intervention in het SolutionModel — is dit intentioneel of ontbreekt de koppeling met de beleidstheorie?"

**Bron:** Dietz & Mulder (2020) *Enterprise Ontology* — onderscheid B-organisatie (beleidstheorie) en I-organisatie; VALOR-O reflectie 2026-03-13.



## Moduleoverzicht (bijgewerkt v0.10)

| Module | Bestand | Beschrijving | Status |
|--------|---------|--------------|--------|
| 00a | `00a-gufo-core.ttl` | gUFO Core subset | ✓ Compleet |
| 00b | `00b-ufo-b.ttl` | UFO-B Events & Perdurants | ✓ Compleet |
| 00c | `00c-ufo-c.ttl` | UFO-C Social Entities (v0.2 — DD-083) | ✓ Compleet |
| 00d | `00d-ufo-l.ttl` | UFO-L Legal Relations + Weigand Policy | ✓ Compleet |
| 00e | `00e-coodm.ttl` | COoDM Decision Making | ✓ Compleet |
| 00f | `00f-cover.ttl` | COVER Value Ontology | ✓ Compleet |
| 00g | `00g-acta.ttl` | ACTA DEMO Transactions + `acta:realisesIntervention` (DD-093) | ✓ Compleet |
| 00h | `00h-causa.ttl` | CAUSA v0.1 Causal Loop Diagrams | ✓ Compleet — **v0.2 pending (DD-092, DD-093)** |
| 00i | `00i-socia.ttl` | SOCIA Actor Analysis (i*) | ✓ Compleet |
| 00j | `00j-capax.ttl` | CAPAX Capability & Feasibility v0.2 (DD-084) + `ConditionCoverage` (DD-092) | ✓ Compleet — **ConditionCoverage pending** |
| 00k | `00k-axia-vsd.ttl` | AXIA-VSD VSD Values Hierarchy | ✓ Compleet |
| 00l | `00l-nexus.ttl` | NEXUS Ecosystem Capability v0.4 (DD-085, DD-091) | ✓ Compleet |
| 00m | `00m-sysont.ttl` | SYSONT System Core Ontology v0.1 (DD-086–090) | ✓ Compleet |
| 00n | `00n-valor-core.ttl` | VALOR-CORE Toepassingsontologie kernlaag v0.1 (DD-091) | ✓ Compleet |

Elk module heeft een bijbehorend SHACL-validatiebestand (`*.shacl.ttl`).

**Pending — fase -1d integratie:**
- **CAUSA v0.2** (DD-092, DD-093): `causa:hasManifestationCondition`, `causa:Intervention` eerste-klas, `causa:realisedBy`, `capax:ConditionCoverage`, `causa:ClaimCoverageAssessment`; SHACL CA-01 t/m CA-03
- **ACTA inverse property** (DD-093): `acta:realisesIntervention` toevoegen als query-hulp
- **CAPAX v0.2 SHACL** (DD-084): `CapabilityDevelopmentNeed.developmentApproach` vocabulaire uitbreiden met `'StructuralRedesign'` en `'GovernanceRedesign'`
- **SHACL 00n-valor-core** (DD-091): (a) `EcosystemAgent` MUST ≥1 `addressesIssue`, (b) `IssueCommunity` MUST ≥1 `hasConcernAbout`, (c) `Issue` MUST `concernedWithSituation`
- **Globale SPARQL-queries**: emergentiepatroon-detectie, gap-keten-traversal, Tessera-audit trail, legitimiteitsaudit (DD-091), realisatiebasis-gap (DD-093), ConditionCoverage-dekking (DD-092)
- **SYSONT validatie-voorbeeld**: `00m-sysont` instantiëren met het Spotify-patroon uit Calhau et al. (2023) §6
