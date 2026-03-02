# VALOR-O Ontologie — Ontwerpbeslissingen

**Versie:** 0.3  
**Datum:** februari 2026  
**Status:** Levend document — wordt bijgewerkt bij elke module

---

## Leeswijzer

Dit document legt vast **waarom** VALOR-O is zoals het is: welke keuzes zijn gemaakt, welke alternatieven zijn overwogen, welke bronnen de beslissing onderbouwen, en waar VALOR-O bewust afwijkt van de bronontologieën. Elk besluit heeft een unieke ID (`DD-NNN`). TTL-comments verwijzen naar deze IDs.

### Bronafkortingen

| Afkorting | Volledige referentie |
|-----------|---------------------|
| **gUFO-spec** | Almeida et al. (2019), *gUFO: A Lightweight Implementation of the Unified Foundational Ontology*, https://nemo-ufes.github.io/gufo/ |
| **UFO-B-2013** | Guizzardi et al. (2013), *Towards Ontological Foundations for the Conceptual Modeling of Events*, ER 2013, LNCS 8217, pp. 327–341 |
| **UFO-B-2019** | Almeida, Falbo & Guizzardi (2019), *Events as Entities in Ontology-Driven Conceptual Modeling*, ER 2019, LNCS 11788, pp. 469–483 |
| **UFO-C-2013** | Guizzardi et al. (2013), *UFO-C: A Foundational Ontology for Social Entities* |
| **UFO-L-2015** | Guizzardi et al. (2015), *UFO-L: An Ontological Account of Legal Relationships* |
| **OntoUML-2018** | Guizzardi et al. (2018), *Endurant Types in Ontology-Driven Conceptual Modeling: Towards OntoUML 2.0*, ER 2018 |
| **COoDM** | Guizzardi, Carneiro & Porello (2020), *A Core Ontology on Decision Making*, ONTOBRAS 2020 |
| **COVER** | Guizzardi et al. (2022), *The Common Ontology of Value and Risk*, Applied Ontology |
| **Weigand-2024** | Weigand, Johannesson & Andersson (2024), *Ontological Analysis of Policy-Based Decision Making*, VMBO 2024 |
| **Almeida-DEMO** | Almeida et al. (2013), *Revisiting the DEMO Transaction Pattern with UFO*, EEWC 2013 |
| **Wetsanalyse** | Ausems, Bulles, Lokin (2021), *Wetsanalyse* |
| **PAMS** | Enserink et al. (2022), *Policy Analysis of Multi-Actor Systems*, TU Delft |
| **Pribbenow-1999** | Pribbenow, S. (1999), *Meronymic Relationships: The Role of Conceptual Parts*, in Gerstl & Pribbenow |

---

## Module 00a — gUFO Core

### DD-001 · Curated subset, geen volledige `owl:imports`

**Besluit:** VALOR-O declareert de gUFO-concepten die het gebruikt als lokale klasse- en eigenschafts-declaraties in `00a-gufo-core.ttl`, in plaats van een enkele `owl:imports <https://nemo-ufes.github.io/gufo/gufo.ttl>`.

**Rationale:** Het gUFO-bestand is ~2500 triple's groot en bevat veel concepten die VALOR-O niet gebruikt (volledige taxonomie van Types, alle kwaliteitsstructuren, etc.). Een lokale curated subset maakt de ontologie begrijpelijker voor nieuwe deelnemers en minder afhankelijk van externe bereikbaarheid. Bovendien maakt het inline documentatie per concept mogelijk.

**Alternatieven overwogen:**
- Volledige `owl:imports`: correct maar te groot, externe afhankelijkheid
- Cherry-picking met `owl:imports` + lokale override: inconsistentierisico

**Afwijking ten opzichte van bronontologie:** Strikt gezien zou `owl:imports` de semantisch correcte keuze zijn. De lokale declaraties zijn geen re-publicatie (ze bevatten geen axioma's die de gUFO-specificatie tegenspreken) maar een subset-documentatie.

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
| `mode` | *(geen punning — zie DD-029)* |
| `quality` | *(geen punning — zie DD-029)* |
| `event` | `gufo:EventType` |
| `situation` | `gufo:SituationType` |
| `historicalRole` | `gufo:Role` (geen apart gUFO-type; zie DD-011) |

**Afwijking:** gUFO zelf gebruikt punning intern maar documenteert het niet als vereiste voor domeinontologieën. VALOR-O maakt het tot een harde conventie, gehandhaafd door SHACL-constraint G7.

**SHACL-implementatie:** G7 (`OntoumlPunningShape`) gebruikt één SPARQL-constraint met een `VALUES`-blok. `"mode"` en `"quality"` zijn niet opgenomen omdat gUFO 1.0 geen corresponderende Types in de Taxonomy of Types definieert (zie DD-029).

**Bron:** gUFO-spec §2.2; OntoUML-2018 §3; UFO-B-2019 §2. Verificatie: `https://nemo-ufes.github.io/gufo/gufo.ttl`.

---

### DD-003 · gUFO-primitieven zijn uitgesloten van punning-verplichting

**Besluit:** De klassen in `00a-gufo-core.ttl` zelf (`gufo:Kind`, `gufo:Event`, `gufo:Relator`, etc.) krijgen **geen** `rdf:type gufo:Kind`-assertie.

**Rationale:** Deze klassen *zijn* de type-hiërarchie — ze zijn de gUFO-primitieven, niet instanties ervan. `gufo:Kind` is zelf een `owl:Class` en een instantie van `gufo:Type` (in de volledige gUFO-spec), maar in VALOR-O's curated subset declareren we deze second-order relaties niet. De SHACL-constraint G7 sluit de canonieke gUFO-namespace (`http://purl.org/nemo/gufo#`) expliciet uit via `FILTER (!STRSTARTS(...))`.

**Bron:** gUFO-spec §2 (Taxonomy of Types). Verificatie: `https://nemo-ufes.github.io/gufo/gufo.ttl`.

---

### DD-004 · `gufo:Participation` — terminologisch conflict met UFO-B

**Besluit:** `gufo:Participation` in `00a-gufo-core.ttl` behoudt zijn gUFO-betekenis: een subklasse van `gufo:Event` die de deelname van een endurant aan een event representeert als een event-entiteit. Dit is **niet** hetzelfde als de *afgeleide* UFO-B Participation (§3.2, P4).

**Het conflict:**

| Begrip | Betekenis | Status |
|--------|-----------|--------|
| `gufo:Participation` | Subklasse van Event: deelname als event-entiteit | Concrete klasse |
| UFO-B Participation (P4) | Het maximale deel van een ComplexEvent exclusief afhankelijk van één Object | **Afgeleide klasse** (derivatie) |

UFO-B-2013 §3.2 axioma P4: `∀e:Event Participation(e) ↔ ∃!o:Object excDepends(e,o)`. Dit is een *equivalent*definitie, niet een subklasse-relatie. De UFO-B Participation is een projectie op event-mereologie.

**Gevolg voor VALOR-O:** In `00b-ufo-b.ttl` declareren we `ufob:excDependsOn` als de functionele dependentie-property die P4 fundeert. We vermijden de naam `Participation` als aparte UFO-B-klasse. Het concept wordt gesimuleerd via SPARQL-queries in de Causa-library.

**Bewuste afwijking ten opzichte van UFO-B-2013:** UFO-B-2013 behandelt Participation als afgeleide klasse (P4/P5). gUFO maakt er een concrete klasse van. VALOR-O volgt gUFO voor pragmatische redenen (GraphDB-compatibiliteit, SPARQL-expressiviteit) maar documenteert het conflict expliciet.

**Bron:** UFO-B-2013 §3.2 (P1–P5); gUFO-spec §3.3.

---

### DD-005 · Allen-relaties als SPARQL-queries, niet als OWL-properties

**Besluit:** De zeven Allen-tijdrelaties (`before`, `meets`, `overlaps`, `starts`, `during`, `finishes`, `equals`) worden **niet** als OWL-objectproperties gedeclareerd. Ze worden geïmplementeerd als SPARQL-queries in de Causa-querybibliotheek.

**Rationale:**
1. Alle Allen-relaties zijn volledig afleidbaar uit `gufo:hasBeginPoint` en `gufo:hasEndPoint` (UFO-B-2013 §3.3, axioma's T7–T13). UFO-B-2019 §3.1 bevestigt dit en biedt ze als OCL-operaties aan.
2. `owl:overlaps` als naam zou conflicteren met de mereologische overlaps-relatie (M7 in UFO-B-2013).
3. Als OWL-properties zouden ze bij elke update afgeleid moeten worden — beter als SPARQL `FILTER`.

**SPARQL-definities (Causa-querybibliotheek):**
```sparql
# before(e1,e2): end(e1) < begin(e2)
FILTER (?end1 < ?begin2)

# meets(e1,e2): end(e1) = begin(e2)
FILTER (?end1 = ?begin2)

# overlaps(e1,e2): begin(e1) < begin(e2) ∧ end(e1) > begin(e2) ∧ end(e1) < end(e2)
FILTER (?begin1 < ?begin2 && ?end1 > ?begin2 && ?end1 < ?end2)

# starts(e1,e2): begin(e1) = begin(e2) ∧ end(e1) < end(e2)
FILTER (?begin1 = ?begin2 && ?end1 < ?end2)

# during(e1,e2): begin(e1) > begin(e2) ∧ end(e1) < end(e2)
FILTER (?begin1 > ?begin2 && ?end1 < ?end2)

# finishes(e1,e2): end(e1) = end(e2) ∧ begin(e1) > begin(e2)
FILTER (?end1 = ?end2 && ?begin1 > ?begin2)

# equals(e1,e2): begin(e1) = begin(e2) ∧ end(e1) = end(e2)
FILTER (?begin1 = ?begin2 && ?end1 = ?end2)
```

**Afwijking ten opzichte van UFO-B-2013:** UFO-B-2013 lijst de Allen-relaties als named relations (T7–T13). VALOR-O behandelt ze als afgeleide queries, in lijn met het advies van UFO-B-2019.

**Bron:** UFO-B-2013 §3.3 (T7–T13); UFO-B-2019 §3.1; Allen (1983).

---

## Module 00b — UFO-B Events

### DD-006 · UFO-B als aparte module, niet geïntegreerd in gUFO Core

**Besluit:** UFO-B krijgt een eigen module `00b-ufo-b.ttl` in plaats van de event-concepten toe te voegen aan `00a-gufo-core.ttl`.

**Rationale:** gUFO bevat al een basisrepresentatie van events (`gufo:Event`, `gufo:broughtAbout`, etc.). De UFO-B-uitbreidingen zijn substantieel: AtomicEvent, ComplexEvent, Disposition, directlyCauses, activates, manifestedBy, excDependsOn — met eigen SHACL-constraints die modulair beheerd moeten worden. Bovendien is UFO-B de primaire bron voor de Causa-perspective-ontologie; die koppeling wordt expliciet gemaakt via de module-import-structuur.

**Alternatief overwogen:** Alles in één bestand — verwerpen vanwege onderhoudbaarheid en omdat de Causa-perspective-ontologie dan op een te groot monolithisch fundament zou staan.

**Bron:** UFO-B-2013 §1; VALOR Product Plan §2.3 (laag 2).

---

### DD-007 · AtomicEvent/ComplexEvent als disjuncte partitie van Event

**Besluit:** `ufob:AtomicEvent` en `ufob:ComplexEvent` worden gedeclareerd als `owl:disjointWith` en samen als complete partitie van `gufo:Event` via `owl:disjointUnionOf`.

**Bronaxioma's:** UFO-B-2013 §3.1:
- `M1: ∀e:Event AtomicEvent(e) ↔ ¬∃e':Event has-part(e,e')` — AtomicEvent heeft geen event-delen
- `M2: ∀e:Event ComplexEvent(e) ↔ ¬AtomicEvent(e)` — ComplexEvent is het complement
- `M6: ∀e:ComplexEvent ∃e1,e2 [properPart(e1,e) ∧ properPart(e2,e) ∧ ¬overlap(e1,e2)]` — Weak Supplementation Principle: ten minste 2 disjuncte delen

**OWL-representatie (keuze):** `owl:disjointUnionOf` voor de complete partitie. Dit is de maximaal expressieve OWL 2-representatie van M1/M2.

**Afwijking:** De volledige bi-conditionele M1/M2 is in OWL niet volledig uitdrukbaar zonder closed-world assumption. SHACL-constraint B1 compenseert dit (WSP: min. 2 disjuncte delen voor ComplexEvent). SHACL-constraint B0 controleert dat elke Event-instantie tot één van beide subklassen behoort.

**Bron:** UFO-B-2013 §3.1 (M1–M2, M6).

---

### DD-008 · Disposition als subklasse van IntrinsicMode

**Besluit:** `ufob:Disposition` is een subklasse van `gufo:IntrinsicMode` (niet van `gufo:Quality`).

**Rationale:** UFO-B-2013 §3.5: "UFO's notion of particularized tropes includes both qualities [...] and dispositions." Disposities zijn tropen die niet noodzakelijk een waarde in een kwaliteitsstructuur hebben (ze zijn niet meetbaar als temperatuur of massa), maar ze inheren wel in objecten en zijn entiteitsspecifiek. `gufo:IntrinsicMode` is de juiste superklasse: het is de gUFO-categorie voor niet-kwaliteitsmatige intrinsieke aspecten.

**Alternatief overwogen:** `gufo:Quality` — verworpen, omdat kwaliteiten dimensionele waarden hebben (QualityValue). Een dispositie als 'financiële kwetsbaarheid' is geen dimensionele kwaliteit.

**Afwijking ten opzichte van gUFO-spec:** gUFO noemt `gufo:IntrinsicMode` als thuisplek voor disposities impliciet, maar declareert `Disposition` niet zelf. VALOR-O introduceert `ufob:Disposition` als VALOR-O-toevoeging bovenop gUFO.

**VALOR-toepassing (Causa):** Een systeem heeft een dispositie om schulden te laten opstapelen ('financiële kwetsbaarheid'). Die dispositie is een IntrinsicMode van het systeem-object. Een Situation van verminderd inkomen *activeert* de dispositie, waarna een AtomicEvent van betalingsachterstand zich *manifesteert*.

**Bron:** UFO-B-2013 §3.5 (D1–D4); gUFO-spec §3.2.

---

### DD-009 · `gufo:contributedToTrigger` vs. strict UFO-B triggers

**Besluit:** VALOR-O gebruikt `gufo:contributedToTrigger` (al aanwezig in gUFO Core) als de OWL-property voor het trigger-mechanisme. De UFO-B-functionaliteit (precies één triggerende Situation per AtomicEvent) wordt gehandhaafd via SHACL-constraint B5, niet als OWL-eigenschap.

**Achtergrond:** UFO-B-2013 axioma S3: `∀e:Event ∃!s:Situation triggers(s,e)` — er is precies één triggerende situatie per event. gUFO's `gufo:contributedToTrigger` is meervoudig (geen functionaliteitsbeperking). Dit is een bewuste vereenvoudiging in gUFO.

**SHACL-compensatie:** B5 valideert `minCount 1, maxCount 1` op `gufo:wasTriggeredBy` voor AtomicEvent.

**Afwijking:** gUFO verzwakt de UFO-B-axiomatisering bewust voor practical expressivity. VALOR-O compenseert via SHACL.

**Bron:** UFO-B-2013 §3.4 (S3–S4); gUFO-spec §3.3.

---

### DD-010 · `directlyCauses` en `causes` als niet-transitieve OWL-properties

**Besluit:** `ufob:directlyCauses` en `ufob:causes` worden gedeclareerd als `owl:ObjectProperty` met expliciete domein/range. `ufob:causes` wordt **niet** als `owl:TransitiveProperty` gedeclareerd.

**Rationale:** UFO-B-2013 S7 definieert `causes` als transitieve sluiting van `directlyCauses`. In OWL DL is `owl:TransitiveProperty` in combinatie met `owl:AsymmetricProperty` en andere restricties problematisch voor beslisbaarheid (zie OWL 2 profiles §11). VALOR-O offert volledige OWL-uitdrukkbaarheid op voor GraphDB-compatibiliteit.

**Implementatie van transitiviteit:** Als SPARQL property path `ufob:directlyCauses+` in de Causa-querybibliotheek. Documentatie als `rdfs:comment` in de TTL.

**Asymmetrie en irreflexiviteit:** Gedocumenteerd als SHACL-constraint B6 (geen OWL-property-axioma om dezelfde reden).

**Afwijking:** UFO-B-2013 axiomatiseert `causes` als transitief en asymmetrisch in first-order logic. VALOR-O implementeert dit als SPARQL + SHACL.

**Bron:** UFO-B-2013 §3.4 (S6–S7).

---

### DD-011 · `historicalRole` als nieuw stereotype (UFO-B-2019)

**Besluit:** `"historicalRole"` wordt als waarde van `gufo:ontoumlStereotype` gedocumenteerd in `00b-ufo-b.ttl`. Klassen met dit stereotype zijn subklassen van `gufo:Role` (er is geen apart gUFO-type voor historicalRole).

**Rationale:** UFO-B-2019 §3.2 introduceert `«historicalRole»` als een nieuw OntoUML-stereotype: een Role die een endurant speelt *in virtue of* deelname aan een past event. Dit verschilt fundamenteel van een gewone `«role»` (die wordt gespeeld in virtue of een bestaand relator):

| Stereotype | Rol-grondslag | Afhankelijkheid |
|------------|---------------|-----------------|
| `«role»` | Bestaand Relator (huidig) | Relator moet bestaan |
| `«historicalRole»` | Voltooid Event (verleden) | Event is voorbij; rol blijft |

**VALOR-toepassing:** Een `valor:HistoricalContributor` (in een latere module) — een Participant die heeft bijgedragen aan een afgesloten DesignPhase draagt die historische rol voort ook nadat de fase is gesloten. Zonder historicalRole zou de rol bij afsluiting verdwijnen.

**SHACL-constraint B8** valideert dat klassen met dit stereotype subklassen zijn van `gufo:Role`.

**Bron:** UFO-B-2019 §3.2 (Figures 5–7).

---

### DD-012 · `participational` en `temporal` als relatie-stereotypen

**Besluit:** `"participational"` en `"temporal"` worden als waarden van `gufo:ontoumlStereotype` gedocumenteerd voor objectproperties in `00b-ufo-b.ttl` als conventies voor event-decomposities (specialisaties van `gufo:isProperPartOf`).

**Rationale:** UFO-B-2019 §3.3 onderscheidt twee typen event-decompositie op basis van Pribbenow (1999):

| Type | Construttie | Deelbepaling |
|------|-------------|--------------|
| `«participational»` | Intern (by dependence) | Maximale deelgebeurtenissen exclusief afhankelijk van één participant |
| `«temporal»` | Extern (by reference) | Opeenvolgende tijdssegmenten op basis van een externe tijdlijn |

**VALOR-toepassing (Causa):** Een schuldhulpverleningstraject (ComplexEvent) heeft:
- *participational* delen: het deel van het traject dat exclusief afhangt van de schuldenaar, versus dat van de schuldeiser
- *temporal* delen: de fasen van het traject (intake → analyse → plan → nazorg)

**Implementatie:** Geen nieuwe OWL-properties; conventies via annotaties. Concrete decompositie-relaties worden in perspectief-ontologieën gedeclareerd.

**Bron:** UFO-B-2019 §3.3; Pribbenow-1999.

---

## Module 00c — UFO-C Social Entities

### DD-013 · SocialCommitment als ExtrinsicMode; SocialRelator als overkoepelende Relator *(herzien)*

**Besluit (herzien):** `ufoc:SocialCommitment` is een subklasse van `gufo:ExtrinsicMode` (niet van `gufo:Relator`). De overkoepelende normatieve band tussen twee agents wordt gemodelleerd als `ufoc:SocialRelator` (subklasse van `gufo:Relator`). `ufoc:SocialClaim` is een nieuwe klasse, eveneens `gufo:ExtrinsicMode`, die het spiegelbeeldige recht-moment vertegenwoordigt.

**Correcte structuur conform UFO-C (Guizzardi et al. 2013; Poletaeva et al. 2017):**

```
SocialRelator      «relator»   gufo:Relator
  ├── hasCommittedAgent → Agent
  ├── hasClaimantAgent  → Agent
  ├── hasCommitmentContent → Situation  (gedeelde propositionele inhoud)
  ├── hasCommitmentMoment → SocialCommitment
  └── hasClaimMoment      → SocialClaim

SocialCommitment   «mode»      gufo:ExtrinsicMode
  ├── commitmentInheresIn   → committed Agent  (primaire afhankelijkheid)
  └── commitmentDependsOn   → claimant Agent   (externe afhankelijkheid)

SocialClaim        «mode»      gufo:ExtrinsicMode
  ├── claimInheresIn   → claimant Agent   (primaire afhankelijkheid)
  └── claimDependsOn   → committed Agent  (externe afhankelijkheid)
```

**Waarom de eerdere modellering fout was:** De eerdere versie modelleerde `SocialCommitment` als `gufo:Relator` — daarmee werd het Commitment verward met de overkoepelende sociale band als geheel. In UFO-C is de Relator de *SocialRelator*; Commitment en Claim zijn de twee ExtrinsicModes die samen de relator *constitueren*. De naam `CommitmentMode` en `ClaimMode` (als subklassen van IntrinsicMode) waren een onnodige en onjuiste extra laag.

**ExtrinsicMode vs IntrinsicMode:** Een ExtrinsicMode is een Aspect dat inhereert in één individu (de drager) maar ook extern afhankelijk is van een ander individu. Dit is fundamenteel anders dan IntrinsicMode (alleen afhankelijk van de drager). `SocialCommitment` inhereert in de committed agent *en* is afhankelijk van de claimant — per definitie een ExtrinsicMode. Bron: gUFO 1.0 §2.7.

**Cascade-effecten:**
- `ufoc:Delegatum` is nu `subClassOf ufoc:SocialRelator` (niet `SocialCommitment`)
- `ufol:LegalRelator` is `subClassOf ufoc:SocialRelator` (zie DD-027)
- `ufol:RightMode` is `subClassOf ufoc:SocialClaim` (zie DD-027)
- `ufol:DutyMode` is `subClassOf ufoc:SocialCommitment` (zie DD-027)

**Eerder besluit (vervallen):** SocialCommitment als Relator. Gemotiveerd door "een commitment duurt" — dit klopt, maar geldt voor de SocialRelator als geheel, niet voor het individuele Moment.

**Bron:** UFO-C-2013 §3; Poletaeva et al. (2017) §3.2 + Fig. 3; gUFO 1.0 §2.7.

---

### DD-014 · Norm als mode van InstitutionalAgent

**Besluit:** `ufoc:Norm` is een subklasse van `ufoc:SocialObject`, die op zijn beurt een subklasse is van `gufo:IntrinsicMode`. Een Norm inhereert in een `ufoc:InstitutionalAgent` (de instelling die de norm draagt en handhaaft).

**Rationale:** UFO-C-2013 modelleert sociale objecten (waaronder normen) als intrinsieke modi van collectieve agents. Een norm bestaat niet onafhankelijk van de institutionele context die haar erkent en handhaaft. Dit onderscheidt:
- `ufoc:Norm` (de abstracte sociale entiteit — IntrinsicMode van InstitutionalAgent)
- het normDocument (het fysieke of digitale artefact dat de norm beschrijft)

**Parallel met DD-016:** Hetzelfde onderscheid keert terug bij Weigand's Policy/PolicyDocument-onderscheid.

**Afwijking:** Sommige rechtsontologieën modelleren normen als zelfstandige abstracte objecten. VALOR-O volgt UFO-C/UFO-L: normen zijn ontologisch afhankelijk van de institutie die hen draagt.

**Bron:** UFO-C-2013 §4; UFO-L-2015 §3.

---

### DD-015 · Concern als fundering van het Issue-concept

**Besluit:** `ufoc:Concern` wordt als aparte subklasse van `ufoc:IntentionalMode` gedeclareerd (naast `ufoc:Belief`, `ufoc:Desire`, `ufoc:Goal`).

**Rationale:** Het VALOR-concept `valor:Issue` (een maatschappelijk vraagstuk) is ontologisch gefundeerd als een `gufo:Situation` waarover meerdere agents een `ufoc:Concern` hebben. Concern is conceptueel onderscheiden van Desire en Goal:

| Modus | Inhoud | Uitgewerkt? |
|-------|--------|-------------|
| `Desire` | Agent wil dat p het geval is | Ja (gewenste toestand) |
| `Goal` | Stabiele, bewuste wens met actieplan | Ja (richtinggevend) |
| `Concern` | Agent beschouwt p als zorgwekkend | Niet per se |

Een Issue in VALOR ontstaat in de Verkenningsfase: agents hebben een Concern over een Situation, nog zonder dat ze een Desire of Goal hebben gearticuleerd. Concern is de vroegst-mogelijke intentionele toestand die een Issue constitueert.

**Bron:** VALOR Product Plan §1.4 (kernbegrip Issue); UFO-C-2013 §3.2.

---

## Module 00d — UFO-L Legal Relations

### DD-016 · Policy vs. PolicyDocument — Weigand 2024-onderscheid

**Besluit:** `ufol:Policy` is een bundel van `ufol:RightMode`s en `ufol:DutyMode`s die inhereert in een `ufoc:InstitutionalAgent` en extern afhankelijk is van de geadresseerde `ufoc:Agent`. `ufol:PolicyDocument` is een afzonderlijk `ufol:InformationLegalObject` dat de Policy *beschrijft* maar er niet mee identiek is.

**Rationale:** Weigand-2024 §3: "Policy is a bundle of rights and duties [...] distinct from the policy document as artifact." Dit is ontologisch fundamenteel: beleidswijzigingen kunnen de Policy veranderen zonder dat het document verandert, en vice versa.

**In VALOR operationeel:** Tesserae kunnen verwijzen naar `ufol:Policy` (de normatieve entiteit) als bewijs, niet naar het document. Lexa-perspectieftracering loopt via `ufol:policyGroundedIn → ufol:DelegationAuthority → ufol:hasLegalBasis → LegalNorm`.

**Ontologische correctie (zie DD-032):** De eerdere modellering positioneerde `ufol:Policy` als `gufo:IntrinsicMode`. Dit is gecorrigeerd naar `gufo:ExtrinsicMode`: Policy inhereert in de delegerende agent én is extern afhankelijk van de geadresseerde agent. Policy is daardoor geen specialisatie van `ufoc:Norm` of `ufoc:SocialObject`.

**Bron:** Weigand-2024 §3–4.

---

### DD-017 · Hohfeld-implementatie met enforceability-gradaties

**Besluit:** `ufol:ClaimRightRelator` krijgt een `ufol:hasEnforceability`-eigenschap met drie waarden: `StrongClaim`, `ClaimAfterDefault`, `WeakClaim`.

**Rationale:** Niet alle rechten zijn even sterk afdwingbaar in de publieke dienstverlening:
- `StrongClaim` (krachtige aanspraak): de plichthebbende heeft een fatale verplichting (bijv. beslistermijn)
- `ClaimAfterDefault` (aanspraak na ingebrekestelling): de aanspraak ontstaat pas na expliciete aanmaning
- `WeakClaim` (zwakke aanspraak): discretionaire ruimte voor de plichthebbende

Dit onderscheid is relevant voor de Lexa-perspective in VALOR: het bepaalt welk type normatieve Tessera als "schending" vs. "niet-ideaal" kan worden geclaimd.

**Afwijking ten opzichte van UFO-L-2015:** UFO-L modelleert rechten binair. VALOR-O voegt de enforceability-gradatie toe als VALOR-specifieke extensie op basis van Wetsanalyse §4.3.3.

**Bron:** UFO-L-2015 §3 (Hohfeld); Weigand-2024 §4; Wetsanalyse §4.3.3.

---

### DD-018 · LegalObject als verplicht gegeven bij elke LegalRelator

**Besluit:** Elke `ufol:LegalRelator`-instantie moet via `ufol:hasLegalObject` verbonden zijn met precies één `ufol:LegalObject`. Dit is SHACL-constraint L2.

**Rationale:** Wetsanalyse element 2: elke juridische betrekking betreft altijd een *object* — een recht *op* iets, een plicht *tot* iets. Het ontbreken van een LegalObject is een modelleerinconsistentie. In de praktijk van Wetsanalyse is het identificeren van het object een van de meest onderscheidende stappen.

**Bron:** Wetsanalyse §4 (element 2 van het analyseschema).

---

## Sectie-overschrijdende beslissingen

### DD-019 · Module-nummering na invoeging UFO-B

**Besluit:** Na invoeging van `00b-ufo-b.ttl` schuift de nummering op:

| Oud | Nieuw | Module | Reden voor volgorde |
|-----|-------|--------|---------------------|
| 00a | 00a | gUFO Core | Fundament |
| *(nieuw)* | 00b | UFO-B Events | Vóór sociale entiteiten; Almeida-DEMO gebruikt UFO-B |
| 00b | 00c | UFO-C Social | Bouwt op gUFO + UFO-B |
| 00c | 00d | UFO-L Legal | Bouwt op alle voorgaande |

UFO-B staat vóór UFO-C omdat Almeida-DEMO (de brug naar UFO-C's SocialCommitment-pattern) events gebruikt als constituerend mechanisme voor transactie-acts. De volgorde weerspiegelt ontologische afhankelijkheid.

Alle `owl:imports`-verwijzingen zijn dienovereenkomstig bijgewerkt:
- `00c-ufo-c.ttl` importeert nu ook `vo:ufo-b`
- `00d-ufo-l.ttl` importeert `vo:gufo-core`, `vo:ufo-b`, `vo:ufo-c`

---

### DD-020 · Taal van `rdfs:comment`: Engels voor termen, Nederlands voor domeinuitleg

**Besluit:** Klasse- en eigenschaftslabels zijn tweetalig (`@en` en `@nl`). `rdfs:comment`-annotaties zijn primair in het **Nederlands** (`@nl`) voor domeininhoudelijke uitleg, en in het **Engels** (`@en`) voor technische/ontologische toelichting.

**Rationale:** VALOR richt zich op Nederlandse publieke dienstverlening. Deelnemers die de Forma-view inspecteren zijn overwegend Nederlandstalig. Technische comments voor ontologie-engineers zijn in het Engels conform wetenschappelijke conventie. Waar beide perspectieven in één comment gecombineerd worden, heeft het Nederlands voorrang.

---

### DD-021 · SHACL-severities: Violation vs. Warning

**Besluit:** SHACL-constraints hebben `sh:severity sh:Violation` als de constraint een ontologisch principe uitdrukt dat nooit mag worden geschonden (bijv. G7 punning, B2 excDependsOn, L1 Hohfeld-mediation). `sh:severity sh:Warning` wordt gebruikt voor constraints die een Best Practice uitdrukken maar waarvan onderbouwde afwijking mogelijk is (bijv. B0 event-partitie in open-world context, B7 CLD-polariteit wanneer data onvolledig is).

**Rationale:** GraphDB is een open-world triplestore. Niet alle Violations zijn daadwerkelijk onmogelijk; sommige zijn artefacten van onvolledige data. Warnings signaleren dat aanvulling wenselijk is zonder de import te blokkeren.

**Bron:** W3C SHACL Specification §2.1.

---

### DD-022 · Omgang met open-world assumption in SHACL

**Besluit:** SHACL-constraints zijn bewust geformuleerd als minimale verplichtingen (`sh:minCount`) of maxima (`sh:maxCount`) die individueel zinvol zijn in een open-world context. We gebruiken `sh:maxCount 1` alleen als de functionaliteit een kernaxioma is van de bronontologie.

**Uitzonderingen (sh:maxCount 1 als harde constraint):**
- B2: `excDependsOn` (UFO-B P1 — functioneel kernaxioma)
- B3: `manifestedBy` (UFO-B D2 — functioneel kernaxioma)
- B4: geactiveerd door (UFO-B D4 — functioneel kernaxioma)
- B5: `wasTriggeredBy` (UFO-B S3 — functioneel kernaxioma)
- B9: `broughtAbout` (UFO-B S2 — functioneel kernaxioma)

**Bron:** UFO-B-2013 §3.4 (S2, S3); §3.5 (D2, D4); W3C SHACL §4.1.

---

### DD-023 · Verplichte gUFO-verankering van klassen én properties

**Besluit:** Dit is een **harde regel** die geldt voor alle huidige én toekomstige VALOR-O modules:

1. **Elke `owl:Class`** (niet in de `gufo:`-namespace) heeft:
   - `rdfs:subClassOf` naar een gUFO-klasse (direct, of via een aantoonbare keten via intermediaire VALOR-O-klassen)
   - `rdf:type` naar het corresponderende gUFO-type-hiërarchietype conform de stereotype→type-mapping in DD-002 (punning-conventie)

2. **Elke `owl:ObjectProperty`** (niet in de `gufo:`-namespace) heeft:
   - `rdfs:subPropertyOf` naar een gUFO-property (direct, of via een aantoonbare keten)
   - Wanneer geen directe gUFO-superProperty de semantiek dekt, wordt de dichtstbijzijnde generieke gUFO-property gebruikt en de afwijking gedocumenteerd in `rdfs:comment`

3. **`owl:DatatypeProperty`** valt buiten deze eis: gUFO definieert geen datatype-property-hiërarchie.

**Motivatie:** Zonder deze verankering is de VALOR-O graph semantisch gefragmenteerd — klassen en properties zweven los van het gemeenschappelijke gUFO-fundament. SPARQL-queries over `rdf:type gufo:Kind` of `rdfs:subPropertyOf gufo:mediates` geven dan incomplete resultaten. De SHACL-constraint G7 (`OntoumlPunningShape`) handhaafd eis 1 voor klassen. Voor properties is handhaving via de audit-procedure (zie DD-022).

**Ontdekking:** Bij controle van de initiële modules 00b–00d bleken alle object properties de `rdfs:subPropertyOf`-keten te missen. Dit is gecorrigeerd in alle vier modules. De regel is nu expliciet vastgelegd zodat hij bij elke nieuwe module direct wordt toegepast.

**Bron:** gUFO-spec §1 (foundational role); DD-002 (punning); DD-003 (uitzondering gUFO-primitieven).

---

### DD-024 · «characterization» in beide richtingen (VALOR-O-conventie)

**Besluit:** In VALOR-O wordt het OntoUML-stereotype `"characterization"` gebruikt op properties in *beide* richtingen:

| Richting | gUFO superProperty | Betekenis |
|---|---|---|
| Mode → Endurant | `gufo:inheresIn` | Primaire richting; conform OntoUML-definitie |
| Endurant → Mode | `gufo:hasQuality` | Navigatierichting; VALOR-O-conventie |

**Rationale:** De OntoUML-definitie stelt dat `«characterization»` de richting Mode → Endurant heeft (de mode karakteriseert zijn drager). In de praktijk zijn properties in de richting Endurant → Mode (`hasGoal`, `hasInterest`, `hasConcern`, etc.) even nuttig voor SPARQL-bevragingen. Beide richtingen beschrijven dezelfde `inheresIn`-relatie, alleen vanuit een ander perspectief.

**Documentatievereiste:** Properties met `gufo:hasQuality` als superProperty en stereotype `"characterization"` krijgen een `rdfs:comment` die de navigatieconventie aangeeft.

**Bron:** OntoUML 2.0 metamodel §4.3 (characterization); gUFO §2.4 (hasQuality als inverse van inheresIn).

---

### DD-025 · «creation» en «termination» via wasCreatedIn / wasTerminatedIn

**Besluit:** OntoUML-stereotypen `«creation»` (Event → Endurant) en `«termination»` (Event → Endurant) worden verankerd via de inverse van respectievelijk `gufo:wasCreatedIn` en `gufo:wasTerminatedIn`.

**Rationale:** `gufo:broughtAbout` heeft range `gufo:Situation` — dit dekt niet de creatie of terminatie van Endurants (Relators, ExtrinsicModes). De gUFO-properties `wasCreatedIn` en `wasTerminatedIn` zijn toegevoegd aan module 00a om dit gat te vullen. Properties met `«creation»` of `«termination»` stereotype gebruiken de inverse richting als gUFO-superProperty.

**Betrokken properties:**
- `ufoc:createsCommitment` — inverse `gufo:wasCreatedIn`
- `ufoc:fulfillsCommitment` — inverse `gufo:wasTerminatedIn`
- `ufoc:revokesCommitment` — inverse `gufo:wasTerminatedIn`
- `ufol:createsLegalRelation` — inverse `gufo:wasCreatedIn`
- `ufol:terminatesLegalRelation` — inverse `gufo:wasTerminatedIn`

**Bron:** gUFO 1.0 §2.8 (Events); OntoUML 2.0 §4.4 (creation/termination).

---

### DD-026 · SHACL-constraints voor OntoUML stereotype-combinaties *(volledig geïmplementeerd)*

**Besluit:** De OntoUML 2.0-specificatie (Fonseca et al. 2019, Table 1) definieert strikte constraints op welke klasse-stereotypen geldig zijn als bron en doel van een gegeven relatie-stereotype. Deze constraints zijn geïmplementeerd als SHACL-shapes G1b, G8 en G9 in `00a-gufo-core.shacl.ttl`.

**Geïmplementeerde shapes:**

| Shape | Naam | Beschrijving |
|---|---|---|
| G1b | `ExtrinsicModeShape` | **Nieuw (sessie 17):** ExtrinsicMode heeft precies 1 drager (inheresIn) + ≥1 extern object (externallyDependsOn); drager ≠ extern object |
| G8 | `OntoumlRelationConstraintShape` | SPARQL-constraint: `(relStereo, srcStereo, tgtStereo)` ∈ geldigeTabel |
| G9 | `OntoumlRelationDomainRangeShape` | Waarschuwing als domain of range ontbreekt (G8 niet toepasbaar) |

**G8 — Mechanisme:** De constraint haalt via `rdfs:domain` het bron-stereotype op en via `rdfs:range` het doel-stereotype (beide via `gufo:ontoumlStereotype`-annotatie) en toetst de tripel aan een `VALUES`-blok met alle geldige combinaties.

**Geldige relatie-stereotypen:** `characterization`, `mediation`, `externalDependence`, `material`, `comparative`, `participation`, `creation`, `termination`, `bringsAbout`, `triggers`, `manifestation`, `historicalDependence`, `componentOf`, `subCollectionOf`, `subQuantityOf`, `memberOf`.

**VALOR-O-extensies op de OntoUML 2.0-tabel:**
- `creation event → relator`: relators worden geschapen door events (createsCommitment, createsLegalRelation)
- `termination event → relator`: relators kunnen worden beëindigd door events
- `historicalDependence event → relator`: modifiesLegalRelation-patroon (DD-028)
- `componentOf relator → mode`: SocialRelator heeft SocialCommitment/SocialClaim als constituent ExtrinsicModes
- `historicalDependence situation → situation`: FeedbackLoop-patroon in UFO-B

**Prefix-declaraties (sessie 17 aangevuld):** `shg` bevat SPARQL-prefixes voor `gufo`, `rdf`, `rdfs`, `owl`, `ufoc`, `ufol`, `xsd`.

**Correcties naar aanleiding van G8-implementatie** (gevonden bij pre-implementatie audit):

| Property | Oud stereotype | Nieuw | Reden |
|---|---|---|---|
| `ufol:fulfillsDelegation` | `"bringsAbout"` | `"termination"` | Event→Relator is termination, niet bringsAbout (Event→Situation) |
| `ufob:containsRelation` | `"componentOf"` | `"historicalDependence"` | Situation→Situation valt buiten componentOf (Endurant→Endurant) |
| `ufoc:hasCommitmentContent` | `"externalDependence"` | *(geen stereotype)* | Relator→Situation heeft geen OntoUML-2.0-equivalent; gUFO hasPropositionalContent-subproperty volstaat |
| `ufoc:hasDelegatedGoal` | `"externalDependence"` | *(geen stereotype)* | Idem |
| `ufob:excDependsOn` | `"externalDependence"` | *(geen stereotype)* | UFO-B P1-axioma; Event→Object valt buiten OntoUML-2.0 externalDependence-bereik |

**Bron:** OntoUML 2.0 §4 (relatie-stereotypen); Fonseca et al. (2019) Table 1; gUFO 1.0 §2.7 (ExtrinsicMode).

---

### DD-027 · LegalRelator subClassOf SocialRelator; RightMode / DutyMode herverankering

**Besluit:**
1. `ufol:LegalRelator` is `rdfs:subClassOf ufoc:SocialRelator` (was `gufo:Relator`)
2. `ufol:RightMode` is `rdfs:subClassOf ufoc:SocialClaim` (was `gufo:IntrinsicMode`)
3. `ufol:DutyMode` is `rdfs:subClassOf ufoc:SocialCommitment` (was `gufo:IntrinsicMode`)
4. `ufol:hasRightMode` is `rdfs:subPropertyOf ufoc:hasClaimMoment`
5. `ufol:hasDutyMode` is `rdfs:subPropertyOf ufoc:hasCommitmentMoment`

**Rationale:** Een rechtsbetrekking is ontologisch een bijzondere sociale relator: de normatieve band is juridisch gefundeerd (via een LegalNorm) en juridisch afdwingbaar. De cascade van UFO-C naar UFO-L is hiermee expliciet in de klasse-hiërarchie verankerd:

```
gufo:Relator
  └── ufoc:SocialRelator
        └── ufol:LegalRelator
              ├── ClaimRightRelator
              ├── CompetenceRelator
              └── ...

gufo:ExtrinsicMode
  ├── ufoc:SocialCommitment
  │     └── ufol:DutyMode
  └── ufoc:SocialClaim
        └── ufol:RightMode
```

**Bron:** DD-013 (herzien); Hohfeld-analyse in UFO-L-2015 §3; Poletaeva et al. (2017) §3.1.

---

### DD-028 · modifiesLegalRelation als afgeleide convenience property

**Besluit:** `ufol:modifiesLegalRelation` blijft als afzonderlijke property, maar krijgt stereotype `"historicalDependence"` en `rdfs:subPropertyOf gufo:historicallyDependsOn`. De property is een *convenience property* die het volledige modificatiepatroon verkort.

**Ontologisch patroon (uitgeschreven):** Een modificatie van een LegalRelator is ontologisch:
1. `ufol:terminatesLegalRelation` — het rechtsfeit beëindigt de oude LegalRelator
2. `ufol:createsLegalRelation` — het rechtsfeit schept een nieuwe LegalRelator
3. `gufo:historicallyDependsOn` — de nieuwe LegalRelator hangt historisch af van de oude

Dit is "tijdreizen" in de ontologie: de juridische toestand verandert, maar de historische keten is traceerbaar. De `modifiesLegalRelation`-property drukt de historische afhankelijkheid uit als shorthand.

**Bron:** DD-013 (herzien); UFO-L-2015 §4 (temporele geldigheid).

---

### DD-029 · Geen punning voor «mode» en «quality»; namespace-correctie gUFO

**Aanleiding:** Tijdens implementatie werd ontdekt dat `gufo:NonQualitativeIntrinsicAspect` en `gufo:QualitativeIntrinsicAspect` **niet bestaan** in gUFO 1.0. Tevens bleek de gebruikte `@prefix gufo:`-namespace incorrect.

**Besluit 1 — Geen punning voor mode/quality:**
De stereotypen `"mode"` en `"quality"` krijgen **geen** `rdf:type`-assertie naar een gUFO-Type. gUFO 1.0 definieert geen ModeType of QualityType in de Taxonomy of Types. De Taxonomy of Types bevat uitsluitend: `Kind`, `SubKind`, `Role`, `Phase`, `Category`, `PhaseMixin`, `RoleMixin`, `Mixin`, `EventType`, `SituationType`, `RelationshipType`.

Konsequentie: G7 (`OntoumlPunningShape`) controleert `"mode"` en `"quality"` niet. Alle eerder toegevoegde `rdf:type gufo:NonQualitativeIntrinsicAspect` en `rdf:type gufo:QualitativeIntrinsicAspect`-asserties zijn verwijderd uit 00b, 00c en 00d.

**Besluit 2 — Canonieke gUFO-namespace:**
De canonieke namespace van gUFO 1.0 is `http://purl.org/nemo/gufo#` (conform `owl:versionIRI` en `vann:preferredNamespaceUri` in de TTL). VALOR-O gebruikte eerder `https://nemo-ufes.github.io/gufo/` (de GitHub Pages distributie-URL). Alle `@prefix gufo:`-declaraties en `STRSTARTS`-filters zijn gecorrigeerd naar `http://purl.org/nemo/gufo#`.

**Verificatie:** `https://nemo-ufes.github.io/gufo/gufo.ttl` (geraadpleegd 2026-02-27). De documentatiepagina `https://nemo-ufes.github.io/gufo/` bevestigt: IRI = `http://purl.org/nemo/gufo#`.

**Oorzaak fout:** Analogisch redeneren vanuit de literatuur (UFO-A beschrijft het onderscheid tussen Qualitative en Non-Qualitative Intrinsic Aspects conceptueel) zonder verificatie in de daadwerkelijke gUFO TTL. **Regel: ALTIJD gUFO-termen verifiëren via `https://nemo-ufes.github.io/gufo/gufo.ttl` — nooit zelf verzinnen.** Ze zijn geregistreerd als open DD's.

### DD-OQ-01 · CLD-variabelen in statische OWL

**Vraag:** Hoe worden dynamische CLD-variabelen (met tijdgebonden waarden) uitgedrukt in een statische OWL-ontologie?

**Opties:**
1. Variabelen als `gufo:Quality`-types met tijdgebonden kwaliteitswaarden via temporele kwalificatie
2. Variabelen als abstracte typen waarvan de huidige waarde een concrete kwaliteitsinstantie is
3. Hybride representatie met SPARQL-projectie

**Status:** Open — te beslechten in VALOR-O Onderzoeksworkstream Fase -1c.

---

### DD-032 · `ufol:Policy` als ExtrinsicMode; geen specialisatie van Norm

**Besluit:** `ufol:Policy` is een subklasse van `gufo:ExtrinsicMode`, niet van `gufo:IntrinsicMode` en niet van `ufoc:Norm` of `ufoc:SocialObject`.

**Rationale:**

Weigand (2024) §4.1 stelt expliciet: *"The policy is a mode of the Organizer; and since it also externally dependent on the Organizational Agent, it is positioned as part of the Organization relator."* Dit is per definitie een `gufo:ExtrinsicMode`: inhereert in één bearer (de delegerende `InstitutionalAgent`), en is extern afhankelijk van een andere partij (de geadresseerde `Agent`).

`ufoc:SocialObject` en `ufoc:Norm` zijn `gufo:IntrinsicMode`s van een collectieve agent — de gemeenschap als geheel is de enkelvoudige bearer, conform UFO-C-2013. Er is geen geïdentificeerde externe afhankelijkheid. Norm en Policy zijn daardoor **zuster-concepten**, niet vader-kind:

```
gufo:Aspect
  └── gufo:IntrinsicAspect
        └── gufo:IntrinsicMode
              └── ufoc:SocialObject   (bearer = collectieve agent)
                    └── ufoc:Norm
                          └── ufol:LegalNorm
  └── gufo:ExtrinsicAspect
        ├── gufo:Relator
        └── gufo:ExtrinsicMode
              ├── ufoc:SocialCommitment
              ├── ufoc:SocialClaim
              └── ufol:Policy          (bearer = Organizer; extern: OrgAgent)
```

**Geen punning-type:** Conform DD-029 ontvangen ExtrinsicModes geen punning-type. gUFO 1.0's Taxonomy of Types bevat geen ModeType.

**Cascade-correcties in `00d-ufo-l.ttl`:**
- `ufol:policyContainsRight` / `policyContainsDuty`: `subPropertyOf gufo:hasQuality` → `subPropertyOf gufo:hasProperPart` (RightMode/DutyMode zijn constituerende Moments, geen Qualities van een bearer)
- `ufol:policyDependsOn` toegevoegd als `subPropertyOf gufo:externallyDependsOn`
- `ufol:describedByDocument`: subPropertyOf `gufo:isAspectOf` verwijderd (geen passende gUFO-property voor Mode→Artefact relatie)

**Eerder besluit (vervallen):** `ufol:Policy subClassOf gufo:IntrinsicMode` — gebaseerd op analogie met SocialObject/Norm zonder de externe afhankelijkheid van de geadresseerde te modelleren.

**Bron:** Weigand et al. (2024) §4.1; gUFO 1.0 §2.7 (ExtrinsicMode definitie).

---

---

## Module 00e — COoDM + COVER (eerste opzet)

### DD-030 · `coodm:Decision` als `ufoc:Intention`, niet als Event

**Besluit:** `coodm:Decision` is een subklasse van `ufoc:Intention` (IntrinsicMode), niet van `gufo:Action` of `gufo:Event`.

**Rationale:** COoDM §3 / Weigand §2.1: *"Central to this ontology is the conceptualization of the decision as an intention."* En: *"The decision is not aimed at an action but at a situation."* De Deliberation is het event; de Decision is de intentionele toestand die door dat event wordt gecreëerd. Dit is consistent met de BDI-architectuur: Intentions zijn mentale toestanden, geen handelingen.

De Decision wordt vervolgens *gemanifesteerd* in een `gufo:Action` (via `coodm:manifestedAs`) — maar dat is de uitvoering, niet de beslissing zelf.

**Bron:** COoDM §3; Weigand-2024 §2.1; UFO-C-2013 (Intention als IntrinsicMode).

---

### DD-031 · `coodm:Preference` als `ufoc:Belief`, niet als `ufoc:Intention`

**Besluit:** `coodm:Preference` is een subklasse van `cover:ValueAscription`, die een subklasse is van `ufoc:Belief` — niet van `ufoc:Intention` of `ufoc:Desire`.

**Rationale:** COoDM §3: *"The preferences are conceptualized as value ascriptions of the agent with respect to some value experience."* En: *"The ontology makes a careful distinction between the decision as an intention (not a belief), the preferences as beliefs (not intentions)."* Een Preference is een cognitief oordeel (wat de agent *denkt* over de waarde van een toestand), geen streefrichting (wat de agent *wil*).

**Taxonomische positie:**
```
ufoc:IntentionalMode
  ├── ufoc:Belief
  │     └── cover:ValueAscription
  │           └── coodm:Preference   ← hier
  ├── ufoc:Desire
  │     └── ufoc:Goal
  │           └── coodm:DecisionGoal
  └── ufoc:Intention
        └── coodm:Decision
```

**Bron:** COoDM §3; BDI-architectuur (Rao & Georgeff 1995).

---

### DD-033 · `cover:ValueExperience` als `gufo:Quality`; `cover:ValueType` als `gufo:Kind`

**Besluit:** `cover:ValueExperience` is een subklasse van `gufo:Quality` (inhereert in een Agent, heeft een valentie als QualityValue). `cover:ValueType` is een `gufo:Kind` in de Taxonomy of Types die ValueExperiences classificeert.

**Rationale:** COVER §3.2–3.3: *"Values are treated as types whose instances are value experiences."* De type/instantie-onderscheiding is precies het gUFO-patroon van `Kind` (in Taxonomy of Types) en individuele instanties. De subjectieve beleving is een Quality van de Agent in een Situation — dit is de hybride positie die zowel het objectieve karakter van waarden (als type) als hun subjectieve realisering (als kwaliteit) uitdrukt.

Dit lost de VSD-spanning op: privacy als *type* bestaat objectief; de privacy-*beleving* van een specifieke burger in een specifieke situatie is de Quality-instantie.

**Geen punning voor ValueExperience:** Als subklasse van `gufo:Quality` ontvangt `cover:ValueExperience` geen punning-type (conform DD-029: alleen Endurant Types krijgen punning).

**Bron:** COVER §3.2–3.3; gUFO §2.5 (Quality); gUFO §3 (Kind in Taxonomy of Types).

---

### DD-034 · `coodm:Preference` = `cover:ValueAscription` in deliberatiecontext

**Besluit:** `coodm:Preference` is een subklasse van `cover:ValueAscription`. Er zijn geen twee aparte concepten — een Preference IS een ValueAscription die relevant is binnen een Deliberation.

**Rationale:** COoDM §3 beschrijft Preferences als *"value ascriptions of the agent"* — dezelfde term die COVER gebruikt. De specialisering in `coodm:Preference` is uitsluitend contextspecifiek: het is de ValueAscription die de evaluatie van DecisionAlternatives stuurt. Dit vermijdt conceptuele duplicatie en maakt de koppeling COoDM↔COVER expliciet.

**Consequentie:** `coodm:hasPreference` heeft als range `coodm:Preference`; `cover:ascribesValueTo` relateert aan `cover:ValueExperience`. De keten is: Deliberation → Preference → ValueExperience → ValueType.

**Bron:** COoDM §3; COVER §3.4.

---

### DD-035 · Twee namespaces in één bestand: `coodm:` en `cover:`

**Besluit:** Module `00e-coodm.ttl` bevat concepten uit zowel de `coodm:`-namespace (COoDM-specifiek) als de `cover:`-namespace (COVER-specifiek). Dit zijn twee aparte prefixen in één TTL-bestand.

**Rationale:** COoDM en COVER zijn onlosmakelijk verbonden: Preferences (COoDM) zijn ValueAscriptions (COVER). Het opsplitsen in twee bestanden zou de koppeling in twee imports vereisen en de coherentie verbreken. Bovendien is de COVER-opzet in 00e nog een *eerste opzet* — een volledig COVER-bestand volgt als latere module.

**Productie-instructie:** Bij uitbreiding van COVER tot een volledig bestand (`00f-cover.ttl`) worden de `cover:`-concepten uit 00e daarheen verplaatst, en importeert 00e dat bestand.

**Bron:** Architectuurkeuze VALOR-O; VALOR Product Plan §12.3.

---

### DD-036 · VAO-correcties o.b.v. Sales et al. (2017): ValueExperience als Event, ValueAscription als Relator

**Besluit:** Drie fundamentele modelleringsfouten uit de eerste opzet van §B (00e) zijn gecorrigeerd op basis van Sales et al. (2017) "An Ontological Analysis of Value Propositions":

**Correctie 1 — `cover:ValueExperience`: Quality → Event**
Sales §4 expliciet: *"value objects are substantials in UFO, while value experiences are considered as events."* Een waardebeleving is iets dat *gebeurt* — het ondergaan van een dienst, gebruik van een goed, ontvangen van een besluit. `cover:ValueExperience` is nu `rdfs:subClassOf gufo:Event`. De participatierelatie `cover:hasBeneficiary` vervangt de vroegere `experiencedBy` (`subPropertyOf gufo:inheresIn`); ze is nu `subPropertyOf gufo:hasParticipant`.

**Correctie 2 — `cover:ValueAscription`: Belief → Relator**
Sales Fig. 2 toont ValueAscription als `<<relator>>` met twee partijen: ValueBeholder (beoordelaar) en ValueBeneficiary (begunstigde). `cover:ValueAscription` is nu `rdfs:subClassOf gufo:Relator`. Toegevoegd: `cover:hasBeholderAgent` en `cover:hasBeneficiaryAgent` als `subPropertyOf gufo:mediates`. Twee Phase-subtypen conform Sales §4:
- `cover:ValuePerception` — beholder == beneficiary (zelf-beoordeling)
- `cover:ValueAssertion` — beholder ≠ beneficiary (VP door organisatie over burger)

**Correctie 3 — `cover:ValueType`: gufo:Kind/EndurantType → gufo:EventType**
ValueType classificeert ValueExperiences (events). EventTypes classificeren events; Kinds classificeren Endurants. `cover:ValueType` is nu `rdf:type gufo:EventType; rdfs:subClassOf gufo:EventType`. De instantienamen zijn aangepast (Privacy → PrivacyExperience, etc.) om de event-aard te benadrukken.

**Cascadeconsequentie — `coodm:Preference` losgekoppeld van ValueAscription (herziet DD-034)**
Een `Belief` en een `Relator` zijn structureel onverenigbaar — geen subklasse-relatie mogelijk. `coodm:Preference` blijft `rdfs:subClassOf ufoc:Belief`. De koppeling met ValueAscription loopt via `coodm:groundsAscription`: de Preference (mentaal substraat) fundeert de ValueAscription (relationele uiting).

**Cascadeconsequentie — `cover:ValueScale` geen QualityValue meer**
`gufo:QualityValue` is de waarde van een `gufo:Quality`. Nu ValueExperience een Event is (geen Quality), is `cover:ValueScale` een eenvoudige annotatieklasse zonder gUFO-superklasse.

**Bron:** Sales, T.P., Guarino, N., Guizzardi, G. & Mylopoulos, J. (2017). *An Ontological Analysis of Value Propositions*. EDOC 2017, §4, Fig. 1–2.

---

---

## Module 00f — COVER Value Ascription Ontology (uitbouw)

### DD-037 · ValueProposition als subtype van cover:ValueAssertion

**Besluit:** `cover:ValueProposition` is een `gufo:SubKind` van `cover:ValueAssertion` (zelf een Phase van `cover:ValueAscription`). Twee verder gespecialiseerde subtypen: `cover:BusinessValueProposition` (portefeuilleniveau) en `cover:OfferingValueProposition` (dienstniveau).

**Rationale:** Sales et al. (2017) §5.1 definieert een ValueProposition expliciet als *"a value assertion a company makes (as the value beholder) that a given market segment (the beneficiaries) will ascribe a particular value to the experiences enabled by an offering."* Dit is per definitie een `ValueAssertion` (beholder ≠ beneficiary). De VP is dus geen apart ontologisch concept — het is een toepassingsspecialisatie van de bestaande Relator-hiërarchie uit 00e.

In VALOR-context: een publieke organisatie (beholder) stelt dat burgers (beneficiary) een bepaalde waarde zullen ervaren bij het afnemen van een dienst. Dit is precies de `ValueAssertion`-structuur. De VP fungeert als Tessera in het Axia-perspectief en vormt de brug naar Acta (de dienst zelf als transactiepatroon in 00g/DEMO).

**Onderscheid BusinessVP / OfferingVP:** Sales §5.2 beschrijft twee abstractieniveaus. BusinessVP: abstracte strategische claim over de totale portefeuille. OfferingVP: concrete claim per dienst, conformerend aan de BusinessVP (`cover:conformsTo`). In VALOR zijn meerdere hiërarchieniveaus mogelijk (gemeentelijk niveau → dienstniveau → varianten), maar de twee niveaus van Sales zijn de minimale structuur.

**Bron:** Sales et al. (2017) §5.1, §5.2, Fig. 4.

---

### DD-038 · VAComponent als Relator met Benefit/Sacrifice subtypen

**Besluit:** `cover:VAComponent` is een `gufo:Relator` die medieert tussen een `cover:ValueAscription` (de overkoepelende beoordeling), een `ufoc:IntentionalMode` (het MentalAspect dat de focus vormt) en een `cover:ValueExperience` (de beleving waarover wordt geoordeeld). Twee SubKind-subtypen: `cover:Benefit` en `cover:Sacrifice`.

**Rationale:** Sales §4/Fig. 2: *"we represent a value ascription as an aggregation of 'smaller' judgments, namely the value ascription components."* Elke component focust op één mentaal aspect van de beholder (doel, wens, zorg) en beoordeelt de ValueExperience daartegen. Dit is precies het Relator-patroon: de component medieert drie partijen en kan niet bestaan zonder elk ervan.

Kambil et al. (1996) via Sales §3: sacrifices omvatten niet alleen prijs maar ook risico, moeite en opportunity cost. De Sacrifice-klasse is dus breder dan alleen financiële kosten.

**Modellering van `hasComponent`:** `cover:hasComponent` is een `subPropertyOf gufo:hasProperPart` — VAComponents zijn constituerende delen van de ValueAscription-Relator, conform het gUFO-patroon voor samengestelde Relators (zie ook `ufoc:hasCommitmentMoment` in 00c als analogie).

**SHACL:** F4 is een Warning (niet Violation) omdat vroege modelleeriteraties een ValueAscription kunnen hebben zonder uitgewerkte components — dit is ontologisch onvolledig maar niet logisch inconsistent.

**Bron:** Sales et al. (2017) §4, Fig. 2; Kambil et al. (1996) via Sales §3.

---

### DD-039 · ValueObject als RoleMixin op gufo:Object

**Besluit:** `cover:ValueObject` is een `gufo:RoleMixin` die substantials (goederen, diensten, besluiten, informatieobjecten) karakteriseert in de context van een waardebeoordeling. `cover:ValueBearer` is de overkoepelende RoleMixin voor zowel ValueObject als ValueExperience.

**Rationale:** Sales §4: *"value objects are substantials in UFO — entities that keep their identity in time."* In tegenstelling tot ValueExperiences (events) zijn ValueObjects Endurants. Ze zijn echter niet altijd waarde-dragers: een vergunning is een ValueObject ín de context van een waardebeoordeling, maar in andere contexten (bijv. juridische analyse) is het gewoon een `ufol:Right`. RoleMixin is daarom de juiste keuze: het is een contextuele karakterisering, niet een essentiële classificatie.

**`cover:enabledBy`:** De relatie van ValueExperience naar ValueObject drukt de causaliteit uit: de ervaring van het ontvangen van een vergunning (event) wordt mogelijk gemaakt door de vergunning zelf (substantial). Sales §4: ervaringen zijn typisch het gebruik, ontvangen of ondergaan van een ValueObject. De ValueExperience is de 'ultimate bearer' van de waardebeoordeling; het ValueObject is de enabler.

**`cover:ValueBearer`:** Overkoepelende RoleMixin conform Sales Fig. 1. Maakt het mogelijk om in een `cover:ascribesValueTo`-statement zowel ValueExperiences als ValueObjects als bereik te accepteren (voor toekomstige uitbreidingen).

**Bron:** Sales et al. (2017) §4, Fig. 1.

---

---

## Module 00g — ACTA Transactieontologie

### DD-040 · Transaction als ufoc:SocialRelator; rollen als RoleMixin

**Besluit:** `acta:Transaction` is een `ufoc:SocialRelator` met `acta:hasInitiator` en `acta:hasExecutor` als mediatie-properties naar `ufoc:Agent`. De rollen `acta:Initiator` en `acta:Executor` zijn `gufo:RoleMixin`s — niet-rigide, contextuele karakteriseringen. CoordinationActs zijn `gufo:Action` (subtype van `gufo:Event`). Logische precedentie tussen acts (`acta:precedes`) is gegrond in `gufo:contributedToTrigger`.

**Rationale:** Almeida et al. (EEWC 2013) formaliseert het DEMO Complete Transaction Pattern expliciet in UFO/OntoUML: *"a transaction is modelled as a Social Relator mediating the initiator and executor."* Dit is de enige gepubliceerde bridge tussen DEMO en UFO en vormt daarmee de directe grondslag. De keuze voor SocialRelator is juist omdat een transactie precies doet wat een Relator doet: zij medieert een normatieve verhouding die niet kan bestaan zonder beide partijen.

Rollen als RoleMixin: een burger is niet wezenlijk een Initiator — hij speelt die rol in de context van een specifieke transactie. Hetzelfde geldt voor de overheid als Executor. RoleMixin laat toe dat een overheid in een geneste transactie zelf Initiator is (t.o.v. een onderaannemer).

Acts als `gufo:Action`: actions zijn intentionele events in gUFO. CoordinationActs zijn intentioneel (de Executor belooft bewust), de ProductionAct ook (de beschikking is een intentionele daad). `acta:precedes` is geen temporele relatie maar een causaal-intentionele afhankelijkheid: de toestand ná act A (een `gufo:Situation`) draagt bij aan het triggeren van act B.

**Twee subtypen van Transaction:** `PublicServiceTransaction` (burger ↔ overheid, Initiator ≠ Executor) en `InternalTransaction` (interne actorrollen binnen dezelfde organisatie, de DEMO B-organisatielaag).

**Bron:** Almeida et al. (2013), Dietz & Mulder (2020) DEMO §3.

---

### DD-041 · Twee richtingen: Transaction groundedIn LegalRelator; ProductionAct createsLegalRelator

**Besluit:** De verhouding tussen Transaction en LegalRelator loopt in twee richtingen, ontologisch onderscheiden:

**(1) `acta:groundedIn` — de grondslag-richting:** Een pre-existente `ufol:LegalRelator` maakt de transactie juridisch mogelijk. Twee patronen:
- `ufol:CompetenceRelator`: de overheid heeft de *bevoegdheid* de ProductionAct uit te voeren. De wet (LegalNorm → CompetenceRelator) authoriseert de Executor. Prototypisch: vergunningverlening, beschikkingsbevoegdheid.
- `ufol:ClaimRightRelator`: de burger heeft een *wettelijk recht* op dienstverlening. De TransactionResult-plicht is pre-constituted door de wet. Prototypisch: bijstandsrecht, AOW-recht.

**(2) `acta:createsLegalRelator` — de schepping-richting:** De `ProductionAct` brengt een *nieuwe* `ufol:LegalRelator` tot stand. Dit is gegrond in `gufo:wasCreatedIn` (de inverse richting: de nieuwe LegalRelator `wasCreatedIn` de ProductionAct). Prototypisch: de beschikking vergunningverlening schept een `ufol:ClaimRightRelator` waarbij de vergunninghouder `RightMode` verkrijgt; de uitkeringsbeschikking schept een periodieke betalingsplicht als `DutyMode` van de overheid.

**Ontologische precisie:** Transaction en LegalRelator zijn *orthogonale* concepten:
- `LegalRelator` is een *normatieve toestand* (een Relator als ExtrinsicAspect dat de rechtsbetrekking constitueert)
- `Transaction` is een *processtructuur* (een SocialRelator die de interactie-episoden tussen Initiator en Executor organiseert)

Ze zijn geen synoniemen en geen deel-geheel-relatie. De transactie *put* haar authorisatie uit een bestaande LegalRelator en *genereert* een nieuwe. Dit is de precieze uitdrukking van Renzo's intuïtie: een LegalRelator is een positie die transacties mogelijk maakt; de transactie schept op haar beurt een nieuwe LegalRelator.

**Bron:** Almeida et al. (2013); UFO-L (Guizzardi et al. 2015) §3-4; Hohfeld (1913) via Weigand (2024).

---

### DD-042 · TransactionResult als ValueObject — brug Acta ↔ Axia

**Besluit:** `acta:TransactionResult` (een `gufo:Situation`) is tegelijk het `cover:ValueObject` dat `cover:ValueExperience`s bij de Initiator mogelijk maakt. De property `acta:enablesExperience` (inverse van `cover:enabledBy`) legt deze brug expliciet.

**Rationale:** Cover's ValueObject is gedefinieerd als *"een substantial of situatie die ValueExperiences mogelijk maakt"* (Sales et al. 2017 §4). Een TransactionResult is precies zo'n entiteit: de vergunning (als rechtspositie) stelt de burger in staat een `cover:AutonomyExperience` te hebben; de uitkering stelt hem in staat een `cover:SolidarityExperience` te hebben; een onredelijk lange doorlooptijd genereert een `cover:FairnessExperience` met negatieve valentie.

Dit is de architectureel cruciale verbinding in VALOR: dezelfde entiteit (het TransactionResult) is de ontologische kern van zowel het Acta-perspectief (hoe wordt de dienst geleverd?) als het Axia-perspectief (welke waarde ervaart de burger?). Er is geen vertaling nodig — het is dezelfde resource in de graph, bevraagd via twee SPARQL-projecties.

**Implicatie voor `cover:OfferingValueProposition`:** De VP van een publieke dienst (00f) is een `ValueAssertion` over de waarden die de Initiator zal ervaren dankzij het TransactionResult. De keten is volledig:
```
ufol:LegalNorm → groundedIn → acta:Transaction → hasTransactionResult →
acta:TransactionResult [= cover:ValueObject] → enablesExperience →
cover:ValueExperience → ascribesValueTo ← cover:ValueAscription [= VP]
```

**Bron:** Sales et al. (2017) §4; DEMO (Dietz & Mulder 2020); gUFO `gufo:wasCreatedIn`.

---

### DD-OQ-02 · i*-Actor Analysis in UFO-C

**Vraag:** Hoe worden i*-intentionele afhankelijkheden (dependum-relaties) uitgedrukt in VALOR-O? Het i*-framework onderscheidt vier typen dependum (goal, task, resource, softgoal) — elk met een eigen ontologische status in UFO-C.

**Voorlopige richting:** Integratie met `ufoc:SocialCommitment` als generieke afhankelijkheidsstructuur, met modaliteitsspecificaties per type. `SoftGoal` is al opgenomen in UFO-C module als `ufoc:SoftGoal`.

**Status:** Open — te beslechten in VALOR-O Onderzoeksworkstream Fase -1c.

---

### DD-OQ-03 · VALOR-O versioning en DesignSpace-migratie

**Vraag:** Hoe wordt VALOR-O geversioneerd? Kan een DesignSpace verwijzen naar een specifieke versie van VALOR-O, en wat zijn de migratieconsequenties bij een VALOR-O update?

**Status:** Open — strategische beslissing (VALOR Product Plan §15, vraag 16).

---

*Dit document wordt bijgewerkt bij elke nieuwe module. Versie-history via Git-commits.*


---

## Module 00c–00f — gUFO-typefouten gecorrigeerd (v0.2, DD-049 verbreed)

### DD-049-ext · Systematische correcties modules 00c–00f

**Besluit:** Onderstaande `rdf:type`-asserties zijn verwijderd of gecorrigeerd in modules 00c t/m 00f, conform het principe dat de gUFO Taxonomy of Types uitsluitend toepasselijk is op de in DD-049 genoemde type-classificatoren.

---

#### Module 00c-ufo-c.ttl  (v0.2)

**[C-001] `ufoc:SocialRelator`: `rdf:type gufo:Relator` verwijderd**

`gufo:Relator` is een klasse in de *Taxonomy of Individuals* — het beschrijft wat SocialRelator-instanties *zijn* (via `rdfs:subClassOf gufo:Relator`). In de *Taxonomy of Types* heeft `gufo:Relator` geen rol: het is geen Kind, SubKind, Role, Phase, Category, EventType of SituationType. Het patroon `rdf:type gufo:Relator` op een klasse is semantisch onjuist (Taxonomy of Types kent geen "RelatorType"). `rdfs:subClassOf gufo:Relator` volstaat volledig.

**[C-002] `ufoc:Delegatum`: `rdf:type gufo:Relator` verwijderd** — zelfde reden.

---

#### Module 00d-ufo-l.ttl  (v0.2)

**[D-001] `ufol:NaturalPersonSubject`: `rdf:type gufo:EventType` → `rdf:type gufo:Role`**

`NaturalPersonSubject` is een subklasse van `ufol:LegalSubject`, die zelf een `gufo:Role` is (anti-rigide, relationeel: een persoon speelt de rol van rechtssubject in de context van een LegalRelator). `EventType` is uitsluitend voor Event-subtypen. `NaturalPersonSubject` is een Endurant (FunctionalComplex-afstammeling via Agent). De correcte classificatie is `gufo:Role` — dezelfde als zijn superklasse `LegalSubject`.

**[D-002] `ufol:LegalRelator`: `rdf:type gufo:Relator` verwijderd** — zelfde reden als C-001.

---

#### Module 00e-coodm.ttl  (v0.2)

**[E-001] `cover:ValueAscription`: `rdf:type gufo:RelationshipType` verwijderd**

`gufo:RelationshipType` is, conform de officiële gUFO-spec, een type-classificator voor *object-properties* (relaties), niet voor klassen (entiteitstypen). Het is het second-order equivalent van een relatie, vergelijkbaar met hoe `gufo:Kind` het second-order equivalent van een klasse is. Het op een klasse plaatsen van `rdf:type gufo:RelationshipType` is een categorieverwisseling.

**[E-002] `cover:ValuePerception`: `rdf:type gufo:Phase` verwijderd**  
**[E-003] `cover:ValueAssertion`: `rdf:type gufo:Phase` verwijderd**

`gufo:Phase` is een anti-rigide sortal in de Taxonomy of Types, bedoeld voor fases van *Endurant-sortalen* (bijv. een persoon die de fase "student" doorloopt). `ValueAscription` is een `gufo:Relator` (ExtrinsicAspect), geen Endurant-sortal. Relators hebben geen fases in de gUFO-zin: ze worden gecreëerd en beëindigd, niet gefaseerd. De subklasse-relatie (`ValuePerception rdfs:subClassOf ValueAscription`) drukt de specialisatie al adequaat uit.

**[E-004] `cover:VAComponent`: `rdf:type gufo:RelationshipType` verwijderd** — zelfde reden als E-001.

---

#### Module 00f-cover.ttl  (v0.2)

**[F-001] `cover:VAComponent`: `rdf:type gufo:RelationshipType` verwijderd** — zelfde reden als E-001/E-004.

**[F-002] `cover:Benefit`: `rdf:type gufo:SubKind` verwijderd**  
**[F-003] `cover:Sacrifice`: `rdf:type gufo:SubKind` verwijderd**  
**[F-004] `cover:ValueProposition`: `rdf:type gufo:SubKind` verwijderd**  
**[F-005] `cover:BusinessValueProposition`: `rdf:type gufo:SubKind` verwijderd**  
**[F-006] `cover:OfferingValueProposition`: `rdf:type gufo:SubKind` verwijderd**

`gufo:SubKind` vereist dat er een `gufo:Kind` boven in de hiërarchie aanwezig is die het identiteitsprincipe draagt. De genoemde klassen zijn (transitief) subklassen van `gufo:Relator` (via VAComponent resp. ValueAscription/ValueAssertion). `gufo:Relator` is een ExtrinsicAspect, geen Kind — het biedt geen identiteitsprincipe in de zin van `gufo:Kind`. Er is geen valide SubKind-classificatie mogelijk voor Relator-subklassen.

**Consequentie:** Benefit/Sacrifice/ValueProposition en subklassen behouden hun `gufo:ontoumlStereotype "subkind"` als annotatieve hint naar het OntoUML-diagram, maar krijgen geen corresponderende `rdf:type`-assertie in de Taxonomy of Types.

---

### DD-052 · Geen ModeType/QualityType in gUFO Taxonomy of Types

**Besluit:** Klassen met `gufo:ontoumlStereotype "mode"` of `"quality"` (IntentionalMode-subklassen, TemporalCondition, DomainVariable, Policy, etc.) krijgen **geen** `rdf:type`-assertie in de Taxonomy of Types.

**Rationale:** De gUFO Taxonomy of Types (gUFO-spec §4) omvat:

| gUFO-type | Toepassingsgebied |
|-----------|------------------|
| `gufo:Kind` | Rigide ultime sortal (Endurant) |
| `gufo:SubKind` | Rigide specialisatie van Kind |
| `gufo:Role` | Anti-rigide sortal (relationeel) |
| `gufo:Phase` | Anti-rigide sortal (intrinsiek) |
| `gufo:Category` | Rigide non-sortal |
| `gufo:Mixin` | Non-rigide non-sortal |
| `gufo:RoleMixin` | Non-rigide non-sortal (relationeel) |
| `gufo:EventType` | Type van Events |
| `gufo:SituationType` | Type van Situations |

Er is **geen** `gufo:ModeType`, `gufo:QualityType` of `gufo:RelatorType` in de Taxonomy of Types. Modes en Qualities worden in de Taxonomy of Individuals gepositioneerd via `rdfs:subClassOf gufo:IntrinsicMode`, `rdfs:subClassOf gufo:Quality` etc. — dat is voldoende.

**Eerder foutief gedocumenteerd:** DD-002 bevatte een mapping `"mode" → gufo:NonQualitativeIntrinsicAspect` als zou dat een punning-type zijn. Dit is incorrect: `gufo:NonQualitativeIntrinsicAspect` is een synoniem voor `gufo:IntrinsicMode` in de *Taxonomy of Individuals*, niet een type-classificator.

**Correctie van DD-002:** De punning-tabel in DD-002 wordt aangevuld met de uitzonderingsbepaling: `"mode"` en `"quality"` ontoumlStereotypes leiden **niet** tot een `rdf:type`-assertie in de Taxonomy of Types. De `rdfs:subClassOf`-assertie naar de juiste Individual-taxonomieklasse volstaat.

**Bron:** gUFO-spec §4 (Taxonomy of Types); gUFO-spec §3 (Taxonomy of Individuals).

---

