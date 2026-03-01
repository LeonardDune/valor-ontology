# Product Plan — gUFO Ontology Editor

**Grafische editor voor het modelleren van ontologieën conform gUFO / OntoUML**

| | |
|---|---|
| **Versie** | 3.0 |
| **Datum** | Februari 2026 |
| **Status** | Concept |
| **Gebaseerd op** | gUFO v1.0.0 · OntoUML Vocabulary v1.1.0 |
| **Doelgroep** | Ontologie-engineers, kennismodelleurs, informatieanalisten |

---

## 1. Inleiding & Probleemstelling

Ontologieën vormen de ruggengraat van kennisrepresentatie in domeinen als enterprise architectuur, biomedische informatica, juridische systemen en linked data. Bestaande tools — zoals Protégé — zijn krachtig maar bieden weinig ondersteuning voor foundational ontologies zoals gUFO.

gUFO (*Gentle Unified Foundation Ontology*, v1.0.0) biedt een lichtgewicht OWL/RDF-implementatie van UFO met twee parallelle taxonomieën: één voor individuen (instanties zoals `gufo:Object`, `gufo:Event`) en één voor typen (metaclassen zoals `gufo:Kind`, `gufo:Role`). OntoUML 2.0 is het bijbehorende grafische modelleerprofiel voor UML 2.0-klassediagrammen, gedefinieerd in de OntoUML Vocabulary v1.1.0 (`https://w3id.org/ontouml#`).

De mapping tussen beide is niet één-op-één:

- gUFO bevat concepten zonder direct OntoUML-equivalent (`FunctionalComplex`, `FixedCollection`, `Participation`, `ExtrinsicMode`, situatie-subklassen, `QualityValue`)
- OntoUML 2.0 bevat stereotypen zonder directe gUFO-tegenhanger (`«historicalRole»`, `«historicalRoleMixin»`, `«datatype»`, `«enumeration»`)
- Het OWL 2 *punning*-mechanisme (een klasse is tegelijk instantie van een metatype) is voor veel modelleurs onbekend terrein

Dit product beschrijft een web-based grafische editor die deze kloof overbrugt.

---

## 2. Product Visie

> *"Voor ontologie-engineers en kennismodelleurs die rigoureuze, herbruikbare ontologieën willen bouwen, biedt de gUFO Ontology Editor een grafische, validerende en collaboratieve omgeving die de kloof overbrugt tussen OntoUML-notatie en gUFO-semantiek — iets wat geen bestaande tool vandaag biedt."*

---

## 3. Doelgroepen & Stakeholders

| Persona | Rol | Primaire behoefte |
|---|---|---|
| Ontologie-engineer | Bouwt domeinontologieën | Visueel modelleren, gUFO-validatie |
| Informatiemanager | Beheert kennismodellen | Versioning, export, documentatie |
| Data Architect | Ontwerpt datamodellen en linked data | SPARQL, integratie, RDF-export |
| Onderzoeker / Academicus | Werkt met UFO-gebaseerde theorie | OntoUML-notatie, referenties naar gUFO-spec |
| Ontwikkelaar / Beheerder | Beheert de applicatie en graph DB | API, deployment, monitoring |

---

## 4. gUFO & OntoUML: Volledige Conceptinventarisatie

Dit hoofdstuk is de inhoudelijke kern van het product. De editor moet het volledige vocabulaire van beide specificaties correct ondersteunen.

### 4.1 Taxonomie van Individuen (gUFO)

Klassen waarvan de instanties individuen zijn:

```
gufo:Individual
  ├── gufo:AbstractIndividual
  │     └── gufo:QualityValue
  └── gufo:ConcreteIndividual
        ├── gufo:Endurant
        │     ├── gufo:Object
        │     │     ├── gufo:FunctionalComplex
        │     │     ├── gufo:Collection
        │     │     │     ├── gufo:FixedCollection
        │     │     │     └── gufo:VariableCollection
        │     │     └── gufo:Quantity
        │     └── gufo:Aspect
        │           ├── gufo:IntrinsicAspect
        │           │     ├── gufo:Quality
        │           │     └── gufo:IntrinsicMode
        │           └── gufo:ExtrinsicAspect
        │                 ├── gufo:Relator
        │                 └── gufo:ExtrinsicMode
        ├── gufo:Event
        │     └── gufo:Participation
        └── gufo:Situation
              ├── gufo:QualityValueAttributionSituation
              ├── gufo:TemporaryInstantiationSituation
              ├── gufo:TemporaryParthoodSituation
              ├── gufo:TemporaryConstitutionSituation
              └── gufo:TemporaryRelationshipSituation
```

### 4.2 Taxonomie van Typen (gUFO)

Klassen waarvan de instanties zelf typen (OWL-klassen) zijn. Maakt gebruik van OWL 2 *punning*:

```
gufo:Type
  ├── gufo:AbstractIndividualType
  ├── gufo:RelationshipType
  │     ├── gufo:MaterialRelationshipType
  │     └── gufo:ComparativeRelationshipType
  └── gufo:ConcreteIndividualType
        ├── gufo:EventType
        ├── gufo:SituationType
        └── gufo:EndurantType
              ├── gufo:RigidType
              │     ├── gufo:Kind
              │     ├── gufo:SubKind
              │     └── gufo:Category
              ├── gufo:NonRigidType
              │     ├── gufo:SemiRigidType → gufo:Mixin
              │     └── gufo:AntiRigidType
              │           ├── gufo:Role
              │           ├── gufo:Phase
              │           ├── gufo:RoleMixin
              │           └── gufo:PhaseMixin
              ├── gufo:Sortal     (= Kind, SubKind, Role, Phase)
              └── gufo:NonSortal  (= Category, Mixin, RoleMixin, PhaseMixin)
```

**Noot over punning:** Een domeinontologieklasse zoals `Person` is tegelijk een `owl:Class` (subclass van `gufo:Object`) én een `rdf:type gufo:Kind`. De editor moet dit mechanisme expliciet ondersteunen en inzichtelijk maken, omdat het het hart vormt van de gUFO-modelleeraanpak.

### 4.3 OntoUML Klasse-stereotypen

Volledige set van `ontouml:ClassStereotype` conform de OntoUML Vocabulary v1.1.0:

| OntoUML Stereotype | gUFO Correspondentie | Rigiditeit | Sortaliteit | Toelichting |
|---|---|---|---|---|
| `«kind»` | `gufo:Kind` | Rigid | Sortal | Basistype met identiteitscriterium; instanties zijn `gufo:FunctionalComplex` |
| `«collective»` | `gufo:Kind` | Rigid | Sortal | Instanties zijn `gufo:Collection`; `isExtensional` onderscheidt Fixed/Variable |
| `«quantity»` | `gufo:Kind` | Rigid | Sortal | Instanties zijn `gufo:Quantity` |
| `«relator»` | `gufo:Kind` | Rigid | Sortal | Instanties zijn `gufo:Relator`; waarheidmaker van materiële relaties |
| `«mode»` | `gufo:Kind` | Rigid | Sortal | Instanties zijn `gufo:IntrinsicMode`; intrinsiek, geen meetwaarde |
| `«quality»` | `gufo:Kind` | Rigid | Sortal | Instanties zijn `gufo:Quality`; intrinsiek, meetbaar via kwaliteitsruimte |
| `«subkind»` | `gufo:SubKind` | Rigid | Sortal | Rigide specialisatie van een Kind |
| `«role»` | `gufo:Role` | Anti-rigid | Sortal | Relationeel afhankelijk; altijd verbonden met `«mediation»` |
| `«phase»` | `gufo:Phase` | Anti-rigid | Sortal | Intrinsiek gemotiveerd; altijd in partitie (complete + disjoint) |
| `«category»` | `gufo:Category` | Rigid | Non-sortal | Essentiële eigenschappen over meerdere Kinds |
| `«mixin»` | `gufo:Mixin` | Semi-rigid | Non-sortal | Rigide voor sommige, contingent voor andere instanties |
| `«roleMixin»` | `gufo:RoleMixin` | Anti-rigid | Non-sortal | Relationeel afhankelijk; meerdere Kinds |
| `«phaseMixin»` | `gufo:PhaseMixin` | Anti-rigid | Non-sortal | Intrinsiek gemotiveerd; meerdere Kinds |
| `«event»` | `gufo:EventType` | — | — | Type waarvan instanties `gufo:Event` zijn |
| `«situation»` | `gufo:SituationType` | — | — | Type waarvan instanties `gufo:Situation` zijn |
| `«historicalRole»` | *Geen directe gUFO-tegenhanger* ★ | Anti-rigid | Sortal | OntoUML 2.0; rol gedefinieerd door historische afhankelijkheid |
| `«historicalRoleMixin»` | *Geen directe gUFO-tegenhanger* ★ | Anti-rigid | Non-sortal | OntoUML 2.0; rolMixin via historische afhankelijkheid |
| `«type»` | `gufo:Type` (higher-order) | — | — | Higher-order type (powertype-patroon) |
| `«abstract»` | `gufo:AbstractIndividualType` | — | — | Instanties zijn abstracte individuen |
| `«datatype»` | *Geen gUFO-tegenhanger* ★ | — | — | Technisch datatype |
| `«enumeration»` | *Geen gUFO-tegenhanger* ★ | — | — | Enumeratie van waarden |

★ = Stereotypen zonder directe gUFO-tegenhanger. De editor documenteert dit expliciet en biedt een handmatige mapping-optie.

### 4.4 OntoUML Relatie-stereotypen

Volledige set van `ontouml:RelationStereotype` conform de OntoUML Vocabulary v1.1.0, met gUFO-correspondentie en grafische notatieconventie:

| OntoUML Stereotype | gUFO Object Property | Richting | Visuele notatie | Toelichting |
|---|---|---|---|---|
| `«mediation»` | `gufo:mediates` | Relator → Endurant | Gestippelde pijl | Existentiële afhankelijkheidsrelatie van Relator naar gemedieerde entiteiten (min. 2) |
| `«characterization»` | `gufo:inheresIn` | Aspect → Bearer | Gestippelde pijl | Aspect (Mode/Quality) karakteriseert drager; multiplicity doeluiteinde = exact 1 |
| `«externalDependence»` | `gufo:externallyDependsOn` | ExtrinsicMode → Endurant | Gestippelde pijl | ExtrinsicMode hangt extern af van een andere entiteit |
| `«material»` | `gufo:MaterialRelationshipType` | Object ↔ Object | Volle lijn (isDerived=true) | Afgeleide materiële relatie; altijd afgeleid via `«derivation»` uit een Relator |
| `«derivation»` | `gufo:isDerivedFrom` | Material → Relator | Gestippelde pijl | Toont dat een materiële relatie afgeleid is van een specifieke Relator |
| `«comparative»` | `gufo:ComparativeRelationshipType` | Object ↔ Object | Volle lijn | Vergelijkingsrelatie op basis van kwaliteitswaarden (bv. *zwaarder dan*) |
| `«componentOf»` | `gufo:isComponentOf` | Object → FunctionalComplex | Shared-diamant aan whole-kant | Part-whole tussen FunctionalComplexen |
| `«memberOf»` | `gufo:isCollectionMemberOf` | Object → Collection | Shared-diamant aan whole-kant | Part-whole: lid van een collectie |
| `«subCollectionOf»` | `gufo:isSubCollectionOf` | Collection → Collection | Shared-diamant aan whole-kant | Part-whole: sub-collectie van een collectie |
| `«subQuantityOf»` | `gufo:isSubQuantityOf` | Quantity → Quantity | Shared-diamant aan whole-kant | Part-whole: portie stof in portie stof |
| `«containment»` | `gufo:isObjectProperPartOf` (variant) ★ | Quantity → Container | Shared-diamant | Container–inhoud relatie; geen dedicated gUFO-property |
| `«structuration»` | `gufo:hasAssociatedQualityValueType` | Quality → QualityValue-type | Gestippelde pijl | Verbindt een Quality-type met zijn kwaliteitsruimte |
| `«instantiation»` | `rdf:type` (punning) | Class → Type (higher-order) | Gestippelde pijl | Toont dat een klasse een instantie is van een higher-order type |
| `«participation»` | `gufo:participatedIn` | Object → Event | Volle pijl | Object neemt deel aan een event |
| `«participational»` | `gufo:isEventProperPartOf` | Participation → Event | Volle pijl | Event-parthood; specifiek voor `gufo:Participation` |
| `«creation»` | `gufo:wasCreatedIn` | Object → Event | Volle pijl | Object wordt tot bestaan gebracht door het event |
| `«termination»` | `gufo:wasTerminatedIn` | Object → Event | Volle pijl | Object houdt op te bestaan door het event |
| `«manifestation»` | `gufo:manifestedIn` | Aspect → Event | Gestippelde pijl | Intrinsiek aspect manifesteert zich in een event |
| `«bringsAbout»` | `gufo:broughtAbout` | Event → Situation | Volle pijl | Event brengt een situatie tot stand |
| `«triggers»` | `gufo:contributedToTrigger` | Situation → Event | Volle pijl | Situatie draagt bij aan het triggeren van een event |
| `«historicalDependence»` | `gufo:historicallyDependsOn` | Event → Event | Gestippelde pijl | Historische afhankelijkheid tussen events |
| *(Generalisatie)* | `rdfs:subClassOf` | Subtype → Supertype | Open driehoek (UML) | Specialisatie/subClassOf; kan gegroepeerd worden in GeneralizationSets |

**Notatieprincipes samengevat:**
- *Gestippelde pijl* → dependentierelaties (characterization, mediation, externalDependence, derivation, structuration, instantiation, manifestation, historicalDependence)
- *Volle lijn* → materiële en vergelijkingsrelaties (material, comparative)
- *Shared-diamant aan whole-kant* → part-whole relaties (componentOf, memberOf, subCollectionOf, subQuantityOf, containment)
- *Volle pijl* → event-gerelateerde relaties (participation, participational, creation, termination, bringsAbout, triggers)
- *Open driehoek* → generalisatie (UML-standaard)

### 4.5 gUFO-concepten zonder direct OntoUML-equivalent

De editor heeft voor deze concepten een eigen gedocumenteerde visualisatieconventie nodig:

| gUFO Concept | Categorie | Voorgestelde editor-aanpak |
|---|---|---|
| `gufo:FunctionalComplex` | Instantieklasse | Impliciet via `«kind»` + tagged value `restrictedTo = functionalComplexNature` |
| `gufo:FixedCollection` / `gufo:VariableCollection` | Instantieklasse | Via `«collective»` + tagged value `isExtensional = true/false` |
| `gufo:ExtrinsicMode` | Instantieklasse | Aparte klasse-node met `«externalDependence»` relatie; te onderscheiden van `«mode»` |
| `gufo:Participation` | Instantieklasse | Subklasse van `«event»` met `«participational»`-relatie; eigenstandig visueel patroon |
| `gufo:QualityValue` | Instantieklasse | Node zichtbaar via `«structuration»` + kwaliteitsruimte-annotatie |
| Situatie-subklassen | Instantieklasse | Specialisatie van `«situation»` met tagged value voor situatietype |
| `gufo:RelationshipType` en subklassen | Metatype | Via `rdf:type` + `«material»` / `«comparative»` + `«instantiation»` relatie |
| `gufo:hasBeginPoint` / `gufo:hasEndPoint` e.a. | Data properties | Attributen op de node in het canvas |
| `gufo:constitutes` | Object property | Beschikbaar als unlabeled relatie; in editor te selecteren als eigenstandige pijl |

---

## 5. Product Scope & Functionaliteit

### 5.1 Kern: Grafische Editor (React Flow)

- Canvas-gebaseerde modelleeromgeving met drag-and-drop van alle 21 klasse-stereotypen en 21 relatiestereotypen
- Palet georganiseerd per categorie (Sortals, Non-sortals, Aspects, Events, Situations, Relations)
- Correcte OntoUML-visualisatie per stereotype: gestippelde pijlen, shared-diamanten, open driehoeken, volle lijnen
- Generalization Sets: aanmaken van complete/disjoint annotaties; visuele weergave conform OntoUML
- Meta-attributen als tagged values per element: `restrictedTo`, `isPowertype`, `isAbstract`, `isDerived`, `isExtensional`, `isOrdered`
- Automatische layout (hierarchisch, force-directed, orthogonaal), mini-map, zoom, pan, grid-snapping
- Multi-select, groepering, compartimenten voor attributen, undo/redo

### 5.2 gUFO-semantiek & Validatie

Real-time validatieregels, geïmplementeerd als SHACL shapes of SPARQL ASK-queries:

- `«kind»` mag niet specialiseren van een andere `«kind»`
- Een Endurant instantieert precies één `gufo:Kind`
- `«relator»` vereist minimaal 2 mediaties naar onderscheiden entiteiten
- `«mode»` en `«quality»` vereisen een `«characterization»` relatie met multiplicity = exact 1 aan de drager-kant
- Rigide types (`«kind»`, `«subkind»`, `«category»`) mogen niet specialiseren van anti-rigide types
- `«role»` vereist directe of indirecte verbinding met een `«mediation»`
- Phases komen altijd in partities (complete + disjoint generalization sets)
- `«material»`-relaties zijn altijd derived en vereisen een `«derivation»`-relatie naar een `«relator»`

Inline waarschuwingen en foutmeldingen in het canvas, gelinkt aan de relevante gUFO-axioma met uitleg.

- ★ **Guided modeling assistent**: contextgevoelige suggesties per stereotype
- ★ **Explain-knop**: toont de volledige gUFO-definitie, axioma's, OntoUML-constraints en voorbeelden per element

### 5.3 Graph Database Integratie

- Opslag als RDF-graph in **Ontotext GraphDB** of **Apache Jena Fuseki**
- Named graphs als isolatie-eenheid per ontologie en versie
- gUFO-referentie-ontologie als aparte read-only named graph
- ★ **SPARQL Query Interface**: ingebouwde Monaco-editor met syntax highlighting, autocomplete en resultaatweergave
- ★ **OWL Reasoning**: integratie met HermiT of ELK voor inferentie en consistency checking

### 5.4 Import & Export

- Export: Turtle (.ttl), RDF/XML, JSON-LD, N-Triples
- Import: RDF/OWL-bestanden met automatische herkenning van gUFO-patronen
- ★ Export naar **OntoUML JSON** conform OntoUML Vocabulary v1.1.0 (`https://w3id.org/ontouml#`)
- ★ Export naar **OntoUML Vocabulary (OWL/TTL)**: het model geserialiseerd als OntoUML-ontologie
- ★ **Documentatiegeneratie**: HTML- of PDF-rapport (namen, definities, relaties, restricties, gUFO-mapping)
- ★ Export naar PlantUML / Mermaid

### 5.5 ★ Versioning & Collaboration

- Git-achtige versiehistorie via named graphs per versie
- Branching & merging van ontologie-versies
- Multi-user real-time samenwerking (WebSocket + Yjs/Automerge CRDT)
- Commentaar & annotaties op elementen
- Audit trail als PROV-O triples

### 5.6 ★ Namespace & Ontologie-beheer

- Namespace manager met ondersteuning voor externe vocabulaires (schema.org, FOAF, Dublin Core, BFO, DOLCE)
- Ontologie-registry voor meerdere ontologieën in één werkruimte
- Dependency graph tussen geïmporteerde ontologieën

### 5.7 ★ Zoeken, Navigeren & Rapporteren

- Full-text zoeken door elementen, relaties en annotaties
- Hiërarchie-browser naast het canvas
- ★ Impact analyse bij aanpassing of verwijdering van elementen
- ★ Metrics Dashboard: statistieken per gUFO-categorie en OntoUML-stereotype

### 5.8 ★ Integratie & API

- REST API voor programmatische toegang
- Webhook-support voor CI/CD-integraties
- ★ Python SDK voor onderzoeks- en datapipeline-contexten
- ★ Plugin-systeem voor externe validatieregels en paletuitbreidingen

---

## 6. Epics & User Stories (selectie)

| Epic | User Story | Prioriteit |
|---|---|---|
| Canvas Editor | Als modelleur wil ik alle 21 klasse-stereotypen en 21 relatiestereotypen kunnen modelleren met de correcte OntoUML-visualisatie. | Must have |
| Canvas Editor | Als modelleur wil ik meta-attributen (`restrictedTo`, `isPowertype`, etc.) per element kunnen instellen. | Must have |
| Canvas Editor | Als modelleur wil ik generalization sets aanmaken met complete/disjoint annotaties. | Must have |
| OWL Punning | Als modelleur wil ik begrijpen dat mijn klasse tegelijk een OWL-klasse én een instantie van een metatype is, ondersteund door de editor. | Must have |
| Validatie | Als modelleur wil ik real-time feedback bij overtreding van een gUFO-axioma, met uitleg en link naar de spec. | Must have |
| Validatie | Als modelleur wil ik een guided hint als ik een `«relator»` aanmaak zonder mediaties. | Must have |
| gUFO Mapping | Als modelleur wil ik weten welke stereotypen geen directe gUFO-tegenhanger hebben. | Must have |
| Graph DB | Als engineer wil ik mijn ontologie opslaan als Turtle in een named graph in GraphDB. | Must have |
| Import/Export | Als architect wil ik exporteren naar OntoUML JSON conform de OntoUML Vocabulary v1.1.0. | Must have |
| Import/Export | Als architect wil ik een bestaande RDF/OWL-ontologie importeren met automatische gUFO-herkenning. | Should have |
| Versioning | Als teamlead wil ik versiehistorie en terugkeer naar een eerdere versie. | Should have |
| SPARQL UI | Als data architect wil ik SPARQL-queries uitvoeren vanuit de editor. | Should have |
| Reasoning | Als onderzoeker wil ik de OWL-reasoner activeren voor inferentie en consistency checking. | Could have |
| Documentatie | Als informatiemanager wil ik een HTML-rapport genereren voor stakeholdercommunicatie. | Should have |
| Collaboration | Als teamlid wil ik real-time samenwerken aan dezelfde ontologie. | Could have |

---

## 7. Technische Architectuur

### 7.1 Frontend

- React + TypeScript
- **React Flow**: custom node types per klasse-stereotype; custom edge types per relatiestereotyp (gestippeld, diamant, open driehoek, volle lijn/pijl)
- Zustand voor state management
- Tailwind CSS + shadcn/ui
- **Monaco Editor** voor SPARQL, Turtle-preview en annotaties
- **Yjs (CRDT)** voor real-time collaboratie

### 7.2 Backend

- Node.js + Fastify
- **N3.js** of **rdflib.js** voor RDF-manipulatie en Turtle-serialisatie/parsing
- SPARQL-client voor communicatie met de triple store
- OWL-reasoner als aparte Java-service (HermiT voor volledige OWL DL, ELK voor OWL EL)
- WebSocket (Socket.IO) voor samenwerking
- JWT + OAuth 2.0

### 7.3 Graph Database

- **Ontotext GraphDB** (primair; Enterprise voor volledige SHACL-support) of **Apache Jena Fuseki**
- Named graphs per ontologie-versie; gUFO-referentie-ontologie als read-only named graph
- Provenance via PROV-O triples bij elke wijziging

### 7.4 gUFO/OntoUML Kennisbasis

- gUFO OWL/TTL van `https://purl.org/nemo/gufo` als referentie-graph
- Validatieregels als **SHACL shapes** (uitvoerbaar op de triple store)
- **OntoUML–gUFO mapping tabel** als JSON-LD conform de OntoUML Vocabulary
- Stereotype-constraint tabel (OntoUML 2.0 paper, Tabel 1) geïmplementeerd in SHACL

### 7.5 Deployment

- Docker Compose voor lokale ontwikkeling
- Kubernetes Helm chart voor cloud-deployment
- CI/CD: GitHub Actions met geautomatiseerde SHACL-validatietests

---

## 8. Roadmap & Fasering

| Fase | Naam | Duur | Deliverables |
|---|---|---|---|
| Fase 0 | Fundament & Architectuur | 4 wk | Tech spike, Docker, gUFO geladen in GraphDB, OntoUML-gUFO mapping tabel v1, OWL punning aanpak |
| Fase 1 | MVP — Canvas + Opslaan | 8 wk | Canvas met alle 21 klasse + 21 relatiestereotypen, correcte pijlstijlen, opslaan/laden als Turtle |
| Fase 2 | Validatie & UX | 6 wk | Volledige SHACL-validatieregels, inline feedback, guided hints, explain-knop, generalization sets, meta-attributen |
| Fase 3 | Import/Export & Documentatie | 5 wk | Turtle/JSON-LD/RDF-XML export/import, OntoUML JSON v1.1.0 export, documentatiegeneratie |
| Fase 4 | SPARQL UI + Reasoning | 5 wk | SPARQL-editor (Monaco), OWL-reasoner, consistency checker |
| Fase 5 | Versioning & Collaboration | 6 wk | Versiehistorie (named graphs), branching, Yjs-samenwerking, PROV-O audit trail |
| Fase 6 | API & Integraties | 4 wk | REST API, webhooks, Python SDK, plugin-systeem v0 |
| Fase 7 | GA & Hardening | 4 wk | Security audit, performance (500 klassen / 1.000 relaties @ 60fps), usability tests, documentatie |

**Totale doorlooptijd: ~42 weken**

---

## 9. Risico's & Mitigatie

| Risico | Impact | Kans | Mitigatie |
|---|---|---|---|
| gUFO–OntoUML mapping is partieel en ambigue (`historicalRole`, `ExtrinsicMode`, situatie-subklassen) | Hoog | Hoog | Vroeg betrekken van ontologie-experts (NEMO/UT); mapping tabel iteratief verfijnen; niet-gemapte elementen expliciet documenteren in editor |
| OWL 2 punning (individuals-vs-types dualiteit) is moeilijk begrijpbaar voor modelleurs | Hoog | Hoog | Dedicated UI-patroon; inline uitleg en interactieve voorbeelden |
| React Flow schaalt slecht bij 500+ nodes | Middel | Middel | Vroege performance spike; virtualisatie van nodes buiten viewport; lazy loading |
| OWL-reasoner performance bij grote ontologieën | Hoog | Middel | Asynchrone requests; ELK als snellere DL-lite reasoner; caching |
| Real-time samenwerking geeft merge-conflicten | Middel | Middel | Yjs CRDT; conflict-resolutie UI; pessimistisch vergrendelen als fallback |
| Adoptie: modelleurs kennen OntoUML/gUFO niet | Hoog | Middel | In-app tutorials, interactieve voorbeeldontologieën, contextgevoelige help |

---

## 10. Definition of Done & Kwaliteitscriteria

### Functioneel

- Alle 21 klasse-stereotypen en 21 relatiestereotypen zijn modelleerbaar met correcte OntoUML-visualisatie
- Alle gUFO-axioma's zijn geïmplementeerd als SHACL shapes en getest
- Import/export is verliesvrij voor Turtle, RDF/XML, JSON-LD en OntoUML JSON v1.1.0
- OWL 2 punning (individuals-vs-types) is correct en begrijpelijk ondersteund

### Technisch

- Unit test coverage ≥ 80% op validatielogica
- End-to-end tests voor kritieke flows (Playwright)
- Canvas vloeiend bij 500 klassen + 1.000 relaties (60fps)
- SPARQL-queries < 2 seconden voor standaardqueries
- OWASP Top 10 passed

### UX

- Usability test met ≥ 5 ontologie-engineers; SUS-score ≥ 75
- WCAG 2.1 AA
- Responsive: bruikbaar op 1280px en breder

---

## 11. Open Vragen & Beslispunten

| # | Vraag | Eigenaar | Deadline |
|---|---|---|---|
| 1 | Welke gUFO-versie is de primaire target? (v1.0.0 of eventuele updates) | Product Owner | Sprint 0 |
| 2 | GraphDB Community of Enterprise? (Enterprise vereist voor volledige SHACL-support) | Architect | Sprint 0 |
| 3 | Multi-tenant SaaS of on-premise als primaire deploymentstrategie? | Stakeholders | Sprint 0 |
| 4 | Hoe visualiseren we OWL 2 punning in het canvas? Aparte UI-laag of overlay? | UX + Architect | Sprint 1 |
| 5 | HermiT (volledige OWL DL) of ELK (OWL EL, sneller)? | Architect | Fase 3 |
| 6 | Hoe mappen we `«historicalRole»` en `«historicalRoleMixin»` op gUFO? Via `gufo:historicallyDependsOn`? | Ontologie-expert | Sprint 1 |
| 7 | Moeten `«datatype»` en `«enumeration»` ondersteund worden voor volledige OntoUML-compatibiliteit? | Product Owner | Sprint 1 |
| 8 | Licentiemodel: open source (MIT/Apache 2.0) of commercieel? | Management | Fase 0 |

---

## 12. AI Agents als Socratische Gesprekspartner

### 12.1 Positionering en uitgangsprincipes

AI Agents in de gUFO Ontology Editor zijn geen validators, geen experts en geen beslissers. Ze zijn **Socratische gesprekspartners**: deelnemers die door het stellen van gerichte vragen, het aandragen van alternatieven en het blootleggen van impliciete aannames de kwaliteit van het model verbeteren — zonder zelf te bepalen welke keuzes gemaakt worden.

Dit onderscheid is niet alleen filosofisch maar heeft concrete architecturele en UX-consequenties. Een agent die zegt "dit is fout" creëert afhankelijkheid en ondermijnt eigenaarschap. Een agent die vraagt "wat bedoel je precies als je zegt dat een Klant een rol is — kan iemand tegelijkertijd klant zijn bij twee organisaties, en zo ja, zijn dat dan twee instanties van dezelfde rol?" dwingt de modelleur tot scherper denken zonder de beslissing over te nemen.

**Kernprincipes:**

- Agents doen **altijd** suggesties, nooit wijzigingen. De modelleur beslist.
- Agents formuleren bevindingen als **vragen of als alternatieven met argumentatie**, niet als oordelen.
- Agents tonen **altijd hun redenering** — welke aanname, welk UFO-principe, welke domeinkennis ligt ten grondslag aan de vraag?
- Agents hebben **geen stem in besluitvorming** over welke elementen wel of niet in het model worden opgenomen.
- De inbreng van agents wordt **gedocumenteerd als sessielogboek**, onderscheiden van de inbreng van menselijke deelnemers.
- Agents spreken op **uitnodiging** of op vooraf ingestelde momenten, niet proactief tussendoor.

### 12.2 De vier agenttypen

**Agent 1 — Domain Modeler**

Neemt een beschrijving van een casus of domein in natuurlijke taal en stelt een eerste gUFO-model voor: kandidaat-Kinds, Roles, Relators, Events en Situations, met beargumentering per keuze. De output is altijd een voorstel ter discussie, nooit een definitief model. De agent legt uit waarom hij bepaalde keuzes suggereert, en welke alternatieve interpretaties ook verdedigbaar zijn.

*Voorbeeldinteractie:*
> "Jullie beschrijven een situatie waarin een burger een aanvraag indient bij een gemeente. Ik stel voor 'Aanvraag' te modelleren als een Relator die de burger en de gemeente verbindt. Maar er is een alternatief: 'Aanvraag' als een zelfstandig Object waarvan burger en gemeente elk een Role vervullen. Welke van deze twee sluit beter aan bij hoe jullie over dit proces denken?"

**Agent 2 — Ontological Critic**

Analyseert een bestaand model en stelt gerichte vragen vanuit UFO-principes én wereldkennis. Richt zich niet op syntactische correctheid (dat doen de SHACL-validators al) maar op semantische adequaatheid: klopt het model met wat deelnemers weten over het domein?

*Voorbeeldinteractie:*
> "Jullie modelleren 'Medewerker' als een Role van 'Persoon'. Maar kan iemand tegelijkertijd medewerker zijn bij twee verschillende organisaties? En zo ja: zijn dat dan twee aparte Role-instanties van dezelfde Persoon? Is dat wat jullie bedoelen, of zien jullie 'Medewerker' als exclusief?"

**Agent 3 — Completeness Advisor**

Vergelijkt het model met bekende ontologiepatronen, referentieontologieën en domeinkennis, en signaleert wat mogelijk ontbreekt. Formuleert dit als een scopevraag, niet als een kritiek.

*Voorbeeldinteractie:*
> "Jullie modelleren een Dienstverleningsrelatie tussen Burger en Gemeente, maar ik zie nog geen representatie van wat er gebeurt als de dienstverlening eindigt — door tijdsverloop, opzegging of wijziging van omstandigheden. Is dat buiten scope, of willen jullie dat nog toevoegen?"

**Agent 4 — Devil's Advocate**

Genereert bewust grensgevallen en counter-cases: situaties in de werkelijkheid die het model niet kan representeren, of die het model op een onbedoelde manier zou classificeren. Dit is de meest confronterende maar ook meest waardevolle agent.

*Voorbeeldinteractie:*
> "Stel dat een persoon geen vaste woonplaats heeft. Past die persoon nog in jullie model? En wat als een organisatie zowel burger als dienstverlener is in verschillende contexten — denk aan een zorginstelling die ook zorg ontvangt? Zijn die twee gevallen modelleerbaar met wat jullie nu hebben?"

### 12.3 Technische vereisten voor de agentarchitectuur

**Context per agent-aanroep**

Elke agent-aanroep bevat ten minste: de volledige huidige ontologie als Turtle, de gUFO-referentie-ontologie, de relevante domeindocumentatie of casus-beschrijving, en de sessiehistorie (eerdere vragen, antwoorden en besluiten van deelnemers). Zonder deze context zijn agent-suggesties te generiek om waardevol te zijn.

**Traceerbaarheid van redenering**

Elke agent-uitingen bevat drie elementen: de vraag of het alternatief zelf, de redenering (welk UFO-principe of welke domeinkennis), en een indicatie van zekerheid ("dit is een veelgemaakte keuze in vergelijkbare ontologieën" vs. "dit is een open vraag waarover experts van mening verschillen").

**Sessielogboek**

Alle agent-inbreng wordt gelogd als onderdeel van de versiehistorie van het model, met expliciete markering dat het om agent-suggesties gaat, niet om beslissingen van deelnemers. Dit maakt de redeneergeschiedenis van het model reproduceerbaar en auditeerbaar.

**Governance van agentrollen**

De facilitator van een modelleersessie bepaalt welke agents actief zijn, op welke momenten ze spreken, en of hun inbreng direct zichtbaar is voor alle deelnemers of eerst gefilterd wordt. Dit voorkomt dat agents de groepsdynamiek domineren.

### 12.4 Spanningsveld: invloed zonder stemrecht

Een agent die altijd beschikbaar is, altijd artikuleert en nooit sociaal ongemak ervaart, heeft een structureel voordeel in een groepsdiscussie — ook zonder formele beslissingsmacht. Dit risico vraagt om expliciete spelregels:

- Agents spreken pas als een deelnemer of facilitator daar expliciet om vraagt.
- Agent-inbreng wordt visueel onderscheiden van menselijke inbreng in de sessie-interface.
- Deelnemers kunnen agent-suggesties negeren zonder dat dit geregistreerd of gesignaleerd wordt als "afwijking".
- De facilitator heeft een "agent-stilte"-modus voor momenten waarop de groep zonder AI-ondersteuning wil delibereren.

---

## 13. Ecosysteem van Perspectieven voor Waardegedreven Publieke Dienstverlening

### 13.1 Achtergrond en ambitie

De gUFO Ontology Editor wordt ingezet als onderdeel van een breder ecosysteem voor het modelleren en ontwerpen van **waardegedreven publieke dienstverlening**. In dit ecosysteem werken uiteenlopende partijen — beleidsmakers, uitvoerders, burgers, ontwerpers, domeinexperts — samen aan complexe vraagstukken vanuit meerdere perspectieven.

De centrale architectuurkeuze is dat alle perspectieven **geen aparte modellen** zijn die achteraf worden geïntegreerd, maar **projecties van één gemeenschappelijke ontologie**. Elk perspectief is van meet af aan uitgedrukt in gUFO. Een causaal diagram is geen apart model dat vertaald moet worden — het *is* gUFO, gepresenteerd via een perspectief-specifieke view. Een stakeholder is een UFO-C Agent, uitgedrukt als specialisatie van `gufo:Object`. Een gevolg in een causaliteitsketen is een `gufo:Situation`, voortgebracht door een `gufo:Event` via `gufo:broughtAbout`.

Vertaling tussen perspectieven is daarmee niet nodig. Consistentie is geen zorg die achteraf opgelost moet worden — ze is ingebakken in de architectuur. Wat wél verschilt per perspectief is uitsluitend de **presentatie aan de gebruiker**: de visuele taal, de terminologie, de interactiepatronen die aansluiten bij de denk- en werkwijze van de deelnemers in dat perspectief.

De perspectieven die het ecosysteem ondersteunt zijn:

| Perspectief | Theoretische basis | Kernconcepten in gUFO |
|---|---|---|
| **Causaal** | Causal Loop Diagrams (Forrester/Meadows), Causal Inference (Pearl) | `gufo:Event`, `gufo:Situation`, `gufo:broughtAbout`, `gufo:contributedToTrigger`, causale kwaliteiten als `gufo:Quality` |
| **Stakeholder** | UFO-C, Actor Analysis (i* framework), Value Sensitive Design | `gufo:Agent` (UFO-C), `gufo:IntrinsicMode` (belangen, intenties), `gufo:Commitment` (UFO-C Relator) |
| **Waarde** | Value Sensitive Design (Friedman c.s.), waarde-pluralisme | Waarden als `gufo:IntrinsicMode` of abstracte typen; waardespanningen als `gufo:Situation` |
| **Normatief / juridisch** | UFO-L rechtsbetrekkingen | `gufo:Norm`, `gufo:Right`, `gufo:Duty`, `gufo:LegalRelator` (UFO-L), institutionele agents |
| **Proces** | UFO-B events en perdurants | `gufo:Event`, `gufo:Participation`, temporele relaties, `gufo:EventType` |
| **Besluitvorming** | Decision ontology (Guizzardi/Mylopoulos) | `gufo:DecisionEvent`, `gufo:Intention` (UFO-C), normatieve grondslag via UFO-L |
| **Ontologisch** | gUFO / OntoUML volledig | Volledige OntoUML-notatie, alle stereotypen en relaties |

Het ontologische perspectief is niet het "echte" model waaruit de andere perspectieven zijn afgeleid — het is de *volledige view*, zichtbaar voor ontologie-engineers en gevorderde gebruikers die de onderliggende structuur willen inspecteren. De andere perspectieven zijn volledig gelijkwaardige, maar gefocuste views op hetzelfde model.

### 13.2 De basis-ontologie als kerncomponent

Het meest kritische onderdeel van het ecosysteem is niet de editor en niet de agents — het is de **basis-ontologie**: de gemeenschappelijke ontologische fundering die alle perspectieven draagt. Die basis-ontologie bestaat uit twee lagen.

**Laag 1: Bestaande UFO-extensies**

Guizzardi en collega's hebben een reeks domeinspecifieke UFO-extensies ontwikkeld die direct relevant zijn voor waardegedreven publieke dienstverlening. Deze worden als fundament opgenomen:

*UFO-B — Events en perdurants.* De volledige ontologie van events, participaties, temporele afhankelijkheden en causale relaties. UFO-B is minimalistisch geïmplementeerd in gUFO; de volledige extensie voegt onder meer toe: onderscheid tussen atomic en complex events, temporele kwalificatie van participaties, en causale afhankelijkheidsrelaties tussen events. Cruciaal voor het causale perspectief en het perspectief procesontwerp.

*UFO-C — Sociale entiteiten.* Agents met intenties en commitments, sociale objecten, normen als sociale objecten, institutionele rollen. UFO-C fundeert het stakeholderperspectief volledig: een Stakeholder is een `gufo:Agent` (UFO-C) met intentionele `gufo:IntrinsicMode`s (doelen, belangen), die via `gufo:Commitment`-Relators aan andere agents gebonden is. Afhankelijkheden uit het i* framework zijn UFO-C Commitments met specifieke modaliteit.

*UFO-L — Rechtsbetrekkingen.* Normen, rechten, plichten, bevoegdheden, rechtspersonen, institutionele feiten. UFO-L is direct relevant voor publieke dienstverlening: een bevoegdheid tot het verlenen van een vergunning is een `gufo:Right` dat inhereerst aan een institutionele agent (gemeente) via een normatieve `gufo:Situation`. Wetgeving is een sociaal object (UFO-C) dat normatieve situaties instelt.

*Decision ontology.* Beslissingen als events met intentionele grondslag (UFO-C) en normatieve grondslag (UFO-L), die situaties brengen en nieuwe events triggeren. Beslissingsalternatieven zijn `gufo:Situation`-types; preferentierelaties zijn comparatieve relaties in gUFO.

**Praktische uitdaging:** Niet alle UFO-extensies zijn volledig als OWL/gUFO beschikbaar. Sommige bestaan primair als referentieontologie in academische publicaties. Een eerste taak in de onderzoeksworkstream (zie §13.4) is een grondige inventarisatie: welke extensies zijn al als OWL-bestand beschikbaar, welke moeten worden geformaliseerd, en welke vragen nadere interpretatie van de oorspronkelijke auteurs?

**Laag 2: Te formaliseren wetenschappelijke theorieën**

Naast de bestaande UFO-extensies wil het ecosysteem zich ook baseren op wetenschappelijke theorieën die nog niet in UFO zijn uitgedrukt. Deze moeten eerst worden geformaliseerd in gUFO en daarna worden ondergebracht in de basis-ontologie. Dit is per definitie wetenschappelijk onderzoekswerk.

*Causal Loop Diagrams (systeemdynamica)*

Causal Loop Diagrams (CLDs) representeren variabelen en de versterkende of dempende causale relaties daartussen, inclusief feedback loops. De ontologische formalisering in gUFO vraagt om:

- Variabelen als `gufo:Quality`-types die inhereren in `gufo:Object`-instanties of `gufo:Situation`-instanties. Een variabele als "schuldenlast" is een `gufo:Quality` die inhereerst aan een `gufo:FunctionalComplex` (de schuldenaar).
- Causale relaties als specialisaties van `gufo:contributedToTrigger`, aangevuld met een polariteits-`gufo:Quality` (versterkend of dempend) en een vertragings-`gufo:Quality`.
- Feedback loops als cyclische ketens van causale relaties — een structureel patroon dat in SPARQL identificeerbaar is als een cycle in de relatie-graph.
- De dynamische, kwantitatieve aard van CLDs (variabelen die toenemen of afnemen) vraagt om een temporeel kwalificatiemechanisme: `gufo:TemporaryInstantiationSituation` of een specifieke extensie daarvan.

De kern-ontologische vraag: zijn CLD-variabelen *typen* van kwaliteiten (in de Taxonomy of Types) of *instanties* (in de Taxonomy of Individuals)? Waarschijnlijk beide, via OWL 2 punning — maar dit vereist zorgvuldige modellering.

*Actor Analysis (i* framework)*

Het i* framework modelleert actoren, hun doelen (hard goals en soft goals), taken, resources, en intentionele afhankelijkheden. De formalisering in gUFO:

- Actoren zijn `gufo:Agent`-specialisaties (UFO-C).
- Hard goals zijn `gufo:IntrinsicMode`s van het type "intentie" die inhereren aan een actor, en die een gewenste `gufo:Situation` als inhoud hebben.
- Soft goals (kwaliteitscriteria) zijn `gufo:IntrinsicMode`s van het type "preferentie", met een comparatieve relatie tot andere situaties.
- Taken zijn `gufo:EventType`s die actors kunnen uitvoeren.
- Intentionele afhankelijkheden zijn `gufo:Commitment`-Relators (UFO-C) waarbij de ene actor vertrouwt op de andere voor het realiseren van een goal of taak.
- Strategische rationale (SR-modellen) voegen interne decomposities toe: een goal decomposeert in subtaken via part-whole relaties op het niveau van intentionele structuren.

*Value Sensitive Design (Friedman c.s.)*

VSD onderscheidt directe en indirecte stakeholders, en beschouwt waarden als moreel geladen eigenschappen die expliciet in het ontwerp verankerd moeten worden. De centrale ontologische vraag — zijn waarden subjectief (gebonden aan een actor) of objectief (onafhankelijk van actoren) — is in de literatuur niet opgelost en vraagt om een expliciete positiekeuze in de basis-ontologie.

Twee verdedigbare posities:

*Positie A — Waarden als IntrinsicMode van agents.* Privacy is een `gufo:IntrinsicMode` die inhereerst aan een `gufo:Agent`. Waardenconflicten zijn situaties waarin twee `gufo:IntrinsicMode`s van dezelfde of verschillende agents in spanning staan. Dit is de subjectivistische positie: waarden bestaan in relatie tot actoren.

*Positie B — Waarden als abstracte typen met instanties.* Privacy is een `gufo:AbstractIndividualType` waarvan instanties voorkomen in concrete situaties. Een ontwerp dat privacy respecteert is een `gufo:Situation` die een instantie van het waardetype Privacy bevat. Dit is de objectivistische positie: waarden bestaan onafhankelijk van actoren, en situaties kunnen er meer of minder mee in overeenstemming zijn.

De keuze tussen deze posities heeft grote gevolgen voor hoe waarde-afwegingen worden gemodelleerd en hoe de waardeview eruitziet. Dit is een van de eerste beslissingen in de onderzoeksworkstream.

### 13.3 Architectuur: één graph, meerdere views

De implementatie van de perspectief-architectuur rust op drie principes.

**Één ontologische graph.** Alle perspectieven schrijven naar en lezen uit dezelfde GraphDB-instantie. Er is geen aparte datastore per perspectief. Een `gufo:Agent` die in de stakeholderview als "Burger" zichtbaar is, is dezelfde resource als de `gufo:Agent` die in de causale view als "betrokkene bij schuldenproblematiek" verschijnt, en dezelfde als de drager van het privacybelang in de waardeview.

**Views als SPARQL-projecties.** Elke perspectief-view is een set SPARQL-queries die een gefocuste subset van de graph ophaalt en visualiseert in de taal van dat perspectief. De causale view vraagt om alle `gufo:broughtAbout`- en `gufo:contributedToTrigger`-ketens. De stakeholderview vraagt om alle `gufo:Agent`-instanties met hun `gufo:IntrinsicMode`s en `gufo:Commitment`-Relators. De queries zijn gedeclareerd in de basis-ontologie, niet hardgecodeerd in de UI.

**Perspectief-ontologieën als view-definitie.** Voor elk perspectief wordt een kleine perspectief-ontologie onderhouden: een OWL-module die de subset van de basis-ontologie beschrijft die voor dat perspectief relevant is, inclusief de mapping van gUFO-concepten naar de terminologie die in de view wordt gebruikt. Deze perspectief-ontologieën zijn uitbreidbaar wanneer nieuwe theorieën worden toegevoegd.

```
┌─────────────────────────────────────────────────────────────┐
│                  Perspectief-views (UI)                      │
│  Causaal │ Stakeholder │ Waarde │ Normatief │ Proces │ Ontol │
└────────────────────────┬────────────────────────────────────┘
                         │  SPARQL-projecties
                         │  (perspectief-ontologieën)
┌────────────────────────▼────────────────────────────────────┐
│              Basis-ontologie (GraphDB)                       │
│  gUFO + UFO-B + UFO-C + UFO-L + Decision ontology           │
│  + CLD-formalisering + Actor Analysis + VSD                  │
└─────────────────────────────────────────────────────────────┘
```

### 13.4 De onderzoeksworkstream (Fase -1)

De basis-ontologie kan niet worden gebouwd als een IT-project tussen de sprints door. Het is een **wetenschappelijk project** met eigen methodologie, mijlpalen en kwaliteitscriteria. Daarvoor wordt een aparte onderzoeksworkstream gestart die parallel loopt aan — en voor een groot deel voorafgaat aan — de softwareontwikkeling.

De onderzoeksworkstream heeft vier fasen:

**Fase -1a: Inventarisatie van bestaande UFO-extensies** *(3 maanden)*

Systematische inventarisatie van alle beschikbare UFO-extensies: welke zijn als OWL/TTL beschikbaar, welke bestaan alleen in publicaties, welke zijn gedeeltelijk geformaliseerd? Output: een gedocumenteerde inventaris met beschikbaarheidsbeoordelingen en een prioritering op basis van relevantie voor het ecosysteem. Waar mogelijk: directe samenwerking met NEMO (LabES/UFES) voor toegang tot interne OWL-bestanden en interpretatie van publicaties.

**Fase -1b: Formalisering van UFO-extensies** *(4 maanden, parallel aan -1a)*

Formalisering van de geprioriteerde UFO-extensies die nog niet volledig als OWL beschikbaar zijn. Dit omvat: modellering in Protégé, SHACL-shapes voor validatie, en documentatie van ontwerpkeuzes. Validatie door ontologie-experts en, waar mogelijk, door de oorspronkelijke auteurs.

**Fase -1c: Formalisering van niet-UFO theorieën** *(6 maanden)*

Ontologische analyse en formalisering van Causal Loop Diagrams, Actor Analysis (i*) en Value Sensitive Design in gUFO. Per theorie: analyse van ontologische commitments, identificatie van UFO-primitieven, modellering, validatie door domeinexperts én ontologen. Expliciete documentatie van design decisions en openstaande vragen. Output: drie OWL-modules, integreerbaar in de basis-ontologie.

**Fase -1d: Integratie en validatie van de basis-ontologie** *(3 maanden)*

Integratie van alle modules tot een coherente basis-ontologie. Consistentiecheck via OWL-redeneerder (HermiT). Validatie via case studies: worden concrete vraagstukken uit waardegedreven publieke dienstverlening adequaat uitgedrukt? Aanpassing op basis van bevindingen. Output: basis-ontologie v1.0, gedocumenteerd en beschikbaar als OWL/TTL in een publiek repository.

De softwareontwikkeling (Fase 0 t/m 9) start zodra de basis-ontologie een stabiele v0.5 heeft bereikt — stabiel genoeg om op te bouwen, maar niet noodzakelijk volledig. De editor en de basis-ontologie worden daarna in iteraties samen volwassen.

**Samenwerkingspartners voor de onderzoeksworkstream:**
- NEMO / LabES (Universidade Federal do Espírito Santo) — Guizzardi's onderzoeksgroep
- Relevante Nederlandse kennisinstellingen (TU Delft, UvA, TNO) voor domeinkennis publieke dienstverlening
- Practitioners uit het domein als validatiepartners voor de case studies

### 13.5 Participatie zonder technische expertise

Een centrale eis is dat deelnemers **zo intuïtief mogelijk kunnen meedoen**, zonder kennis van gUFO, UFO-extensies of OWL te hoeven verwerven. De oplossing zit niet in het versimpelen van de ontologie — dat zou de precisie ondermijnen die het ecosysteem juist waardevol maakt. De oplossing zit in de **radicale scheiding tussen de modelleertaal en de participatietaal**.

Deelnemers werken uitsluitend in de taal van hun perspectief. Een beleidsmedewerker die in de causale view aangeeft dat "gegevensdeling leidt tot minder vertrouwen bij burgers" voegt een `gufo:contributedToTrigger`-relatie toe tussen een Event en een Situation — zonder dat ooit te zien of te weten. De perspectief-view vertaalt die handeling naar de juiste ontologische structuur op basis van de perspectief-ontologie.

De Socratische agents spelen hier een sleutelrol als *ontologische tolk*. Ze stellen vragen in begrijpelijke taal die wél ontologisch scherp zijn: "Je zegt dat gegevensdeling leidt tot minder vertrouwen. Is dat altijd zo, of alleen onder bepaalde omstandigheden? En bij welke burgers precies — alle burgers, of specifiek degenen die eerder negatieve ervaringen hadden?" Dit zijn intuïtief begrijpelijke vragen — en tegelijkertijd vragen die helpen specificeren of de relatie universeel of gesitueerd is, en aan welk subject het kwaliteitskenmerk "vertrouwen" inhereerst.

Terugkoppeling aan deelnemers gebeurt altijd in hun eigen taal. Als het systeem een besluit omzet naar een gUFO-triple, ziet de deelnemer: "Vastgelegd: gegevensdeling draagt bij aan een situatie van verminderd burgervertrouwen, met name bij burgers met eerdere negatieve ervaringen." Niet: "Toegevoegd: `ex:Gegevensdeling gufo:contributedToTrigger ex:VerminderdVertrouwenSituatie`."

### 13.6 Democratische besluitvorming en de rol van agents

Binnen elk perspectief werken partijen conform democratische principes aan het model. Beslissingen over de inhoud worden genomen door de deelnemers — niet door agents, engineers of het systeem. Elke deelnemer heeft een gelijke stem, ongeacht technische expertise. Het model reflecteert de gedeelde intentie van de groep, ook als een ontologie-engineer een andere modellering zou prefereren. De engineer kan dat signaleren — maar niet overrulen.

Agents nemen deel als uitgenodigde gesprekspartner zonder stemrecht. Ze stellen vragen, leggen alternatieven voor en maken consequenties van keuzes zichtbaar — maar bepalen nooit wat de groep besluit. Als de groep een keuze maakt die ontologisch suboptimaal is, documenteert de agent dat verschil van inzicht als informatie voor de groep, niet als bezwaar.

De facilitator bewaakt de balans. Een agent mag nooit de dominante stem in een sessie worden. Spelregels: agents spreken op uitnodiging of op vaste momenten, agent-inbreng is visueel onderscheiden van menselijke inbreng, deelnemers kunnen agent-suggesties negeren zonder registratie als "afwijking", en de facilitator heeft een agent-stilte-modus voor deliberatie zonder AI-aanwezigheid.

### 13.7 Sessiearchitectuur

Een modelleersessie heeft de volgende structuur:

**Voorbereiding.** De facilitator stelt het actieve perspectief in en laadt de relevante delen van het bestaande model. De Socratische agent krijgt als context mee: de huidige ontologie, de basis-ontologie, de casus-beschrijving en de sessiedoelen.

**Werksessie.** Deelnemers modelleren in hun perspectief-view. De perspectief-ontologie vertaalt hun handelingen naar gUFO-triples. De Socratische agent is beschikbaar op uitnodiging en stelt vragen in de taal van het perspectief. Agent-inbreng is zichtbaar als een aparte vragenlaag, onderscheiden van de inhoudelijke modellaag.

**Verificatie.** Na de werksessie controleert de SHACL-validator de consistentie van het model. De ontologie-engineer inspecteert de gegenereerde triples en kan technische issues signaleren. Bevindingen worden teruggekoppeld aan de groep in hun eigen taal.

**Documentatie.** Het sessielogboek — opgeslagen als PROV-O provenance in de graph database — bevat: alle besluiten van de groep, alle agent-vragen en -suggesties, de gegenereerde gUFO-triples, eventuele engineer-signaleringen, en openstaande vragen voor volgende sessies.

### 13.8 Technische vereisten

**Perspectief-ontologieën.** Voor elk perspectief een OWL-module die de relevante subset van de basis-ontologie beschrijft, inclusief terminologische mapping naar de taal van de view. Perspectief-ontologieën zijn declaratief en uitbreidbaar.

**Query-gestuurde views.** De perspectief-views zijn niet hardgecodeerd maar gegenereerd op basis van de perspectief-ontologieën. Wanneer een nieuwe theorie aan de basis-ontologie wordt toegevoegd, is de bijbehorende view in principe genereerbaar zonder nieuwe UI-code.

**Sessiebeheer.** Een sessie-module beheert deelnemers, roltoekenning (facilitator, deelnemer, engineer, waarnemer), agent-configuratie en het sessielogboek als PROV-O provenance.

**Toegankelijkheid als eerste eis.** Alle perspectief-views worden ontworpen voor deelnemers zonder technische achtergrond: begrijpelijke taal, minimale notatie, directe feedback in mensentaal. Geen zichtbare gUFO-techniek tenzij expliciet gewenst.

### 13.9 Uitbreiding van de roadmap

| Fase | Naam | Type | Duur | Deliverables |
|---|---|---|---|---|
| **Fase -1a** | Inventarisatie UFO-extensies | Onderzoek | 3 mnd | Inventaris beschikbaarheid en prioritering |
| **Fase -1b** | Formalisering UFO-extensies | Onderzoek | 4 mnd | OWL-modules UFO-B, UFO-C, UFO-L, Decision ontology |
| **Fase -1c** | Formalisering niet-UFO theorieën | Onderzoek | 6 mnd | OWL-modules CLD, Actor Analysis, VSD |
| **Fase -1d** | Integratie basis-ontologie | Onderzoek | 3 mnd | Basis-ontologie v1.0, case study validatie |
| **Fase 8** | Perspectief-views | Software | 10 wk | Causale view, stakeholderview, waardeview, normatieve view, procesview |
| **Fase 9** | Sessiebeheer & participatie | Software | 8 wk | Sessiebeheer, agent-governance, sessielogboek PROV-O, toegankelijkheidsaudit |

De softwareontwikkeling (Fase 0–7) start bij basis-ontologie v0.5. Fase 8 en 9 starten bij v1.0.

### 13.10 Aanvullende open vragen

| # | Vraag | Eigenaar | Deadline |
|---|---|---|---|
| 9 | Welke UFO-extensies zijn al als OWL beschikbaar, en welke moeten worden geformaliseerd? | Ontologie-onderzoeker | Fase -1a |
| 10 | Zijn waarden in VSD `gufo:IntrinsicMode`s van agents (subjectivistisch) of abstracte typen (objectivistisch)? | Ontologie-onderzoeker + filosoof | Fase -1c |
| 11 | Hoe worden de dynamische/kwantitatieve aspecten van CLD-variabelen uitgedrukt in een statische OWL-ontologie? | Ontologie-onderzoeker | Fase -1c |
| 12 | Welke samenwerking met NEMO/LabES is haalbaar voor validatie van de geformaliseerde UFO-extensies? | Projectleider | Fase -1a |
| 13 | Hoe worden democratische besluiten traceerbaar vastgelegd in de versiehistorie? | Architect | Fase 9 |
| 14 | Hoe voorkom je dat de agent een disproportionele invloed heeft in sessies met deelnemers zonder technische achtergrond? | Facilitator + UX | Fase 9 |
| 15 | Welke perspectief-views worden als eerste gebouwd? (prioritering op basis van vroegste gebruikersbehoefte) | Product Owner | Fase 0 |
| 16 | Zijn de perspectief-ontologieën volledig declaratief genereerbaar, of is per view toch handmatige UI-code nodig? | Architect | Fase 8 |

---

## 14. Referenties

- gUFO v1.0.0 specificatie: https://nemo-ufes.github.io/gufo/
- gUFO OWL/TTL bron: https://purl.org/nemo/gufo
- OntoUML Vocabulary v1.1.0: https://dev.ontouml.org/ontouml-vocabulary/
- OntoUML Metamodel: https://w3id.org/ontouml/metamodel
- Guizzardi et al. (2018), *Endurant Types in Ontology-Driven Conceptual Modeling: Towards OntoUML 2.0*, ER 2018
- Fonseca et al. (2019), *Relations in Ontology-Driven Conceptual Modeling*, ER 2019
- Almeida et al. (2019), *gUFO: A Lightweight Implementation of the Unified Foundational Ontology (UFO)*

---

*Einde Product Plan — gUFO Ontology Editor v3.0*
