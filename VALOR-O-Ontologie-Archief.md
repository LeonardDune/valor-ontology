# VALOR-O Ontologie Archief

Dit bestand bevat alle VALOR-O TTL-modules (ontologie + SHACL) als referentie voor nieuwe chats.
Gegenereerd: 2026-02-28. Status: modules 00a t/m 00g compleet.

---

## Module: 00a-gufo-core.ttl

```turtle
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix vo:    <https://valor-ecosystem.nl/ontology/> .

###############################################################################
# VALOR-O — Module 00a: gUFO Core
#
# Purpose : Declare the subset of gUFO 1.0 that VALOR-O actually uses.
#           This is NOT a full re-publication of gUFO; it is a curated
#           import that makes VALOR-O self-contained for documentation
#           and tooling purposes.
#
# Source  : Almeida et al. (2019), gUFO v1.0.0
#           https://nemo-ufes.github.io/gufo/
#           URI: https://nemo-ufes.github.io/gufo/gufo.ttl
#
# Module structuur (na invoeging UFO-B als aparte module):
#   00a-gufo-core.ttl      ← dit bestand: gUFO-primitieven
#   00b-ufo-b.ttl          ← UFO-B events en causaliteit (nieuw)
#   00c-ufo-c.ttl          ← UFO-C sociale entiteiten
#   00d-ufo-l.ttl          ← UFO-L rechtsbetrekkingen
#
# DESIGN DECISIONS (zie DESIGN-DECISIONS.md voor volledige rationale):
#   DD-001 · Curated subset i.p.v. owl:imports
#   DD-002 · OWL2 Punning als standaardpatroon
#   DD-003 · gUFO-primitieven uitgesloten van punning-verplichting
#   DD-004 · gufo:Participation — terminologisch conflict met UFO-B
#   DD-005 · Allen-relaties als SPARQL-queries, niet als OWL-properties
#
# In production: replace body of each class/property with
#   owl:imports <https://nemo-ufes.github.io/gufo/gufo.ttl>
# and remove the local declarations.
###############################################################################

vo:gufo-core
    a owl:Ontology ;
    dcterms:title "VALOR-O — gUFO Core subset"@nl ;
    dcterms:description
        "Curated subset of gUFO used as the foundational layer of VALOR-O."@nl ;
    owl:versionInfo "0.1" .


###############################################################################
# ── TAXONOMY OF INDIVIDUALS ──────────────────────────────────────────────────
#
#  ConcreteIndividual
#  ├── Endurant                  (wholly present at each instant)
#  │   ├── Object                (independent endurant)
#  │   │   └── FunctionalComplex
#  │   ├── Aspect                (existentially dependent)
#  │   │   ├── IntrinsicAspect
#  │   │   │   ├── IntrinsicMode   (unshareable, e.g. a belief)
#  │   │   │   └── Quality         (value-bearing intrinsic aspect)
#  │   │   └── ExtrinsicAspect
#  │   │       ├── Relator         (mediates a material relation)
#  │   │       └── ExtrinsicMode   (inheres in one; also depends on another)
#  │   └── Collection
#  └── Event                     (partially present / perdurant)
#      ├── Action
#      └── Participation
#  AbstractIndividual
#  └── QualityValue
#  Situation                      (a state of affairs)
###############################################################################

# ── Top ──────────────────────────────────────────────────────────────────────

gufo:Individual
    a owl:Class ;
    rdfs:label "Individual"@en ;
    rdfs:comment
        "Top of the taxonomy of individuals. Everything that exists as a
         particular (token) is an Individual."@en .

gufo:ConcreteIndividual
    a owl:Class ;
    rdfs:subClassOf gufo:Individual ;
    rdfs:label "ConcreteIndividual"@en .

gufo:AbstractIndividual
    a owl:Class ;
    rdfs:subClassOf gufo:Individual ;
    rdfs:label "AbstractIndividual"@en ;
    rdfs:comment
        "Individuals that are neither in space nor time, e.g. quality values,
         propositions."@en .

# ── Endurant branch ──────────────────────────────────────────────────────────

gufo:Endurant
    a owl:Class ;
    rdfs:subClassOf gufo:ConcreteIndividual ;
    rdfs:label "Endurant"@en ;
    rdfs:comment
        "A concrete individual that is wholly present whenever it exists.
         Endurants persist through time while potentially changing."@en .

gufo:Object
    a owl:Class ;
    rdfs:subClassOf gufo:Endurant ;
    rdfs:label "Object"@en ;
    rdfs:comment
        "An endurant that exists independently: its existence does not
         depend on the existence of any other particular endurant."@en .

gufo:FunctionalComplex
    a owl:Class ;
    rdfs:subClassOf gufo:Object ;
    rdfs:label "FunctionalComplex"@en ;
    rdfs:comment
        "An object whose parts play different functional roles, e.g. a
         person, an organisation, a car."@en .

gufo:Collection
    a owl:Class ;
    rdfs:subClassOf gufo:Endurant ;
    rdfs:label "Collection"@en ;
    rdfs:comment
        "An endurant whose parts play the same member role."@en .

# ── Aspect branch ─────────────────────────────────────────────────────────────

gufo:Aspect
    a owl:Class ;
    rdfs:subClassOf gufo:Endurant ;
    rdfs:label "Aspect"@en ;
    rdfs:comment
        "An existentially dependent endurant: it inheres in (or mediates
         between) other individuals."@en .

gufo:IntrinsicAspect
    a owl:Class ;
    rdfs:subClassOf gufo:Aspect ;
    rdfs:label "IntrinsicAspect"@en ;
    rdfs:comment "An aspect that inheres in exactly one individual."@en .

gufo:IntrinsicMode
    a owl:Class ;
    rdfs:subClassOf gufo:IntrinsicAspect ;
    rdfs:label "IntrinsicMode"@en ;
    rdfs:comment
        "An intrinsic aspect that is not directly associated with a quality
         structure (e.g. a belief, a disposition, an intention, a skill)."@en .

gufo:Quality
    a owl:Class ;
    rdfs:subClassOf gufo:IntrinsicAspect ;
    rdfs:label "Quality"@en ;
    rdfs:comment
        "An intrinsic aspect associated with a quality structure/dimension
         (e.g. temperature, mass, colour). Its value is a QualityValue."@en .

gufo:ExtrinsicAspect
    a owl:Class ;
    rdfs:subClassOf gufo:Aspect ;
    rdfs:label "ExtrinsicAspect"@en ;
    rdfs:comment
        "An aspect that depends on more than one individual."@en .

gufo:Relator
    a owl:Class ;
    rdfs:subClassOf gufo:ExtrinsicAspect ;
    rdfs:label "Relator"@en ;
    rdfs:comment
        "An extrinsic aspect that mediates a material relation between two
         or more objects. A relator unifies the relata into a nexus
         (e.g. a marriage, a contract, an employment)."@en .

gufo:ExtrinsicMode
    a owl:Class ;
    rdfs:subClassOf gufo:ExtrinsicAspect ;
    rdfs:label "ExtrinsicMode"@en ;
    rdfs:comment
        "An aspect that inheres in exactly one individual (its bearer) but
         is also externally dependent on another individual (the extrinsic
         object). Unlike a Relator, the dependence is asymmetric: there is
         one primary bearer and one external object.
         Examples: a social commitment (inheres in the committed agent,
         depends on the claimant); a belief about a person (inheres in the
         believer, depends on the believed-about individual).
         Source: gUFO 1.0 §2.7; UFO-C (Guizzardi et al. 2013)."@en .

# ── Event branch ──────────────────────────────────────────────────────────────

gufo:Event
    a owl:Class ;
    rdfs:subClassOf gufo:ConcreteIndividual ;
    rdfs:label "Event"@en ;
    rdfs:comment
        "A concrete individual that is spread across time and is only
         partially present at any given instant (perdurant)."@en .

gufo:Action
    a owl:Class ;
    rdfs:subClassOf gufo:Event ;
    rdfs:label "Action"@en ;
    rdfs:comment
        "An intentional event performed by an agent. The agent's intention
         is a constitutive aspect of the action."@en .

gufo:Participation
    a owl:Class ;
    rdfs:subClassOf gufo:Event ;
    rdfs:label "Participation"@en ;
    rdfs:comment
        """An event that represents the participation of an endurant in
         another event.

         [DD-004] TERMINOLOGISCH CONFLICT MET UFO-B:
         gUFO's gufo:Participation (subklasse van Event) is NIET identiek
         aan UFO-B 'Participation' (§3.2, axioma P4). UFO-B definieert
         Participation als afgeleide klasse: het maximale deel van een
         ComplexEvent dat exclusief afhangt van precies één Object:
           P4: ∀e:Event Participation(e) ↔ ∃!o:Object excDepends(e,o)
         Dit is een derivatie op event-mereologie, geen zelfstandige klasse.
         gUFO maakt er pragmatisch een concrete klasse van voor
         GraphDB/SPARQL-compatibiliteit.
         VALOR-O volgt gUFO hier. Zie 00b-ufo-b.ttl voor het mereologische
         patroon dat UFO-B Participation simuleert via SPARQL.
         Bron: UFO-B-2013 §3.2 (P1-P5); gUFO-spec §3.3."""@en .

# ── Situation ──────────────────────────────────────────────────────────────────

gufo:Situation
    a owl:Class ;
    rdfs:subClassOf gufo:ConcreteIndividual ;
    rdfs:label "Situation"@en ;
    rdfs:comment
        "A state of affairs: a (possibly complex) fact about the world at
         some time. Situations are neither endurants nor events."@en .

# ── AbstractIndividual subtypes ───────────────────────────────────────────────

gufo:QualityValue
    a owl:Class ;
    rdfs:subClassOf gufo:AbstractIndividual ;
    rdfs:label "QualityValue"@en ;
    rdfs:comment
        "The value of a quality in a quality dimension/structure
         (e.g. 36.6°C, red, 70 kg)."@en .


###############################################################################
# ── TAXONOMY OF TYPES ────────────────────────────────────────────────────────
#
#  Type (second-order entities — types of individuals)
#  ├── EndurantType
#  │   ├── Sortal               (provides identity)
#  │   │   ├── Kind             (rigid identity principle)
#  │   │   ├── SubKind
#  │   │   ├── Role             (anti-rigid, relational)
#  │   │   └── Phase            (anti-rigid, intrinsic)
#  │   └── NonSortal            (no identity principle of its own)
#  │       ├── Category         (rigid)
#  │       ├── Mixin            (non-rigid)
#  │       └── RoleMixin
#  ├── EventType
#  └── SituationType
###############################################################################

gufo:Type
    a owl:Class ;
    rdfs:label "Type"@en ;
    rdfs:comment
        "A second-order entity: a type of individual. Types classify
         individuals."@en .

gufo:EndurantType
    a owl:Class ;
    rdfs:subClassOf gufo:Type ;
    rdfs:label "EndurantType"@en .

gufo:Sortal
    a owl:Class ;
    rdfs:subClassOf gufo:EndurantType ;
    rdfs:label "Sortal"@en ;
    rdfs:comment
        "An EndurantType that provides or carries an identity principle for
         its instances."@en .

gufo:Kind
    a owl:Class ;
    rdfs:subClassOf gufo:Sortal ;
    rdfs:label "Kind"@en ;
    rdfs:comment
        "A rigid, ultimate sortal: provides an identity principle and every
         instance is necessarily an instance (rigid). A Kind cannot
         specialise another Kind."@en .

gufo:SubKind
    a owl:Class ;
    rdfs:subClassOf gufo:Sortal ;
    rdfs:label "SubKind"@en ;
    rdfs:comment
        "A rigid specialisation of a Kind. Instances are necessarily
         instances."@en .

gufo:Role
    a owl:Class ;
    rdfs:subClassOf gufo:Sortal ;
    rdfs:label "Role"@en ;
    rdfs:comment
        "An anti-rigid sortal: an individual plays a Role contingently,
         depending on participation in a relational context (Relator)."@en .

gufo:Phase
    a owl:Class ;
    rdfs:subClassOf gufo:Sortal ;
    rdfs:label "Phase"@en ;
    rdfs:comment
        "An anti-rigid sortal: an individual is in a Phase contingently,
         depending on intrinsic conditions. Phases of the same Kind must
         partition the population."@en .

gufo:NonSortal
    a owl:Class ;
    rdfs:subClassOf gufo:EndurantType ;
    rdfs:label "NonSortal"@en ;
    rdfs:comment
        "An EndurantType that aggregates properties from multiple Kinds
         without providing an identity principle."@en .

gufo:Category
    a owl:Class ;
    rdfs:subClassOf gufo:NonSortal ;
    rdfs:label "Category"@en ;
    rdfs:comment "A rigid non-sortal."@en .

gufo:Mixin
    a owl:Class ;
    rdfs:subClassOf gufo:NonSortal ;
    rdfs:label "Mixin"@en ;
    rdfs:comment "A non-rigid non-sortal."@en .

gufo:RoleMixin
    a owl:Class ;
    rdfs:subClassOf gufo:NonSortal ;
    rdfs:label "RoleMixin"@en ;
    rdfs:comment
        "A non-sortal whose instances are always playing some role
         in a relational context."@en .

gufo:EventType
    a owl:Class ;
    rdfs:subClassOf gufo:Type ;
    rdfs:label "EventType"@en .

gufo:SituationType
    a owl:Class ;
    rdfs:subClassOf gufo:Type ;
    rdfs:label "SituationType"@en .


###############################################################################
# ── OWL 2 PUNNING PATTERN ─────────────────────────────────────────────────────
#
#  In gUFO, a domain concept like "Person" is BOTH:
#    (a) an owl:Class  — so it can appear in subClassOf hierarchies and
#        restrictions (first-order use)
#    (b) an individual of type gufo:Kind — so it can appear as a value in
#        object-property assertions (second-order use)
#
#  OWL 2 allows a URI to denote both a class and an individual in the same
#  ontology (punning). VALOR-O uses this pattern throughout.
#
#  Convention:
#    :Person  a owl:Class, gufo:Kind .
#    :Person  rdfs:subClassOf gufo:FunctionalComplex .
###############################################################################


###############################################################################
# ── FOUNDATIONAL RELATIONS ────────────────────────────────────────────────────
###############################################################################

# ── Inherence ─────────────────────────────────────────────────────────────────

gufo:inheresIn
    a owl:ObjectProperty ;
    rdfs:label "inheres in"@en ;
    rdfs:domain gufo:Aspect ;
    rdfs:range  gufo:Endurant ;
    rdfs:comment
        "Relates an Aspect to the endurant it intrinsically depends upon.
         An Aspect cannot exist without its bearer."@en .

gufo:hasQuality
    a owl:ObjectProperty ;
    owl:inverseOf gufo:inheresIn ;
    rdfs:label "has quality / has aspect"@en ;
    rdfs:domain gufo:Endurant ;
    rdfs:range  gufo:Aspect .

# ── Mediation (Relator → Object) ──────────────────────────────────────────────

gufo:mediates
    a owl:ObjectProperty ;
    rdfs:subPropertyOf gufo:inheresIn ;
    rdfs:label "mediates"@en ;
    rdfs:domain gufo:Relator ;
    rdfs:range  gufo:Object ;
    rdfs:comment
        "Relates a Relator to one of the objects it connects. A Relator
         must mediate at least two distinct objects."@en .

# ── Material relation (derived from Relator) ──────────────────────────────────

gufo:isMaterialRelationBetween
    a owl:ObjectProperty ;
    rdfs:label "is material relation between"@en ;
    rdfs:comment
        "The material (non-reified) relation that is derived from a Relator.
         Typically expressed as a subproperty with specific domain/range."@en .

# ── Characterisation (IntrinsicMode → Object) ─────────────────────────────────

gufo:characterizes
    a owl:ObjectProperty ;
    rdfs:subPropertyOf gufo:inheresIn ;
    rdfs:label "characterizes"@en ;
    rdfs:domain gufo:IntrinsicAspect ;
    rdfs:range  gufo:Object .

# ── Quality value ─────────────────────────────────────────────────────────────

gufo:hasQualityValue
    a owl:ObjectProperty ;
    rdfs:label "has quality value"@en ;
    rdfs:domain gufo:Quality ;
    rdfs:range  gufo:QualityValue .

# ── Events ────────────────────────────────────────────────────────────────────

gufo:participatedIn
    a owl:ObjectProperty ;
    rdfs:label "participated in"@en ;
    rdfs:domain gufo:Object ;
    rdfs:range  gufo:Event .

gufo:hasParticipant
    a owl:ObjectProperty ;
    owl:inverseOf gufo:participatedIn ;
    rdfs:label "has participant"@en ;
    rdfs:domain gufo:Event ;
    rdfs:range  gufo:Object .

gufo:broughtAbout
    a owl:ObjectProperty ;
    rdfs:label "brought about"@en ;
    rdfs:domain gufo:Event ;
    rdfs:range  gufo:Situation ;
    rdfs:comment
        "Relates an event to the situation it produced. The situation begins
         to hold after the event concludes."@en .

gufo:contributedToTrigger
    a owl:ObjectProperty ;
    rdfs:label "contributed to trigger"@en ;
    rdfs:domain gufo:Situation ;
    rdfs:range  gufo:Event ;
    rdfs:comment
        "Relates a situation (the triggering condition) to an event it
         causally contributed to triggering."@en .

gufo:wasTriggeredBy
    a owl:ObjectProperty ;
    owl:inverseOf gufo:contributedToTrigger ;
    rdfs:label "was triggered by"@en ;
    rdfs:domain gufo:Event ;
    rdfs:range  gufo:Situation .

gufo:manifestedIn
    a owl:ObjectProperty ;
    rdfs:label "manifested in"@en ;
    rdfs:domain gufo:IntrinsicMode ;
    rdfs:range  gufo:Event ;
    rdfs:comment
        "An intrinsic mode (e.g. a capability, a disposition) that is
         realised or manifested in a particular event."@en .

# ── Situations ────────────────────────────────────────────────────────────────

gufo:isAspectOf
    a owl:ObjectProperty ;
    rdfs:label "is aspect of"@en ;
    rdfs:comment
        "Relates a Situation to an individual it is about or that it
         involves."@en .

# ── Parthood ──────────────────────────────────────────────────────────────────

gufo:isProperPartOf
    a owl:ObjectProperty ;
    a owl:TransitiveProperty ;
    a owl:AsymmetricProperty ;
    a owl:IrreflexiveProperty ;
    rdfs:label "is proper part of"@en .

gufo:isPartOf
    a owl:ObjectProperty ;
    a owl:TransitiveProperty ;
    rdfs:label "is part of"@en ;
    rdfs:comment "Reflexive closure of isProperPartOf."@en .

gufo:hasProperPart
    a owl:ObjectProperty ;
    owl:inverseOf gufo:isProperPartOf ;
    rdfs:label "has proper part"@en .

# ── Historical dependence ─────────────────────────────────────────────────────

gufo:historicallyDependsOn
    a owl:ObjectProperty ;
    rdfs:label "historically depends on"@en ;
    rdfs:comment
        "Relates an individual to another individual whose prior existence
         was necessary for the first individual to come into existence."@en .

# ── External dependence (ExtrinsicMode) ──────────────────────────────────────

gufo:externallyDependsOn
    a owl:ObjectProperty ;
    rdfs:label "externally depends on"@en ;
    rdfs:domain gufo:ExtrinsicAspect ;
    rdfs:range  gufo:Endurant ;
    rdfs:comment
        "Relates an ExtrinsicMode to the external individual it depends on
         (the extrinsic object — not the bearer). An ExtrinsicMode both
         inheres in its bearer (via gufo:inheresIn) and externally depends
         on another individual (via this property).
         Example: a social commitment inheres in the committed agent and
         externally depends on the claimant agent.
         Source: gUFO 1.0 §2.7; OntoUML «externalDependence»."@en .

# ── Creation and Termination of Endurants ────────────────────────────────────

gufo:wasCreatedIn
    a owl:ObjectProperty ;
    rdfs:label "was created in"@en ;
    rdfs:domain gufo:Endurant ;
    rdfs:range  gufo:Event ;
    rdfs:comment
        "Relates an endurant to the event in which it came into existence.
         Inverse direction of the OntoUML «creation» stereotype relation
         (Event → Endurant). Used as the gUFO anchor for «creation»
         properties in VALOR-O (DD-025)."@en .

gufo:wasTerminatedIn
    a owl:ObjectProperty ;
    rdfs:label "was terminated in"@en ;
    rdfs:domain gufo:Endurant ;
    rdfs:range  gufo:Event ;
    rdfs:comment
        "Relates an endurant to the event in which it ceased to exist.
         Inverse direction of the OntoUML «termination» stereotype relation
         (Event → Endurant). Used as the gUFO anchor for «termination»
         properties in VALOR-O (DD-025)."@en .

# ── Temporal ──────────────────────────────────────────────────────────────────

gufo:hasBeginPoint
    a owl:DatatypeProperty ;
    rdfs:label "has begin point"@en ;
    rdfs:range xsd:dateTime .

gufo:hasEndPoint
    a owl:DatatypeProperty ;
    rdfs:label "has end point"@en ;
    rdfs:range xsd:dateTime .


###############################################################################
# ── INTENTIONAL STATES (used in UFO-C, COoDM) ────────────────────────────────
#
#  Intentional states are IntrinsicModes with a propositional content.
#  gUFO defines the abstract taxonomy; UFO-C fills in the specifics.
###############################################################################

gufo:IntentionalMode
    a owl:Class ;
    rdfs:subClassOf gufo:IntrinsicMode ;
    rdfs:label "IntentionalMode"@en ;
    rdfs:comment
        "An IntrinsicMode with propositional content: beliefs, desires,
         intentions, goals, commitments as mental states."@en .

gufo:hasPropositionalContent
    a owl:ObjectProperty ;
    rdfs:label "has propositional content"@en ;
    rdfs:domain gufo:IntentionalMode ;
    rdfs:range  gufo:Situation ;
    rdfs:comment
        "Relates an intentional mode to the situation that constitutes its
         propositional content (the state of affairs it is about)."@en .


###############################################################################
# ── ANNOTATION PROPERTIES ─────────────────────────────────────────────────────
###############################################################################

gufo:stereotype
    a owl:AnnotationProperty ;
    rdfs:label "stereotype"@en ;
    rdfs:comment
        "OntoUML stereotype of the annotated class or property
         (e.g. «kind», «role», «relator», «mode»)."@en .

gufo:ontoumlStereotype
    a owl:AnnotationProperty ;
    rdfs:subPropertyOf gufo:stereotype ;
    rdfs:label "ontouml stereotype"@en .

###############################################################################
# END OF MODULE 00a — gUFO Core
###############################################################################
```

## Module: 00a-gufo-core.shacl.ttl

```turtle
@prefix sh:    <http://www.w3.org/ns/shacl#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix shg:  <https://valor-ecosystem.nl/shacl/gufo-core> .
@prefix vo:   <https://valor-ecosystem.nl/ontology/> .

###############################################################################
# VALOR-O — SHACL Shapes: gUFO Core (Module 00a)
#
# Validates structural constraints on gUFO primitives as used in VALOR-O.
# gUFO itself is an external ontology; these shapes guard how VALOR-O
# domain classes may extend it.
###############################################################################

shg
    a owl:Ontology ;
    dcterms:title "VALOR-O SHACL — gUFO Core"@nl ;
    owl:versionInfo "0.1" .


###############################################################################
# G1 — Every IntrinsicMode must inhere in exactly one Endurant
###############################################################################

gufo:IntrinsicModeShape
    a sh:NodeShape ;
    sh:targetClass gufo:IntrinsicMode ;
    sh:name "IntrinsicModeShape" ;
    sh:description
        "G1: Elke IntrinsicMode moet via gufo:inheresIn inheren aan
         precies één Endurant (gUFO axioma: modes zijn existentieel
         afhankelijk van hun drager)." ;

    sh:property [
        sh:path     gufo:inheresIn ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class    gufo:Endurant ;
        sh:name     "inheresIn" ;
        sh:message  "G1: IntrinsicMode.inheresIn vereist precies één gufo:Endurant."
    ] .


###############################################################################
# G1b — Every ExtrinsicMode must have exactly one primary bearer (inheresIn)
#        and at least one external dependent (externallyDependsOn)
###############################################################################

gufo:ExtrinsicModeShape
    a sh:NodeShape ;
    sh:targetClass gufo:ExtrinsicMode ;
    sh:name "ExtrinsicModeShape" ;
    sh:description
        "G1b: Elke ExtrinsicMode moet via gufo:inheresIn inheren aan
         precies één Endurant (de drager), én via gufo:externallyDependsOn
         afhankelijk zijn van ten minste één andere Endurant (het externe object).
         gUFO axioma: ExtrinsicMode heeft asymmetrische dubbele afhankelijkheid." ;

    sh:property [
        sh:path     gufo:inheresIn ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class    gufo:Endurant ;
        sh:name     "inheresIn" ;
        sh:message  "G1b: ExtrinsicMode.inheresIn vereist precies één gufo:Endurant (de primaire drager)."
    ] ;

    sh:property [
        sh:path     gufo:externallyDependsOn ;
        sh:minCount 1 ;
        sh:class    gufo:Endurant ;
        sh:name     "externallyDependsOn" ;
        sh:message  "G1b: ExtrinsicMode.externallyDependsOn vereist ten minste één gufo:Endurant (het externe object)."
    ] ;

    sh:sparql [
        sh:name    "G1b-drager-ne-extern" ;
        sh:message "G1b: De primaire drager (inheresIn) en het externe object (externallyDependsOn) mogen niet hetzelfde individu zijn." ;
        sh:prefixes shg ;
        sh:select  """
            SELECT $this WHERE {
                $this gufo:inheresIn          ?bearer .
                $this gufo:externallyDependsOn ?external .
                FILTER (?bearer = ?external)
            }
        """
    ] .


###############################################################################
# G2 — Every Relator must mediate at least two distinct Endurants
###############################################################################

gufo:RelatorShape
    a sh:NodeShape ;
    sh:targetClass gufo:Relator ;
    sh:name "RelatorShape" ;
    sh:description
        "G2: Elke Relator moet via gufo:mediates ten minste twee
         verschillende Endurants mediëren (gUFO: Relators zijn
         existentieel afhankelijk van meerdere individuen)." ;

    sh:property [
        sh:path     gufo:mediates ;
        sh:minCount 2 ;
        sh:class    gufo:Endurant ;
        sh:name     "mediates" ;
        sh:message  "G2: Relator.mediates vereist ten minste 2 gufo:Endurant instances."
    ] ;

    sh:sparql [
        sh:name    "G2b-distinct-mediated" ;
        sh:message "G2b: Een Relator mag niet tweemaal dezelfde Endurant mediëren." ;
        sh:prefixes shg ;
        sh:select  """
            SELECT $this
            WHERE {
                $this gufo:mediates ?e1 .
                $this gufo:mediates ?e2 .
                FILTER (?e1 = ?e2)
                FILTER NOT EXISTS {
                    $this gufo:mediates ?other .
                    FILTER (?other != ?e1)
                }
            }
        """
    ] .


###############################################################################
# G3 — Quality must have at most one hasQualityValue
###############################################################################

gufo:QualityShape
    a sh:NodeShape ;
    sh:targetClass gufo:Quality ;
    sh:name "QualityShape" ;
    sh:description
        "G3: Een Quality mag maximaal één hasQualityValue hebben
         (een kwaliteitsdimensie heeft één actuele waarde)." ;

    sh:property [
        sh:path     gufo:hasQualityValue ;
        sh:maxCount 1 ;
        sh:name     "hasQualityValue" ;
        sh:message  "G3: Quality.hasQualityValue mag maximaal één waarde hebben."
    ] .


###############################################################################
# G4 — Event must have hasBeginPoint ≤ hasEndPoint when both present
###############################################################################

gufo:EventTemporalShape
    a sh:NodeShape ;
    sh:targetClass gufo:Event ;
    sh:name "EventTemporalShape" ;
    sh:description
        "G4: Als een Event zowel hasBeginPoint als hasEndPoint heeft,
         moet het beginpunt voor of gelijk zijn aan het eindpunt." ;

    sh:sparql [
        sh:name    "G4-begin-before-end" ;
        sh:message "G4: gufo:hasBeginPoint moet ≤ gufo:hasEndPoint zijn." ;
        sh:prefixes shg ;
        sh:select  """
            SELECT $this
            WHERE {
                $this gufo:hasBeginPoint ?begin .
                $this gufo:hasEndPoint   ?end .
                FILTER (?begin > ?end)
            }
        """
    ] .


###############################################################################
# G5 — Situation must have at least one participanting Endurant
#       (via gufo:manifestedIn inverse or direct participation)
###############################################################################

gufo:SituationShape
    a sh:NodeShape ;
    sh:targetClass gufo:Situation ;
    sh:name "SituationShape" ;
    sh:description
        "G5: Een Situation die als NormativeSituation of DesignSituation
         wordt gebruikt, moet via gufo:manifestedIn ten minste één
         Endurant betrekken. (Waarschuwing, geen hard error.)" ;

    sh:severity sh:Warning ;
    sh:property [
        sh:path     [ sh:inversePath gufo:manifestedIn ] ;
        sh:minCount 1 ;
        sh:name     "manifestedBy" ;
        sh:message  "G5 (waarschuwing): Situation heeft geen Endurant via gufo:manifestedIn."
    ] .


###############################################################################
# G6 — IntentionalMode.hasPropositionalContent → Situation
#       (defined here at gUFO level; specialisations in UFO-C extend this)
###############################################################################

gufo:IntentionalModeContentShape
    a sh:NodeShape ;
    sh:targetClass gufo:IntentionalMode ;
    sh:name "IntentionalModeContentShape" ;
    sh:description
        "G6: Een IntentionalMode moet precies één hasPropositionalContent
         hebben van type gufo:Situation." ;

    sh:property [
        sh:path     gufo:hasPropositionalContent ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class    gufo:Situation ;
        sh:name     "hasPropositionalContent" ;
        sh:message  "G6: IntentionalMode.hasPropositionalContent vereist precies één gufo:Situation."
    ] .


###############################################################################
# G7 — OWL Punning: elke resource met gufo:ontoumlStereotype moet ook
#       rdf:type hebben naar het corresponderende gUFO-type-hiërarchietype
#
# DD-002: het punning-patroon geldt voor ALLE stereotypen, niet alleen
# voor «kind». De volledige stereotype → gUFO-type mapping:
#
#   Stereotype       → gUFO instantietype
#   ─────────────────────────────────────────────────────
#   kind             → gufo:Kind
#   subkind          → gufo:SubKind
#   role             → gufo:Role
#   historicalRole   → gufo:Role  (UFO-B-2019, geen apart type)
#   phase            → gufo:Phase
#   category         → gufo:Category
#   mixin            → gufo:Mixin
#   roleMixin        → gufo:RoleMixin
#   relator          → gufo:Relator
#   event            → gufo:EventType
#   situation        → gufo:SituationType
#
# Stereotypen ZONDER punning-verplichting — gUFO 1.0 definieert hiervoor
# geen Type in de Taxonomy of Types:
#   mode    → geen gUFO-Type (gUFO 1.0 heeft geen ModeType o.i.d.)
#   quality → geen gUFO-Type (gUFO 1.0 heeft geen QualityType o.i.d.)
#
# Verificatie: https://nemo-ufes.github.io/gufo/gufo.ttl (geraadpleegd 2026-02-27)
# Noot: gufo:NonQualitativeIntrinsicAspect en gufo:QualitativeIntrinsicAspect
# bestaan NIET in de echte gUFO TTL. Zie DD-029.
#
# Stereotypen ook zonder punning-verplichting:
#   collective, quantity (zeldzaam in VALOR), type, abstract,
#   datatype, enumeration (technisch/meta — niet in VALOR-O gebruikt).
#
# Implementatie: één SPARQL-constraint met VALUES-blok voor de volledige
# mapping. Eén violation per resource die de vereiste rdf:type mist.
#
# gUFO-primitieven (namespace http://purl.org/nemo/gufo#) zijn
# uitgesloten: zij ZIJN de type-hiërarchie, niet instanties ervan (DD-003).
###############################################################################

gufo:OntoumlPunningShape
    a sh:NodeShape ;
    sh:targetSubjectsOf gufo:ontoumlStereotype ;
    sh:name "OntoumlPunningShape" ;
    sh:description
        """G7: Elke resource met gufo:ontoumlStereotype moet via rdf:type
         het corresponderende gUFO-type-hiërarchietype dragen
         (OWL2 punning-conventie, DD-002).
         Geldt voor alle stereotypen met een gUFO-tegenhanger.
         gUFO-primitieven zijn uitgesloten (DD-003).""" ;

    sh:sparql [
        sh:name    "G7-punning-volledig" ;
        sh:message """G7: Resource met ontoumlStereotype '{?stereotype}' mist
         het vereiste rdf:type '{?vereistType}'.
         Voeg toe: <resource> rdf:type <vereistType> .
         (OWL2 punning — DD-002; gUFO-primitieven zijn uitgesloten — DD-003).""" ;
        sh:prefixes shg: ;
        sh:select  """
            SELECT $this ?stereotype ?vereistType
            WHERE {
                $this gufo:ontoumlStereotype ?stereotype .

                # Volledige stereotype → gUFO-type mapping (DD-002)
                VALUES (?stereotype ?vereistType) {
                    ( "kind"           gufo:Kind                              )
                    ( "subkind"        gufo:SubKind                           )
                    ( "role"           gufo:Role                              )
                    ( "historicalRole" gufo:Role                              )
                    ( "phase"          gufo:Phase                             )
                    ( "category"       gufo:Category                          )
                    ( "mixin"          gufo:Mixin                             )
                    ( "roleMixin"      gufo:RoleMixin                         )
                    ( "relator"        gufo:Relator                           )
                    ( "event"          gufo:EventType                         )
                    ( "situation"      gufo:SituationType                     )
                }
                # NB: "mode" en "quality" zijn NIET opgenomen omdat gUFO 1.0
                # geen ModeType of QualityType definieert in de Taxonomy of Types.
                # Verificatie: https://nemo-ufes.github.io/gufo/gufo.ttl (DD-029).

                # De vereiste rdf:type ontbreekt
                FILTER NOT EXISTS { $this rdf:type ?vereistType }

                # Sluit gUFO-primitieven uit: zij ZIJN de type-hiërarchie (DD-003)
                FILTER (!STRSTARTS(STR($this), "http://purl.org/nemo/gufo#"))
            }
        """
    ] .


###############################################################################
# Prefix declarations for SPARQL constraints
###############################################################################

shg
    a sh:PrefixDeclaration ;
    sh:declare [
        sh:prefix    "gufo" ;
        sh:namespace "http://purl.org/nemo/gufo#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "rdf" ;
        sh:namespace "http://www.w3.org/1999/02/22-rdf-syntax-ns#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "rdfs" ;
        sh:namespace "http://www.w3.org/2000/01/rdf-schema#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "owl" ;
        sh:namespace "http://www.w3.org/2002/07/owl#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "ufoc" ;
        sh:namespace "https://valor-ecosystem.nl/ontology/ufo-c#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "ufol" ;
        sh:namespace "https://valor-ecosystem.nl/ontology/ufo-l#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "xsd" ;
        sh:namespace "http://www.w3.org/2001/XMLSchema#"^^xsd:anyURI
    ] .



###############################################################################
# G8 — OntoUML Stereotype Combinatie Constraints (DD-026)
#
#  Valideert dat elke owl:ObjectProperty met een relatie-stereotype
#  een source-klasse (rdfs:domain) en target-klasse (rdfs:range) heeft
#  waarvan de stereotypen een geldige combinatie vormen conform
#  OntoUML 2.0 (Fonseca et al. 2019, Table 1).
#
#  Geldige relatie-stereotypen:
#    characterization, mediation, externalDependence, material,
#    comparative, participation, creation, termination, bringsAbout,
#    triggers, manifestation, historicalDependence, componentOf,
#    subCollectionOf, subQuantityOf, memberOf
#
#  Uitsluitingen:
#   - gUFO-namespace properties (zijn de primitieven zelf)
#   - Properties zonder ontoumlStereotype
#   - Klasse-stereotypen (kind, subkind, role, etc.)
#
#  Klasse-stereotypen worden opgezocht via gufo:ontoumlStereotype op de
#  domain- en range-klassen van de property. Ontbrekende domain of range
#  levert een G9-waarschuwing, geen error.
#
#  VALOR-O-afwijkingen gedocumenteerd in DD-026:
#   - hasCommitmentContent / hasDelegatedGoal: geen stereotype (Relator→Situation
#     valt buiten OntoUML 2.0; gUFO hasPropositionalContent-subproperty)
#   - excDependsOn: geen stereotype (UFO-B P1-axioma; Event→Object
#     valt buiten OntoUML 2.0 externalDependence-bereik)
#   - historicalDependence uitgebreid met Situation→Situation voor
#     FeedbackLoop-patroon in VALOR-B
###############################################################################

gufo:OntoumlRelationConstraintShape
    a sh:NodeShape ;
    sh:targetSubjectsOf gufo:ontoumlStereotype ;
    sh:name "OntoumlRelationConstraintShape" ;
    sh:description
        """G8: Elke owl:ObjectProperty met een relatie-stereotype moet een
         geldige combinatie van source- en target-stereotypen hebben conform
         OntoUML 2.0 (Fonseca et al. 2019, Table 1) en VALOR-O-extensies
         (DD-026). Zie DESIGN-DECISIONS.md DD-026 voor de volledige tabel
         met 518 geldige combinaties.""" ;

    sh:sparql [
        sh:name    "G8-stereotypecombinatie" ;
        sh:message """G8: Property heeft relatie-stereotype maar
         de combinatie (source-stereotype, target-stereotype) is niet geldig
         conform OntoUML 2.0 (Fonseca et al. 2019) en VALOR-O-extensies.
         Zie DESIGN-DECISIONS.md DD-026.""" ;
        sh:prefixes shg ;
        sh:select  """
            SELECT $this ?relStereo ?srcStereo ?tgtStereo
            WHERE {
                # Alleen owl:ObjectProperty
                $this a owl:ObjectProperty .

                # Property heeft een relatie-stereotype
                $this gufo:ontoumlStereotype ?relStereo .

                # Alleen relatie-stereotypen (niet klasse-stereotypen)
                VALUES ?relStereo {
                    "characterization" "mediation" "externalDependence"
                    "material" "comparative" "participation"
                    "creation" "termination" "bringsAbout"
                    "triggers" "manifestation" "historicalDependence"
                    "componentOf" "subCollectionOf" "subQuantityOf" "memberOf"
                }

                # Sluit gUFO-namespace properties uit
                FILTER (!STRSTARTS(STR($this), "http://purl.org/nemo/gufo#"))

                # Haal source-stereotype op via rdfs:domain van de property
                $this rdfs:domain ?srcClass .
                ?srcClass gufo:ontoumlStereotype ?srcStereo .

                # Haal target-stereotype op via rdfs:range van de property
                $this rdfs:range ?tgtClass .
                ?tgtClass gufo:ontoumlStereotype ?tgtStereo .

                # Combinatie ontbreekt in de geldige-combinaties-tabel
                FILTER NOT EXISTS {
                    VALUES (?relStereo ?srcStereo ?tgtStereo) {
                    ( "bringsAbout" "event" "situation" )
                    ( "characterization" "mode" "kind" )
                    ( "characterization" "mode" "subkind" )
                    ( "characterization" "mode" "role" )
                    ( "characterization" "mode" "historicalRole" )
                    ( "characterization" "mode" "phase" )
                    ( "characterization" "mode" "category" )
                    ( "characterization" "mode" "mixin" )
                    ( "characterization" "mode" "roleMixin" )
                    ( "characterization" "mode" "phaseMixin" )
                    ( "characterization" "mode" "relator" )
                    ( "characterization" "mode" "mode" )
                    ( "characterization" "mode" "quality" )
                    ( "characterization" "quality" "kind" )
                    ( "characterization" "quality" "subkind" )
                    ( "characterization" "quality" "role" )
                    ( "characterization" "quality" "historicalRole" )
                    ( "characterization" "quality" "phase" )
                    ( "characterization" "quality" "category" )
                    ( "characterization" "quality" "mixin" )
                    ( "characterization" "quality" "roleMixin" )
                    ( "characterization" "quality" "phaseMixin" )
                    ( "characterization" "quality" "relator" )
                    ( "characterization" "quality" "mode" )
                    ( "characterization" "quality" "quality" )
                    ( "characterization" "kind" "kind" )
                    ( "characterization" "kind" "subkind" )
                    ( "characterization" "kind" "role" )
                    ( "characterization" "kind" "historicalRole" )
                    ( "characterization" "kind" "phase" )
                    ( "characterization" "kind" "category" )
                    ( "characterization" "kind" "mixin" )
                    ( "characterization" "kind" "roleMixin" )
                    ( "characterization" "kind" "phaseMixin" )
                    ( "characterization" "kind" "relator" )
                    ( "characterization" "kind" "mode" )
                    ( "characterization" "kind" "quality" )
                    ( "characterization" "subkind" "kind" )
                    ( "characterization" "subkind" "subkind" )
                    ( "characterization" "subkind" "role" )
                    ( "characterization" "subkind" "historicalRole" )
                    ( "characterization" "subkind" "phase" )
                    ( "characterization" "subkind" "category" )
                    ( "characterization" "subkind" "mixin" )
                    ( "characterization" "subkind" "roleMixin" )
                    ( "characterization" "subkind" "phaseMixin" )
                    ( "characterization" "subkind" "relator" )
                    ( "characterization" "subkind" "mode" )
                    ( "characterization" "subkind" "quality" )
                    ( "characterization" "role" "kind" )
                    ( "characterization" "role" "subkind" )
                    ( "characterization" "role" "role" )
                    ( "characterization" "role" "historicalRole" )
                    ( "characterization" "role" "phase" )
                    ( "characterization" "role" "category" )
                    ( "characterization" "role" "mixin" )
                    ( "characterization" "role" "roleMixin" )
                    ( "characterization" "role" "phaseMixin" )
                    ( "characterization" "role" "relator" )
                    ( "characterization" "role" "mode" )
                    ( "characterization" "role" "quality" )
                    ( "characterization" "historicalRole" "kind" )
                    ( "characterization" "historicalRole" "subkind" )
                    ( "characterization" "historicalRole" "role" )
                    ( "characterization" "historicalRole" "historicalRole" )
                    ( "characterization" "historicalRole" "phase" )
                    ( "characterization" "historicalRole" "category" )
                    ( "characterization" "historicalRole" "mixin" )
                    ( "characterization" "historicalRole" "roleMixin" )
                    ( "characterization" "historicalRole" "phaseMixin" )
                    ( "characterization" "historicalRole" "relator" )
                    ( "characterization" "historicalRole" "mode" )
                    ( "characterization" "historicalRole" "quality" )
                    ( "characterization" "phase" "kind" )
                    ( "characterization" "phase" "subkind" )
                    ( "characterization" "phase" "role" )
                    ( "characterization" "phase" "historicalRole" )
                    ( "characterization" "phase" "phase" )
                    ( "characterization" "phase" "category" )
                    ( "characterization" "phase" "mixin" )
                    ( "characterization" "phase" "roleMixin" )
                    ( "characterization" "phase" "phaseMixin" )
                    ( "characterization" "phase" "relator" )
                    ( "characterization" "phase" "mode" )
                    ( "characterization" "phase" "quality" )
                    ( "characterization" "category" "kind" )
                    ( "characterization" "category" "subkind" )
                    ( "characterization" "category" "role" )
                    ( "characterization" "category" "historicalRole" )
                    ( "characterization" "category" "phase" )
                    ( "characterization" "category" "category" )
                    ( "characterization" "category" "mixin" )
                    ( "characterization" "category" "roleMixin" )
                    ( "characterization" "category" "phaseMixin" )
                    ( "characterization" "category" "relator" )
                    ( "characterization" "category" "mode" )
                    ( "characterization" "category" "quality" )
                    ( "characterization" "mixin" "kind" )
                    ( "characterization" "mixin" "subkind" )
                    ( "characterization" "mixin" "role" )
                    ( "characterization" "mixin" "historicalRole" )
                    ( "characterization" "mixin" "phase" )
                    ( "characterization" "mixin" "category" )
                    ( "characterization" "mixin" "mixin" )
                    ( "characterization" "mixin" "roleMixin" )
                    ( "characterization" "mixin" "phaseMixin" )
                    ( "characterization" "mixin" "relator" )
                    ( "characterization" "mixin" "mode" )
                    ( "characterization" "mixin" "quality" )
                    ( "characterization" "roleMixin" "kind" )
                    ( "characterization" "roleMixin" "subkind" )
                    ( "characterization" "roleMixin" "role" )
                    ( "characterization" "roleMixin" "historicalRole" )
                    ( "characterization" "roleMixin" "phase" )
                    ( "characterization" "roleMixin" "category" )
                    ( "characterization" "roleMixin" "mixin" )
                    ( "characterization" "roleMixin" "roleMixin" )
                    ( "characterization" "roleMixin" "phaseMixin" )
                    ( "characterization" "roleMixin" "relator" )
                    ( "characterization" "roleMixin" "mode" )
                    ( "characterization" "roleMixin" "quality" )
                    ( "characterization" "phaseMixin" "kind" )
                    ( "characterization" "phaseMixin" "subkind" )
                    ( "characterization" "phaseMixin" "role" )
                    ( "characterization" "phaseMixin" "historicalRole" )
                    ( "characterization" "phaseMixin" "phase" )
                    ( "characterization" "phaseMixin" "category" )
                    ( "characterization" "phaseMixin" "mixin" )
                    ( "characterization" "phaseMixin" "roleMixin" )
                    ( "characterization" "phaseMixin" "phaseMixin" )
                    ( "characterization" "phaseMixin" "relator" )
                    ( "characterization" "phaseMixin" "mode" )
                    ( "characterization" "phaseMixin" "quality" )
                    ( "characterization" "relator" "kind" )
                    ( "characterization" "relator" "subkind" )
                    ( "characterization" "relator" "role" )
                    ( "characterization" "relator" "historicalRole" )
                    ( "characterization" "relator" "phase" )
                    ( "characterization" "relator" "category" )
                    ( "characterization" "relator" "mixin" )
                    ( "characterization" "relator" "roleMixin" )
                    ( "characterization" "relator" "phaseMixin" )
                    ( "characterization" "relator" "relator" )
                    ( "characterization" "relator" "mode" )
                    ( "characterization" "relator" "quality" )
                    ( "comparative" "kind" "kind" )
                    ( "comparative" "kind" "subkind" )
                    ( "comparative" "kind" "role" )
                    ( "comparative" "kind" "historicalRole" )
                    ( "comparative" "kind" "phase" )
                    ( "comparative" "kind" "category" )
                    ( "comparative" "kind" "mixin" )
                    ( "comparative" "kind" "roleMixin" )
                    ( "comparative" "kind" "phaseMixin" )
                    ( "comparative" "subkind" "kind" )
                    ( "comparative" "subkind" "subkind" )
                    ( "comparative" "subkind" "role" )
                    ( "comparative" "subkind" "historicalRole" )
                    ( "comparative" "subkind" "phase" )
                    ( "comparative" "subkind" "category" )
                    ( "comparative" "subkind" "mixin" )
                    ( "comparative" "subkind" "roleMixin" )
                    ( "comparative" "subkind" "phaseMixin" )
                    ( "comparative" "role" "kind" )
                    ( "comparative" "role" "subkind" )
                    ( "comparative" "role" "role" )
                    ( "comparative" "role" "historicalRole" )
                    ( "comparative" "role" "phase" )
                    ( "comparative" "role" "category" )
                    ( "comparative" "role" "mixin" )
                    ( "comparative" "role" "roleMixin" )
                    ( "comparative" "role" "phaseMixin" )
                    ( "comparative" "historicalRole" "kind" )
                    ( "comparative" "historicalRole" "subkind" )
                    ( "comparative" "historicalRole" "role" )
                    ( "comparative" "historicalRole" "historicalRole" )
                    ( "comparative" "historicalRole" "phase" )
                    ( "comparative" "historicalRole" "category" )
                    ( "comparative" "historicalRole" "mixin" )
                    ( "comparative" "historicalRole" "roleMixin" )
                    ( "comparative" "historicalRole" "phaseMixin" )
                    ( "comparative" "phase" "kind" )
                    ( "comparative" "phase" "subkind" )
                    ( "comparative" "phase" "role" )
                    ( "comparative" "phase" "historicalRole" )
                    ( "comparative" "phase" "phase" )
                    ( "comparative" "phase" "category" )
                    ( "comparative" "phase" "mixin" )
                    ( "comparative" "phase" "roleMixin" )
                    ( "comparative" "phase" "phaseMixin" )
                    ( "comparative" "category" "kind" )
                    ( "comparative" "category" "subkind" )
                    ( "comparative" "category" "role" )
                    ( "comparative" "category" "historicalRole" )
                    ( "comparative" "category" "phase" )
                    ( "comparative" "category" "category" )
                    ( "comparative" "category" "mixin" )
                    ( "comparative" "category" "roleMixin" )
                    ( "comparative" "category" "phaseMixin" )
                    ( "comparative" "mixin" "kind" )
                    ( "comparative" "mixin" "subkind" )
                    ( "comparative" "mixin" "role" )
                    ( "comparative" "mixin" "historicalRole" )
                    ( "comparative" "mixin" "phase" )
                    ( "comparative" "mixin" "category" )
                    ( "comparative" "mixin" "mixin" )
                    ( "comparative" "mixin" "roleMixin" )
                    ( "comparative" "mixin" "phaseMixin" )
                    ( "comparative" "roleMixin" "kind" )
                    ( "comparative" "roleMixin" "subkind" )
                    ( "comparative" "roleMixin" "role" )
                    ( "comparative" "roleMixin" "historicalRole" )
                    ( "comparative" "roleMixin" "phase" )
                    ( "comparative" "roleMixin" "category" )
                    ( "comparative" "roleMixin" "mixin" )
                    ( "comparative" "roleMixin" "roleMixin" )
                    ( "comparative" "roleMixin" "phaseMixin" )
                    ( "comparative" "phaseMixin" "kind" )
                    ( "comparative" "phaseMixin" "subkind" )
                    ( "comparative" "phaseMixin" "role" )
                    ( "comparative" "phaseMixin" "historicalRole" )
                    ( "comparative" "phaseMixin" "phase" )
                    ( "comparative" "phaseMixin" "category" )
                    ( "comparative" "phaseMixin" "mixin" )
                    ( "comparative" "phaseMixin" "roleMixin" )
                    ( "comparative" "phaseMixin" "phaseMixin" )
                    ( "componentOf" "kind" "kind" )
                    ( "componentOf" "kind" "subkind" )
                    ( "componentOf" "kind" "role" )
                    ( "componentOf" "kind" "historicalRole" )
                    ( "componentOf" "kind" "phase" )
                    ( "componentOf" "kind" "category" )
                    ( "componentOf" "kind" "mixin" )
                    ( "componentOf" "kind" "roleMixin" )
                    ( "componentOf" "kind" "phaseMixin" )
                    ( "componentOf" "kind" "mode" )
                    ( "componentOf" "kind" "quality" )
                    ( "componentOf" "kind" "relator" )
                    ( "componentOf" "kind" "situation" )
                    ( "componentOf" "subkind" "kind" )
                    ( "componentOf" "subkind" "subkind" )
                    ( "componentOf" "subkind" "role" )
                    ( "componentOf" "subkind" "historicalRole" )
                    ( "componentOf" "subkind" "phase" )
                    ( "componentOf" "subkind" "category" )
                    ( "componentOf" "subkind" "mixin" )
                    ( "componentOf" "subkind" "roleMixin" )
                    ( "componentOf" "subkind" "phaseMixin" )
                    ( "componentOf" "subkind" "mode" )
                    ( "componentOf" "subkind" "quality" )
                    ( "componentOf" "subkind" "relator" )
                    ( "componentOf" "subkind" "situation" )
                    ( "componentOf" "role" "kind" )
                    ( "componentOf" "role" "subkind" )
                    ( "componentOf" "role" "role" )
                    ( "componentOf" "role" "historicalRole" )
                    ( "componentOf" "role" "phase" )
                    ( "componentOf" "role" "category" )
                    ( "componentOf" "role" "mixin" )
                    ( "componentOf" "role" "roleMixin" )
                    ( "componentOf" "role" "phaseMixin" )
                    ( "componentOf" "role" "mode" )
                    ( "componentOf" "role" "quality" )
                    ( "componentOf" "role" "relator" )
                    ( "componentOf" "role" "situation" )
                    ( "componentOf" "historicalRole" "kind" )
                    ( "componentOf" "historicalRole" "subkind" )
                    ( "componentOf" "historicalRole" "role" )
                    ( "componentOf" "historicalRole" "historicalRole" )
                    ( "componentOf" "historicalRole" "phase" )
                    ( "componentOf" "historicalRole" "category" )
                    ( "componentOf" "historicalRole" "mixin" )
                    ( "componentOf" "historicalRole" "roleMixin" )
                    ( "componentOf" "historicalRole" "phaseMixin" )
                    ( "componentOf" "historicalRole" "mode" )
                    ( "componentOf" "historicalRole" "quality" )
                    ( "componentOf" "historicalRole" "relator" )
                    ( "componentOf" "historicalRole" "situation" )
                    ( "componentOf" "phase" "kind" )
                    ( "componentOf" "phase" "subkind" )
                    ( "componentOf" "phase" "role" )
                    ( "componentOf" "phase" "historicalRole" )
                    ( "componentOf" "phase" "phase" )
                    ( "componentOf" "phase" "category" )
                    ( "componentOf" "phase" "mixin" )
                    ( "componentOf" "phase" "roleMixin" )
                    ( "componentOf" "phase" "phaseMixin" )
                    ( "componentOf" "phase" "mode" )
                    ( "componentOf" "phase" "quality" )
                    ( "componentOf" "phase" "relator" )
                    ( "componentOf" "phase" "situation" )
                    ( "componentOf" "category" "kind" )
                    ( "componentOf" "category" "subkind" )
                    ( "componentOf" "category" "role" )
                    ( "componentOf" "category" "historicalRole" )
                    ( "componentOf" "category" "phase" )
                    ( "componentOf" "category" "category" )
                    ( "componentOf" "category" "mixin" )
                    ( "componentOf" "category" "roleMixin" )
                    ( "componentOf" "category" "phaseMixin" )
                    ( "componentOf" "category" "mode" )
                    ( "componentOf" "category" "quality" )
                    ( "componentOf" "category" "relator" )
                    ( "componentOf" "category" "situation" )
                    ( "componentOf" "mixin" "kind" )
                    ( "componentOf" "mixin" "subkind" )
                    ( "componentOf" "mixin" "role" )
                    ( "componentOf" "mixin" "historicalRole" )
                    ( "componentOf" "mixin" "phase" )
                    ( "componentOf" "mixin" "category" )
                    ( "componentOf" "mixin" "mixin" )
                    ( "componentOf" "mixin" "roleMixin" )
                    ( "componentOf" "mixin" "phaseMixin" )
                    ( "componentOf" "mixin" "mode" )
                    ( "componentOf" "mixin" "quality" )
                    ( "componentOf" "mixin" "relator" )
                    ( "componentOf" "mixin" "situation" )
                    ( "componentOf" "roleMixin" "kind" )
                    ( "componentOf" "roleMixin" "subkind" )
                    ( "componentOf" "roleMixin" "role" )
                    ( "componentOf" "roleMixin" "historicalRole" )
                    ( "componentOf" "roleMixin" "phase" )
                    ( "componentOf" "roleMixin" "category" )
                    ( "componentOf" "roleMixin" "mixin" )
                    ( "componentOf" "roleMixin" "roleMixin" )
                    ( "componentOf" "roleMixin" "phaseMixin" )
                    ( "componentOf" "roleMixin" "mode" )
                    ( "componentOf" "roleMixin" "quality" )
                    ( "componentOf" "roleMixin" "relator" )
                    ( "componentOf" "roleMixin" "situation" )
                    ( "componentOf" "phaseMixin" "kind" )
                    ( "componentOf" "phaseMixin" "subkind" )
                    ( "componentOf" "phaseMixin" "role" )
                    ( "componentOf" "phaseMixin" "historicalRole" )
                    ( "componentOf" "phaseMixin" "phase" )
                    ( "componentOf" "phaseMixin" "category" )
                    ( "componentOf" "phaseMixin" "mixin" )
                    ( "componentOf" "phaseMixin" "roleMixin" )
                    ( "componentOf" "phaseMixin" "phaseMixin" )
                    ( "componentOf" "phaseMixin" "mode" )
                    ( "componentOf" "phaseMixin" "quality" )
                    ( "componentOf" "phaseMixin" "relator" )
                    ( "componentOf" "phaseMixin" "situation" )
                    ( "componentOf" "mode" "kind" )
                    ( "componentOf" "mode" "subkind" )
                    ( "componentOf" "mode" "role" )
                    ( "componentOf" "mode" "historicalRole" )
                    ( "componentOf" "mode" "phase" )
                    ( "componentOf" "mode" "category" )
                    ( "componentOf" "mode" "mixin" )
                    ( "componentOf" "mode" "roleMixin" )
                    ( "componentOf" "mode" "phaseMixin" )
                    ( "componentOf" "mode" "mode" )
                    ( "componentOf" "mode" "quality" )
                    ( "componentOf" "mode" "relator" )
                    ( "componentOf" "mode" "situation" )
                    ( "componentOf" "quality" "kind" )
                    ( "componentOf" "quality" "subkind" )
                    ( "componentOf" "quality" "role" )
                    ( "componentOf" "quality" "historicalRole" )
                    ( "componentOf" "quality" "phase" )
                    ( "componentOf" "quality" "category" )
                    ( "componentOf" "quality" "mixin" )
                    ( "componentOf" "quality" "roleMixin" )
                    ( "componentOf" "quality" "phaseMixin" )
                    ( "componentOf" "quality" "mode" )
                    ( "componentOf" "quality" "quality" )
                    ( "componentOf" "quality" "relator" )
                    ( "componentOf" "quality" "situation" )
                    ( "componentOf" "relator" "kind" )
                    ( "componentOf" "relator" "subkind" )
                    ( "componentOf" "relator" "role" )
                    ( "componentOf" "relator" "historicalRole" )
                    ( "componentOf" "relator" "phase" )
                    ( "componentOf" "relator" "category" )
                    ( "componentOf" "relator" "mixin" )
                    ( "componentOf" "relator" "roleMixin" )
                    ( "componentOf" "relator" "phaseMixin" )
                    ( "componentOf" "relator" "mode" )
                    ( "componentOf" "relator" "quality" )
                    ( "componentOf" "relator" "relator" )
                    ( "componentOf" "relator" "situation" )
                    ( "componentOf" "situation" "kind" )
                    ( "componentOf" "situation" "subkind" )
                    ( "componentOf" "situation" "role" )
                    ( "componentOf" "situation" "historicalRole" )
                    ( "componentOf" "situation" "phase" )
                    ( "componentOf" "situation" "category" )
                    ( "componentOf" "situation" "mixin" )
                    ( "componentOf" "situation" "roleMixin" )
                    ( "componentOf" "situation" "phaseMixin" )
                    ( "componentOf" "situation" "mode" )
                    ( "componentOf" "situation" "quality" )
                    ( "componentOf" "situation" "relator" )
                    ( "componentOf" "situation" "situation" )
                    ( "creation" "event" "kind" )
                    ( "creation" "event" "subkind" )
                    ( "creation" "event" "role" )
                    ( "creation" "event" "historicalRole" )
                    ( "creation" "event" "phase" )
                    ( "creation" "event" "relator" )
                    ( "creation" "event" "mode" )
                    ( "creation" "event" "quality" )
                    ( "externalDependence" "mode" "kind" )
                    ( "externalDependence" "mode" "subkind" )
                    ( "externalDependence" "mode" "role" )
                    ( "externalDependence" "mode" "historicalRole" )
                    ( "externalDependence" "mode" "phase" )
                    ( "externalDependence" "mode" "category" )
                    ( "externalDependence" "mode" "mixin" )
                    ( "externalDependence" "mode" "roleMixin" )
                    ( "externalDependence" "mode" "phaseMixin" )
                    ( "externalDependence" "mode" "relator" )
                    ( "externalDependence" "mode" "situation" )
                    ( "externalDependence" "quality" "kind" )
                    ( "externalDependence" "quality" "subkind" )
                    ( "externalDependence" "quality" "role" )
                    ( "externalDependence" "quality" "historicalRole" )
                    ( "externalDependence" "quality" "phase" )
                    ( "externalDependence" "quality" "category" )
                    ( "externalDependence" "quality" "mixin" )
                    ( "externalDependence" "quality" "roleMixin" )
                    ( "externalDependence" "quality" "phaseMixin" )
                    ( "externalDependence" "quality" "relator" )
                    ( "externalDependence" "quality" "situation" )
                    ( "historicalDependence" "kind" "kind" )
                    ( "historicalDependence" "kind" "subkind" )
                    ( "historicalDependence" "kind" "role" )
                    ( "historicalDependence" "kind" "historicalRole" )
                    ( "historicalDependence" "kind" "phase" )
                    ( "historicalDependence" "kind" "category" )
                    ( "historicalDependence" "kind" "mixin" )
                    ( "historicalDependence" "kind" "roleMixin" )
                    ( "historicalDependence" "kind" "phaseMixin" )
                    ( "historicalDependence" "kind" "mode" )
                    ( "historicalDependence" "kind" "quality" )
                    ( "historicalDependence" "kind" "relator" )
                    ( "historicalDependence" "kind" "situation" )
                    ( "historicalDependence" "kind" "event" )
                    ( "historicalDependence" "subkind" "kind" )
                    ( "historicalDependence" "subkind" "subkind" )
                    ( "historicalDependence" "subkind" "role" )
                    ( "historicalDependence" "subkind" "historicalRole" )
                    ( "historicalDependence" "subkind" "phase" )
                    ( "historicalDependence" "subkind" "category" )
                    ( "historicalDependence" "subkind" "mixin" )
                    ( "historicalDependence" "subkind" "roleMixin" )
                    ( "historicalDependence" "subkind" "phaseMixin" )
                    ( "historicalDependence" "subkind" "mode" )
                    ( "historicalDependence" "subkind" "quality" )
                    ( "historicalDependence" "subkind" "relator" )
                    ( "historicalDependence" "subkind" "situation" )
                    ( "historicalDependence" "subkind" "event" )
                    ( "historicalDependence" "role" "kind" )
                    ( "historicalDependence" "role" "subkind" )
                    ( "historicalDependence" "role" "role" )
                    ( "historicalDependence" "role" "historicalRole" )
                    ( "historicalDependence" "role" "phase" )
                    ( "historicalDependence" "role" "category" )
                    ( "historicalDependence" "role" "mixin" )
                    ( "historicalDependence" "role" "roleMixin" )
                    ( "historicalDependence" "role" "phaseMixin" )
                    ( "historicalDependence" "role" "mode" )
                    ( "historicalDependence" "role" "quality" )
                    ( "historicalDependence" "role" "relator" )
                    ( "historicalDependence" "role" "situation" )
                    ( "historicalDependence" "role" "event" )
                    ( "historicalDependence" "historicalRole" "kind" )
                    ( "historicalDependence" "historicalRole" "subkind" )
                    ( "historicalDependence" "historicalRole" "role" )
                    ( "historicalDependence" "historicalRole" "historicalRole" )
                    ( "historicalDependence" "historicalRole" "phase" )
                    ( "historicalDependence" "historicalRole" "category" )
                    ( "historicalDependence" "historicalRole" "mixin" )
                    ( "historicalDependence" "historicalRole" "roleMixin" )
                    ( "historicalDependence" "historicalRole" "phaseMixin" )
                    ( "historicalDependence" "historicalRole" "mode" )
                    ( "historicalDependence" "historicalRole" "quality" )
                    ( "historicalDependence" "historicalRole" "relator" )
                    ( "historicalDependence" "historicalRole" "situation" )
                    ( "historicalDependence" "historicalRole" "event" )
                    ( "historicalDependence" "phase" "kind" )
                    ( "historicalDependence" "phase" "subkind" )
                    ( "historicalDependence" "phase" "role" )
                    ( "historicalDependence" "phase" "historicalRole" )
                    ( "historicalDependence" "phase" "phase" )
                    ( "historicalDependence" "phase" "category" )
                    ( "historicalDependence" "phase" "mixin" )
                    ( "historicalDependence" "phase" "roleMixin" )
                    ( "historicalDependence" "phase" "phaseMixin" )
                    ( "historicalDependence" "phase" "mode" )
                    ( "historicalDependence" "phase" "quality" )
                    ( "historicalDependence" "phase" "relator" )
                    ( "historicalDependence" "phase" "situation" )
                    ( "historicalDependence" "phase" "event" )
                    ( "historicalDependence" "category" "kind" )
                    ( "historicalDependence" "category" "subkind" )
                    ( "historicalDependence" "category" "role" )
                    ( "historicalDependence" "category" "historicalRole" )
                    ( "historicalDependence" "category" "phase" )
                    ( "historicalDependence" "category" "category" )
                    ( "historicalDependence" "category" "mixin" )
                    ( "historicalDependence" "category" "roleMixin" )
                    ( "historicalDependence" "category" "phaseMixin" )
                    ( "historicalDependence" "category" "mode" )
                    ( "historicalDependence" "category" "quality" )
                    ( "historicalDependence" "category" "relator" )
                    ( "historicalDependence" "category" "situation" )
                    ( "historicalDependence" "category" "event" )
                    ( "historicalDependence" "mixin" "kind" )
                    ( "historicalDependence" "mixin" "subkind" )
                    ( "historicalDependence" "mixin" "role" )
                    ( "historicalDependence" "mixin" "historicalRole" )
                    ( "historicalDependence" "mixin" "phase" )
                    ( "historicalDependence" "mixin" "category" )
                    ( "historicalDependence" "mixin" "mixin" )
                    ( "historicalDependence" "mixin" "roleMixin" )
                    ( "historicalDependence" "mixin" "phaseMixin" )
                    ( "historicalDependence" "mixin" "mode" )
                    ( "historicalDependence" "mixin" "quality" )
                    ( "historicalDependence" "mixin" "relator" )
                    ( "historicalDependence" "mixin" "situation" )
                    ( "historicalDependence" "mixin" "event" )
                    ( "historicalDependence" "roleMixin" "kind" )
                    ( "historicalDependence" "roleMixin" "subkind" )
                    ( "historicalDependence" "roleMixin" "role" )
                    ( "historicalDependence" "roleMixin" "historicalRole" )
                    ( "historicalDependence" "roleMixin" "phase" )
                    ( "historicalDependence" "roleMixin" "category" )
                    ( "historicalDependence" "roleMixin" "mixin" )
                    ( "historicalDependence" "roleMixin" "roleMixin" )
                    ( "historicalDependence" "roleMixin" "phaseMixin" )
                    ( "historicalDependence" "roleMixin" "mode" )
                    ( "historicalDependence" "roleMixin" "quality" )
                    ( "historicalDependence" "roleMixin" "relator" )
                    ( "historicalDependence" "roleMixin" "situation" )
                    ( "historicalDependence" "roleMixin" "event" )
                    ( "historicalDependence" "phaseMixin" "kind" )
                    ( "historicalDependence" "phaseMixin" "subkind" )
                    ( "historicalDependence" "phaseMixin" "role" )
                    ( "historicalDependence" "phaseMixin" "historicalRole" )
                    ( "historicalDependence" "phaseMixin" "phase" )
                    ( "historicalDependence" "phaseMixin" "category" )
                    ( "historicalDependence" "phaseMixin" "mixin" )
                    ( "historicalDependence" "phaseMixin" "roleMixin" )
                    ( "historicalDependence" "phaseMixin" "phaseMixin" )
                    ( "historicalDependence" "phaseMixin" "mode" )
                    ( "historicalDependence" "phaseMixin" "quality" )
                    ( "historicalDependence" "phaseMixin" "relator" )
                    ( "historicalDependence" "phaseMixin" "situation" )
                    ( "historicalDependence" "phaseMixin" "event" )
                    ( "historicalDependence" "mode" "kind" )
                    ( "historicalDependence" "mode" "subkind" )
                    ( "historicalDependence" "mode" "role" )
                    ( "historicalDependence" "mode" "historicalRole" )
                    ( "historicalDependence" "mode" "phase" )
                    ( "historicalDependence" "mode" "category" )
                    ( "historicalDependence" "mode" "mixin" )
                    ( "historicalDependence" "mode" "roleMixin" )
                    ( "historicalDependence" "mode" "phaseMixin" )
                    ( "historicalDependence" "mode" "mode" )
                    ( "historicalDependence" "mode" "quality" )
                    ( "historicalDependence" "mode" "relator" )
                    ( "historicalDependence" "mode" "situation" )
                    ( "historicalDependence" "mode" "event" )
                    ( "historicalDependence" "quality" "kind" )
                    ( "historicalDependence" "quality" "subkind" )
                    ( "historicalDependence" "quality" "role" )
                    ( "historicalDependence" "quality" "historicalRole" )
                    ( "historicalDependence" "quality" "phase" )
                    ( "historicalDependence" "quality" "category" )
                    ( "historicalDependence" "quality" "mixin" )
                    ( "historicalDependence" "quality" "roleMixin" )
                    ( "historicalDependence" "quality" "phaseMixin" )
                    ( "historicalDependence" "quality" "mode" )
                    ( "historicalDependence" "quality" "quality" )
                    ( "historicalDependence" "quality" "relator" )
                    ( "historicalDependence" "quality" "situation" )
                    ( "historicalDependence" "quality" "event" )
                    ( "historicalDependence" "relator" "kind" )
                    ( "historicalDependence" "relator" "subkind" )
                    ( "historicalDependence" "relator" "role" )
                    ( "historicalDependence" "relator" "historicalRole" )
                    ( "historicalDependence" "relator" "phase" )
                    ( "historicalDependence" "relator" "category" )
                    ( "historicalDependence" "relator" "mixin" )
                    ( "historicalDependence" "relator" "roleMixin" )
                    ( "historicalDependence" "relator" "phaseMixin" )
                    ( "historicalDependence" "relator" "mode" )
                    ( "historicalDependence" "relator" "quality" )
                    ( "historicalDependence" "relator" "relator" )
                    ( "historicalDependence" "relator" "situation" )
                    ( "historicalDependence" "relator" "event" )
                    ( "historicalDependence" "situation" "kind" )
                    ( "historicalDependence" "situation" "subkind" )
                    ( "historicalDependence" "situation" "role" )
                    ( "historicalDependence" "situation" "historicalRole" )
                    ( "historicalDependence" "situation" "phase" )
                    ( "historicalDependence" "situation" "category" )
                    ( "historicalDependence" "situation" "mixin" )
                    ( "historicalDependence" "situation" "roleMixin" )
                    ( "historicalDependence" "situation" "phaseMixin" )
                    ( "historicalDependence" "situation" "mode" )
                    ( "historicalDependence" "situation" "quality" )
                    ( "historicalDependence" "situation" "relator" )
                    ( "historicalDependence" "situation" "situation" )
                    ( "historicalDependence" "situation" "event" )
                    ( "historicalDependence" "event" "kind" )
                    ( "historicalDependence" "event" "subkind" )
                    ( "historicalDependence" "event" "role" )
                    ( "historicalDependence" "event" "historicalRole" )
                    ( "historicalDependence" "event" "phase" )
                    ( "historicalDependence" "event" "category" )
                    ( "historicalDependence" "event" "mixin" )
                    ( "historicalDependence" "event" "roleMixin" )
                    ( "historicalDependence" "event" "phaseMixin" )
                    ( "historicalDependence" "event" "mode" )
                    ( "historicalDependence" "event" "quality" )
                    ( "historicalDependence" "event" "relator" )
                    ( "historicalDependence" "event" "situation" )
                    ( "historicalDependence" "event" "event" )
                    ( "manifestation" "mode" "event" )
                    ( "manifestation" "quality" "event" )
                    ( "material" "kind" "kind" )
                    ( "material" "kind" "subkind" )
                    ( "material" "kind" "role" )
                    ( "material" "kind" "historicalRole" )
                    ( "material" "kind" "phase" )
                    ( "material" "kind" "category" )
                    ( "material" "kind" "mixin" )
                    ( "material" "kind" "roleMixin" )
                    ( "material" "kind" "phaseMixin" )
                    ( "material" "kind" "relator" )
                    ( "material" "subkind" "kind" )
                    ( "material" "subkind" "subkind" )
                    ( "material" "subkind" "role" )
                    ( "material" "subkind" "historicalRole" )
                    ( "material" "subkind" "phase" )
                    ( "material" "subkind" "category" )
                    ( "material" "subkind" "mixin" )
                    ( "material" "subkind" "roleMixin" )
                    ( "material" "subkind" "phaseMixin" )
                    ( "material" "subkind" "relator" )
                    ( "material" "role" "kind" )
                    ( "material" "role" "subkind" )
                    ( "material" "role" "role" )
                    ( "material" "role" "historicalRole" )
                    ( "material" "role" "phase" )
                    ( "material" "role" "category" )
                    ( "material" "role" "mixin" )
                    ( "material" "role" "roleMixin" )
                    ( "material" "role" "phaseMixin" )
                    ( "material" "role" "relator" )
                    ( "material" "historicalRole" "kind" )
                    ( "material" "historicalRole" "subkind" )
                    ( "material" "historicalRole" "role" )
                    ( "material" "historicalRole" "historicalRole" )
                    ( "material" "historicalRole" "phase" )
                    ( "material" "historicalRole" "category" )
                    ( "material" "historicalRole" "mixin" )
                    ( "material" "historicalRole" "roleMixin" )
                    ( "material" "historicalRole" "phaseMixin" )
                    ( "material" "historicalRole" "relator" )
                    ( "material" "phase" "kind" )
                    ( "material" "phase" "subkind" )
                    ( "material" "phase" "role" )
                    ( "material" "phase" "historicalRole" )
                    ( "material" "phase" "phase" )
                    ( "material" "phase" "category" )
                    ( "material" "phase" "mixin" )
                    ( "material" "phase" "roleMixin" )
                    ( "material" "phase" "phaseMixin" )
                    ( "material" "phase" "relator" )
                    ( "material" "category" "kind" )
                    ( "material" "category" "subkind" )
                    ( "material" "category" "role" )
                    ( "material" "category" "historicalRole" )
                    ( "material" "category" "phase" )
                    ( "material" "category" "category" )
                    ( "material" "category" "mixin" )
                    ( "material" "category" "roleMixin" )
                    ( "material" "category" "phaseMixin" )
                    ( "material" "category" "relator" )
                    ( "material" "mixin" "kind" )
                    ( "material" "mixin" "subkind" )
                    ( "material" "mixin" "role" )
                    ( "material" "mixin" "historicalRole" )
                    ( "material" "mixin" "phase" )
                    ( "material" "mixin" "category" )
                    ( "material" "mixin" "mixin" )
                    ( "material" "mixin" "roleMixin" )
                    ( "material" "mixin" "phaseMixin" )
                    ( "material" "mixin" "relator" )
                    ( "material" "roleMixin" "kind" )
                    ( "material" "roleMixin" "subkind" )
                    ( "material" "roleMixin" "role" )
                    ( "material" "roleMixin" "historicalRole" )
                    ( "material" "roleMixin" "phase" )
                    ( "material" "roleMixin" "category" )
                    ( "material" "roleMixin" "mixin" )
                    ( "material" "roleMixin" "roleMixin" )
                    ( "material" "roleMixin" "phaseMixin" )
                    ( "material" "roleMixin" "relator" )
                    ( "material" "phaseMixin" "kind" )
                    ( "material" "phaseMixin" "subkind" )
                    ( "material" "phaseMixin" "role" )
                    ( "material" "phaseMixin" "historicalRole" )
                    ( "material" "phaseMixin" "phase" )
                    ( "material" "phaseMixin" "category" )
                    ( "material" "phaseMixin" "mixin" )
                    ( "material" "phaseMixin" "roleMixin" )
                    ( "material" "phaseMixin" "phaseMixin" )
                    ( "material" "phaseMixin" "relator" )
                    ( "material" "relator" "kind" )
                    ( "material" "relator" "subkind" )
                    ( "material" "relator" "role" )
                    ( "material" "relator" "historicalRole" )
                    ( "material" "relator" "phase" )
                    ( "material" "relator" "category" )
                    ( "material" "relator" "mixin" )
                    ( "material" "relator" "roleMixin" )
                    ( "material" "relator" "phaseMixin" )
                    ( "material" "relator" "relator" )
                    ( "mediation" "relator" "kind" )
                    ( "mediation" "relator" "subkind" )
                    ( "mediation" "relator" "role" )
                    ( "mediation" "relator" "historicalRole" )
                    ( "mediation" "relator" "phase" )
                    ( "mediation" "relator" "category" )
                    ( "mediation" "relator" "mixin" )
                    ( "mediation" "relator" "roleMixin" )
                    ( "mediation" "relator" "phaseMixin" )
                    ( "memberOf" "kind" "collective" )
                    ( "memberOf" "subkind" "collective" )
                    ( "memberOf" "role" "collective" )
                    ( "memberOf" "historicalRole" "collective" )
                    ( "memberOf" "phase" "collective" )
                    ( "memberOf" "category" "collective" )
                    ( "memberOf" "mixin" "collective" )
                    ( "memberOf" "roleMixin" "collective" )
                    ( "memberOf" "phaseMixin" "collective" )
                    ( "participation" "kind" "event" )
                    ( "participation" "subkind" "event" )
                    ( "participation" "role" "event" )
                    ( "participation" "historicalRole" "event" )
                    ( "participation" "phase" "event" )
                    ( "participation" "category" "event" )
                    ( "participation" "mixin" "event" )
                    ( "participation" "roleMixin" "event" )
                    ( "participation" "phaseMixin" "event" )
                    ( "subCollectionOf" "collective" "collective" )
                    ( "subQuantityOf" "quantity" "quantity" )
                    ( "termination" "event" "kind" )
                    ( "termination" "event" "subkind" )
                    ( "termination" "event" "role" )
                    ( "termination" "event" "historicalRole" )
                    ( "termination" "event" "phase" )
                    ( "termination" "event" "relator" )
                    ( "termination" "event" "mode" )
                    ( "termination" "event" "quality" )
                    ( "triggers" "situation" "event" )
                    }
                }
            }
        """
    ] .


###############################################################################
# G9 — Properties met relatie-stereotype maar zonder domain of range
###############################################################################

gufo:OntoumlRelationDomainRangeShape
    a sh:NodeShape ;
    sh:targetSubjectsOf gufo:ontoumlStereotype ;
    sh:name "OntoumlRelationDomainRangeShape" ;
    sh:description
        """G9 (waarschuwing): Een owl:ObjectProperty met relatie-stereotype
         hoort een rdfs:domain en rdfs:range te hebben zodat de
         stereotype-combinatieconstraint G8 kan worden gecontroleerd.
         Ontbrekende domain of range maakt G8-validatie onmogelijk (DD-026).""" ;

    sh:severity sh:Warning ;

    sh:sparql [
        sh:name    "G9a-domain-aanwezig" ;
        sh:message "G9a (waarschuwing): Property met relatie-stereotype mist rdfs:domain — G8-validatie niet mogelijk." ;
        sh:prefixes shg ;
        sh:select  """
            SELECT $this
            WHERE {
                $this a owl:ObjectProperty .
                $this gufo:ontoumlStereotype ?relStereo .
                VALUES ?relStereo {
                    "characterization" "mediation" "externalDependence"
                    "material" "comparative" "participation"
                    "creation" "termination" "bringsAbout"
                    "triggers" "manifestation" "historicalDependence"
                    "componentOf" "subCollectionOf" "subQuantityOf" "memberOf"
                }
                FILTER (!STRSTARTS(STR($this), "http://purl.org/nemo/gufo#"))
                FILTER NOT EXISTS { $this rdfs:domain ?d }
            }
        """
    ] ;

    sh:sparql [
        sh:name    "G9b-range-aanwezig" ;
        sh:message "G9b (waarschuwing): Property met relatie-stereotype mist rdfs:range — G8-validatie niet mogelijk." ;
        sh:prefixes shg ;
        sh:select  """
            SELECT $this
            WHERE {
                $this a owl:ObjectProperty .
                $this gufo:ontoumlStereotype ?relStereo .
                VALUES ?relStereo {
                    "characterization" "mediation" "externalDependence"
                    "material" "comparative" "participation"
                    "creation" "termination" "bringsAbout"
                    "triggers" "manifestation" "historicalDependence"
                    "componentOf" "subCollectionOf" "subQuantityOf" "memberOf"
                }
                FILTER (!STRSTARTS(STR($this), "http://purl.org/nemo/gufo#"))
                FILTER NOT EXISTS { $this rdfs:range ?r }
            }
        """
    ] .


###############################################################################
# G10 — Superklasse-stereotype-consistentie (DD-026 aanvulling)
#
#  G7 controleert: heeft dit stereotype het ju
```

---

## Module: 00b-ufo-b.ttl

```turtle
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufob:  <https://valor-ecosystem.nl/ontology/ufo-b#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix vo:    <https://valor-ecosystem.nl/ontology/> .

###############################################################################
# VALOR-O — Module 00b: UFO-B  (Events & Causality)
#
# Purpose : Formalise the event ontology of UFO needed by VALOR-O.
#           Covers: AtomicEvent/ComplexEvent partition, Disposition,
#           causal properties (directlyCauses, causes, activates,
#           manifestedBy), event dependence (excDependsOn),
#           and the new OntoUML stereotypes from Almeida 2019
#           (historicalRole, participational, temporal).
#
# DESIGN DECISIONS:
#   DD-006 · UFO-B als aparte module (niet geïntegreerd in gUFO Core)
#   DD-007 · AtomicEvent/ComplexEvent als disjuncte partitie van Event
#   DD-008 · Disposition als subklasse van IntrinsicMode
#   DD-009 · gufo:contributedToTrigger vs. strict UFO-B triggers
#   DD-010 · directlyCauses en causes als niet-transitieve OWL-properties
#   DD-011 · historicalRole als nieuw stereotype (UFO-B-2019)
#   DD-012 · participational en temporal als relatie-stereotypen (UFO-B-2019)
#   DD-004 · gufo:Participation — terminologisch conflict (zie 00a)
#   DD-005 · Allen-relaties als SPARQL-queries (zie §Allen onderaan)
#
# Sources :
#   UFO-B-2013 : Guizzardi, G. et al. (2013). "Towards Ontological
#     Foundations for the Conceptual Modeling of Events." ER 2013,
#     LNCS 8217, pp. 327–341.
#   UFO-B-2019 : Almeida, J.P.A., Falbo, R. de A., Guizzardi, G. (2019).
#     "Events as Entities in Ontology-Driven Conceptual Modeling."
#     ER 2019, LNCS 11788, pp. 469–483.
#
# Imports : 00a-gufo-core.ttl
###############################################################################

vo:ufo-b
    a owl:Ontology ;
    owl:imports vo:gufo-core ;
    dcterms:title "VALOR-O — UFO-B Events & Causality"@nl ;
    dcterms:description
        """Ontologie van events, causaliteit en disposities.
         Uitbreiding van de event-primitieven in gUFO Core.
         Gefundeerd in UFO-B-2013 (axiomatisering) en
         UFO-B-2019 (OntoUML-stereotypen)."""@nl ;
    owl:versionInfo "0.1" .


###############################################################################
# ── 1. ATOMICÉVENT / COMPLEXEVENT PARTITIE ───────────────────────────────────
#
# UFO-B-2013 §3.1, axioma's M1/M2:
#   M1: ∀e:Event AtomicEvent(e) ↔ ¬∃e':Event has-part(e,e')
#       Een AtomicEvent heeft geen event-delen.
#   M2: ∀e:Event ComplexEvent(e) ↔ ¬AtomicEvent(e)
#       Een ComplexEvent heeft ten minste één event-deel.
#
# [DD-007] ONTWERPKEUZE: In OWL DL is de volledige bi-conditionele
# axiomatisering van M1/M2 niet volledig uitdrukbaar (closed-world
# assumption vereist). VALOR-O declareert de disjointness en declareert
# de complete partitie via owl:disjointUnionOf. Completeness (elk Event
# is óf AtomicEvent óf ComplexEvent) is ook als SPARQL-constraint
# geformuleerd (B0 in het SHACL-bestand).
#
# SHACL-compensatie: constraint B1 (Weak Supplementation Principle,
# axioma M6) valideert dat ComplexEvent ten minste 2 disjuncte delen
# heeft. Constraint B0 controleert dat elke Event-instantie tot één
# van beide subklassen behoort.
###############################################################################

gufo:Event
    owl:disjointUnionOf ( ufob:AtomicEvent ufob:ComplexEvent ) .

ufob:AtomicEvent
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Event ;
    rdfs:label "AtomicEvent"@en , "Atomair event"@nl ;
    rdfs:comment
        """Een event zonder event-delen. Instanciaties: één causaliteit-
         stap in een CLD-interventie, één transactie-act in DEMO.
         UFO-B-2013 §3.1 axioma M1:
           AtomicEvent(e) ↔ ¬∃e':Event has-part(e,e')
         [DD-007] disjoint van ComplexEvent via owl:disjointUnionOf."""@nl .

ufob:ComplexEvent
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Event ;
    rdfs:label "ComplexEvent"@en , "Complex event"@nl ;
    rdfs:comment
        """Een event dat bestaat uit ten minste twee disjuncte event-delen
         (Weak Supplementation Principle, M6). Instanciaties: een
         beleidsproces, een schuldhulpverleningstraject, een
         Design Space lifecycle.
         UFO-B-2013 §3.1 axioma M2:
           ComplexEvent(e) ↔ ¬AtomicEvent(e)
         [DD-007] Minimale partgrootte 2 is SHACL-constraint B1.
         UFO-B-2019 §3.3 onderscheidt twee soorten decomposities:
         participational (naar participant) en temporal (naar tijdssegment).
         Zie relatie-stereotypen «participational» en «temporal» onderaan."""@nl .


###############################################################################
# ── 2. EXCLUSIEVE DEPENDENTIE (excDependsOn) ─────────────────────────────────
#
# UFO-B-2013 §3.2, axioma's P1–P3:
#   P1: ∀e:AtomicEvent ∃!o:Object excDepends(e,o)
#       Elk AtomicEvent hangt exclusief af van precies één Object.
#   P2: excDepends(e,o) → depends(e,o)
#   P3: excDepends(e,o) ∧ depends(e,o') → o = o'
#       (uniqueness van de exclusieve drager)
#
# [DD-007] ONDERSCHEID VAN gufo:hasParticipant:
#   gufo:hasParticipant is niet-functioneel (meerdere participanten mogelijk).
#   excDependsOn is functioneel (precies één Object) voor AtomicEvent.
#   SHACL-constraint B2 dwingt de functionaliteit af (maxCount 1).
###############################################################################

ufob:excDependsOn
    a owl:ObjectProperty ;
    rdfs:subPropertyOf gufo:hasParticipant ;
    rdfs:label "exclusively depends on"@en , "hangt exclusief af van"@nl ;
    rdfs:domain ufob:AtomicEvent ;
    rdfs:range  gufo:Object ;
    rdfs:comment
        """Functionele dependentierelatie: een AtomicEvent hangt af van
         precies één Object (zijn exclusieve drager).
         UFO-B-2013 §3.2 axioma P1:
           ∀e:AtomicEvent ∃!o:Object excDepends(e,o)
         [DD-007] Onderscheid van gufo:hasParticipant (niet-functioneel).
         Geen OntoUML-relatie-stereotype: excDependsOn is een UFO-B-specifiek
         axioma. OntoUML 2.0 «externalDependence» vereist source=mode|quality;
         hier is de source een Event. Dit valt buiten het OntoUML-stereotype-
         systeem (DD-026). Functionaliteit gehandhaafd via SHACL B2 (maxCount 1)."""@nl .


###############################################################################
# ── 3. DISPOSITION ───────────────────────────────────────────────────────────
#
# UFO-B-2013 §3.5, axioma's D1–D4:
#   D1: Disposition ⊂ Trope  (een dispositie is een troop/modus)
#   D2: ∀d:Disposition manifestedBy(d) ⊆ AtomicEvent
#       (een dispositie manifsteert zich als een AtomicEvent)
#   D3: ∀d:Disposition ∃s:Situation activates(s,d)
#       (een Situation activeert een Disposition)
#   D4: ∀d:Disposition ∀s1,s2:Situation
#       activates(s1,d) ∧ activates(s2,d) → s1 = s2
#       (precies één activerende Situation per Disposition)
#
# [DD-008] ONTWERPKEUZE: Disposition is subklasse van gufo:IntrinsicMode
#   (niet van gufo:Quality). Motivatie: disposities zijn niet direct
#   meetbaar in een kwaliteitsstructuur (temperatuur, massa). Ze zijn
#   entiteitsspecifieke tropen zonder dimensionele waarde.
#   gUFO noemt IntrinsicMode als thuisplek voor disposities impliciet.
#   VALOR-O introduceert Disposition als VALOR-O-toevoeging.
#   Bron: UFO-B-2013 §3.5; gUFO-spec §3.2.
#
# VALOR-relevantie:
#   In het Causa-perspectief zijn disposities de causale mechanismen
#   achter een Issue: een systeem heeft een dispositie om toe te staan
#   dat schulden zich opstapelen. Die dispositie manifsteert zich als
#   een serie AtomicEvents (betalingsachterstanden). Een interventie
#   (schuldhulpverlening) verwijdert de activerende Situation.
###############################################################################

ufob:Disposition
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf gufo:IntrinsicMode ;
    rdfs:label "Disposition"@en , "Dispositie"@nl ;
    rdfs:comment
        """Een intrinsieke modus van een Object die het object gevoelig
         maakt voor activering door een Situation, waarna het een
         AtomicEvent manifesteert.
         UFO-B-2013 §3.5 axioma D1: Disposition ⊂ Trope (IntrinsicMode).
         [DD-008] Keuze voor IntrinsicMode i.p.v. Quality: disposities
         hebben geen dimensionele waarde in een kwaliteitsstructuur.
         Instanciatie in VALOR (Causa): 'de financiële kwetsbaarheid
         van een schuldenaar' is een Disposition die door een Situation
         van verminderd inkomen wordt geactiveerd, wat een event van
         betalingsachterstand manifsteert."""@nl .

# ── Activering (Situation → Disposition) ─────────────────────────────────────

ufob:activates
    a owl:ObjectProperty ;
    rdfs:subPropertyOf gufo:contributedToTrigger ;
    rdfs:label "activates"@en , "activeert"@nl ;
    rdfs:domain gufo:Situation ;
    rdfs:range  ufob:Disposition ;
    rdfs:comment
        """Relateert een Situation aan een Disposition die ze triggert.
         UFO-B-2013 §3.5 axioma D3:
           ∀d:Disposition ∃s:Situation activates(s,d)
         Axioma D4: precies één activerende Situation per Disposition.
         SHACL-constraint B4 (maxCount 1 via inverse van activates).
         Geen OntoUML-relatie-stereotype: «triggers» (Situation→Event) is niet
         van toepassing want Disposition is geen Event maar een Mode. Dit is
         een UFO-B-specifiek axioma zonder OntoUML 2.0-equivalent (DD-026).
         Bron: UFO-B-2013 §3.5."""@nl .

# ── Manifestatie (Disposition → AtomicEvent) ─────────────────────────────────

ufob:manifestedBy
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "manifestation" ;
    rdfs:subPropertyOf gufo:manifestedIn ;
    rdfs:label "manifested by"@en , "manifsteert zich als"@nl ;
    rdfs:domain ufob:Disposition ;
    rdfs:range  ufob:AtomicEvent ;
    rdfs:comment
        """Relateert een Disposition aan het AtomicEvent waarin ze zich
         manifesteert. Functioneel: een Disposition manifesteert zich
         als precies één AtomicEvent.
         UFO-B-2013 §3.5 axioma D2:
           ∀d:Disposition manifestedBy(d) ⊆ AtomicEvent
         SHACL-constraint B3 (maxCount 1).
         Relatie tot gufo:manifestedIn (in 00a): dat is de inverse richting
         (van IntrinsicMode naar Event). ufob:manifestedBy heeft als domein
         specifiek Disposition en range specifiek AtomicEvent — preciezer."""@nl .


###############################################################################
# ── 4. CAUSALITEIT ────────────────────────────────────────────────────────────
#
# UFO-B-2013 §3.4, axioma's S1–S7:
#   S1: Situation ⊂ Endurant-like entity (Situation bestaat buiten events)
#   S2: ∀e:Event ∃!s:Situation bringsAbout(e,s)   — al in gUFO: broughtAbout
#   S3: ∀e:Event ∃!s:Situation triggeredBy(e,s)   — al in gUFO: wasTriggeredBy
#   S4: bringsAbout(e,s) ∧ triggeredBy(e,s') → s ≠ s'
#       (het event brengt iets nieuws tot stand; triggert ≠ outcome)
#   S5: triggers(s,e) → ¬exists(s) during e
#       (de triggende situatie houdt op te bestaan wanneer het event start)
#   S6: directlyCauses(e1,e2) ↔
#       ∃s:Situation [bringsAbout(e1,s) ∧ triggeredBy(e2,s)]
#       (directe causaliteit via gedeelde Situation)
#   S7: causes(e1,e2) ↔ directlyCauses+(e1,e2)
#       (transitieve sluiting = indirecte causaliteit)
#
# [DD-009] TRIGGERS: gufo:contributedToTrigger is NIET functioneel;
#   UFO-B S3 vereist precies één triggerende Situation. SHACL-constraint
#   B5 (maxCount 1 op wasTriggeredBy per AtomicEvent) compenseert dit.
#
# [DD-010] TRANSITIVITEIT: causes wordt NIET als owl:TransitiveProperty
#   gedeclareerd. Motivatie:
#   (a) Combinatie van TransitiveProperty + AsymmetricProperty + andere
#       restricties is problematisch voor OWL DL-beslisbaarheid.
#   (b) De transitieve sluiting is als SPARQL property path beschikbaar:
#       ufob:directlyCauses+ in de Causa-querybibliotheek.
#   Bewuste afwijking van UFO-B-2013 S7.
###############################################################################

ufob:directlyCauses
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf gufo:historicallyDependsOn ;
    rdfs:label "directly causes"@en , "veroorzaakt direct"@nl ;
    rdfs:domain gufo:Event ;
    rdfs:range  gufo:Event ;
    rdfs:comment
        """Directe causaliteitsrelatie: e1 veroorzaakt e2 als er een
         gedeelde Situation s bestaat waarvoor geldt:
           broughtAbout(e1,s) ∧ wasTriggeredBy(e2,s)
         UFO-B-2013 §3.4 axioma S6.
         [DD-010] Asymmetrie en irreflexiviteit zijn als SHACL gedocumenteerd
         (B6), niet als OWL-property-axioma (beslisbaarheidsrisico).
         In de Causa-querybibliotheek: gebruik ufob:directlyCauses+
         voor transitieve sluiting."""@nl .

ufob:causes
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf ufob:directlyCauses ;
    rdfs:label "causes"@en , "veroorzaakt (transitief)"@nl ;
    rdfs:comment
        """Transitieve causaliteitsrelatie: de transitieve sluiting van
         directlyCauses.
         UFO-B-2013 §3.4 axioma S7:
           causes(e1,e2) ↔ directlyCauses+(e1,e2)
         [DD-010] BEWUSTE AFWIJKING: causes wordt NIET als
         owl:TransitiveProperty gedeclareerd omdat dit in combinatie met
         AsymmetricProperty OWL DL-beslisbaarheid kan ondermijnen.
         De transitieve sluiting is beschikbaar als SPARQL property path:
           ?e1 ufob:directlyCauses+ ?e2
         De OWL-declaratie als subPropertyOf directlyCauses is een
         documentaire hint, geen volledig semantische assertie."""@nl .


###############################################################################
# ── 5. CAUSAL LOOP DIAGRAM EIGENSCHAPPEN (VALOR-uitbreiding) ─────────────────
#
# Causal Loop Diagrams (CLD) modelleren variabelen en hun causale relaties
# met polariteit en vertraging. In VALOR-O zijn dit specialisaties van
# ufob:directlyCauses.
#
# [DD-010 / VALOR-specifiek] Polariteit en vertraging zijn VALOR-O
# toevoegingen bovenop UFO-B. De grondslag is het Causa-perspectief
# (VALOR Product Plan §4.2) en de CLD-literatuur (Forrester 1968,
# Meadows 2008). Pearl (2009) fundeert de richting van causaliteit
# (directed acyclic graphs als basis).
#
# Onzekerheidsannotatie (PAMS): elke CLD-relatie kan een onzekerheidsniveau
# dragen conform de PAMS-taxonomie (Enserink et al. 2022, TU Delft):
#   StatisticalRisk      — kansverdelingen bekend
#   ScenarioUncertainty  — kwalitatieve scenario's beschikbaar
#   RecognizedIgnorance  — het onbekende is herkenbaar
#   DeepUncertainty      — geen overeenstemming over modellen of waarden
###############################################################################

ufob:CausalRelation
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "CausalRelation"@en , "Causale relatie (CLD)"@nl ;
    rdfs:comment
        """Reïficatie van een causale relatie in een Causal Loop Diagram.
         Een CausalRelation is een Situation: de toestand dát variabele X
         bijdraagt aan variabele Y. Als Situation (niet als Event) kan ze
         duurzaam bestaan en geannoteerd worden met polariteit, vertraging
         en onzekerheid.
         [CORRECTIE] Eerder incorrect als «event» getypeerd; een causale
         relatie is een toestand (Situation), niet een gebeurtenis (Event).
         Bron: VALOR Product Plan §4.2 (Causa); Meadows (2008) §1;
         gUFO-spec §3 (Situation als state of affairs)."""@nl .

ufob:hasCausalPolarity
    a owl:DatatypeProperty ;
    rdfs:label "has causal polarity"@en , "heeft causale polariteit"@nl ;
    rdfs:domain ufob:CausalRelation ;
    rdfs:range  xsd:string ;
    rdfs:comment
        """Polariteit van de causale relatie in een CLD:
           '+' (versterkend / reinforcing): als X toeneemt neemt Y toe;
               als X afneemt neemt Y af.
           '-' (dempend / balancing): als X toeneemt neemt Y af;
               als X afneemt neemt Y toe.
         Bron: Meadows (2008) §1; Forrester (1968)."""@nl .

ufob:hasDelay
    a owl:DatatypeProperty ;
    rdfs:label "has delay"@en , "heeft vertraging"@nl ;
    rdfs:domain ufob:CausalRelation ;
    rdfs:range  xsd:boolean ;
    rdfs:comment
        """Geeft aan of de causale relatie een significante vertraging
         kent (true = vertraagd effect). In CLD-notatie weergegeven
         met een dubbele pijl (||).
         Bron: Meadows (2008) §1."""@nl .

ufob:hasUncertaintyLevel
    a owl:ObjectProperty ;
    rdfs:subPropertyOf gufo:hasQuality ;
    rdfs:label "has uncertainty level"@en , "heeft onzekerheidsniveau"@nl ;
    rdfs:domain ufob:CausalRelation ;
    rdfs:range  ufob:UncertaintyLevel ;
    rdfs:comment
        """Het onzekerheidsniveau van de causale relatie conform de
         PAMS-taxonomie (Enserink et al. 2022, TU Delft).
         Geen OntoUML-relatie-stereotype: «characterization» vereist
         mode|quality als source; hier is de source een Situation.
         gUFO-verankering via gufo:hasQuality (Situation→Quality) is
         ontologisch correct maar heeft geen OntoUML 2.0-equivalent (DD-026).
         Bron: Enserink et al. (2022), §3 (uncertainty taxonomy)."""@nl .

# ── PAMS-onzekerheidsindeling ─────────────────────────────────────────────────

ufob:UncertaintyLevel
    a owl:Class ;
    gufo:ontoumlStereotype "quality" ;
    rdfs:subClassOf gufo:Quality ;
    rdfs:label "UncertaintyLevel"@en , "Onzekerheidsniveau"@nl ;
    rdfs:comment
        """Kwaliteitsdimensie die het onzekerheidsniveau van een CausalRelation
         uitdrukt. Subklasse van gufo:Quality: een UncertaintyLevel inhereert
         als kwaliteitswaarde aan een CausalRelation-instantie.
         De vier PAMS-waarden (StatisticalRisk, ScenarioUncertainty,
         RecognizedIgnorance, DeepUncertainty) zijn individuen van dit Kind
         — hetzelfde patroon als EnforceabilityLevel in 00d-ufo-l.ttl.
         Conform PAMS-taxonomie (Enserink et al. 2022, TU Delft §3)."""@nl .

ufob:StatisticalRisk
    a ufob:UncertaintyLevel ;
    rdfs:label "StatisticalRisk"@en , "Statistisch risico"@nl ;
    rdfs:comment
        """Kansverdelingen zijn bekend. Beslissers zijn het eens over
         het model en de waarden. Bron: Enserink et al. (2022) §3."""@nl .

ufob:ScenarioUncertainty
    a ufob:UncertaintyLevel ;
    rdfs:label "ScenarioUncertainty"@en , "Scenario-onzekerheid"@nl ;
    rdfs:comment
        """Het toekomstige verloop is onzeker maar beschrijfbaar in
         kwalitatieve scenario's. Eens over het model, oneens over
         de waarden. Bron: Enserink et al. (2022) §3."""@nl .

ufob:RecognizedIgnorance
    a ufob:UncertaintyLevel ;
    rdfs:label "RecognizedIgnorance"@en , "Erkende onwetendheid"@nl ;
    rdfs:comment
        """Wat onbekend is, is herkenbaar, maar scenario's zijn niet
         opstelbaar. Bron: Enserink et al. (2022) §3."""@nl .

ufob:DeepUncertainty
    a ufob:UncertaintyLevel ;
    rdfs:label "DeepUncertainty"@en , "Diepe onzekerheid"@nl ;
    rdfs:comment
        """Geen overeenstemming over de modellen zelf of de centrale
         waarden. Het is onduidelijk wat 'de feiten' zijn.
         Bron: Enserink et al. (2022) §3."""@nl .


###############################################################################
# ── 6. NIEUW: ONTOUML 2019 STEREOTYPEN ───────────────────────────────────────
#
# UFO-B-2019 §3.2–3.3 introduceert drie nieuwe elementen voor event-
# modellering die niet in de originele gUFO-specificatie zitten:
#
# (a) «historicalRole» — Klasse-stereotype
# (b) «participational» — Relatie-stereotype (event-decompostie naar participant)
# (c) «temporal» — Relatie-stereotype (event-decompositie naar tijdssegment)
#
# [DD-011] «historicalRole»: een Role die een endurant speelt in virtue
#   of deelname aan een PAST event — fundamenteel anders dan een gewone
#   «role» (die gespeeld wordt in virtue van een BESTAAND relator).
#   VALOR-relevantie: een Participant die heeft bijgedragen aan een
#   afgesloten DesignPhase is een historische roldrager.
#   Bron: UFO-B-2019 §3.2 (Figures 5–7).
#
# [DD-012] «participational» vs. «temporal»: twee soorten event-decomposities
#   (Pribbenow-theorie, geciteerd in UFO-B-2019 §3.3):
#   participational = intern geconstrueerde delen op basis van dependentie-
#     eigenschap (wie participeert bepaalt de decompositie)
#   temporal = extern geconstrueerde delen op basis van temporele referentie
#   Bron: UFO-B-2019 §3.3; Pribbenow (1999) in UFO-B-2019 referentielijst.
###############################################################################

# ── (a) historicalRole als stereotype-waarde ──────────────────────────────────
#
# N.B.: historicalRole is een klasse-STEREOTYPE, geen nieuwe klasse.
# In VALOR-O: domeinontologie-klassen die een rol beschrijven die wordt
# gespeeld vanwege een historisch event, worden geannoteerd met
#   gufo:ontoumlStereotype "historicalRole"
# en zijn subklassen van gufo:Role (er is geen apart gUFO-type;
# UFO-B-2019 plaatst historicalRole als subtype van «role» in OntoUML).

ufob:HistoricalRolePattern
    rdfs:comment
        """[DD-011] «historicalRole» stereotype-patroon:
         Een klasse met ontoumlStereotype 'historicalRole' moet:
         (1) rdfs:subClassOf gufo:Role zijn (anti-rigide, relationeel)
         (2) Verbonden zijn met een «event»-klasse via een
             «participation»-associatie met minCard ≥ 1
             (de rol wordt gespeeld vanwege deelname aan dat event)
         (3) Worden gedragen door een endurant die het event heeft
             meegemaakt maar waarbij het event nu is afgelopen.
         VALOR-toepassing: ufoc:HistoricalContributor (in UFO-C module)
         voor een Participant die heeft bijgedragen aan een afgesloten fase.
         Bron: UFO-B-2019 §3.2."""@nl .

# ── (b) participational en (c) temporal als relatie-stereotypen ──────────────
#
# Dit zijn geen OWL-properties maar annotatieconventies voor
# event-decomposities (gufo:isProperPartOf gespecialiseerd).

ufob:ParticipationalDecomposition
    rdfs:comment
        """[DD-012] «participational» relatie-patroon:
         Een mereologische relatie tussen events waarbij de decompositie
         wordt bepaald door wie er participeert. De deelgebeurtenissen
         zijn de 'maximal portions' die exclusief afhangen van één
         participant (Pribbenow's internal construction principle).
         Semantisch: ComplexEvent → AtomicEvent (excDependsOn dezelfde Object).
         Notatieconventie in VALOR-O: gufo:isProperPartOf met annotatie
           gufo:ontoumlStereotype "participational"
         Bron: UFO-B-2019 §3.3; Pribbenow (1999)."""@nl .

ufob:TemporalDecomposition
    rdfs:comment
        """[DD-012] «temporal» relatie-patroon:
         Een mereologische relatie tussen events waarbij de decompositie
         wordt bepaald door een extern temporeel referentiekader (tijdssegmenten).
         De deelgebeurtenissen zijn opeenvolgende tijdsperioden van het
         ComplexEvent (Pribbenow's external construction principle).
         Semantisch: ComplexEvent → sub-Event (hasBeginPoint/hasEndPoint < parent).
         Notatieconventie in VALOR-O: gufo:isProperPartOf met annotatie
           gufo:ontoumlStereotype "temporal"
         Bron: UFO-B-2019 §3.3; Pribbenow (1999)."""@nl .


###############################################################################
# ── 7. FEEDBACK LOOPS (VALOR-CLD-extensie) ───────────────────────────────────
#
# CLD-feedbackloops zijn cyclische patronen in het netwerk van
# CausalRelations. Ze zijn niet als OWL-klassen te declareren (OWL
# kan geen grafcycli uitdrukken). Ze worden gedetecteerd via SPARQL
# property paths (zie Causa-querybibliotheek).
#
# Twee typen (Meadows 2008 §3):
#   Reinforcing (R) — versterkende terugkoppeling: de lus versterkt zichzelf
#   Balancing (B)   — dempende terugkoppeling: de lus streeft een balans na
#
# In VALOR-O worden feedbackloops gemodelleerd als Situations die
# een cyclisch netwerk van CausalRelations omvatten.
###############################################################################

ufob:FeedbackLoop
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "FeedbackLoop"@en , "Terugkoppelingslus"@nl ;
    rdfs:comment
        """Een Situation die een cyclisch netwerk van CausalRelations
         beschrijft. Feedbackloops worden gedetecteerd via SPARQL
         property paths op ufob:directlyCauses (cyclus-detectie):
           SELECT ?start WHERE { ?start ufob:directlyCauses+ ?start }
         Twee subtypen: ReinforcingLoop en BalancingLoop.
         Bron: Meadows (2008) §3; VALOR Product Plan §4.2 (Causa)."""@nl .

ufob:ReinforcingLoop
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf ufob:FeedbackLoop ;
    rdfs:label "ReinforcingLoop"@en , "Versterkende terugkoppelingslus"@nl ;
    rdfs:comment
        """Een feedbacklus met uitsluitend of overwegend '+'-polariteiten
         (of een even aantal '-'-polariteiten), zodat de lus zichzelf
         versterkt. CLD-notatie: label R.
         Bron: Meadows (2008) §3."""@nl .

ufob:BalancingLoop
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf ufob:FeedbackLoop ;
    rdfs:label "BalancingLoop"@en , "Dempende terugkoppelingslus"@nl ;
    rdfs:comment
        """Een feedbacklus met een oneven aantal '-'-polariteiten, zodat
         de lus streeft naar een balans of doel. CLD-notatie: label B.
         Bron: Meadows (2008) §3."""@nl .

# ufob:loopType VERWIJDERD: classificatie R/B via rdfs:subClassOf —
# ReinforcingLoop en BalancingLoop zijn subklassen van FeedbackLoop.
# Subtype uitgedrukt via rdf:type op instantieniveau, niet als property.
# Een property met domein én range FeedbackLoop was ontologisch circulair.

ufob:containsRelation
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf gufo:historicallyDependsOn ;
    rdfs:label "contains relation"@en , "bevat relatie"@nl ;
    rdfs:domain ufob:FeedbackLoop ;
    rdfs:range  ufob:CausalRelation ;
    rdfs:comment
        "De CausalRelations die samen de feedbacklus vormen.
         Stereotype «historicalDependence» (Situation→Situation): een FeedbackLoop
         is historisch afhankelijk van zijn constituerende CausalRelations.
         Gecorrigeerd van «componentOf» (DD-026: componentOf is Endurant→Endurant,
         niet Situation→Situation)."@nl .


###############################################################################
# ── 8. ALLEN-RELATIES (documentatie, niet als OWL-properties) ────────────────
#
# UFO-B-2013 §3.3, axioma's T7–T13 definiëren de zeven Allen-tijdrelaties:
#   before, meets, overlaps, starts, during, finishes, equals
# op basis van de temporele eindpunten van events.
#
# [DD-005] BEWUSTE KEUZE: Allen-relaties worden NIET als OWL-properties
#   gedeclareerd. Motivatie:
#   (1) Alle zeven zijn volledig afleidbaar uit gufo:hasBeginPoint en
#       gufo:hasEndPoint (UFO-B-2019 §3.1 bevestigt dit).
#   (2) owl:overlaps zou conflicteren met de mereologische overlaps-relatie
#       (M7 in UFO-B-2013).
#   (3) Als OWL-properties zouden ze bij elke update afgeleid moeten worden.
#   Implementatie: gedocumenteerd als SPARQL-queries in de Causa-library.
#
# SPARQL-definities (voor Causa-querybibliotheek):
#   before(e1,e2)   ↔ end(e1) < begin(e2)
#   meets(e1,e2)    ↔ end(e1) = begin(e2)
#   overlaps(e1,e2) ↔ begin(e1) < begin(e2) ∧ end(e1) > begin(e2) ∧ end(e1) < end(e2)
#   starts(e1,e2)   ↔ begin(e1) = begin(e2) ∧ end(e1) < end(e2)
#   during(e1,e2)   ↔ begin(e1) > begin(e2) ∧ end(e1) < end(e2)
#   finishes(e1,e2) ↔ end(e1) = end(e2) ∧ begin(e1) > begin(e2)
#   equals(e1,e2)   ↔ begin(e1) = begin(e2) ∧ end(e1) = end(e2)
#
# Bron: UFO-B-2013 §3.3 (T7–T13); UFO-B-2019 §3.1; Allen (1983).
###############################################################################

ufob:_allen_documentation
    rdfs:comment
        """[DD-005] Allen-tijdrelaties zijn als SPARQL-queries geïmplementeerd,
         niet als OWL-objectproperties. Zie Causa-querybibliotheek.
         Bron: UFO-B-2013 §3.3 (T7–T13); UFO-B-2019 §3.1."""@nl .


###############################################################################
# END OF MODULE 00b — UFO-B Events & Causality
###############################################################################
```

## Module: 00b-ufo-b.shacl.ttl

```turtle
@prefix sh:    <http://www.w3.org/ns/shacl#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufob:  <https://valor-ecosystem.nl/ontology/ufo-b#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix shb:  <https://valor-ecosystem.nl/shacl/ufo-b#> .
@prefix vo:   <https://valor-ecosystem.nl/ontology/> .

###############################################################################
# VALOR-O — SHACL Shapes: UFO-B Events & Causality (Module 00b)
#
# Elke constraint verwijst naar het UFO-B axioma dat eraan ten grondslag ligt.
# Constraints zijn Violation tenzij expliciet sh:Warning.
# Zie DESIGN-DECISIONS.md §DD-022 voor de rationale van severity-keuzes.
###############################################################################

shb:
    a owl:Ontology ;
    dcterms:title "VALOR-O SHACL — UFO-B Events & Causality"@nl ;
    owl:versionInfo "0.1" .


###############################################################################
# B0 — Elke Event-instantie is óf AtomicEvent óf ComplexEvent
#
# UFO-B-2013 M1/M2: disjuncte, complete partitie.
# [DD-007] In OWL is de complete partitie uitgedrukt als
# owl:disjointUnionOf in 00b-ufo-b.ttl. Deze SHACL-constraint
# detecteert Event-instanties die geen van beide subklassen zijn
# (open-world-compensatie).
# Severity: Warning (open-world: data kan onvolledig zijn).
###############################################################################

shb:EventPartitionShape
    a sh:NodeShape ;
    sh:targetClass gufo:Event ;
    sh:severity sh:Warning ;
    sh:name "EventPartitionShape" ;
    sh:description
        "B0: Elke gufo:Event-instantie moet óf ufob:AtomicEvent óf
         ufob:ComplexEvent zijn (UFO-B-2013 M1/M2, disjuncte partitie)." ;
    sh:sparql [
        sh:name    "B0-event-partition" ;
        sh:message "B0 (waarschuwing): Event-instantie is geen AtomicEvent of ComplexEvent." ;
        sh:prefixes shb: ;
        sh:select  """
            SELECT $this
            WHERE {
                $this a gufo:Event .
                FILTER NOT EXISTS { $this a ufob:AtomicEvent }
                FILTER NOT EXISTS { $this a ufob:ComplexEvent }
            }
        """
    ] .


###############################################################################
# B1 — ComplexEvent heeft ten minste 2 disjuncte event-delen
#
# UFO-B-2013 §3.1 axioma M6 (Weak Supplementation Principle):
#   ∀e:ComplexEvent ∃e1,e2:Event [
#     properPart(e1,e) ∧ properPart(e2,e) ∧ ¬overlap(e1,e2) ]
# Gesimplificeerd in SHACL: minCount 2 op isProperPartOf-inverse.
# Severity: Violation (WSP is een kern-mereologisch principe).
###############################################################################

shb:ComplexEventPartsShape
    a sh:NodeShape ;
    sh:targetClass ufob:ComplexEvent ;
    sh:name "ComplexEventPartsShape" ;
    sh:description
        "B1: Een ComplexEvent moet ten minste 2 disjuncte event-delen hebben
         (UFO-B-2013 M6, Weak Supplementation Principle)." ;
    sh:property [
        sh:path     [ sh:inversePath gufo:isProperPartOf ] ;
        sh:minCount 2 ;
        sh:class    gufo:Event ;
        sh:name     "hasEventParts" ;
        sh:message  "B1: ComplexEvent vereist ten minste 2 event-delen via gufo:isProperPartOf."
    ] .


###############################################################################
# B2 — AtomicEvent.excDependsOn is functioneel (max. 1 Object)
#
# UFO-B-2013 §3.2 axioma P1:
#   ∀e:AtomicEvent ∃!o:Object excDepends(e,o)
# [DD-007] excDependsOn is functioneel; gufo:hasParticipant is dit niet.
# Severity: Violation (uniqueness van drager is een UFO-B-kernaxioma).
###############################################################################

shb:AtomicEventDependenceShape
    a sh:NodeShape ;
    sh:targetClass ufob:AtomicEvent ;
    sh:name "AtomicEventDependenceShape" ;
    sh:description
        "B2: Een AtomicEvent hangt af van precies één Object via
         excDependsOn (UFO-B-2013 P1)." ;
    sh:property [
        sh:path     ufob:excDependsOn ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class    gufo:Object ;
        sh:name     "excDependsOn" ;
        sh:message  "B2: AtomicEvent.excDependsOn vereist precies één gufo:Object."
    ] .


###############################################################################
# B3 — Disposition.manifestedBy is functioneel (max. 1 AtomicEvent)
#
# UFO-B-2013 §3.5 axioma D2:
#   ∀d:Disposition manifestedBy(d) ⊆ AtomicEvent
# De manifestatie is één specifiek AtomicEvent.
# Severity: Violation (functioneel axioma).
###############################################################################

shb:DispositionManifestationShape
    a sh:NodeShape ;
    sh:targetClass ufob:Disposition ;
    sh:name "DispositionManifestationShape" ;
    sh:description
        "B3: Een Disposition manifsteert zich als ten hoogste 1 AtomicEvent
         (UFO-B-2013 D2, functioneel)." ;
    sh:property [
        sh:path     ufob:manifestedBy ;
        sh:maxCount 1 ;
        sh:class    ufob:AtomicEvent ;
        sh:name     "manifestedBy" ;
        sh:message  "B3: Disposition.manifestedBy mag maximaal 1 AtomicEvent hebben."
    ] .


###############################################################################
# B4 — Disposition heeft precies 1 activerende Situation
#
# UFO-B-2013 §3.5 axioma D4:
#   ∀d:Disposition ∀s1,s2 activates(s1,d) ∧ activates(s2,d) → s1 = s2
# Geïmplementeerd via inverse van activates (max. 1 activerende situatie).
# Severity: Violation (functionaliteitsaxioma).
###############################################################################

shb:DispositionActivationShape
    a sh:NodeShape ;
    sh:targetClass ufob:Disposition ;
    sh:name "DispositionActivationShape" ;
    sh:description
        "B4: Een Disposition wordt geactiveerd door ten hoogste 1 Situation
         (UFO-B-2013 D4, functioneel)." ;
    sh:property [
        sh:path     [ sh:inversePath ufob:activates ] ;
        sh:maxCount 1 ;
        sh:class    gufo:Situation ;
        sh:name     "activatedBy" ;
        sh:message  "B4: Disposition wordt geactiveerd door maximaal 1 Situation (axioma D4)."
    ] .


###############################################################################
# B5 — AtomicEvent.wasTriggeredBy is functioneel (max. 1 Situation)
#
# UFO-B-2013 §3.4 axioma S3:
#   ∀e:Event ∃!s:Situation triggeredBy(e,s)
# [DD-009] gufo:contributedToTrigger is niet-functioneel in gUFO;
# SHACL compenseert de zwakkere OWL-declaratie.
# Severity: Violation voor AtomicEvent (strikter dan ComplexEvent).
###############################################################################

shb:AtomicEventTriggerShape
    a sh:NodeShape ;
    sh:targetClass ufob:AtomicEvent ;
    sh:name "AtomicEventTriggerShape" ;
    sh:description
        "B5: Een AtomicEvent wordt getriggerd door precies 1 Situation
         (UFO-B-2013 S3, via gufo:wasTriggeredBy)." ;
    sh:property [
        sh:path     gufo:wasTriggeredBy ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class    gufo:Situation ;
        sh:name     "wasTriggeredBy" ;
        sh:message  "B5: AtomicEvent.wasTriggeredBy vereist precies 1 Situation (axioma S3)."
    ] .


###############################################################################
# B6 — directlyCauses is asymmetrisch en irreflexief
#
# UFO-B-2013 §3.4: causaliteit is gericht en onomkeerbaar.
# [DD-010] Dit is niet als OWL-eigenschap gedeclareerd (beslisbaarheidsrisico);
# SHACL dwingt het af als SPARQL-constraint.
# Severity: Violation.
###############################################################################

shb:CausalAsymmetryShape
    a sh:NodeShape ;
    sh:targetSubjectsOf ufob:directlyCauses ;
    sh:name "CausalAsymmetryShape" ;
    sh:description
        "B6: ufob:directlyCauses is asymmetrisch en irreflexief
         (UFO-B-2013 §3.4, causaliteit is onomkeerbaar)." ;
    sh:sparql [
        sh:name    "B6a-irreflexive" ;
        sh:message "B6a: Een event kan niet zichzelf veroorzaken (irreflexiviteit)." ;
        sh:prefixes shb: ;
        sh:select  """
            SELECT $this
            WHERE {
                $this ufob:directlyCauses $this .
            }
        """
    ] ;
    sh:sparql [
        sh:name    "B6b-asymmetric" ;
        sh:message "B6b: Causale relatie is asymmetrisch: als A veroorzaakt B, dan niet B veroorzaakt A." ;
        sh:prefixes shb: ;
        sh:select  """
            SELECT $this
            WHERE {
                $this ufob:directlyCauses ?other .
                ?other ufob:directlyCauses $this .
            }
        """
    ] .


###############################################################################
# B7 — CausalRelation.hasCausalPolarity is '+' of '-'
#
# VALOR-O CLD-extensie: polariteit is een verplichte annotatie op elke
# gemodelleerde CausalRelation (in het Causa-perspectief).
# Severity: Warning (niet alle CausalRelations zijn per se CLD-relaties).
###############################################################################

shb:CausalRelationPolarityShape
    a sh:NodeShape ;
    sh:targetClass ufob:CausalRelation ;
    sh:severity sh:Warning ;
    sh:name "CausalRelationPolarityShape" ;
    sh:description
        "B7: Elke CausalRelation in een CLD moet een hasCausalPolarity
         hebben met waarde '+' of '-'." ;
    sh:property [
        sh:path     ufob:hasCausalPolarity ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:in       ( "+" "-" ) ;
        sh:name     "hasCausalPolarity" ;
        sh:message  "B7 (waarschuwing): CausalRelation mist polariteit '+' of '-'."
    ] .


###############################################################################
# B8 — «historicalRole» stereotype-constraint
#
# [DD-011] Klassen met ontoumlStereotype 'historicalRole' moeten:
# (a) subklasse zijn van gufo:Role
# (b) verbonden zijn met een event-klasse via participation
# Severity: Warning (verbinding via participation niet altijd als triple
# aanwezig in data).
###############################################################################

shb:HistoricalRoleStereotypeShape
    a sh:NodeShape ;
    sh:targetSubjectsOf gufo:ontoumlStereotype ;
    sh:severity sh:Warning ;
    sh:name "HistoricalRoleStereotypeShape" ;
    sh:description
        "B8: Klassen met ontoumlStereotype 'historicalRole' moeten
         subklasse zijn van gufo:Role (UFO-B-2019 §3.2)." ;
    sh:sparql [
        sh:name    "B8-historicalRole-subClassOf-Role" ;
        sh:message "B8 (waarschuwing): Class met 'historicalRole' stereotype is geen subklasse van gufo:Role." ;
        sh:prefixes shb: ;
        sh:select  """
            SELECT $this
            WHERE {
                $this gufo:ontoumlStereotype "historicalRole" .
                FILTER NOT EXISTS { $this rdfs:subClassOf gufo:Role }
                FILTER (!STRSTARTS(STR($this), "http://purl.org/nemo/gufo#"))
            }
        """
    ] .


###############################################################################
# B9 — Event.broughtAbout is functioneel per AtomicEvent
#
# UFO-B-2013 §3.4 axioma S2:
#   ∀e:Event ∃!s:Situation bringsAbout(e,s)
# Severity: Violation voor AtomicEvent.
###############################################################################

shb:AtomicEventOutcomeShape
    a sh:NodeShape ;
    sh:targetClass ufob:AtomicEvent ;
    sh:name "AtomicEventOutcomeShape" ;
    sh:description
        "B9: Een AtomicEvent brengt precies 1 Situation tot stand
         (UFO-B-2013 S2, via gufo:broughtAbout)." ;
    sh:property [
        sh:path     gufo:broughtAbout ;
        sh:minCount 1 ;
        sh:maxCount 1 ;
        sh:class    gufo:Situation ;
        sh:name     "broughtAbout" ;
        sh:message  "B9: AtomicEvent.broughtAbout vereist precies 1 Situation (axioma S2)."
    ] .


###############################################################################
# B10 — Triggerende en voortgebrachte Situation zijn disjunct
#
# UFO-B-2013 §3.4 axioma S4:
#   bringsAbout(e,s) ∧ triggeredBy(e,s') → s ≠ s'
# Het event brengt iets nieuws tot stand; het triggert niet wat het zelf
# voortbrengt.
# Severity: Violation.
###############################################################################

shb:TriggerOutcomeDisjointShape
    a sh:NodeShape ;
    sh:targetClass gufo:Event ;
    sh:name "TriggerOutcomeDisjointShape" ;
    sh:description
        "B10: De triggerende Situation en de voortgebrachte Situation
         van hetzelfde Event mogen niet identiek zijn (UFO-B-2013 S4)." ;
    sh:sparql [
        sh:name    "B10-trigger-outcome-disjoint" ;
        sh:message "B10: Het event triggert en brengt dezelfde Situation tot stand (axioma S4 geschonden)." ;
        sh:prefixes shb: ;
        sh:select  """
            SELECT $this
            WHERE {
                $this gufo:wasTriggeredBy ?s .
                $this gufo:broughtAbout ?s .
            }
        """
    ] .


###############################################################################
# Prefix declarations voor SPARQL constraints
###############################################################################

shb:
    a sh:PrefixDeclaration ;
    sh:declare [
        sh:prefix    "gufo" ;
        sh:namespace "http://purl.org/nemo/gufo#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "ufob" ;
        sh:namespace "https://valor-ecosystem.nl/ontology/ufo-b#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "rdf" ;
        sh:namespace "http://www.w3.org/1999/02/22-rdf-syntax-ns#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "rdfs" ;
        sh:namespace "http://www.w3.org/2000/01/rdf-schema#"^^xsd:anyURI
    ] .

###############################################################################
# END OF SHACL — UFO-B Events & Causality
###############################################################################
```

---

## Module: 00c-ufo-c.ttl

```turtle
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix skos:  <http://www.w3.org/2004/02/skos/core#> .
@prefix vo:   <https://valor-ecosystem.nl/ontology/> .

###############################################################################
# VALOR-O — Module 00c: UFO-C  (Social Entities)
#
# Purpose : Formalise the social layer of UFO needed by VALOR-O.
#           Covers: Agent, intentional modes (goal, belief, desire,
#           intention, commitment/claim pair), social objects (norms,
#           roles as social constructs), and the delegation pattern.
#
# Module structuur (na invoeging UFO-B als aparte module — DD-019):
#   00a-gufo-core.ttl  → 00b-ufo-b.ttl  → 00c-ufo-c.ttl (dit bestand)
#                                       → 00d-ufo-l.ttl
#
# DESIGN DECISIONS (zie DESIGN-DECISIONS.md):
#   DD-013 · SocialCommitment als ExtrinsicMode; SocialRelator als overkoepelende Relator
#   DD-014 · Norm als mode van InstitutionalAgent
#   DD-015 · Concern als fundering van het Issue-concept
#   DD-020 · Taal van rdfs:comment (NL domein, EN technisch)
#   DD-024 · «characterization» in beide richtingen (VALOR-O-conventie)
#   DD-025 · «creation»/«termination» via wasCreatedIn/wasTerminatedIn
#
# Source  : Guizzardi et al. (2013), "UFO-C: A Foundational Ontology
#           for Social Entities"; Guizzardi (2005) PhD thesis;
#           de Oliveira Bringuente et al. (2011).
#
# Imports : 00a-gufo-core.ttl, 00b-ufo-b.ttl
###############################################################################

vo:ufo-c
    a owl:Ontology ;
    owl:imports vo:gufo-core ;
    owl:imports vo:ufo-b ;
    dcterms:title "VALOR-O — UFO-C Social Entities"@nl ;
    dcterms:description
        "Ontologie van sociale entiteiten: agents, intentionele toestanden,
         sociale objecten, commitments en delegatie."@nl ;
    owl:versionInfo "0.1" .


###############################################################################
# ── 1. AGENT ──────────────────────────────────────────────────────────────────
#
#  An Agent is a FunctionalComplex with a mind: it has beliefs, desires and
#  intentions (BDI architecture).  Agents can be physical persons or
#  institutional/collective agents (organisations).
###############################################################################

ufoc:Agent
    a owl:Class ;
    rdf:type gufo:Kind ;
    gufo:ontoumlStereotype "kind" ;
    rdfs:subClassOf gufo:FunctionalComplex ;
    rdfs:label "Agent"@en , "Agent"@nl ;
    rdfs:comment
        "Een FunctionalComplex met intentionele toestanden (BDI). Agents
         handelen op grond van doelen, overtuigingen en intenties. Agents
         kunnen fysiek (personen) of institutioneel (organisaties) zijn."@nl .

ufoc:PhysicalAgent
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufoc:Agent ;
    rdfs:label "PhysicalAgent"@en , "Fysieke agent"@nl ;
    rdfs:comment "Een agent die een fysiek lichaam heeft (persoon)."@nl .

ufoc:InstitutionalAgent
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufoc:Agent ;
    rdfs:label "InstitutionalAgent"@en , "Institutionele agent"@nl ;
    rdfs:comment
        "Een agent wiens bestaan afhankelijk is van collectieve
         erkenning (organisatie, gemeente, rechtspersoon)."@nl .

# Disjointness: a physical agent is not institutional
[ a owl:AllDisjointClasses ;
  owl:members ( ufoc:PhysicalAgent ufoc:InstitutionalAgent ) ] .


###############################################################################
# ── 2. INTENTIONAL MODES ──────────────────────────────────────────────────────
#
#  All intentional modes are IntrinsicModes that inhere in an Agent and have
#  a propositional content expressed as a Situation (the state of affairs the
#  mode is "about").
#
#  Following COoDM (Guizzardi, Carneiro, Porello 2020):
#    Belief   — doxastic mode  (the agent thinks p is true)
#    Desire   — conative mode  (the agent wants p to be true)
#    Goal     — a desire that is stable and deliberated
#    Intention — a goal the agent has decided to pursue via an action plan
#    Commitment — a social intention made public to another agent
###############################################################################

ufoc:IntentionalMode
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf gufo:IntentionalMode ;
    rdfs:label "IntentionalMode"@en , "Intentionele toestand"@nl ;
    rdfs:comment
        "Een intrinsieke modus van een agent met propositionele inhoud
         (een situatie waarover de modus gaat)."@nl .

# ── Belief ────────────────────────────────────────────────────────────────────

ufoc:Belief
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:IntentionalMode ;
    rdfs:label "Belief"@en , "Overtuiging"@nl ;
    rdfs:comment
        "Een intentionele modus waarbij de agent de propositionele inhoud
         als waar beschouwt."@nl .

# ── Desire / Goal ─────────────────────────────────────────────────────────────

ufoc:Desire
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:IntentionalMode ;
    rdfs:label "Desire"@en , "Wens"@nl ;
    rdfs:comment
        "Een intentionele modus waarbij de agent de propositionele inhoud
         als gewenst beschouwt."@nl .

ufoc:Goal
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:Desire ;
    rdfs:label "Goal"@en , "Doel"@nl ;
    rdfs:comment
        "Een gestabiliseerde, bewust gekozen wens die de agent als
         richtinggevend beschouwt voor zijn handelen."@nl .

ufoc:SoftGoal
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:Desire ;
    rdfs:label "SoftGoal"@en , "Preferentiedoel"@nl ;
    rdfs:comment
        "Een doel waarvan de vervulling gradueel is en niet binair: het
         gaat over 'zo goed mogelijk bereiken', niet 'al dan niet bereiken'.
         Gebruikt in i*-actor-analyse."@nl .

# ── Intention ─────────────────────────────────────────────────────────────────

ufoc:Intention
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:Goal ;
    rdfs:label "Intention"@en , "Intentie"@nl ;
    rdfs:comment
        "Een doel waarvoor de agent een actieplan heeft gevormd en dat hij
         heeft besloten na te streven."@nl .

# ── Interest ──────────────────────────────────────────────────────────────────

ufoc:Interest
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:Desire ;
    rdfs:label "Interest"@en , "Belang"@nl ;
    rdfs:comment
        "Een wens waarbij de agent een voordeel of nadeel ervaart afhankelijk
         van een toestand in de wereld. Gebruikt in stakeholderanalyse
         (Socia-perspectief)."@nl .

# ── Concern ───────────────────────────────────────────────────────────────────

ufoc:Concern
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:IntentionalMode ;
    rdfs:label "Concern"@en , "Zorg / betrokkenheid"@nl ;
    rdfs:comment
        "Een intentionele toestand waarbij de agent de propositionele inhoud
         als problematisch of zorgwekkend beschouwt. Fundeert het concept
         'Issue' in VALOR: een Issue bestaat doordat agents een Concern
         hebben ten aanzien van een Situation."@nl .


###############################################################################
# ── 3. SOCIAL RELATOR, COMMITMENT AND CLAIM ───────────────────────────────────
#
#  UFO-C (Guizzardi et al. 2013; Poletaeva et al. 2017) distinguishes:
#
#    SocialRelator     — the overarching Relator connecting two Agents.
#                        It is constituted by a pair of mutually dependent
#                        ExtrinsicModes: a SocialCommitment and a SocialClaim.
#
#    SocialCommitment  — an ExtrinsicMode inhering in the committed Agent
#                        and externally dependent on the claimant Agent.
#                        Represents the duty-side of the social bond.
#
#    SocialClaim       — an ExtrinsicMode inhering in the claimant Agent
#                        and externally dependent on the committed Agent.
#                        Represents the right-side of the social bond.
#
#  Both Moments share the same propositional content, which is a property
#  of the SocialRelator as a whole (Poletaeva 2017 §3.2).
#
#  DESIGN DECISION DD-013 (revised):
#    Previous versions modelled SocialCommitment as a Relator — ontologically
#    incorrect. The Relator is the SocialRelator; Commitment and Claim are
#    the two ExtrinsicMode components that together constitute it.
#    Source: Guizzardi et al. (2013) UFO-C; Poletaeva et al. (2017) Fig. 3.
#
#  This pattern underlies:
#    - DEMO transactions (Transaction is a SocialRelator subclass)
#    - UFO-L legal relations (LegalRelator subClassOf SocialRelator)
#    - i* dependencies (a dependency IS a social relator)
###############################################################################

ufoc:SocialRelator
    a owl:Class ;
    rdf:type gufo:Relator ;
    gufo:ontoumlStereotype "relator" ;
    rdfs:subClassOf gufo:Relator ;
    rdfs:label "SocialRelator"@en , "Sociale relator"@nl ;
    rdfs:comment
        "Een Relator die de normatieve band tussen twee agents uitdrukt.
         Bestaat uit een SocialCommitment (plicht-kant) en een SocialClaim
         (recht-kant) die samen de relator constitueren. De propositionele
         inhoud is eigenschap van de relator als geheel.
         Bron: UFO-C (Guizzardi et al. 2013); Poletaeva et al. (2017)."@nl .

ufoc:SocialCommitment
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf gufo:ExtrinsicMode ;
    rdfs:label "SocialCommitment"@en , "Sociale toezegging"@nl ;
    rdfs:comment
        "Een ExtrinsicMode die inhereert in de committed agent (de plicht-
         dragende partij) en extern afhankelijk is van de claimant agent.
         Vertegenwoordigt de plicht-kant van de sociale band.
         DD-013 (revisie): dit is NIET de overkoepelende Relator, maar één
         van de twee constituerende Moments van de SocialRelator."@nl .

ufoc:SocialClaim
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf gufo:ExtrinsicMode ;
    rdfs:label "SocialClaim"@en , "Sociale aanspraak"@nl ;
    rdfs:comment
        "Een ExtrinsicMode die inhereert in de claimant agent (de recht-
         houdende partij) en extern afhankelijk is van de committed agent.
         Vertegenwoordigt de recht-kant van de sociale band. Spiegelbeeld
         van SocialCommitment; deelt dezelfde propositionele inhoud."@nl .

# ── SocialRelator: mediation en inhoud ───────────────────────────────────────

ufoc:hasCommittedAgent
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has committed agent"@en ;
    rdfs:domain ufoc:SocialRelator ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment "De agent die de plicht draagt in de sociale relator."@nl .

ufoc:hasClaimantAgent
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has claimant agent"@en ;
    rdfs:domain ufoc:SocialRelator ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment "De agent ten behoeve van wie de plicht geldt."@nl .

ufoc:hasCommitmentContent
    a owl:ObjectProperty ;
    rdfs:subPropertyOf gufo:hasPropositionalContent ;
    rdfs:label "has commitment content"@en ;
    rdfs:domain ufoc:SocialRelator ;
    rdfs:range  gufo:Situation ;
    rdfs:comment
        "De propositionele inhoud van de sociale relator: de toestand die
         de committed agent dient te bewerkstelligen. Gedeeld door beide
         constituerende Moments (SocialCommitment en SocialClaim).
         Geen OntoUML-relatie-stereotype: Relator→Situation is een
         gUFO-primitieve relatie (hasPropositionalContent) zonder
         OntoUML-2.0-equivalent (DD-026)."@nl .

# ── SocialRelator: componentOf relaties naar zijn Moments ────────────────────

ufoc:hasCommitmentMoment
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasProperPart ;
    rdfs:label "has commitment moment"@en ;
    rdfs:domain ufoc:SocialRelator ;
    rdfs:range  ufoc:SocialCommitment ;
    rdfs:comment
        "Relateert de SocialRelator aan zijn plicht-Moment (SocialCommitment).
         De SocialCommitment is een constituerend deel van de relator."@nl .

ufoc:hasClaimMoment
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasProperPart ;
    rdfs:label "has claim moment"@en ;
    rdfs:domain ufoc:SocialRelator ;
    rdfs:range  ufoc:SocialClaim ;
    rdfs:comment
        "Relateert de SocialRelator aan zijn recht-Moment (SocialClaim).
         De SocialClaim is een constituerend deel van de relator."@nl .

# ── SocialCommitment: inherentie en externe afhankelijkheid ──────────────────

ufoc:commitmentInheresIn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf gufo:inheresIn ;
    rdfs:label "commitment inheres in"@en ;
    rdfs:domain ufoc:SocialCommitment ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De SocialCommitment inhereert in de committed agent: deze draagt
         de sociale verplichting als intrinsieke eigenschap."@nl .

ufoc:commitmentDependsOn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "externalDependence" ;
    rdfs:subPropertyOf gufo:externallyDependsOn ;
    rdfs:label "commitment depends on"@en ;
    rdfs:domain ufoc:SocialCommitment ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De SocialCommitment is extern afhankelijk van de claimant agent:
         zonder de claimant kan de commitment niet bestaan."@nl .

# ── SocialClaim: inherentie en externe afhankelijkheid ───────────────────────

ufoc:claimInheresIn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf gufo:inheresIn ;
    rdfs:label "claim inheres in"@en ;
    rdfs:domain ufoc:SocialClaim ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De SocialClaim inhereert in de claimant agent: deze draagt het
         sociale recht als intrinsieke eigenschap."@nl .

ufoc:claimDependsOn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "externalDependence" ;
    rdfs:subPropertyOf gufo:externallyDependsOn ;
    rdfs:label "claim depends on"@en ;
    rdfs:domain ufoc:SocialClaim ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De SocialClaim is extern afhankelijk van de committed agent:
         zonder de committed agent kan de claim niet bestaan."@nl .


###############################################################################
# ── 4. SOCIAL OBJECT ──────────────────────────────────────────────────────────
#
#  A social object is an abstract individual whose existence depends on
#  collective acceptance by a community of agents. It is not a physical
#  object but it can be encoded in (or borne by) physical artifacts.
#
#  Examples: a law, a norm, a rule, a language, money, a title.
#
#  In UFO-C, a social object is modelled as an IntrinsicMode of a
#  collective agent (the community that accepts it).
###############################################################################

ufoc:SocialObject
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf gufo:IntrinsicMode ;
    rdfs:label "SocialObject"@en , "Sociaal object"@nl ;
    rdfs:comment
        "Een intrinsieke modus van een collectieve agent (gemeenschap)
         die als sociaal werkelijk geldt zolang de gemeenschap het
         accepteert. Normen, regels, taal, geld."@nl .

ufoc:Norm
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufoc:SocialObject ;
    rdfs:label "Norm"@en , "Norm"@nl ;
    rdfs:comment
        "Een sociaal object dat schrijft voor of verbiedt dat agents
         bepaalde handelingen verrichten of bepaalde toestanden
         bewerkstelligen. Normen kunnen juridisch (UFO-L), organisatorisch
         of moreel zijn."@nl .

ufoc:NormativeSituation
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "NormativeSituation"@en , "Normatieve situatie"@nl ;
    rdfs:comment
        "Een situatie die ontstaat doordat een Norm van toepassing is op
         een bepaalde agent of toestand. De Norm instelt de normatieve
         situatie; de normatieve situatie constitueert rechten en plichten."@nl .

ufoc:instates
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf gufo:contributedToTrigger ;
    rdfs:label "instates"@en ;
    rdfs:domain ufoc:Norm ;
    rdfs:range  ufoc:NormativeSituation ;
    rdfs:comment
        "Relateert een Norm aan de normatieve situatie(s) die ze in het
         leven roept zodra ze van toepassing is."@nl .


###############################################################################
# ── 5. SOCIAL ROLE ────────────────────────────────────────────────────────────
#
#  A social role is a Role (anti-rigid, relational) that an Agent plays
#  within a normative/social context. The role is constituted by the
#  SocialCommitment relator that connects two agents.
###############################################################################

ufoc:SocialRole
    a owl:Class ;
    rdf:type gufo:Role ;
    gufo:ontoumlStereotype "role" ;
    rdfs:subClassOf ufoc:Agent ;
    rdfs:label "SocialRole"@en , "Sociale rol"@nl ;
    rdfs:comment
        "Een Rol die een Agent speelt in een sociale context, geconstitueerd
         door een SocialCommitment. Voorbeeld: Schuldenaar, Schuldeiser,
         Vertegenwoordiger."@nl .


###############################################################################
# ── 6. DELEGATION ─────────────────────────────────────────────────────────────
#
#  Delegation is a material relation between two agents derived from a
#  special SocialCommitment (the Delegatum relator): agent A delegates a
#  goal to agent B. This creates:
#    - a social claim of B towards A (B may rely on A's support)
#    - a social commitment of B towards A (B assumes A's goal)
#
#  The delegation pattern is used in:
#    - DEMO (organisation as network of delegation)
#    - UFO-L / Weigand policy (policy as delegation of normative power)
###############################################################################

ufoc:Delegatum
    a owl:Class ;
    rdf:type gufo:Relator ;
    gufo:ontoumlStereotype "relator" ;
    rdfs:subClassOf ufoc:SocialRelator ;
    rdfs:label "Delegatum"@en , "Delegatieverhouding"@nl ;
    rdfs:comment
        "Een SocialRelator waarbij de committed agent (delegatee) een
         doel van de claimant agent (delegator) overneemt en zich verbindt
         dat doel na te streven namens de delegator.
         DD-013 (revisie): Delegatum is een subklasse van SocialRelator
         (niet meer van SocialCommitment)."@nl .

ufoc:Delegator
    a owl:Class ;
    rdf:type gufo:Role ;
    gufo:ontoumlStereotype "role" ;
    rdfs:subClassOf ufoc:Agent ;
    rdfs:label "Delegator"@en , "Opdrachtgever"@nl ;
    rdfs:comment "De agent die een doel delegeert aan een andere agent."@nl .

ufoc:Delegatee
    a owl:Class ;
    rdf:type gufo:Role ;
    gufo:ontoumlStereotype "role" ;
    rdfs:subClassOf ufoc:Agent ;
    rdfs:label "Delegatee"@en , "Uitvoerend agent"@nl ;
    rdfs:comment
        "De agent die het gedelegeerde doel aanvaardt en zich verbindt dit
         na te streven namens de delegator."@nl .

ufoc:hasDelegator
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf ufoc:hasClaimantAgent ;
    rdfs:label "has delegator"@en ;
    rdfs:domain ufoc:Delegatum ;
    rdfs:range  ufoc:Delegator .

ufoc:hasDelegatee
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf ufoc:hasCommittedAgent ;
    rdfs:label "has delegatee"@en ;
    rdfs:domain ufoc:Delegatum ;
    rdfs:range  ufoc:Delegatee .

ufoc:hasDelegatedGoal
    a owl:ObjectProperty ;
    rdfs:subPropertyOf ufoc:hasCommitmentContent ;
    rdfs:label "has delegated goal"@en ;
    rdfs:domain ufoc:Delegatum ;
    rdfs:range  gufo:Situation ;
    rdfs:comment
        "De gewenste situatie die de delegator aan de delegatee overdraagt.
         Geen OntoUML-relatie-stereotype: zie hasCommitmentContent (DD-026)."@nl .


###############################################################################
# ── 7. SOCIAL ACTION ──────────────────────────────────────────────────────────
#
#  A social action is an Action whose execution creates, modifies or
#  extinguishes a SocialCommitment (or SocialObject).
#  Social actions are speech-act-inspired: they are communicative events
#  between agents.
###############################################################################

ufoc:SocialAction
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Action ;
    rdfs:label "SocialAction"@en , "Sociale handeling"@nl ;
    rdfs:comment
        "Een handeling die een normatief effect heeft: ze roept een
         SocialCommitment in het leven, wijzigt deze, of heft haar op."@nl .

ufoc:CommitmentCreationAction
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf ufoc:SocialAction ;
    rdfs:label "CommitmentCreationAction"@en , "Toezeggingshandeling"@nl ;
    rdfs:comment
        "Een sociale handeling die een nieuwe SocialCommitment in het leven
         roept (bijv. een belofte, een aanvaarding, een overeenkomst)."@nl .

ufoc:CommitmentFulfillmentAction
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf ufoc:SocialAction ;
    rdfs:label "CommitmentFulfillmentAction"@en , "Nakomingshandeling"@nl ;
    rdfs:comment
        "Een sociale handeling die de propositionele inhoud van een
         SocialCommitment verwezenlijkt en daarmee de commitment opheft."@nl .

ufoc:CommitmentRevocationAction
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf ufoc:SocialAction ;
    rdfs:label "CommitmentRevocationAction"@en , "Herroepingshandeling"@nl ;
    rdfs:comment
        "Een sociale handeling waarbij de committed agent de commitment
         terugtrekt (herroept), met toestemming of niet."@nl .

ufoc:createsCommitment
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "creation" ;
    rdfs:subPropertyOf [ owl:inverseOf gufo:wasCreatedIn ] ;
    rdfs:label "creates commitment"@en ;
    rdfs:domain ufoc:CommitmentCreationAction ;
    rdfs:range  ufoc:SocialRelator ;
    rdfs:comment
        "De CommitmentCreationAction brengt een nieuwe SocialRelator tot
         bestaan. Stereotype «creation» conform OntoUML; gUFO-verankering
         via inverse van gufo:wasCreatedIn (DD-025)."@nl .

ufoc:fulfillsCommitment
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "termination" ;
    rdfs:subPropertyOf [ owl:inverseOf gufo:wasTerminatedIn ] ;
    rdfs:label "fulfills commitment"@en ;
    rdfs:domain ufoc:CommitmentFulfillmentAction ;
    rdfs:range  ufoc:SocialRelator ;
    rdfs:comment
        "De CommitmentFulfillmentAction beëindigt een SocialRelator doordat
         de propositionele inhoud is verwezenlijkt. Stereotype «termination»;
         gUFO-verankering via inverse van gufo:wasTerminatedIn (DD-025)."@nl .

ufoc:revokesCommitment
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "termination" ;
    rdfs:subPropertyOf [ owl:inverseOf gufo:wasTerminatedIn ] ;
    rdfs:label "revokes commitment"@en ;
    rdfs:domain ufoc:CommitmentRevocationAction ;
    rdfs:range  ufoc:SocialRelator ;
    rdfs:comment
        "De CommitmentRevocationAction herroept een SocialRelator eenzijdig.
         Stereotype «termination»; gUFO-verankering via inverse van
         gufo:wasTerminatedIn (DD-025)."@nl .


###############################################################################
# ── 8. PROPERTY CHAINS & SHORTCUTS ───────────────────────────────────────────
###############################################################################

# An agent's commitment content — shortcut
ufoc:hasCommitmentTowards
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "material" ;
    rdfs:label "has commitment towards"@en ;
    rdfs:domain ufoc:Agent ;
    rdfs:range  ufoc:Agent ;
    owl:propertyChainAxiom (
        [ owl:inverseOf ufoc:hasCommittedAgent ]
        ufoc:hasClaimantAgent
    ) ;
    rdfs:comment
        "Afgeleide eigenschap: A has commitment towards B als er een
         SocialRelator bestaat waarbij A de committed agent is en
         B de claimant agent."@nl .

# Agent's intentional mode — via characterizes
ufoc:hasIntentionalMode
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf gufo:hasQuality ;
    rdfs:label "has intentional mode"@en ;
    rdfs:domain ufoc:Agent ;
    rdfs:range  ufoc:IntentionalMode ;
    rdfs:comment
        "Relateert een agent aan een van zijn intentionele toestanden
         (doelen, overtuigingen, belangen, zorgen)."@nl .

ufoc:hasGoal
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf ufoc:hasIntentionalMode ;
    rdfs:label "has goal"@en ;
    rdfs:domain ufoc:Agent ;
    rdfs:range  ufoc:Goal .

ufoc:hasInterest
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf ufoc:hasIntentionalMode ;
    rdfs:label "has interest"@en ;
    rdfs:domain ufoc:Agent ;
    rdfs:range  ufoc:Interest .

ufoc:hasConcern
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf ufoc:hasIntentionalMode ;
    rdfs:label "has concern"@en ;
    rdfs:domain ufoc:Agent ;
    rdfs:range  ufoc:Concern .

ufoc:hasBelief
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf ufoc:hasIntentionalMode ;
    rdfs:label "has belief"@en ;
    rdfs:domain ufoc:Agent ;
    rdfs:range  ufoc:Belief .


###############################################################################
# ── 9. SHACL SHAPES (inline documentation) ────────────────────────────────────
#
#  These constraints are expressed as rdfs:comments here.
#  Full SHACL shapes are in the companion shapes file (shacl/00b-ufo-c.shacl.ttl)
#
#  Key constraints:
#  (C1) Every SocialCommitment must mediate exactly 2 distinct Agents
#       (hasCommittedAgent and hasClaimantAgent with owl:differentFrom)
#  (C2) Every CommitmentMode must inhere in the same agent as
#       hasCommittedAgent of its SocialCommitment
#  (C3) Every ClaimMode must inhere in the same agent as
#       hasClaimantAgent of its SocialCommitment
#  (C4) A SocialRole must be connected to at least one SocialCommitment
#       via gufo:mediates
#  (C5) A Concern's propositional content must be typed as a Situation
###############################################################################

ufoc:_shacl_constraints
    rdfs:comment
        """Constraints (see SHACL file):
        C1: SocialRelator mediates exactly 2 distinct Agents
            (hasCommittedAgent ≠ hasClaimantAgent).
        C2: SocialCommitment.commitmentInheresIn = SocialRelator.hasCommittedAgent.
        C3: SocialClaim.claimInheresIn = SocialRelator.hasClaimantAgent.
        C4: SocialRole must participate in ≥1 SocialRelator.
        C5: IntentionalMode.hasPropositionalContent → Situation.""" .


###############################################################################
# END OF MODULE 00b — UFO-C Social Entities
###############################################################################
```

## Module: 00c-ufo-c.shacl.ttl

```turtle
@prefix sh:    <http://www.w3.org/ns/shacl#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix shc:  <https://valor-ecosystem.nl/shacl/ufo-c> .
@prefix vo:   <https://valor-ecosystem.nl/ontology/> .

###############################################################################
# VALOR-O — SHACL Shapes: UFO-C Social Entities (Module 00b)
#
# Constraints C1–C8 as documented in 00b-ufo-c.ttl.
###############################################################################

shc
    a owl:Ontology ;
    dcterms:title "VALOR-O SHACL — UFO-C Social Entities"@nl ;
    owl:versionInfo "0.1" .


###############################################################################
# C1 — SocialRelator mediates exactly 2 distinct Agents
###############################################################################

ufoc:SocialRelatorShape
    a sh:NodeShape ;
    sh:targetClass ufoc:SocialRelator ;
    sh:name "SocialRelatorShape" ;
    sh:description
        "C1: SocialRelator vereist precies één hasCommittedAgent,
         precies één hasClaimantAgent, precies één hasCommitmentContent,
         en de twee agents moeten van elkaar verschillen." ;

    sh:property [
        sh:path ufoc:hasCommittedAgent ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:message "C1a: SocialRelator vereist precies één hasCommittedAgent (ufoc:Agent)."
    ] ;

    sh:property [
        sh:path ufoc:hasClaimantAgent ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:message "C1b: SocialRelator vereist precies één hasClaimantAgent (ufoc:Agent)."
    ] ;

    sh:property [
        sh:path ufoc:hasCommitmentContent ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class gufo:Situation ;
        sh:message "C1c: SocialRelator vereist precies één hasCommitmentContent (gufo:Situation)."
    ] ;

    sh:sparql [
        sh:name    "C1d-agents-distinct" ;
        sh:message "C1d: hasCommittedAgent en hasClaimantAgent mogen niet naar dezelfde agent verwijzen." ;
        sh:prefixes shc ;
        sh:select  """
            SELECT $this WHERE {
                $this ufoc:hasCommittedAgent ?a .
                $this ufoc:hasClaimantAgent  ?b .
                FILTER (?a = ?b)
            }
        """
    ] .


###############################################################################
# C2 — SocialCommitment: inhereert in committed agent, afhankelijk van claimant
###############################################################################

ufoc:SocialCommitmentShape
    a sh:NodeShape ;
    sh:targetClass ufoc:SocialCommitment ;
    sh:name "SocialCommitmentShape" ;
    sh:description
        "C2: SocialCommitment moet via commitmentInheresIn inheren aan de
         hasCommittedAgent van zijn SocialRelator, en via commitmentDependsOn
         afhankelijk zijn van de hasClaimantAgent." ;

    sh:property [
        sh:path ufoc:commitmentInheresIn ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:message "C2a: SocialCommitment.commitmentInheresIn vereist precies één ufoc:Agent."
    ] ;

    sh:property [
        sh:path ufoc:commitmentDependsOn ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:message "C2b: SocialCommitment.commitmentDependsOn vereist precies één ufoc:Agent."
    ] ;

    sh:sparql [
        sh:name    "C2c-inhere-committed" ;
        sh:message "C2c: SocialCommitment.commitmentInheresIn moet overeenkomen met de hasCommittedAgent van de bijbehorende SocialRelator." ;
        sh:prefixes shc ;
        sh:select  """
            SELECT $this WHERE {
                ?relator ufoc:hasCommitmentMoment $this ;
                         ufoc:hasCommittedAgent   ?committed .
                $this ufoc:commitmentInheresIn ?bearer .
                FILTER (?bearer != ?committed)
            }
        """
    ] .


###############################################################################
# C3 — SocialClaim: inhereert in claimant agent, afhankelijk van committed
###############################################################################

ufoc:SocialClaimShape
    a sh:NodeShape ;
    sh:targetClass ufoc:SocialClaim ;
    sh:name "SocialClaimShape" ;
    sh:description
        "C3: SocialClaim moet via claimInheresIn inheren aan de
         hasClaimantAgent van zijn SocialRelator, en via claimDependsOn
         afhankelijk zijn van de hasCommittedAgent." ;

    sh:property [
        sh:path ufoc:claimInheresIn ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:message "C3a: SocialClaim.claimInheresIn vereist precies één ufoc:Agent."
    ] ;

    sh:property [
        sh:path ufoc:claimDependsOn ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:message "C3b: SocialClaim.claimDependsOn vereist precies één ufoc:Agent."
    ] ;

    sh:sparql [
        sh:name    "C3c-inhere-claimant" ;
        sh:message "C3c: SocialClaim.claimInheresIn moet overeenkomen met de hasClaimantAgent van de bijbehorende SocialRelator." ;
        sh:prefixes shc ;
        sh:select  """
            SELECT $this WHERE {
                ?relator ufoc:hasClaimMoment    $this ;
                         ufoc:hasClaimantAgent  ?claimant .
                $this ufoc:claimInheresIn ?bearer .
                FILTER (?bearer != ?claimant)
            }
        """
    ] .


###############################################################################
# C4 — SocialRole participates in at least one SocialRelator
###############################################################################

ufoc:SocialRoleShape
    a sh:NodeShape ;
    sh:targetClass ufoc:SocialRole ;
    sh:name "SocialRoleShape" ;
    sh:description
        "C4: Een SocialRole moet betrokken zijn bij ten minste één
         SocialRelator als committed of claimant agent." ;

    sh:sparql [
        sh:name    "C4-role-in-relator" ;
        sh:message "C4: SocialRole heeft geen SocialRelator als committed of claimant agent." ;
        sh:prefixes shc ;
        sh:select  """
            SELECT $this WHERE {
                FILTER NOT EXISTS {
                    { ?r ufoc:hasCommittedAgent $this }
                    UNION
                    { ?r ufoc:hasClaimantAgent  $this }
                }
            }
        """
    ] .


###############################################################################
# C5 — IntentionalMode has exactly one propositional content (Situation)
###############################################################################

ufoc:IntentionalModeShape
    a sh:NodeShape ;
    sh:targetClass ufoc:IntentionalMode ;
    sh:name "IntentionalModeShape" ;
    sh:description
        "C5: Elke IntentionalMode vereist precies één
         hasPropositionalContent van type gufo:Situation." ;

    sh:property [
        sh:path gufo:hasPropositionalContent ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class gufo:Situation ;
        sh:message "C5: IntentionalMode.hasPropositionalContent vereist precies één gufo:Situation."
    ] .


###############################################################################
# C6 — Agent partition: must be PhysicalAgent or InstitutionalAgent
###############################################################################

ufoc:AgentPartitionShape
    a sh:NodeShape ;
    sh:targetClass ufoc:Agent ;
    sh:name "AgentPartitionShape" ;
    sh:description
        "C6: Elke Agent moet een PhysicalAgent of InstitutionalAgent zijn." ;

    sh:or (
        [ sh:class ufoc:PhysicalAgent      ]
        [ sh:class ufoc:InstitutionalAgent ]
    ) ;
    sh:message "C6: Agent moet ufoc:PhysicalAgent of ufoc:InstitutionalAgent zijn." .


###############################################################################
# C7 — Delegatum: delegator ≠ delegatee, both required
###############################################################################

ufoc:DelegatumShape
    a sh:NodeShape ;
    sh:targetClass ufoc:Delegatum ;
    sh:name "DelegatumShape" ;
    sh:description
        "C7: Delegatum vereist precies één hasDelegator en één
         hasDelegatee, en ze moeten verschillen." ;

    sh:property [
        sh:path ufoc:hasDelegator ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Delegator ;
        sh:message "C7a: Delegatum vereist precies één hasDelegator (ufoc:Delegator)."
    ] ;

    sh:property [
        sh:path ufoc:hasDelegatee ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Delegatee ;
        sh:message "C7b: Delegatum vereist precies één hasDelegatee (ufoc:Delegatee)."
    ] ;

    sh:sparql [
        sh:name    "C7c-delegator-ne-delegatee" ;
        sh:message "C7c: Delegator en Delegatee moeten van elkaar verschillen." ;
        sh:prefixes shc ;
        sh:select  """
            SELECT $this WHERE {
                $this ufoc:hasDelegator ?d1 ;
                      ufoc:hasDelegatee ?d2 .
                FILTER (?d1 = ?d2)
            }
        """
    ] .


###############################################################################
# C8 — Norm is a SocialObject: must inhere in a collective Agent
###############################################################################

ufoc:NormShape
    a sh:NodeShape ;
    sh:targetClass ufoc:Norm ;
    sh:name "NormShape" ;
    sh:description
        "C8: Een Norm is een SocialObject en moet inheren aan een
         institutionele of collectieve Agent (normen bestaan door
         collectieve erkenning)." ;

    sh:property [
        sh:path gufo:inheresIn ;
        sh:minCount 1 ;
        sh:class ufoc:InstitutionalAgent ;
        sh:message "C8: Norm.inheresIn vereist ten minste één ufoc:InstitutionalAgent."
    ] .


###############################################################################
# Prefix declarations for SPARQL constraints
###############################################################################

shc
    a sh:PrefixDeclaration ;
    sh:declare [
        sh:prefix    "gufo" ;
        sh:namespace "http://purl.org/nemo/gufo#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "ufoc" ;
        sh:namespace "https://valor-ecosystem.nl/ontology/ufo-c#"^^xsd:anyURI
    ] .

###############################################################################
# END OF SHACL — UFO-C
###############################################################################
```

---

## Module: 00d-ufo-l.ttl

```turtle
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix ufol:  <https://valor-ecosystem.nl/ontology/ufo-l#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix vo:   <https://valor-ecosystem.nl/ontology/> .

###############################################################################
# VALOR-O — Module 00d: UFO-L  (Legal Relations)
#
# Purpose : Formalise the normative/legal layer of VALOR-O.
#           Covers: LegalSubject, LegalObject, LegalRelation (Hohfeld's
#           four correlate-pairs), Norm, NormativeSituation, LegalFact,
#           DerivationRule, DelegationAuthority, and the Weigand (2024)
#           policy-as-delegation pattern.
#
#           Enriched with concepts from:
#             - Wetsanalyse (Ausems, Bulles, Lokin 2021) — juridisch
#               analyseschema (16 elements), Hohfeld subclasses,
#               DerivationRule (afleidingsregel), LegalObject (rechtsobject),
#               DelegationAuthority/Fulfillment (delegatiebevoegdheid),
#               TemporalCondition (tijdsaanduiding als voorwaarde vs.
#               parameter), DomainVariable (variabele + variabelewaarde).
#             - Weigand, Johannesson, Andersson (2024) — policy as bundle
#               of rights/duties inhering in an agent via delegation,
#               distinct from the policy document as artifact.
#
# Module structuur (na invoeging UFO-B — DD-019):
#   00a-gufo-core.ttl → 00b-ufo-b.ttl → 00c-ufo-c.ttl → 00d-ufo-l.ttl
#
# DESIGN DECISIONS (zie DESIGN-DECISIONS.md):
#   DD-016 · Policy vs. PolicyDocument (Weigand 2024)
#   DD-017 · Hohfeld-implementatie met enforceability-gradaties
#   DD-018 · LegalObject als verplicht gegeven bij elke LegalRelator
#   DD-019 · Module-nummering na invoeging UFO-B
#
# Sources : Guizzardi et al. (2015), UFO-L: An Ontological Account of
#             Legal Relationships.
#           Ausems, Bulles, Lokin (2021), Wetsanalyse.
#           Weigand et al. (2024), VMBO 2024, CEUR-WS Vol. 3821.
#
# Imports : 00a-gufo-core.ttl, 00b-ufo-b.ttl, 00c-ufo-c.ttl
###############################################################################

vo:ufo-l
    a owl:Ontology ;
    owl:imports vo:gufo-core ;
    owl:imports vo:ufo-b ;
    owl:imports vo:ufo-c ;
    dcterms:title "VALOR-O — UFO-L Legal Relations"@nl ;
    dcterms:description
        "Ontologie van rechtsbetrekkingen, normen, rechtsfeiten en
         delegatie. Gebouwd op UFO-L en verrijkt met het juridisch
         analyseschema (Wetsanalyse) en de beleidsontologie (Weigand)."@nl ;
    owl:versionInfo "0.1" .


###############################################################################
# ── OVERVIEW OF HOHFELD CORRELATE PAIRS ──────────────────────────────────────
#
#  Wetsanalyse §4.3.3  /  UFO-L §3
#
#  Pair 1 — Claim-Right  ↔  Duty          (aanspraak – verplichting)
#  Pair 2 — Power/Competence ↔ Liability  (bevoegdheid – gehoudenheid)
#  Pair 3 — Immunity ↔ No-Power           (immuniteit – geen bevoegdheid)
#  Pair 4 — Privilege/Liberty ↔ No-Right  (vrijheid – geen aanspraak)
#
#  Each pair is reified as a LegalRelator that mediates two LegalSubjects
#  and generates two IntrinsicModes (one per party).
###############################################################################


###############################################################################
# ── 1. LEGAL SUBJECT (Rechtssubject) ─────────────────────────────────────────
###############################################################################

ufol:LegalSubject
    a owl:Class ;
    rdf:type gufo:Role ;
    gufo:ontoumlStereotype "role" ;
    rdfs:subClassOf ufoc:Agent ;
    rdfs:label "LegalSubject"@en , "Rechtssubject"@nl ;
    rdfs:comment
        "Een Agent in zijn hoedanigheid als drager van rechten en plichten.
         Een rechtssubject speelt deze rol in de context van een
         LegalRelator (rechtsbetrekking)."@nl .

ufol:NaturalPersonSubject
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf ufol:LegalSubject ;
    rdfs:label "NaturalPersonSubject"@en , "Natuurlijk persoon"@nl ;
    rdfs:comment
        "Een rechtssubject dat een fysieke persoon is. Draagt rechten en
         plichten vanwege zijn hoedanigheid als natuurlijk persoon in een
         specifieke juridische relatie (bijv. belastingplichtige, burger,
         werknemer)."@nl .

ufol:LegalPersonSubject
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalSubject ;
    rdfs:label "LegalPersonSubject"@en , "Rechtspersoon"@nl ;
    rdfs:comment
        "Een rechtssubject dat een institutionele agent is (gemeente,
         bedrijf, bestuursorgaan). Bestaat door collectieve erkenning
         en draagt rechten en plichten als rechtspersoon."@nl .


###############################################################################
# ── 2. LEGAL OBJECT (Rechtsobject) ───────────────────────────────────────────
#
#  Toevoeging op basis van Wetsanalyse element 2.
#  Een rechtsobject is het voorwerp van een rechtsbetrekking:
#  de zaak, dienst, handeling of het informatieobject waarop de
#  rechtsbetrekking betrekking heeft.
###############################################################################

ufol:LegalObject
    a owl:Class ;
    rdf:type gufo:Kind ;
    gufo:ontoumlStereotype "kind" ;
    rdfs:subClassOf gufo:FunctionalComplex ;
    rdfs:label "LegalObject"@en , "Rechtsobject"@nl ;
    rdfs:comment
        "Het voorwerp van een rechtsbetrekking: een zaak, dienst,
         handeling of informatieobject waarop een LegalRelator betrekking
         heeft. Wetsanalyse: 'het voorwerp waarop een in de wetgeving
         beschreven handeling of situatie betrekking heeft'."@nl .

ufol:PhysicalLegalObject
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalObject ;
    rdfs:label "PhysicalLegalObject"@en , "Fysiek rechtsobject"@nl ;
    rdfs:comment "Een tastbare zaak als rechtsobject (woning, voertuig)."@nl .

ufol:AbstractLegalObject
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalObject ;
    rdfs:label "AbstractLegalObject"@en , "Abstract rechtsobject"@nl ;
    rdfs:comment
        "Een niet-fysiek rechtsobject: uitkering, bijdrage, vergunning,
         recht op studiefinanciering."@nl .

ufol:InformationLegalObject
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalObject ;
    rdfs:label "InformationLegalObject"@en , "Informatierechtsobject"@nl ;
    rdfs:comment
        "Een informatie-object als rechtsobject: aangifte, bezwaarschrift,
         beschikking, aanvraag."@nl .


###############################################################################
# ── 3. NORM ───────────────────────────────────────────────────────────────────
#
#  A Norm is a social object (UFO-C) that instates a NormativeSituation.
#  The NormativeSituation constitutes the LegalRelator.
#
#  Norm types follow Wetsanalyse §4.2.2:
#    - Conduct norm (gedragsregel): obliges, forbids, permits behaviour
#    - Competence norm (bevoegdheidsregel): grants authority to act
#    - Derivation norm (afleidingsregel): determines rights/duty content
###############################################################################

ufol:LegalNorm
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufoc:Norm ;
    rdfs:label "LegalNorm"@en , "Rechtsnorm"@nl ;
    rdfs:comment
        "Een sociaal object dat een juridisch geldige norm constitueert.
         Rechtsnormen zijn in formele of gedelegeerde wetgeving verankerd
         en worden door institutionele autoriteit gehandhaafd."@nl .

ufol:ConductNorm
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalNorm ;
    rdfs:label "ConductNorm"@en , "Gedragsregel"@nl ;
    rdfs:comment
        "Een rechtsnorm die gedrag of handelen gebiedt, verbiedt of
         toestaat. Wetsanalyse: 'gedragsregels staan bepaalde gedragingen
         of handelingen toe, verbieden of leggen ze op'."@nl .

ufol:CompetenceNorm
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalNorm ;
    rdfs:label "CompetenceNorm"@en , "Bevoegdheidsregel"@nl ;
    rdfs:comment
        "Een rechtsnorm die een bestuursorgaan of rechtssubject de
         bevoegdheid verleent een bepaalde handeling te verrichten of
         een bepaalde toestand tot stand te brengen."@nl .

ufol:NormativeSituation
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "NormativeSituation"@en , "Normatieve situatie"@nl ;
    rdfs:comment
        "Een situatie die bestaat doordat een LegalNorm van toepassing
         is op een of meer LegalSubjects. De NormativeSituation
         constitueert de LegalRelator (rechtsbetrekking)."@nl .

ufol:instatesNormativeSituation
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf gufo:contributedToTrigger ;
    rdfs:label "instates normative situation"@en ;
    rdfs:domain ufol:LegalNorm ;
    rdfs:range  ufol:NormativeSituation ;
    rdfs:comment
        "Relateert een LegalNorm aan de NormativeSituation die zij in
         het leven roept zodra zij van toepassing is."@nl .

ufol:hasLegalBasis
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf gufo:historicallyDependsOn ;
    rdfs:label "has legal basis"@en ;
    rdfs:domain ufol:NormativeSituation ;
    rdfs:range  ufol:LegalNorm ;
    rdfs:comment
        "Relateert een NormativeSituation (of LegalRelator) aan de
         LegalNorm waarop zij is gebaseerd. Fundeert traceerbaarheid:
         elke Tessera in Lexa heeft via dit pad een bronwetsartikel."@nl .


###############################################################################
# ── 4. LEGAL RELATION / RELATOR (Rechtsbetrekking) ───────────────────────────
#
#  A LegalRelator is a Relator (UFO) that mediates two LegalSubjects.
#  Following Hohfeld, it generates an IntrinsicMode in each party:
#    - the right-holder gets a RightMode
#    - the duty-bearer gets a DutyMode
#
#  The LegalRelator has a LegalObject (what the relation is about) and
#  a temporal scope (optionally bounded by TemporalConditions).
###############################################################################

ufol:LegalRelator
    a owl:Class ;
    rdf:type gufo:Relator ;
    gufo:ontoumlStereotype "relator" ;
    rdfs:subClassOf ufoc:SocialRelator ;
    rdfs:label "LegalRelator"@en , "Rechtsbetrekking"@nl ;
    rdfs:comment
        "Een SocialRelator die een juridische verhouding uitdrukt tussen twee
         LegalSubjects. Medieert een rechthebbende (right-holder) en een
         plichthebbende (duty-bearer). Specialisatie van SocialRelator:
         de juridische band is een bijzondere vorm van sociale band.
         Wetsanalyse: 'een juridische relatie tussen twee rechtssubjecten
         en beschrijft een specifieke juridische toestand'.
         DD-027: LegalRelator subClassOf ufoc:SocialRelator."@nl .

ufol:hasRightHolder
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has right holder"@en , "heeft rechthebbende"@nl ;
    rdfs:domain ufol:LegalRelator ;
    rdfs:range  ufol:LegalSubject .

ufol:hasDutyBearer
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has duty bearer"@en , "heeft plichthebbende"@nl ;
    rdfs:domain ufol:LegalRelator ;
    rdfs:range  ufol:LegalSubject .

ufol:hasLegalObject
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has legal object"@en , "heeft rechtsobject"@nl ;
    rdfs:domain ufol:LegalRelator ;
    rdfs:range  ufol:LegalObject ;
    rdfs:comment
        "Relateert een rechtsbetrekking aan het rechtsobject: het voorwerp
         waarop de rechtsbetrekking betrekking heeft."@nl .

ufol:hasTemporalScope
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf gufo:hasQuality ;
    rdfs:label "has temporal scope"@en ;
    rdfs:domain ufol:LegalRelator ;
    rdfs:range  ufol:TemporalCondition ;
    rdfs:comment
        "De temporele geldigheidsscope van de rechtsbetrekking: een
         termijn, peildatum of periode waarbinnen zij geldt."@nl .

# ── Right and Duty Modes ──────────────────────────────────────────────────────

ufol:RightMode
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:SocialClaim ;
    rdfs:label "RightMode"@en , "Recht (modus)"@nl ;
    rdfs:comment
        "De ExtrinsicMode die de rechthebbende draagt als gevolg van de
         LegalRelator: zijn recht op nakoming door de plichthebbende.
         Specialisatie van SocialClaim: het juridische recht is een
         bijzondere vorm van sociale aanspraak.
         DD-027: RightMode subClassOf ufoc:SocialClaim."@nl .

ufol:DutyMode
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:SocialCommitment ;
    rdfs:label "DutyMode"@en , "Plicht (modus)"@nl ;
    rdfs:comment
        "De ExtrinsicMode die de plichthebbende draagt als gevolg van de
         LegalRelator: zijn juridische verplichting.
         Specialisatie van SocialCommitment: de juridische plicht is een
         bijzondere vorm van sociale toezegging.
         DD-027: DutyMode subClassOf ufoc:SocialCommitment."@nl .

ufol:hasRightMode
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf ufoc:hasClaimMoment ;
    rdfs:label "has right mode"@en ;
    rdfs:domain ufol:LegalRelator ;
    rdfs:range  ufol:RightMode ;
    rdfs:comment
        "Relateert de LegalRelator aan zijn RightMode (het recht-Moment).
         Specialisatie van ufoc:hasClaimMoment."@nl .

ufol:hasDutyMode
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf ufoc:hasCommitmentMoment ;
    rdfs:label "has duty mode"@en ;
    rdfs:domain ufol:LegalRelator ;
    rdfs:range  ufol:DutyMode ;
    rdfs:comment
        "Relateert de LegalRelator aan zijn DutyMode (het plicht-Moment).
         Specialisatie van ufoc:hasCommitmentMoment."@nl .


###############################################################################
# ── 5. HOHFELD SUBCLASSES (Wetsanalyse §4.3.3) ───────────────────────────────
###############################################################################

# ── Pair 1: Claim-Right ↔ Duty (aanspraak – verplichting) ────────────────────

ufol:ClaimRightRelator
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalRelator ;
    rdfs:label "ClaimRightRelator"@en , "Aanspraak–verplichting"@nl ;
    rdfs:comment
        "Het meest voorkomende type rechtsbetrekking. De plichthebbende
         heeft de verplichting een bepaalde handeling te verrichten of na
         te laten; de rechthebbende heeft de aanspraak dat dit ook
         daadwerkelijk gebeurt. Wetsanalyse onderscheidt drie varianten:
         krachtige aanspraak, aanspraak na ingebrekestelling, zwakke
         aanspraak."@nl .

ufol:EnforceabilityLevel
    a owl:Class ;
    gufo:ontoumlStereotype "quality" ;
    rdfs:subClassOf gufo:Quality ;
    rdfs:label "EnforceabilityLevel"@en , "Afdwingbaarheidsniveau"@nl ;
    rdfs:comment
        "De mate waarin de aanspraak afdwingbaar is. Waarden:
         StrongClaim (krachtige aanspraak — fatale verplichting),
         ClaimAfterDefault (aanspraak na ingebrekestelling),
         WeakClaim (zwakke aanspraak — zwakke verplichting)."@nl .

ufol:StrongClaim
    a ufol:EnforceabilityLevel ;
    rdfs:label "StrongClaim"@en , "Krachtige aanspraak"@nl .

ufol:ClaimAfterDefault
    a ufol:EnforceabilityLevel ;
    rdfs:label "ClaimAfterDefault"@en , "Aanspraak na ingebrekestelling"@nl .

ufol:WeakClaim
    a ufol:EnforceabilityLevel ;
    rdfs:label "WeakClaim"@en , "Zwakke aanspraak"@nl .

ufol:hasEnforceability
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "structuration" ;
    rdfs:subPropertyOf gufo:hasQuality ;
    rdfs:label "has enforceability"@en ;
    rdfs:domain ufol:ClaimRightRelator ;
    rdfs:range  ufol:EnforceabilityLevel .

# ── Pair 2: Power/Competence ↔ Liability (bevoegdheid – gehoudenheid) ─────────

ufol:CompetenceRelator
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalRelator ;
    rdfs:label "CompetenceRelator"@en , "Bevoegdheid–gehoudenheid"@nl ;
    rdfs:comment
        "Een rechtsbetrekking waarbij de rechthebbende (de bevoegde agent)
         de bevoegdheid heeft een juridische toestand tot stand te brengen
         die de plichthebbende (de gehoudene) raakt. Wetsanalyse:
         gebonden bevoegdheid (indicatief presens) vs. discretionaire
         bevoegdheid ('kan', 'naar zijn oordeel')."@nl .

ufol:CompetenceType
    a owl:Class ;
    gufo:ontoumlStereotype "quality" ;
    rdfs:subClassOf gufo:Quality ;
    rdfs:label "CompetenceType"@en , "Bevoegdheidstype"@nl .

ufol:BoundCompetence
    a ufol:CompetenceType ;
    rdfs:label "BoundCompetence"@en , "Gebonden bevoegdheid"@nl ;
    rdfs:comment
        "De bevoegde agent heeft geen vrijheid bij de uitoefening van
         de bevoegdheid. Herkenbaar aan indicatief presens in de wet."@nl .

ufol:DiscretionaryCompetence
    a ufol:CompetenceType ;
    rdfs:label "DiscretionaryCompetence"@en , "Discretionaire bevoegdheid"@nl ;
    rdfs:comment
        "De bevoegde agent heeft vrijheid om de bevoegdheid wel of niet
         uit te oefenen. Herkenbaar aan 'kan', 'naar zijn oordeel'."@nl .

ufol:hasCompetenceType
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "structuration" ;
    rdfs:subPropertyOf gufo:hasQuality ;
    rdfs:label "has competence type"@en ;
    rdfs:domain ufol:CompetenceRelator ;
    rdfs:range  ufol:CompetenceType .

# ── Pair 3: Immunity ↔ No-Power (immuniteit – geen bevoegdheid) ───────────────

ufol:ImmunityRelator
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalRelator ;
    rdfs:label "ImmunityRelator"@en , "Immuniteit–geen bevoegdheid"@nl ;
    rdfs:comment
        "Een rechtsbetrekking waarbij de rechthebbende een immuniteit
         heeft die de bevoegdheid van de wederpartij als het ware
         neutraliseert. Voorbeeld: diplomatieke immuniteit."@nl .

# ── Pair 4: Privilege/Liberty ↔ No-Right (vrijheid – geen aanspraak) ──────────

ufol:LibertyRelator
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalRelator ;
    rdfs:label "LibertyRelator"@en , "Vrijheid–geen aanspraak"@nl ;
    rdfs:comment
        "Een rechtsbetrekking waarbij de rechthebbende een vrije keuze
         heeft waarop de wederpartij geen aanspraak kan maken.
         Wetsanalyse: 'voor de uitvoeringspraktijk minder relevant'
         omdat er geen rechtsfeiten bij horen."@nl .


###############################################################################
# ── 6. LEGAL FACT (Rechtsfeit) ────────────────────────────────────────────────
#
#  A legal fact is an Event that creates, modifies or extinguishes a
#  LegalRelator (rechtsbetrekking).
#
#  Wetsanalyse element 4, four subclasses:
#    a. Rechtshandeling (intentional act aimed at legal effect)
#    b. Feitelijke handeling met rechtsgevolg (act with unintended legal effect)
#    c. Gebeurtenis met rechtsgevolg (event without acting subject)
#    d. Tijdsverloop met rechtsgevolg (temporal trigger)
###############################################################################

ufol:LegalFact
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Event ;
    rdfs:label "LegalFact"@en , "Rechtsfeit"@nl ;
    rdfs:comment
        "Een handeling of gebeurtenis, of tijdsverloop dat een wijziging
         in de juridische toestand teweegbrengt. Wetsanalyse: 'rechtsfeiten
         creëren, wijzigen of beëindigen rechten en plichten'."@nl .

ufol:createsLegalRelation
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "creation" ;
    rdfs:subPropertyOf [ owl:inverseOf gufo:wasCreatedIn ] ;
    rdfs:label "creates legal relation"@en ;
    rdfs:domain ufol:LegalFact ;
    rdfs:range  ufol:LegalRelator ;
    rdfs:comment
        "Het rechtsfeit doet een nieuwe LegalRelator ontstaan.
         Stereotype «creation»; gUFO-verankering via inverse van
         gufo:wasCreatedIn (DD-025)."@nl .

ufol:modifiesLegalRelation
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf gufo:historicallyDependsOn ;
    rdfs:label "modifies legal relation"@en ;
    rdfs:domain ufol:LegalFact ;
    rdfs:range  ufol:LegalRelator ;
    rdfs:comment
        "Convenience property: het rechtsfeit wijzigt een LegalRelator.
         Ontologisch patroon (DD-028): modificatie is terminatie van de
         oude LegalRelator + creatie van een nieuwe LegalRelator + een
         historicalDependence van de nieuwe op de oude. Deze property
         drukt de historische afhankelijkheidsrelatie uit.
         Stereotype «historicalDependence»."@nl .

ufol:terminatesLegalRelation
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "termination" ;
    rdfs:subPropertyOf [ owl:inverseOf gufo:wasTerminatedIn ] ;
    rdfs:label "terminates legal relation"@en ;
    rdfs:domain ufol:LegalFact ;
    rdfs:range  ufol:LegalRelator ;
    rdfs:comment
        "Het rechtsfeit beëindigt een bestaande LegalRelator.
         Stereotype «termination»; gUFO-verankering via inverse van
         gufo:wasTerminatedIn (DD-025)."@nl .

# ── 6a: Rechtshandeling ───────────────────────────────────────────────────────

ufol:LegalAct
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf ufol:LegalFact ;
    rdfs:subClassOf gufo:Action ;
    rdfs:label "LegalAct"@en , "Rechtshandeling"@nl ;
    rdfs:comment
        "Een handeling die iemand uitvoert met de bedoeling een bepaald
         rechtsgevolg tot stand te brengen. Wetsanalyse: 'op rechtsgevolg
         gerichte wil die zich door een verklaring heeft geopenbaard'."@nl .

ufol:PublicLawAct
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalAct ;
    rdfs:label "PublicLawAct"@en , "Publiekrechtelijke rechtshandeling"@nl ;
    rdfs:comment
        "Een rechtshandeling waarbij een bestuursorgaan zijn bevoegdheid
         ontleent aan een wettelijk voorschrift en het handelen op
         rechtsgevolgen is gericht (bijv. een besluit ex art. 1:3 Awb)."@nl .

ufol:PrivateLawAct
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalAct ;
    rdfs:label "PrivateLawAct"@en , "Privaatrechtelijke rechtshandeling"@nl ;
    rdfs:comment
        "Een rechtshandeling in de privaatrechtelijke sfeer (overeenkomst,
         eenzijdige rechtshandeling ex art. 3:33 BW)."@nl .

# ── 6b: Feitelijke handeling met rechtsgevolg ─────────────────────────────────

ufol:FactualActWithLegalEffect
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf ufol:LegalFact ;
    rdfs:subClassOf gufo:Action ;
    rdfs:label "FactualActWithLegalEffect"@en ,
               "Feitelijke handeling met rechtsgevolg"@nl ;
    rdfs:comment
        "Een handeling met rechtsgevolg zonder dat de betrokkene dat
         rechtsgevolg beoogde."@nl .

# ── 6c: Gebeurtenis met rechtsgevolg ──────────────────────────────────────────

ufol:EventWithLegalEffect
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf ufol:LegalFact ;
    rdfs:label "EventWithLegalEffect"@en , "Gebeurtenis met rechtsgevolg"@nl ;
    rdfs:comment
        "Een gebeurtenis die rechtsgevolgen heeft zonder dat daar een
         handelend rechtssubject aan te pas komt (overlijden,
         natuurramp)."@nl .

# ── 6d: Tijdsverloop met rechtsgevolg ─────────────────────────────────────────

ufol:TemporalTrigger
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf ufol:LegalFact ;
    rdfs:label "TemporalTrigger"@en , "Tijdsverloop met rechtsgevolg"@nl ;
    rdfs:comment
        "Een tijdsverloop waaraan de wet een rechtsgevolg verbindt:
         het aflopen van een termijn brengt een wijziging in de juridische
         toestand teweeg."@nl .

ufol:triggerDuration
    a owl:DatatypeProperty ;
    rdfs:label "trigger duration"@en ;
    rdfs:domain ufol:TemporalTrigger ;
    rdfs:range  xsd:duration ;
    rdfs:comment "De duur van de termijn die het rechtsgevolg triggert."@nl .


###############################################################################
# ── 7. TEMPORAL CONDITION (Tijdsaanduiding) ───────────────────────────────────
#
#  Wetsanalyse element 12: tijdsaanduidingen bepalen de geldigheidsscope
#  van rechtsbetrekkingen of zijn parameters in afleidingsregels.
#  Onderscheid: tijdsaanduiding-als-voorwaarde vs. peildatum-als-parameter.
###############################################################################

ufol:TemporalCondition
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf gufo:IntrinsicMode ;
    rdfs:label "TemporalCondition"@en , "Tijdsaanduiding"@nl ;
    rdfs:comment
        "Een tijdsgebonden conditie die de geldigheid van een
         rechtsbetrekking of de toepasselijkheid van een afleidingsregel
         begrenst. Wetsanalyse element 12: tijdsaanduidingen kunnen een
         verbijzondering zijn van een voorwaarde (termijn) of van een
         parameter (peildatum)."@nl .

ufol:DeadlineCondition
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:TemporalCondition ;
    rdfs:label "DeadlineCondition"@en , "Termijn"@nl ;
    rdfs:comment
        "Een tijdsaanduiding die fungeert als voorwaarde: de handeling
         moet binnen de gestelde termijn worden verricht om het
         beoogde rechtsgevolg te hebben."@nl .

ufol:ReferenceDate
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:TemporalCondition ;
    rdfs:label "ReferenceDate"@en , "Peildatum / referentieperiode"@nl ;
    rdfs:comment
        "Een tijdsaanduiding die fungeert als parameter in een
         afleidingsregel: een vaste datum of periode waarop de
         toestand van het rechtssubject beoordeeld wordt
         (bijv. 1 januari van het kalenderjaar)."@nl .

ufol:hasStartDate
    a owl:DatatypeProperty ;
    rdfs:label "has start date"@en ;
    rdfs:domain ufol:TemporalCondition ;
    rdfs:range  xsd:date .

ufol:hasEndDate
    a owl:DatatypeProperty ;
    rdfs:label "has end date"@en ;
    rdfs:domain ufol:TemporalCondition ;
    rdfs:range  xsd:date .


###############################################################################
# ── 8. DOMAIN VARIABLE (Variabele + Variabelewaarde) ─────────────────────────
#
#  Wetsanalyse elements 7+8: een variabele is een kenmerk van een
#  rechtssubject, rechtsobject, rechtsbetrekking of rechtsfeit dat voor
#  verschillende instanties een andere waarde kan hebben.
#  In gUFO: een Quality-type dat inhereert aan een LegalSubject of LegalObject.
###############################################################################

ufol:DomainVariable
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf gufo:Quality ;
    rdfs:label "DomainVariable"@en , "Variabele"@nl ;
    rdfs:comment
        "Een kenmerk van een rechtssubject, rechtsobject, rechtsbetrekking
         of rechtsfeit dat per instantie een andere waarde kan hebben.
         Wetsanalyse element 7: 'de waarde die een bepaalde variabele kan
         hebben' is een DomainVariableValue."@nl .

ufol:DomainVariableValue
    a owl:Class ;
    gufo:ontoumlStereotype "quality" ;
    rdfs:subClassOf gufo:QualityValue ;
    rdfs:label "DomainVariableValue"@en , "Variabelewaarde"@nl ;
    rdfs:comment
        "De concrete waarde van een DomainVariable voor een specifieke
         instantie (bijv. inkomen = € 45.000, leeftijd = 67)."@nl .

ufol:LegalParameter
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufol:DomainVariable ;
    rdfs:label "LegalParameter"@en , "Parameter"@nl ;
    rdfs:comment
        "Een variabele die over een periode voor alle rechtssubjecten
         en rechtsobjecten gelijke waarden heeft. Wetsanalyse element 9:
         'vaste getallen of waarden in een afleidingsregel die over een
         periode gelijk zijn voor alle rechtssubjecten en rechtsobjecten'
         (bijv. premiepercentage, drempelbedrag)."@nl .

ufol:LegalParameterValue
    a owl:Class ;
    gufo:ontoumlStereotype "quality" ;
    rdfs:subClassOf ufol:DomainVariableValue ;
    rdfs:label "LegalParameterValue"@en , "Parameterwaarde"@nl ;
    rdfs:comment
        "De concrete waarde van een LegalParameter in een gegeven periode
         (bijv. maximumdagloon 2020 = € 57.232)."@nl .

ufol:hasVariableValue
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "structuration" ;
    rdfs:subPropertyOf gufo:hasQualityValue ;
    rdfs:label "has variable value"@en ;
    rdfs:domain ufol:DomainVariable ;
    rdfs:range  ufol:DomainVariableValue .


###############################################################################
# ── 9. DERIVATION RULE (Afleidingsregel) ─────────────────────────────────────
#
#  Wetsanalyse element 6: an afleidingsregel is a rule that derives new
#  facts or values from existing ones. It determines whether a right exists
#  (beslisregel) or its extent (rekenregel).
#
#  In UFO terms: a normative specification that links a set of
#  DomainVariables (input) to a LegalRelator or DomainVariable (output)
#  via a derivation logic. The rule is a SocialObject (UFO-C) — it is
#  collectively accepted as binding.
###############################################################################

ufol:DerivationRule
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufoc:SocialObject ;
    rdfs:label "DerivationRule"@en , "Afleidingsregel"@nl ;
    rdfs:comment
        "Een rechtsnorm die de inhoud of omvang van een rechtsbetrekking
         bepaalt door nieuwe feiten of waarden af te leiden uit bestaande.
         Wetsanalyse element 6: beslisregel (bepaalt of een recht bestaat)
         of rekenregel (bepaalt de hoogte/duur van een recht)."@nl .

ufol:DecisionRule
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:DerivationRule ;
    rdfs:label "DecisionRule"@en , "Beslisregel"@nl ;
    rdfs:comment
        "Een afleidingsregel die bepaalt of een rechtssubject of
         rechtsobject tot een bepaalde categorie behoort of recht heeft
         op een bepaalde rechtsbetrekking (bijv. art. 17 WW:
         recht op uitkering)."@nl .

ufol:CalculationRule
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:DerivationRule ;
    rdfs:label "CalculationRule"@en , "Rekenregel"@nl ;
    rdfs:comment
        "Een afleidingsregel die de hoogte of duur van een recht of plicht
         bepaalt (bijv. art. 47 WW: hoogte uitkering = 0,75 × (...))."@nl .

ufol:hasInputVariable
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasQuality ;
    rdfs:label "has input variable"@en ;
    rdfs:domain ufol:DerivationRule ;
    rdfs:range  ufol:DomainVariable ;
    rdfs:comment
        "Een DomainVariable die als invoervariabele wordt gebruikt in de
         afleidingsregel. Stereotype «componentOf»: de variabele is een
         constituerend onderdeel van de regel."@nl .

ufol:hasOutputVariable
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasQuality ;
    rdfs:label "has output variable"@en ;
    rdfs:domain ufol:DerivationRule ;
    rdfs:range  ufol:DomainVariable ;
    rdfs:comment
        "De DomainVariable (uitvoervariabele) die door de afleidingsregel
         wordt bepaald. Stereotype «componentOf»: de variabele is een
         constituerend onderdeel van de regel."@nl .

ufol:derivesRelator
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "derivation" ;
    rdfs:subPropertyOf gufo:contributedToTrigger ;
    rdfs:label "derives relator"@en ;
    rdfs:domain ufol:DerivationRule ;
    rdfs:range  ufol:LegalRelator ;
    rdfs:comment
        "De LegalRelator (rechtsbetrekking) waarvan het bestaan of de
         omvang wordt afgeleid door deze DerivationRule."@nl .

ufol:dependsOnRule
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf gufo:historicallyDependsOn ;
    rdfs:label "depends on rule"@en ;
    rdfs:domain ufol:DerivationRule ;
    rdfs:range  ufol:DerivationRule ;
    rdfs:comment
        "Afleidingshiërarchie (Wetsanalyse): een afleidingsregel kan
         afhankelijk zijn van de uitvoer van een andere afleidingsregel.
         Transitief: modelleer geen cirkels."@nl .

ufol:hasCondition
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasPropositionalContent ;
    rdfs:label "has condition"@en ;
    rdfs:domain ufol:DerivationRule ;
    rdfs:range  ufol:LegalCondition ;
    rdfs:comment
        "De voorwaarde(n) waaronder de afleidingsregel van toepassing is
         (Wetsanalyse element 5). Stereotype «componentOf»: de LegalCondition
         is een constituerend onderdeel van de DerivationRule."@nl .

# ── Condition (Voorwaarde, Wetsanalyse element 5) ─────────────────────────────

ufol:LegalCondition
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "LegalCondition"@en , "Voorwaarde"@nl ;
    rdfs:comment
        "Een conditie die beschrijft aan welke omstandigheid voldaan moet
         zijn voor het intreden van een rechtsgevolg. Wetsanalyse element
         5: 'herkenbaar aan voegwoorden zoals indien, als, tenzij, mits'."@nl .

ufol:CumulativeCondition
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalCondition ;
    rdfs:label "CumulativeCondition"@en , "Cumulatieve voorwaarde"@nl ;
    rdfs:comment "Alle deelcondities moeten gelden (AND)."@nl .

ufol:AlternativeCondition
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:LegalCondition ;
    rdfs:label "AlternativeCondition"@en , "Alternatieve voorwaarde"@nl ;
    rdfs:comment "Ten minste één deelconditie moet gelden (OR)."@nl .

ufol:hasSubCondition
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasPropositionalContent ;
    rdfs:label "has sub-condition"@en ;
    rdfs:domain ufol:LegalCondition ;
    rdfs:range  ufol:LegalCondition ;
    rdfs:comment
        "Deelcondities van een samengestelde LegalCondition (AND/OR-boom).
         Stereotype «componentOf» (Situation→Situation): de deelcondities
         zijn constituerende onderdelen van de samengestelde conditie."@nl .


###############################################################################
# ── 10. DELEGATION AUTHORITY (Delegatiebevoegdheid) ──────────────────────────
#
#  Wetsanalyse elements 14+15 + Weigand (2024) policy-as-delegation.
#
#  A DelegationAuthority is a CompetenceRelator where:
#    - the right-holder (delegating body) grants authority to make rules
#    - the duty-bearer (delegatee) may or must exercise that authority
#
#  The resulting rules constitute a Policy (Weigand): a bundle of
#  rights/duties inhering in an agent via this delegation chain.
#  The PolicyDocument (beleidsregel, AMvB, ministeriële regeling) is
#  an InformationLegalObject that describes (but is NOT identical to)
#  the Policy.
###############################################################################

ufol:DelegationAuthority
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:CompetenceRelator ;
    rdfs:label "DelegationAuthority"@en , "Delegatiebevoegdheid"@nl ;
    rdfs:comment
        "Een bevoegdheidsrechtsbetrekking waarbij de bevoegde agent
         (delegating body) de bevoegdheid heeft — of de opdracht — om
         nadere regels te stellen over een rechtsbetrekking, rechtsfeit
         of afleidingsregel. Wetsanalyse element 14."@nl .

ufol:DelegationMandatory
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:DelegationAuthority ;
    rdfs:label "MandatoryDelegation"@en , "Verplichte delegatie"@nl ;
    rdfs:comment
        "Verplichte delegatie: de (nadere) regels moeten worden gesteld.
         Herkenbaar aan: 'bij amvb worden regels gesteld'."@nl .

ufol:DelegationFacultative
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:DelegationAuthority ;
    rdfs:label "FacultativeDelegation"@en , "Facultatieve delegatie"@nl ;
    rdfs:comment
        "Facultatieve delegatie: er is een keuze om de wettelijke regels
         al dan niet uit te werken. Herkenbaar aan: 'kunnen regels
         worden gesteld'."@nl .

ufol:allowsSubdelegation
    a owl:DatatypeProperty ;
    rdfs:label "allows subdelegation"@en ;
    rdfs:domain ufol:DelegationAuthority ;
    rdfs:range  xsd:boolean ;
    rdfs:comment
        "Wetsanalyse: subdelegatie is mogelijk als 'bij of krachtens'
         wordt gebruikt in de delegatiebevoegdheid."@nl .

ufol:DelegationFulfillment
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Event ;
    rdfs:label "DelegationFulfillment"@en , "Delegatie-invulling"@nl ;
    rdfs:comment
        "De concrete regeling of het regelingsonderdeel waarin de
         DelegationAuthority is ingevuld (bijv. een AMvB, ministeriële
         regeling of beleidsregel). Wetsanalyse element 15.
         Gecorrigeerd stereotype: «event» i.p.v. «subkind» — dit is een
         Event-subklasse, geen Endurant-subklasse (DD-026)."@nl .

ufol:fulfillsDelegation
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "termination" ;
    rdfs:subPropertyOf [ owl:inverseOf gufo:wasTerminatedIn ] ;
    rdfs:label "fulfills delegation"@en ;
    rdfs:domain ufol:DelegationFulfillment ;
    rdfs:range  ufol:DelegationAuthority ;
    rdfs:comment
        "Expliciete terugverwijzing van de delegatie-invulling naar
         de delegatiegrondslag in de bovenliggende wet: de DelegationAuthority
         wordt 'ingevuld' en daarmee beëindigd als open verplichting.
         Stereotype «termination» (Event→Relator, DD-025).
         Wetsanalyse: 'het is praktisch als de wetgever in de delegatie-invulling
         uitdrukkelijk verwijst naar de delegatiegrondslag'."@nl .


###############################################################################
# ── 11. POLICY (Weigand 2024) ─────────────────────────────────────────────────
#
#  A Policy is an ExtrinsicMode: it inheres in one InstitutionalAgent (the
#  bearer/organizer) and is externally dependent on the agents it addresses
#  (the organizational agents whose behaviour it governs).
#
#  This follows directly from Weigand (2024) §4.1:
#    "The policy is a mode of the Organizer; and since it also externally
#     dependent on the Organizational Agent, it is positioned as part of
#     the Organization relator."
#
#  Consequence: Policy is NOT a specialisation of ufoc:SocialObject or
#  ufoc:Norm (both IntrinsicModes). Policy and Norm are sibling concepts:
#    - Norm     (IntrinsicMode) — inheres in a collective agent as a whole;
#                                 no identified external dependant
#    - Policy   (ExtrinsicMode) — inheres in the organizer/delegator AND
#                                 is externally dependent on the addressee
#
#  NB: Modes (IntrinsicMode and ExtrinsicMode) receive NO punning type in
#  gUFO 1.0 — the Taxonomy of Types covers Endurant Types (Kind, Role, etc.)
#  and Event/Situation Types, but has no ModeType. (DD-029, DD-032)
#
#  Weigand's key distinction (maintained):
#    - Policy (ufol:Policy)           — the normative entity (what obliges)
#    - PolicyDocument (ufol:PolicyDocument) — the artifact that describes it
###############################################################################

ufol:Policy
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf gufo:ExtrinsicMode ;
    rdfs:label "Policy"@en , "Beleid (normatief)"@nl ;
    rdfs:comment
        "Een bundel van rechten en plichten (RightMode en DutyMode) die
         inhereert aan de institutionele agent (organisator/delegator) en
         extern afhankelijk is van de geadresseerde organisatorische agent.
         ExtrinsicMode conform Weigand (2024) §4.1.
         GEEN specialisatie van ufoc:Norm of ufoc:SocialObject: Norm is een
         IntrinsicMode van een collectieve agent; Policy is een ExtrinsicMode
         met twee onderscheiden partijen. (DD-032)"@nl .

ufol:PolicyDocument
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufol:InformationLegalObject ;
    rdfs:label "PolicyDocument"@en , "Beleidsdocument"@nl ;
    rdfs:comment
        "Een informatieobject (artefact) dat een Policy beschrijft maar
         er niet mee identiek is. Weigand (2024): het document draagt de
         Policy, maar de Policy zelf is een normatieve entiteit die
         inhereert aan de organisatie. Wijziging van het document wijzigt
         niet automatisch de Policy."@nl .

ufol:describedByDocument
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "externalDependence" ;
    rdfs:label "described by document"@en ;
    rdfs:domain ufol:Policy ;
    rdfs:range  ufol:PolicyDocument ;
    rdfs:comment
        "Relateert een Policy aan het PolicyDocument dat haar beschrijft.
         Geen UFO-subproperty: er is geen passende gUFO-property voor de
         relatie tussen een ExtrinsicMode en een beschrijvend artefact.
         (DD-032)"@nl .

ufol:policyInheresIn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:subPropertyOf gufo:inheresIn ;
    rdfs:label "policy inheres in"@en ;
    rdfs:domain ufol:Policy ;
    rdfs:range  ufoc:InstitutionalAgent ;
    rdfs:comment
        "De institutionele agent (organisator/delegator) in wie de Policy
         als ExtrinsicMode inhereert. Primaire afhankelijkheid."@nl .

ufol:policyDependsOn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "externalDependence" ;
    rdfs:subPropertyOf gufo:externallyDependsOn ;
    rdfs:label "policy depends on"@en ;
    rdfs:domain ufol:Policy ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De geadresseerde agent op wie de Policy van toepassing is en van
         wie de Policy extern afhankelijk is. Externe afhankelijkheid
         conform ExtrinsicMode-patroon (DD-032)."@nl .

ufol:policyGroundedIn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "historicalDependence" ;
    rdfs:subPropertyOf gufo:historicallyDependsOn ;
    rdfs:label "policy grounded in"@en ;
    rdfs:domain ufol:Policy ;
    rdfs:range  ufol:DelegationAuthority ;
    rdfs:comment
        "De DelegationAuthority (delegatiebevoegdheid in de bovenliggende
         wet) die de grondslag vormt voor deze Policy."@nl .

ufol:policyContainsRight
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasProperPart ;
    rdfs:label "policy contains right"@en ;
    rdfs:domain ufol:Policy ;
    rdfs:range  ufol:RightMode ;
    rdfs:comment
        "De RightMode is een constituerend Moment van de Policy-bundel.
         subPropertyOf gufo:hasProperPart (niet hasQuality: Policy is
         geen Endurant-bearer van een Quality, maar een bundel Moments).
         (DD-032)"@nl .

ufol:policyContainsDuty
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasProperPart ;
    rdfs:label "policy contains duty"@en ;
    rdfs:domain ufol:Policy ;
    rdfs:range  ufol:DutyMode ;
    rdfs:comment
        "De DutyMode is een constituerend Moment van de Policy-bundel.
         subPropertyOf gufo:hasProperPart (DD-032)."@nl .


###############################################################################
# ── 12. SOURCE DEFINITION (Brondefinitie, Wetsanalyse element 16) ─────────────
###############################################################################

ufol:SourceDefinition
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf ufoc:SocialObject ;
    rdfs:label "SourceDefinition"@en , "Brondefinitie"@nl ;
    rdfs:comment
        "Een begripsomschrijving die expliciet is opgenomen in wetgeving
         en een eenduidige betekenis geeft aan een in de wetgeving
         gebruikte term. Wetsanalyse element 16. Te onderscheiden van
         analytische begrippen die bij Wetsanalyse worden gemaakt maar
         geen directe wettelijke bron hebben."@nl .

ufol:definedTerm
    a owl:DatatypeProperty ;
    rdfs:label "defined term"@en ;
    rdfs:domain ufol:SourceDefinition ;
    rdfs:range  xsd:string .

ufol:definitionText
    a owl:DatatypeProperty ;
    rdfs:label "definition text"@en ;
    rdfs:domain ufol:SourceDefinition ;
    rdfs:range  xsd:string .

ufol:sourceArticle
    a owl:DatatypeProperty ;
    rdfs:label "source article"@en ;
    rdfs:domain ufol:SourceDefinition ;
    rdfs:range  xsd:string ;
    rdfs:comment
        "Identificator van het wetsartikel waar de brondefinitie
         staat (bijv. 'art. 1:1 Awb' of een JCIL URI)."@nl .


###############################################################################
# ── 13. LEXA SHORTCUT PROPERTIES ─────────────────────────────────────────────
#
#  Convenience properties for the Lexa perspective SPARQL queries.
###############################################################################

ufol:hasRight
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:label "has right"@en ;
    rdfs:domain ufol:LegalSubject ;
    rdfs:range  ufol:RightMode ;
    owl:propertyChainAxiom (
        [ owl:inverseOf ufol:hasRightHolder ]
        ufol:hasRightMode
    ) ;
    rdfs:comment
        "Afgeleide eigenschap: een rechtssubject heeft een RightMode als
         er een LegalRelator bestaat waarbij het de rechthebbende is."@nl .

ufol:hasDuty
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "characterization" ;
    rdfs:label "has duty"@en ;
    rdfs:domain ufol:LegalSubject ;
    rdfs:range  ufol:DutyMode ;
    owl:propertyChainAxiom (
        [ owl:inverseOf ufol:hasDutyBearer ]
        ufol:hasDutyMode
    ) ;
    rdfs:comment
        "Afgeleide eigenschap: een rechtssubject heeft een DutyMode als
         er een LegalRelator bestaat waarbij het de plichthebbende is."@nl .

ufol:isSubjectOf
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "material" ;
    rdfs:subPropertyOf gufo:participatedIn ;
    rdfs:label "is subject of"@en ;
    rdfs:domain ufol:LegalSubject ;
    rdfs:range  ufol:LegalRelator ;
    rdfs:comment
        "Relateert een rechtssubject aan alle LegalRelators waarbij het
         betrokken is (als rechthebbende of plichthebbende). Stereotype
         «material»: afgeleide materiële relatie die het bestaan van de
         LegalRelator-mediatie weerspiegelt."@nl .


###############################################################################
# ── 14. SHACL CONSTRAINTS (inline documentation) ──────────────────────────────
#
#  Key constraints (see shacl/00c-ufo-l.shacl.ttl):
#
#  (L1) LegalRelator mediates exactly 2 distinct LegalSubjects (hasRightHolder
#       and hasDutyBearer, owl:differentFrom)
#  (L2) LegalRelator has exactly 1 hasLegalObject
#  (L3) DerivationRule has at least 1 hasInputVariable and exactly 1
#       hasOutputVariable or exactly 1 derivesRelator
#  (L4) DelegationFulfillment must have fulfillsDelegation pointing to a
#       DelegationAuthority
#  (L5) Policy must have policyGroundedIn pointing to a DelegationAuthority
#  (L6) PolicyDocument must have describedByDocument inverse of describedByDocument
#  (L7) TemporalCondition hasStartDate ≤ hasEndDate if both present
#  (L8) DomainVariable characterizes LegalSubject or LegalObject
###############################################################################

ufol:_shacl_constraints
    rdfs:comment
        """Constraints (see SHACL file):
        L1: LegalRelator mediates exactly 2 distinct LegalSubjects.
        L2: LegalRelator has exactly 1 LegalObject.
        L3: DerivationRule has ≥1 input variable and exactly 1 output/relator.
        L4: DelegationFulfillment.fulfillsDelegation → DelegationAuthority.
        L5: Policy.policyGroundedIn → DelegationAuthority.
        L6: PolicyDocument is describedByDocument target.
        L7: TemporalCondition start ≤ end.
        L8: DomainVariable inheres in LegalSubject or LegalObject.""" .


###############################################################################
# END OF MODULE 00c — UFO-L Legal Relations
###############################################################################
```

## Module: 00d-ufo-l.shacl.ttl

```turtle
@prefix sh:    <http://www.w3.org/ns/shacl#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix ufol:  <https://valor-ecosystem.nl/ontology/ufo-l#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix shl:  <https://valor-ecosystem.nl/shacl/ufo-l> .
@prefix vo:   <https://valor-ecosystem.nl/ontology/> .

###############################################################################
# VALOR-O — SHACL Shapes: UFO-L Legal Relations (Module 00c)
#
# Constraints L1–L12 covering:
#   LegalRelator structure, Hohfeld subclasses, DerivationRule,
#   DelegationAuthority, Policy/PolicyDocument, TemporalCondition,
#   DomainVariable, SourceDefinition.
###############################################################################

shl
    a owl:Ontology ;
    dcterms:title "VALOR-O SHACL — UFO-L Legal Relations"@nl ;
    owl:versionInfo "0.1" .


###############################################################################
# L1 — LegalRelator mediates exactly 2 distinct LegalSubjects
###############################################################################

ufol:LegalRelatorShape
    a sh:NodeShape ;
    sh:targetClass ufol:LegalRelator ;
    sh:name "LegalRelatorShape" ;
    sh:description
        "L1: Elke LegalRelator vereist precies één hasRightHolder en
         precies één hasDutyBearer, en beide moeten van elkaar verschillen." ;

    sh:property [
        sh:path ufol:hasRightHolder ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufol:LegalSubject ;
        sh:message "L1a: LegalRelator vereist precies één hasRightHolder (ufol:LegalSubject)."
    ] ;

    sh:property [
        sh:path ufol:hasDutyBearer ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufol:LegalSubject ;
        sh:message "L1b: LegalRelator vereist precies één hasDutyBearer (ufol:LegalSubject)."
    ] ;

    sh:sparql [
        sh:name    "L1c-subjects-distinct" ;
        sh:message "L1c: hasRightHolder en hasDutyBearer mogen niet naar hetzelfde LegalSubject verwijzen." ;
        sh:prefixes shl ;
        sh:select  """
            SELECT $this WHERE {
                $this ufol:hasRightHolder ?r .
                $this ufol:hasDutyBearer  ?d .
                FILTER (?r = ?d)
            }
        """
    ] .


###############################################################################
# L2 — LegalRelator has exactly one LegalObject
###############################################################################

ufol:LegalRelatorObjectShape
    a sh:NodeShape ;
    sh:targetClass ufol:LegalRelator ;
    sh:name "LegalRelatorObjectShape" ;
    sh:description
        "L2: Elke LegalRelator vereist precies één hasLegalObject." ;

    sh:property [
        sh:path ufol:hasLegalObject ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufol:LegalObject ;
        sh:message "L2: LegalRelator vereist precies één hasLegalObject (ufol:LegalObject)."
    ] .


###############################################################################
# L3 — LegalRelator has a legal basis (NormativeSituation or LegalNorm)
###############################################################################

ufol:LegalRelatorBasisShape
    a sh:NodeShape ;
    sh:targetClass ufol:LegalRelator ;
    sh:name "LegalRelatorBasisShape" ;
    sh:description
        "L3: Elke LegalRelator moet via hasLegalBasis terug te herleiden
         zijn naar een LegalNorm (traceerbaarheid Wetsanalyse)." ;

    sh:property [
        sh:path ufol:hasLegalBasis ;
        sh:minCount 1 ;
        sh:class ufol:LegalNorm ;
        sh:message "L3: LegalRelator vereist ten minste één hasLegalBasis (ufol:LegalNorm)."
    ] .


###############################################################################
# L4 — DerivationRule: input + (output variable XOR derives relator)
###############################################################################

ufol:DerivationRuleShape
    a sh:NodeShape ;
    sh:targetClass ufol:DerivationRule ;
    sh:name "DerivationRuleShape" ;
    sh:description
        "L4: Een DerivationRule vereist:
         (a) ten minste één hasInputVariable;
         (b) ofwel een hasOutputVariable ofwel een derivesRelator
             (maar niet beide tegelijk)." ;

    sh:property [
        sh:path ufol:hasInputVariable ;
        sh:minCount 1 ;
        sh:class ufol:DomainVariable ;
        sh:message "L4a: DerivationRule vereist ten minste één hasInputVariable."
    ] ;

    # L4b: output XOR relator — exactly one of the two must be present
    sh:sparql [
        sh:name    "L4b-output-xor-relator" ;
        sh:message "L4b: DerivationRule vereist ofwel hasOutputVariable ofwel derivesRelator (niet beide, niet geen van beide)." ;
        sh:prefixes shl ;
        sh:select  """
            SELECT $this WHERE {
                BIND(
                    EXISTS { $this ufol:hasOutputVariable ?v } AS ?hasOut
                )
                BIND(
                    EXISTS { $this ufol:derivesRelator ?r } AS ?hasRel
                )
                FILTER ( ?hasOut = ?hasRel )
            }
        """
    ] .


###############################################################################
# L5 — DelegationFulfillment must reference a DelegationAuthority
###############################################################################

ufol:DelegationFulfillmentShape
    a sh:NodeShape ;
    sh:targetClass ufol:DelegationFulfillment ;
    sh:name "DelegationFulfillmentShape" ;
    sh:description
        "L5: Elke DelegationFulfillment (delegatie-invulling) moet via
         fulfillsDelegation verwijzen naar een DelegationAuthority
         (delegatiegrondslag)." ;

    sh:property [
        sh:path ufol:fulfillsDelegation ;
        sh:minCount 1 ;
        sh:class ufol:DelegationAuthority ;
        sh:message "L5: DelegationFulfillment.fulfillsDelegation vereist ten minste één DelegationAuthority."
    ] .


###############################################################################
# L6 — Policy: ExtrinsicMode — inheres in InstitutionalAgent, depends on Agent,
#              grounded in DelegationAuthority
###############################################################################

ufol:PolicyShape
    a sh:NodeShape ;
    sh:targetClass ufol:Policy ;
    sh:name "PolicyShape" ;
    sh:description
        "L6: Een Policy (ExtrinsicMode, Weigand 2024) moet:
         (a) inheren aan een InstitutionalAgent via policyInheresIn;
         (b) extern afhankelijk zijn van een Agent via policyDependsOn;
         (c) gegrond zijn in een DelegationAuthority via policyGroundedIn;
         (d) de bearer en de geadresseerde moeten van elkaar verschillen." ;

    sh:property [
        sh:path ufol:policyInheresIn ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:InstitutionalAgent ;
        sh:message "L6a: Policy.policyInheresIn vereist precies één ufoc:InstitutionalAgent."
    ] ;

    sh:property [
        sh:path ufol:policyDependsOn ;
        sh:minCount 1 ;
        sh:class ufoc:Agent ;
        sh:message "L6b: Policy.policyDependsOn vereist ten minste één ufoc:Agent (geadresseerde)."
    ] ;

    sh:property [
        sh:path ufol:policyGroundedIn ;
        sh:minCount 1 ;
        sh:class ufol:DelegationAuthority ;
        sh:message "L6c: Policy.policyGroundedIn vereist ten minste één DelegationAuthority."
    ] .


###############################################################################
# L7 — PolicyDocument described by at least one Policy
###############################################################################

ufol:PolicyDocumentShape
    a sh:NodeShape ;
    sh:targetClass ufol:PolicyDocument ;
    sh:name "PolicyDocumentShape" ;
    sh:description
        "L7: Een PolicyDocument (artefact) moet beschreven zijn door
         (d.w.z. de inverse van describedByDocument hebben voor)
         ten minste één Policy." ;

    sh:sparql [
        sh:name    "L7-document-has-policy" ;
        sh:message "L7: PolicyDocument is niet gekoppeld aan een Policy via describedByDocument." ;
        sh:prefixes shl ;
        sh:select  """
            SELECT $this WHERE {
                FILTER NOT EXISTS {
                    ?policy ufol:describedByDocument $this .
                }
            }
        """
    ] .


###############################################################################
# L8 — TemporalCondition: hasStartDate ≤ hasEndDate when both present
###############################################################################

ufol:TemporalConditionShape
    a sh:NodeShape ;
    sh:targetClass ufol:TemporalCondition ;
    sh:name "TemporalConditionShape" ;
    sh:description
        "L8: Als een TemporalCondition zowel hasStartDate als hasEndDate
         heeft, moet het startpunt voor of gelijk zijn aan het eindpunt." ;

    sh:sparql [
        sh:name    "L8-start-before-end" ;
        sh:message "L8: TemporalCondition.hasStartDate moet ≤ hasEndDate zijn." ;
        sh:prefixes shl ;
        sh:select  """
            SELECT $this WHERE {
                $this ufol:hasStartDate ?s .
                $this ufol:hasEndDate   ?e .
                FILTER (?s > ?e)
            }
        """
    ] .


###############################################################################
# L9 — DomainVariable inheres in LegalSubject or LegalObject
###############################################################################

ufol:DomainVariableShape
    a sh:NodeShape ;
    sh:targetClass ufol:DomainVariable ;
    sh:name "DomainVariableShape" ;
    sh:description
        "L9: Een DomainVariable (variabele) moet inheren aan een
         LegalSubject of een LegalObject." ;

    sh:property [
        sh:path gufo:inheresIn ;
        sh:minCount 1 ;
        sh:message "L9a: DomainVariable.inheresIn is vereist."
    ] ;

    sh:sparql [
        sh:name    "L9b-inhere-in-legal-entity" ;
        sh:message "L9b: DomainVariable moet inheren aan een ufol:LegalSubject of ufol:LegalObject." ;
        sh:prefixes shl ;
        sh:select  """
            SELECT $this WHERE {
                $this gufo:inheresIn ?bearer .
                FILTER NOT EXISTS {
                    { ?bearer a ufol:LegalSubject }
                    UNION
                    { ?bearer a ufol:LegalObject  }
                }
            }
        """
    ] .


###############################################################################
# L10 — LegalFact relates to at least one LegalRelator
###############################################################################

ufol:LegalFactShape
    a sh:NodeShape ;
    sh:targetClass ufol:LegalFact ;
    sh:name "LegalFactShape" ;
    sh:description
        "L10: Elk LegalFact (rechtsfeit) moet via createsLegalRelation,
         modifiesLegalRelation of terminatesLegalRelation betrekking
         hebben op ten minste één LegalRelator." ;

    sh:sparql [
        sh:name    "L10-fact-relates-relator" ;
        sh:message "L10: LegalFact heeft geen relatie met een LegalRelator via creates/modifies/terminatesLegalRelation." ;
        sh:prefixes shl ;
        sh:select  """
            SELECT $this WHERE {
                FILTER NOT EXISTS {
                    { $this ufol:createsLegalRelation    ?r }
                    UNION
                    { $this ufol:modifiesLegalRelation   ?r }
                    UNION
                    { $this ufol:terminatesLegalRelation ?r }
                }
            }
        """
    ] .


###############################################################################
# L11 — NormativeSituation has a legal basis (LegalNorm)
###############################################################################

ufol:NormativeSituationShape
    a sh:NodeShape ;
    sh:targetClass ufol:NormativeSituation ;
    sh:name "NormativeSituationShape" ;
    sh:description
        "L11: Elke NormativeSituation moet gegrond zijn in een LegalNorm
         via hasLegalBasis." ;

    sh:property [
        sh:path ufol:hasLegalBasis ;
        sh:minCount 1 ;
        sh:class ufol:LegalNorm ;
        sh:message "L11: NormativeSituation.hasLegalBasis vereist ten minste één LegalNorm."
    ] .


###############################################################################
# L12 — ClaimRightRelator has an EnforceabilityLevel
###############################################################################

ufol:ClaimRightRelatorShape
    a sh:NodeShape ;
    sh:targetClass ufol:ClaimRightRelator ;
    sh:name "ClaimRightRelatorShape" ;
    sh:description
        "L12: Elke ClaimRightRelator (aanspraak–verplichting) moet een
         hasEnforceability hebben (krachtig, na ingebrekestelling,
         of zwak — Wetsanalyse §4.3.3)." ;

    sh:property [
        sh:path ufol:hasEnforceability ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufol:EnforceabilityLevel ;
        sh:message "L12: ClaimRightRelator.hasEnforceability vereist precies één EnforceabilityLevel."
    ] .


###############################################################################
# Prefix declarations for SPARQL constraints
###############################################################################

shl
    a sh:PrefixDeclaration ;
    sh:declare [
        sh:prefix    "gufo" ;
        sh:namespace "http://purl.org/nemo/gufo#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "ufoc" ;
        sh:namespace "https://valor-ecosystem.nl/ontology/ufo-c#"^^xsd:anyURI
    ] ;
    sh:declare [
        sh:prefix    "ufol" ;
        sh:namespace "https://valor-ecosystem.nl/ontology/ufo-l#"^^xsd:anyURI
    ] .

###############################################################################
# END OF SHACL — UFO-L
###############################################################################
```

---

## Module: 00e-coodm.ttl

```turtle
###############################################################################
#  VALOR-O — Module 00e: COoDM Decision Ontology + COVER Value Ascription
#
#  Namespace  : https://valor-ecosystem.nl/ontology/coodm#
#  Prefix     : coodm:
#  Versie     : 0.1  (februari 2026)
#  Imports    : 00a-gufo-core, 00b-ufo-b, 00c-ufo-c, 00d-ufo-l
#
#  Bronnen:
#    COoDM  — Guizzardi, R., Carneiro, B.G., Porello, D. & Guizzardi, G.
#             (2020). A Core Ontology on Decision Making.
#             Proc. ONTOBRAS 2020, CEUR-WS Vol. 2728, pp. 9–21.
#    COVER  — Guizzardi, G. et al. (2022). The Common Ontology of Value
#             and Risk (COVER). Applied Ontology 17(2), pp. 281–313.
#    Weigand-2024 — zie 00d-ufo-l.ttl
#
#  Ontwerpbeslissingen:
#    DD-030 · Decision als Intention (ufoc:Intention), niet als Event
#    DD-031 · Preference als Belief (ufoc:Belief), niet als Intention
#    DD-033 · ValueExperience als gufo:Quality; ValueType als Kind
#    DD-034 · ValueAscription = Preference in deliberatiecontext
#    DD-035 · Twee namespaces in één bestand: coodm: en cover:
#
#  Structuur:
#    §A  COoDM — besluitvormingskern
#        A1. DecisionSituation
#        A2. Deliberation
#        A3. DecisionAlternative
#        A4. Decision
#        A5. DecisionGoal
#        A6. Properties
#    §B  COVER — waarde-ascriptie (eerste opzet)
#        B1. ValueType
#        B2. ValueExperience
#        B3. ValueAscription / Preference
#        B4. ValueTension
#        B5. ValueScale
#        B6. Properties
###############################################################################

@prefix coodm: <https://valor-ecosystem.nl/ontology/coodm#> .
@prefix cover: <https://valor-ecosystem.nl/ontology/cover#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix ufol:  <https://valor-ecosystem.nl/ontology/ufo-l#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .

###############################################################################
#  Ontologie-declaratie
###############################################################################

<https://valor-ecosystem.nl/ontology/coodm>
    a owl:Ontology ;
    rdfs:label "VALOR-O Module 00e — COoDM Decision Ontology + COVER Value Ascription"@en ;
    owl:imports <https://valor-ecosystem.nl/ontology/gufo-core> ;
    owl:imports <https://valor-ecosystem.nl/ontology/ufo-b> ;
    owl:imports <https://valor-ecosystem.nl/ontology/ufo-c> ;
    owl:imports <https://valor-ecosystem.nl/ontology/ufo-l> ;
    owl:versionInfo "0.1" ;
    rdfs:comment
        "Integreert COoDM (Guizzardi et al. 2020) en een eerste opzet van
         COVER (Guizzardi et al. 2022) in VALOR-O. Fundeert het
         Delibera-perspectief (besluitvorming) en het Axia-perspectief
         (waarden) in VALOR."@nl .


###############################################################################
#  §A — COoDM: Besluitvormingskern
#
#  Centrale structuur conform COoDM §3:
#
#    Een agent bevindt zich in een DecisionSituation: zijn intentionele
#    toestand (Goals, Desires) is niet bevredigd. Dit triggert een
#    Deliberation-event. Tijdens de deliberatie vergelijkt de agent
#    DecisionAlternatives op basis van Preferences (ValueAscriptions).
#    De deliberatie produceert een Decision: een nieuwe Intention met een
#    DecisionGoal als propositiële inhoud. De Decision wordt gemanifesteerd
#    in een Action (de uitvoering).
#
#    BDI-toewijzing (Rao & Georgeff 1995; COoDM §2):
#      - Beliefs    → ufoc:Belief (bestaand in 00c)
#      - Desires    → ufoc:Desire / ufoc:Goal (bestaand in 00c)
#      - Intentions → ufoc:Intention (bestaand in 00c)
#      - Decision   → coodm:Decision (subklasse van ufoc:Intention)
#      - Preference → coodm:Preference (subklasse van ufoc:Belief,
#                     NIET van ufoc:Intention — DD-031)
###############################################################################

###############################################################################
#  §A1 — DecisionSituation
#
#  Een situatie die een agent ervaart als onbevredigend ten aanzien van zijn
#  intentionele toestand: zijn Goals of Desires zijn niet vervuld.
#  Dit is de trigger voor een Deliberation.
#  Conform COoDM §3: "the deliberation is triggered by a situation in which
#  the agent's intentions have not been satisfied."
###############################################################################

coodm:DecisionSituation
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "DecisionSituation"@en , "Beslissingssituatie"@nl ;
    rdfs:comment
        "Een situatie die een agent ervaart als onbevredigend: zijn intentionele
         toestand (Goals, Desires) is niet vervuld. De DecisionSituation is de
         trigger voor een Deliberation-event.
         Conform COoDM §3."@nl ,
        "A situation in which an agent's intentional state (goals, desires)
         is not satisfied, triggering a Deliberation event."@en .


###############################################################################
#  §A2 — Deliberation
#
#  Het besluitvormingsproces als Event (Action). Conform COoDM §3:
#  deliberation is triggered by a DecisionSituation, considers one or more
#  DecisionAlternatives, uses Preferences (ValueAscriptions) to evaluate
#  them, and results in the creation of a Decision.
#
#  Deliberation is een subklasse van gufo:Action omdat het een intentioneel
#  geïnitieerd event is (de agent delibereert bewust).
#
#  Koppeling met Weigand (2024): een Deliberation kan worden begrensd door
#  een ufol:Policy (via coodm:guidedByPolicy) — dit modelleert
#  policy-gestuurd beslissen.
###############################################################################

coodm:Deliberation
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Action ;
    rdfs:label "Deliberation"@en , "Deliberatie"@nl ;
    rdfs:comment
        "Het besluitvormingsproces als intentioneel event. Getriggerd door een
         DecisionSituation, overweegt één of meer DecisionAlternatives op basis
         van Preferences (ValueAscriptions), en resulteert in een Decision.
         Conform COoDM §3. Kan worden begrensd door een ufol:Policy
         (Weigand 2024 §4.2: 'Procedure'-rol van PolicyDocument in
         Deliberation). (DD-030, DD-031)"@nl .


###############################################################################
#  §A3 — DecisionAlternative
#
#  Een mogelijke uitkomst of handelwijze die door de agent tijdens de
#  deliberatie wordt overwogen. Gemodelleerd als gufo:Situation: een
#  mogelijke wereld-toestand (de situatie die zou ontstaan als dit
#  alternatief wordt gekozen).
#
#  Conform COoDM §3: "the decision is aimed at a situation, not at an action
#  [...] the situation is to be created through the execution of an action."
###############################################################################

coodm:DecisionAlternative
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "DecisionAlternative"@en , "Beslissingsalternatief"@nl ;
    rdfs:comment
        "Een mogelijke toestand (Situation) die zou ontstaan als een bepaalde
         handelwijze wordt gekozen. De agent vergelijkt alternatieven tijdens
         Deliberation op basis van Preferences. Conform COoDM §3."@nl .


###############################################################################
#  §A4 — Decision
#
#  De uitkomst van een Deliberation: een nieuwe Intention van de agent.
#  Cruciaal onderscheid (DD-030): Decision is een INTENTIE (IntrinsicMode),
#  niet een Event. De Decision is het resultaat van de Deliberation-event,
#  maar is zelf een intentionele toestand van de agent.
#
#  "The decision is not aimed at an action but at a situation."
#  (COoDM §3 / Weigand §2.1)
#
#  De propositiële inhoud van de Decision is een DecisionGoal (§A5).
###############################################################################

coodm:Decision
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:Intention ;
    rdfs:label "Decision"@en , "Beslissing"@nl ;
    rdfs:comment
        "De uitkomst van een Deliberation: een nieuwe Intention van de agent,
         gericht op het realiseren van een DecisionGoal (een gewenste situatie).
         Decision is een IntrinsicMode (Intention), NIET een Event.
         De Deliberation creëert de Decision; de Decision wordt vervolgens
         gemanifesteerd in een Action. (DD-030; COoDM §3)"@nl .


###############################################################################
#  §A5 — DecisionGoal
#
#  De propositiële inhoud van een Decision: de gewenste situatie die moet
#  worden bereikt. DecisionGoal is een subklasse van ufoc:Goal (die zelf
#  een subklasse is van ufoc:Desire).
#
#  Onderscheid van ufoc:Goal: een gewoon Goal is een gestabiliseerde wens;
#  een DecisionGoal is specifiek de propositiële inhoud van een Decision —
#  de Agent heeft expliciet besloten dit doel na te streven via deliberatie.
###############################################################################

coodm:DecisionGoal
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:Goal ;
    rdfs:label "DecisionGoal"@en , "Beslissingsdoel"@nl ;
    rdfs:comment
        "De propositiële inhoud van een Decision: de gewenste situatie die
         de agent heeft besloten na te streven via Deliberation. Subklasse
         van ufoc:Goal — een expliciet gekozen en gemotiveerd doel.
         Conform COoDM §3."@nl .


###############################################################################
#  §A6 — COoDM Properties
###############################################################################

#  Deliberation ──triggeredBy──► DecisionSituation
coodm:triggeredBy
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "triggering" ;
    rdfs:subPropertyOf gufo:wasTriggeredBy ;
    rdfs:label "triggered by"@en ;
    rdfs:domain coodm:Deliberation ;
    rdfs:range  coodm:DecisionSituation ;
    rdfs:comment
        "De DecisionSituation die de Deliberation heeft getriggerd.
         Conform UFO-B: elke Action heeft een triggerende Situation.
         Conform COoDM §3."@nl .

#  Deliberation ──considers──► DecisionAlternative
coodm:considers
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "considers"@en ;
    rdfs:domain coodm:Deliberation ;
    rdfs:range  coodm:DecisionAlternative ;
    rdfs:comment
        "De DecisionAlternative(s) die worden overwogen tijdens de Deliberation.
         Een Deliberation overweegt minimaal één alternatief. Conform COoDM §3."@nl .

#  Deliberation ──resultedIn──► Decision  (creation relation)
coodm:resultedIn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "creation" ;
    rdfs:subPropertyOf gufo:wasCreatedIn ;
    rdfs:label "resulted in"@en ;
    rdfs:domain coodm:Deliberation ;
    rdfs:range  coodm:Decision ;
    rdfs:comment
        "De Decision die door de Deliberation is gecreëerd als nieuwe Intention
         van de agent. Conform UFO-B creation-patroon: de Deliberation brengt
         de Decision tot stand. Conform COoDM §3."@nl .

#  Decision ──decisionGoal──► DecisionGoal
coodm:decisionGoal
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:hasPropositionalContent ;
    rdfs:label "decision goal"@en ;
    rdfs:domain coodm:Decision ;
    rdfs:range  coodm:DecisionGoal ;
    rdfs:comment
        "De DecisionGoal die de propositiële inhoud vormt van de Decision:
         de gewenste situatie die de agent nastreeft. Conform COoDM §3."@nl .

#  Decision ──manifestedAs──► gufo:Action
coodm:manifestedAs
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "manifestation" ;
    rdfs:label "manifested as"@en ;
    rdfs:domain coodm:Decision ;
    rdfs:range  gufo:Action ;
    rdfs:comment
        "De Action die de uitvoering is van de Decision. Conform COoDM §3:
         'the executed action is considered the manifestation of the decision.'
         De Decision is de intentie; de Action is de realisering ervan."@nl .

#  Deliberation ──guidedByPolicy──► ufol:Policy  (Weigand 2024 koppeling)
coodm:guidedByPolicy
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "guided by policy"@en ;
    rdfs:domain coodm:Deliberation ;
    rdfs:range  ufol:Policy ;
    rdfs:comment
        "De ufol:Policy die de Deliberation beperkt of structureert.
         Conform Weigand (2024) §4.2: een PolicyDocument kan de rol van
         'Procedure' vervullen in een Deliberation, waarbij de ingebedde
         beslisregels de ruimte van geldige Decisions beperken.
         De koppeling loopt via Policy (de normatieve entiteit), niet via
         het PolicyDocument (het artefact)."@nl .

#  Deliberation ──hasPreference──► Preference  (→ §B3)
coodm:hasPreference
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "has preference"@en ;
    rdfs:domain coodm:Deliberation ;
    rdfs:range  coodm:Preference ;
    rdfs:comment
        "De Preference(s) van de delibererende agent die de evaluatie van
         DecisionAlternatives sturen. Conform COoDM §3: 'preferences are
         conceptualized as value ascriptions of the agent with respect to
         some value experience.' (DD-031, DD-034)"@nl .


###############################################################################

###############################################################################
#  §B — COVER: Waarde-ascriptie (VAO conform Sales et al. 2017)
#
#  Correcties t.o.v. eerste opzet (DD-036 herziet DD-033 en DD-034):
#
#    1. ValueExperience: gufo:Quality → gufo:Event
#       Sales §4: "value objects are substantials; value experiences are events"
#
#    2. ValueAscription: ufoc:Belief → gufo:Relator
#       Sales Fig. 2: "<<relator>> ValueAscription" met beholder/beneficiary
#
#    3. ValueType: gufo:Kind/EndurantType → gufo:EventType
#       ValueType classificeert ValueExperiences (events), niet Endurants
#
#    4. Preference: subklasse van ValueAscription → ufoc:Belief
#       Preference (Belief) en ValueAscription (Relator) zijn structureel
#       onderscheiden: Preference is mentaal substraat, ValueAscription is
#       de relationele uiting. Keten: Preference ──groundsAscription──►
#       ValueAscription
#
#    5. ValueBeholder / ValueBeneficiary toegevoegd als gufo:RoleMixin
#
#    6. ValuePerception / ValueAssertion als Phase-subtypen van ValueAscription
#
###############################################################################

###############################################################################
#  §B1 — ValueType
#
#  Een EventType dat ValueExperiences (events) classificeert.
#  Conform Sales §4: value experiences zijn events, hun types zijn EventTypes.
###############################################################################

cover:ValueType
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:EventType ;
    rdfs:label "ValueType"@en , "Waardetype"@nl ;
    rdfs:comment
        "Een EventType dat ValueExperiences (events) classificeert.
         Voorbeelden: PrivacyExperience, FairnessExperience, AutonomyExperience.
         Conform Sales et al. (2017) §4: value experiences zijn events,
         hun types zijn gufo:EventTypes. (DD-036)"@nl .

cover:PrivacyExperience
    a cover:ValueType ;
    rdfs:label "PrivacyExperience"@en , "Privacybeleving"@nl .

cover:FairnessExperience
    a cover:ValueType ;
    rdfs:label "FairnessExperience"@en , "Rechtvaardigheidsbeleving"@nl .

cover:AutonomyExperience
    a cover:ValueType ;
    rdfs:label "AutonomyExperience"@en , "Autonomiebeleving"@nl .

cover:EfficiencyExperience
    a cover:ValueType ;
    rdfs:label "EfficiencyExperience"@en , "Efficiëntiebeleving"@nl .

cover:TransparencyExperience
    a cover:ValueType ;
    rdfs:label "TransparencyExperience"@en , "Transparantiebeleving"@nl .

cover:SolidarityExperience
    a cover:ValueType ;
    rdfs:label "SolidarityExperience"@en , "Solidariteitsbeleving"@nl .


###############################################################################
#  §B2 — ValueExperience
#
#  Een waardebeleving als EVENT: de episode waarin een ValueBeneficiary
#  iets ondergaat en daarin een waarde ervaart.
#  Conform Sales et al. (2017) §4: "value experiences are events."
#
#  Deelnemers:
#    cover:hasBeneficiary  → de agent die de experience ondergaat
#  Context:
#    cover:hasValueContext  → de omringende Situation
#  Classificatie:
#    cover:ofType           → het ValueType
#  Valentie:
#    cover:hasValence       → cover:ValueScale
###############################################################################

cover:ValueExperience
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Event ;
    rdfs:label "ValueExperience"@en , "Waardebeleving"@nl ;
    rdfs:comment
        "Een waardebeleving als event: de episode waarin een ValueBeneficiary
         een waarde ervaart bij het ondergaan van een dienst, goed of besluit.
         Conform Sales et al. (2017) §4: 'value experiences are events.'
         (DD-036)"@nl .


###############################################################################
#  §B3 — ValueBeholder en ValueBeneficiary  (RoleMixin)
#
#  Conform Sales Fig. 2: beide zijn <<roleMixin>> — rollen die agents spelen
#  in de context van een ValueAscription-Relator.
#
#  ValueBeholder  : de agent die het waarde-oordeel velt
#  ValueBeneficiary: de agent voor wie het oordeel geldt
###############################################################################

cover:ValueBeholder
    a owl:Class ;
    rdf:type gufo:RoleMixin ;
    gufo:ontoumlStereotype "roleMixin" ;
    rdfs:subClassOf gufo:RoleMixin ;
    rdfs:label "ValueBeholder"@en , "Waarde-beoordelaar"@nl ;
    rdfs:comment
        "De agent die in een ValueAscription de rol van beoordelaar speelt.
         RoleMixin conform Sales et al. (2017) Fig. 2. (DD-036)"@nl .

cover:ValueBeneficiary
    a owl:Class ;
    rdf:type gufo:RoleMixin ;
    gufo:ontoumlStereotype "roleMixin" ;
    rdfs:subClassOf gufo:RoleMixin ;
    rdfs:label "ValueBeneficiary"@en , "Waarde-ontvanger"@nl ;
    rdfs:comment
        "De agent voor wie het waarde-oordeel geldt in een ValueAscription.
         RoleMixin conform Sales et al. (2017) Fig. 2. (DD-036)"@nl .


###############################################################################
#  §B4 — ValueAscription
#
#  Een waarde-ascriptie als RELATOR: medieert beholder en beneficiary.
#  Conform Sales et al. (2017) Fig. 2: "<<relator>> ValueAscription."
#
#  Twee Phase-subtypen:
#    ValuePerception : beholder == beneficiary (zelf-beoordeling)
#    ValueAssertion  : beholder != beneficiary (VP door organisatie over burger)
#
#  Relatie tot Preference (DD-036, herziet DD-034):
#    Preference (Belief) fundeert ValueAscription (Relator) via groundsAscription.
#    Belief en Relator zijn structureel onverenigbaar — geen subklasse-relatie.
###############################################################################

cover:ValueAscription
    a owl:Class ;
    rdf:type gufo:RelationshipType ;
    gufo:ontoumlStereotype "relator" ;
    rdfs:subClassOf gufo:Relator ;
    rdfs:label "ValueAscription"@en , "Waarde-ascriptie"@nl ;
    rdfs:comment
        "Een waarde-ascriptie als Relator: medieert ValueBeholder en
         ValueBeneficiary. De ascriptie is een oordeel over een
         ValueExperience (event). Conform Sales et al. (2017) Fig. 2.
         (DD-036)"@nl .

cover:ValuePerception
    a owl:Class ;
    rdf:type gufo:Phase ;
    gufo:ontoumlStereotype "phase" ;
    rdfs:subClassOf cover:ValueAscription ;
    rdfs:label "ValuePerception"@en , "Waarde-perceptie"@nl ;
    rdfs:comment
        "Een ValueAscription waarbij beholder en beneficiary dezelfde agent
         zijn: zelf-beoordeling. Conform Sales et al. (2017) §4."@nl .

cover:ValueAssertion
    a owl:Class ;
    rdf:type gufo:Phase ;
    gufo:ontoumlStereotype "phase" ;
    rdfs:subClassOf cover:ValueAscription ;
    rdfs:label "ValueAssertion"@en , "Waarde-assertie"@nl ;
    rdfs:comment
        "Een ValueAscription waarbij beholder en beneficiary verschillende
         agents zijn. Fundeert Value Propositions (00f).
         Conform Sales et al. (2017) §4."@nl .


###############################################################################
#  §B5 — Preference  (COoDM ↔ COVER koppeling)
#
#  Preference is een ufoc:Belief van de delibererende agent die de grondslag
#  vormt voor een ValueAscription. Conform COoDM §3 en Sales (2017):
#  de Preference is het mentale substraat; de ValueAscription is de
#  relationele uiting. (DD-036 herziet DD-034)
###############################################################################

coodm:Preference
    a owl:Class ;
    gufo:ontoumlStereotype "mode" ;
    rdfs:subClassOf ufoc:Belief ;
    rdfs:label "Preference"@en , "Preferentie"@nl ;
    rdfs:comment
        "Een ufoc:Belief van een delibererende agent die zijn waarde-oordeel
         uitdrukt over een DecisionAlternative. De Preference is het mentale
         substraat dat een ValueAscription (Relator) fundeert via
         coodm:groundsAscription. Conform COoDM §3 en Sales et al. (2017).
         (DD-036 herziet DD-034)"@nl .


###############################################################################
#  §B6 — ValueTension
###############################################################################

cover:ValueTension
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "ValueTension"@en , "Waardenspanning"@nl ;
    rdfs:comment
        "Een situatie waarin twee of meer ValueExperiences in conflict zijn:
         het realiseren van de ene waarde ondermijnt de andere.
         Voorbeeld: Privacybeleving vs. Transparantiebeleving bij
         gegevensuitwisseling. Fundeert het Axia-perspectief."@nl .


###############################################################################
#  §B7 — ValueScale  (valentie)
#
#  Valentie van een ValueExperience. Geen gufo:QualityValue meer want
#  ValueExperience is nu een Event, geen Quality. (DD-036)
###############################################################################

cover:ValueScale
    a owl:Class ;
    rdfs:label "ValueScale"@en , "Waardeschaal"@nl ;
    rdfs:comment
        "De valentie van een ValueExperience: positief, negatief of neutraal.
         Geen gufo:QualityValue (ValueExperience is een Event). (DD-036)"@nl .

cover:PositiveValence
    a cover:ValueScale ;
    rdfs:label "positive valence"@en , "positieve valentie"@nl ;
    rdfs:comment "De ValueExperience is een positieve waardebeleving."@nl .

cover:NegativeValence
    a cover:ValueScale ;
    rdfs:label "negative valence"@en , "negatieve valentie"@nl ;
    rdfs:comment "De ValueExperience is een negatieve waardebeleving."@nl .

cover:NeutralValence
    a cover:ValueScale ;
    rdfs:label "neutral valence"@en , "neutrale valentie"@nl ;
    rdfs:comment "De ValueExperience heeft geen duidelijke valentie."@nl .


###############################################################################
#  §B8 — COVER Properties
###############################################################################

#  ValueExperience ──hasBeneficiary──► ufoc:Agent  (participatie)
cover:hasBeneficiary
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "participational" ;
    rdfs:subPropertyOf gufo:hasParticipant ;
    rdfs:label "has beneficiary"@en ;
    rdfs:domain cover:ValueExperience ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De agent die de ValueExperience ondergaat als ValueBeneficiary.
         subPropertyOf gufo:hasParticipant (Event → Object).
         Conform Sales et al. (2017) Fig. 1. (DD-036)"@nl .

#  ValueExperience ──hasValueContext──► gufo:Situation
cover:hasValueContext
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "has value context"@en ;
    rdfs:domain cover:ValueExperience ;
    rdfs:range  gufo:Situation ;
    rdfs:comment
        "De situatie (context) waarbinnen de ValueExperience plaatsvindt.
         Conform Sales et al. (2017) §4: elke ValueExperience heeft een
         context die bijdraagt aan het waarde-oordeel."@nl .

#  ValueExperience ──ofType──► cover:ValueType
cover:ofType
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "instantiation" ;
    rdfs:label "of type"@en ;
    rdfs:domain cover:ValueExperience ;
    rdfs:range  cover:ValueType ;
    rdfs:comment
        "Het ValueType (EventType) waarvan deze ValueExperience een instantie is.
         Conform Sales et al. (2017) §4. (DD-036)"@nl .

#  ValueExperience ──hasValence──► cover:ValueScale
cover:hasValence
    a owl:ObjectProperty ;
    rdfs:label "has valence"@en ;
    rdfs:domain cover:ValueExperience ;
    rdfs:range  cover:ValueScale ;
    rdfs:comment
        "De valentie van de ValueExperience. Geen subPropertyOf
         gufo:hasQualityValue (ValueExperience is een Event). (DD-036)"@nl .

#  ValueAscription ──hasBeholderAgent──► ufoc:Agent  (mediation)
cover:hasBeholderAgent
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has beholder agent"@en ;
    rdfs:domain cover:ValueAscription ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De ValueBeholder: de agent die de beoordelaarsrol speelt in de
         ValueAscription-Relator. Conform Sales et al. (2017) Fig. 2. (DD-036)"@nl .

#  ValueAscription ──hasBeneficiaryAgent──► ufoc:Agent  (mediation)
cover:hasBeneficiaryAgent
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has beneficiary agent"@en ;
    rdfs:domain cover:ValueAscription ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De ValueBeneficiary: de agent voor wie het oordeel geldt in de
         ValueAscription-Relator. Conform Sales et al. (2017) Fig. 2. (DD-036)"@nl .

#  ValueAscription ──ascribesValueTo──► cover:ValueExperience  (mediation)
cover:ascribesValueTo
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "ascribes value to"@en ;
    rdfs:domain cover:ValueAscription ;
    rdfs:range  cover:ValueExperience ;
    rdfs:comment
        "De ValueExperience (event) waarover de ValueAscription (Relator)
         een oordeel uitspreekt. subPropertyOf gufo:mediates.
         Conform Sales et al. (2017) Fig. 2. (DD-036)"@nl .

#  Preference ──groundsAscription──► cover:ValueAscription
coodm:groundsAscription
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "grounds ascription"@en ;
    rdfs:domain coodm:Preference ;
    rdfs:range  cover:ValueAscription ;
    rdfs:comment
        "De ValueAscription (Relator) die gegrond is in deze Preference (Belief).
         De Preference is het mentale substraat; de ValueAscription is de
         relationele uiting. (DD-036)"@nl .

#  ValueTension ──involvesTension──► cover:ValueExperience
cover:involvesTension
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "involves tension"@en ;
    rdfs:domain cover:ValueTension ;
    rdfs:range  cover:ValueExperience ;
    rdfs:comment
        "De ValueExperiences betrokken bij de ValueTension.
         Vereist minimaal twee ValueExperiences (zie SHACL E8)."@nl .

###############################################################################
#  Einde module 00e-coodm.ttl
###############################################################################
```

## Module: 00e-coodm.shacl.ttl

```turtle
###############################################################################
#  VALOR-O — Module 00e SHACL: COoDM Decision Ontology + COVER Value Ascription
#
#  Constraints:
#    §A  COoDM
#      E1  Deliberation.triggeredBy      — vereist DecisionSituation
#      E2  Deliberation.considers        — vereist ≥1 DecisionAlternative
#      E3  Deliberation.resultedIn       — vereist precies 1 Decision
#      E4  Decision.decisionGoal         — vereist precies 1 DecisionGoal
#    §B  COVER
#      E5  ValueExperience.hasBeneficiary    — vereist ≥1 Agent (participatie)
#      E6  ValueExperience.ofType           — vereist precies 1 ValueType
#      E7  ValueExperience.hasValence       — vereist precies 1 ValueScale
#      E8  ValueTension.involvesTension    — vereist ≥2 ValueExperiences
#      E9  ValueAscription: beholder, beneficiary en experience verplicht
###############################################################################

@prefix coodm: <https://valor-ecosystem.nl/ontology/coodm#> .
@prefix cover: <https://valor-ecosystem.nl/ontology/cover#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix ufol:  <https://valor-ecosystem.nl/ontology/ufo-l#> .
@prefix sh:    <http://www.w3.org/ns/shacl#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .

###############################################################################
#  §A — COoDM Constraints
###############################################################################

###############################################################################
#  E1 — Deliberation moet getriggerd zijn door een DecisionSituation
###############################################################################

coodm:DeliberationShape
    a sh:NodeShape ;
    sh:targetClass coodm:Deliberation ;
    sh:name "DeliberationShape" ;
    sh:description
        "E1–E3: Een Deliberation moet (a) getriggerd zijn door een
         DecisionSituation, (b) minstens één DecisionAlternative overwegen,
         en (c) precies één Decision produceren." ;

    sh:property [
        sh:path coodm:triggeredBy ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class coodm:DecisionSituation ;
        sh:severity sh:Violation ;
        sh:message "E1: Deliberation.triggeredBy vereist precies één DecisionSituation."
    ] ;

    sh:property [
        sh:path coodm:considers ;
        sh:minCount 1 ;
        sh:class coodm:DecisionAlternative ;
        sh:severity sh:Violation ;
        sh:message "E2: Deliberation.considers vereist ten minste één DecisionAlternative."
    ] ;

    sh:property [
        sh:path coodm:resultedIn ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class coodm:Decision ;
        sh:severity sh:Violation ;
        sh:message "E3: Deliberation.resultedIn vereist precies één Decision."
    ] .


###############################################################################
#  E4 — Decision moet precies één DecisionGoal hebben
###############################################################################

coodm:DecisionShape
    a sh:NodeShape ;
    sh:targetClass coodm:Decision ;
    sh:name "DecisionShape" ;
    sh:description
        "E4: Een Decision moet precies één DecisionGoal hebben als
         propositiële inhoud." ;

    sh:property [
        sh:path coodm:decisionGoal ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class coodm:DecisionGoal ;
        sh:severity sh:Violation ;
        sh:message "E4: Decision.decisionGoal vereist precies één DecisionGoal."
    ] .


###############################################################################
#  §B — COVER Constraints
###############################################################################

###############################################################################

###############################################################################
#  E5–E7 — ValueExperience: beneficiary, type en valentie verplicht
#  (DD-036: ValueExperience is nu een Event, niet een Quality)
###############################################################################

cover:ValueExperienceShape
    a sh:NodeShape ;
    sh:targetClass cover:ValueExperience ;
    sh:name "ValueExperienceShape" ;
    sh:description
        "E5–E7: Een ValueExperience (event) moet (a) een ValueBeneficiary hebben,
         (b) van precies één ValueType zijn, en (c) precies één valentie hebben.
         Conform Sales et al. (2017) en DD-036." ;

    sh:property [
        sh:path cover:hasBeneficiary ;
        sh:minCount 1 ;
        sh:class ufoc:Agent ;
        sh:severity sh:Violation ;
        sh:message "E5: ValueExperience.hasBeneficiary vereist ten minste één ufoc:Agent."
    ] ;

    sh:property [
        sh:path cover:ofType ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class cover:ValueType ;
        sh:severity sh:Violation ;
        sh:message "E6: ValueExperience.ofType vereist precies één cover:ValueType."
    ] ;

    sh:property [
        sh:path cover:hasValence ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class cover:ValueScale ;
        sh:severity sh:Violation ;
        sh:message "E7: ValueExperience.hasValence vereist precies één cover:ValueScale."
    ] .


###############################################################################
#  E8 — ValueTension vereist minimaal twee betrokken ValueExperiences
###############################################################################

cover:ValueTensionShape
    a sh:NodeShape ;
    sh:targetClass cover:ValueTension ;
    sh:name "ValueTensionShape" ;
    sh:description "E8: Een ValueTension vereist minimaal twee ValueExperiences." ;

    sh:property [
        sh:path cover:involvesTension ;
        sh:minCount 2 ;
        sh:class cover:ValueExperience ;
        sh:severity sh:Violation ;
        sh:message "E8: ValueTension.involvesTension vereist ten minste twee cover:ValueExperiences."
    ] .


###############################################################################
#  E9 — ValueAscription: beholder, beneficiary en experience verplicht
#  (DD-036: ValueAscription is een Relator met twee mediatie-partijen)
###############################################################################

cover:ValueAscriptionShape
    a sh:NodeShape ;
    sh:targetClass cover:ValueAscription ;
    sh:name "ValueAscriptionShape" ;
    sh:description
        "E9: Een ValueAscription (Relator) moet (a) een beoordelende agent hebben,
         (b) een begunstigde agent hebben, en (c) een ValueExperience beoordelen.
         Conform Sales et al. (2017) Fig. 2 en DD-036." ;

    sh:property [
        sh:path cover:hasBeholderAgent ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:severity sh:Violation ;
        sh:message "E9a: ValueAscription.hasBeholderAgent vereist precies één ufoc:Agent."
    ] ;

    sh:property [
        sh:path cover:hasBeneficiaryAgent ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:severity sh:Violation ;
        sh:message "E9b: ValueAscription.hasBeneficiaryAgent vereist precies één ufoc:Agent."
    ] ;

    sh:property [
        sh:path cover:ascribesValueTo ;
        sh:minCount 1 ;
        sh:class cover:ValueExperience ;
        sh:severity sh:Violation ;
        sh:message "E9c: ValueAscription.ascribesValueTo vereist ten minste één cover:ValueExperience."
    ] .

###############################################################################
#  Einde 00e-coodm.shacl.ttl
###############################################################################
```

---

## Module: 00f-cover.ttl

```turtle
###############################################################################
#  VALOR-O — Module 00f: COVER Value Ascription Ontology (uitbouw)
#
#  Namespace  : https://valor-ecosystem.nl/ontology/cover#  (prefix cover:)
#  Versie     : 0.1  (februari 2026)
#  Imports    : 00a-gufo-core, 00b-ufo-b, 00c-ufo-c, 00e-coodm
#
#  Bron:
#    Sales, T.P., Guarino, N., Guizzardi, G. & Mylopoulos, J. (2017).
#    An Ontological Analysis of Value Propositions. EDOC 2017.
#    [verwijst terug naar] Andersson et al. (2016), VAO.
#
#  Relatie tot 00e:
#    Module 00e (coodm) bevat de kern van COVER: ValueExperience, ValueType,
#    ValueAscription, ValueBeholder, ValueBeneficiary, ValueTension,
#    ValueScale, Preference. Module 00f bouwt daarop voort:
#
#    §A  ValueObject en ValueBearer
#    §B  VAComponent, Benefit, Sacrifice
#    §C  ValueProposition (BusinessVP en OfferingVP)
#    §D  Properties
#
#  Ontwerpbeslissingen:
#    DD-037 · ValueProposition als subtype van cover:ValueAssertion
#    DD-038 · VAComponent als Relator met Benefit/Sacrifice subtypen
#    DD-039 · ValueObject als RoleMixin (substantial in de rol van waarde-drager)
###############################################################################

@prefix cover: <https://valor-ecosystem.nl/ontology/cover#> .
@prefix coodm: <https://valor-ecosystem.nl/ontology/coodm#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .

###############################################################################
#  Ontologie-declaratie
###############################################################################

<https://valor-ecosystem.nl/ontology/cover>
    a owl:Ontology ;
    rdfs:label "VALOR-O Module 00f — COVER Value Ascription Ontology (uitbouw)"@en ;
    owl:imports <https://valor-ecosystem.nl/ontology/gufo-core> ;
    owl:imports <https://valor-ecosystem.nl/ontology/ufo-b> ;
    owl:imports <https://valor-ecosystem.nl/ontology/ufo-c> ;
    owl:imports <https://valor-ecosystem.nl/ontology/coodm> ;
    owl:versionInfo "0.1" ;
    rdfs:comment
        "Uitbouw van de VAO conform Sales et al. (2017): ValueObject,
         VAComponent (Benefit/Sacrifice) en ValueProposition.
         Fundeert het Axia-perspectief in VALOR volledig."@nl .


###############################################################################
#  §A — ValueObject en ValueBearer
#
#  In Sales §4 / Fig. 1 onderscheidt de VAO twee soorten waarde-dragers
#  (ValueBearers):
#    - ValueExperience : een event (gemodelleerd in 00e)
#    - ValueObject     : een substantial (goed, dienst, besluit)
#
#  Een ValueExperience wordt altijd 'enabled by' een ValueObject: je kunt
#  een streamingervaring niet hebben zonder het streamingplatform.
#
#  ValueBearer is de overkoepelende RoleMixin (Fig. 1): zowel
#  ValueExperiences als ValueObjects kunnen de rol van ValueBearer spelen
#  in een ValueAscription.
###############################################################################

###############################################################################
#  §A1 — ValueBearer  (RoleMixin)
#
#  Conform Sales Fig. 1: "<<roleMixin>> ValueBearer" — het overkoepelende
#  concept voor alles waaraan waarde kan worden toegeschreven. Twee subtypen:
#  ValueExperience (event, in 00e) en ValueObject (substantial, §A2).
###############################################################################

cover:ValueBearer
    a owl:Class ;
    rdf:type gufo:RoleMixin ;
    gufo:ontoumlStereotype "roleMixin" ;
    rdfs:subClassOf gufo:RoleMixin ;
    rdfs:label "ValueBearer"@en , "Waarde-drager"@nl ;
    rdfs:comment
        "Het overkoepelende concept voor entiteiten waaraan waarde kan worden
         toegeschreven. Twee subtypen conform Sales et al. (2017) Fig. 1:
         (a) cover:ValueExperience — een event (in 00e);
         (b) cover:ValueObject — een substantial (goed, dienst, besluit).
         (DD-039)"@nl .


###############################################################################
#  §A2 — ValueObject  (RoleMixin op Object)
#
#  Een substantial (goed, dienst, besluit, informatieobject) dat de rol van
#  waarde-drager speelt. Conform Sales §4: "value objects are substantials
#  in UFO (entities that keep their identity in time)."
#
#  ValueObject is een RoleMixin op gufo:Object. Een specifiek goed (bijv.
#  een vergunning, een zorgaanbod, een uitkering) speelt de ValueObject-rol
#  in de context van een waarde-beoordeling.
#
#  Relatie tot ValueExperience: een ValueExperience (event) is typisch
#  het gebruik/ontvangen/ondergaan van een ValueObject. De ValueExperience
#  is de 'ultimate bearer' van de waarde-beoordeling; het ValueObject is
#  de entiteit die de experience 'enables'.
###############################################################################

cover:ValueObject
    a owl:Class ;
    rdf:type gufo:RoleMixin ;
    gufo:ontoumlStereotype "roleMixin" ;
    rdfs:subClassOf gufo:RoleMixin ;
    rdfs:label "ValueObject"@en , "Waardeobject"@nl ;
    rdfs:comment
        "Een substantial (goed, dienst, besluit) dat de rol van waarde-drager
         speelt. Conform Sales et al. (2017) §4: 'value objects are
         substantials in UFO — entities that keep their identity in time.'
         Een ValueExperience (event) is typisch het gebruik of ondergaan
         van een ValueObject: cover:enabledBy relateert de twee.
         (DD-039)"@nl .


###############################################################################
#  §B — VAComponent, Benefit, Sacrifice
#
#  Conform Sales §4 / Fig. 2: een ValueAscription is een aggregaat van
#  'smaller judgments', de ValueAscription Components (VAComponents).
#  Elke VAComponent focust op één MentalAspect van de ValueBeholder en
#  brengt de relevante kwaliteiten van de ValueExperience in verband met
#  dat mentale aspect.
#
#  Twee subtypen:
#    Benefit   — positief component: de experience voldoet aan een MentalAspect
#    Sacrifice — negatief component: de experience kost iets (geld, moeite, risico)
#
#  Sales §3 (Kambil et al.): drie soorten kosten naast prijs:
#    risico, moeite, en opportunity cost.
#
#  Modellering: VAComponent is een Relator die medieert tussen:
#    - de ValueAscription (de overkoepelende beoordeling)
#    - het MentalAspect dat de focus is (ufoc:IntentionalMode)
#    - de ValueExperience waarover wordt geoordeeld
###############################################################################

###############################################################################
#  §B1 — VAComponent
###############################################################################

cover:VAComponent
    a owl:Class ;
    rdf:type gufo:RelationshipType ;
    gufo:ontoumlStereotype "relator" ;
    rdfs:subClassOf gufo:Relator ;
    rdfs:label "VAComponent"@en , "Waarde-ascriptiecomponent"@nl ;
    rdfs:comment
        "Een component van een ValueAscription: een deelbeoordeling die
         focust op één MentalAspect (doel, wens, zorg) van de ValueBeholder
         en de kwaliteiten van de ValueExperience daarmee in verband brengt.
         Een ValueAscription is opgebouwd uit één of meer VAComponents.
         Conform Sales et al. (2017) §4/Fig. 2. (DD-038)"@nl .


###############################################################################
#  §B2 — Benefit (subtype VAComponent)
###############################################################################

cover:Benefit
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf cover:VAComponent ;
    rdfs:label "Benefit"@en , "Baat"@nl ;
    rdfs:comment
        "Een positief VAComponent: de ValueExperience voldoet (geheel of
         gedeeltelijk) aan het relevante MentalAspect van de ValueBeholder.
         Conform Sales et al. (2017) §4: 'benefits are value-generating
         aspects of the experience.' (DD-038)"@nl .


###############################################################################
#  §B3 — Sacrifice (subtype VAComponent)
###############################################################################

cover:Sacrifice
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf cover:VAComponent ;
    rdfs:label "Sacrifice"@en , "Offer"@nl ;
    rdfs:comment
        "Een negatief VAComponent: de ValueExperience vereist een opoffering
         (prijs, risico, moeite, opportunity cost) van de ValueBeholder/
         ValueBeneficiary. Conform Kambil et al. (1996) zoals geciteerd in
         Sales et al. (2017) §3: kosten bestaan uit prijs, risico en moeite.
         (DD-038)"@nl .


###############################################################################
#  §C — ValueProposition
#
#  Conform Sales §5.1 / Fig. 4: een ValueProposition is een specifiek type
#  ValueAssertion waarbij een bedrijf/organisatie (de ValueBeholder) een
#  oordeel velt over de waarde die een marktsegment (de ValueBeneficiary)
#  zal toekennen aan de ervaringen die een Offering mogelijk maakt.
#
#  Cruciale onderscheidingen (Sales §5):
#    - VP ≠ Offering: een VP beantwoordt WATom en WAAROM klanten kiezen;
#      een Offering beschrijft HOE waarde wordt geleverd.
#    - BusinessVP vs. OfferingVP: twee abstractieniveaus.
#
#  In VALOR-context: een ValueProposition is de expliciete claim van een
#  publieke organisatie over de waarde die burgers zullen ervaren bij het
#  afnemen van een publieke dienst. Dit is de brug tussen Axia (waarden)
#  en Acta (dienstverlening / transactiepatroon).
###############################################################################

###############################################################################
#  §C1 — ValueProposition
###############################################################################

cover:ValueProposition
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf cover:ValueAssertion ;
    rdfs:label "ValueProposition"@en , "Waardepropositie"@nl ;
    rdfs:comment
        "Een ValueAssertion waarbij een organisatie (ValueBeholder) stelt
         dat een marktsegment/doelgroep (ValueBeneficiary) een bepaalde
         waarde zal toekennen aan de ervaringen die een dienst of aanbod
         mogelijk maakt. Subtype van cover:ValueAssertion (beholder ≠
         beneficiary). Conform Sales et al. (2017) §5.
         In VALOR: de expliciete waardeclaim van een publieke organisatie
         over haar dienstverlening — brug tussen Axia en Acta. (DD-037)"@nl .


###############################################################################
#  §C2 — BusinessValueProposition
#
#  VP op portefeuilleniveau: abstracte claim over de waarde van het totale
#  dienstenpakket voor een breed marktsegment. Sales §5.2: "the idea of
#  what the company delivers through all its offerings for a specific
#  market segment."
###############################################################################

cover:BusinessValueProposition
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf cover:ValueProposition ;
    rdfs:label "BusinessValueProposition"@en , "Organisatiewaardepropositie"@nl ;
    rdfs:comment
        "Een ValueProposition op het niveau van de totale portefeuille van
         een organisatie voor een breed marktsegment. Abstract en grofmazig
         in termen van benefits en sacrifices.
         In VALOR: de strategische waardeclaim van een gemeente of
         uitvoeringsorganisatie over haar dienstenpakket als geheel.
         Conform Sales et al. (2017) §5.2. (DD-037)"@nl .


###############################################################################
#  §C3 — OfferingValueProposition
#
#  VP op aanbodniveau: concrete claim over de waarde van één specifieke
#  dienst of regeling voor een specifiek(er) segment. Sales §5.2: "specifies
#  the actual value embedded in each offering."
###############################################################################

cover:OfferingValueProposition
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf cover:ValueProposition ;
    rdfs:label "OfferingValueProposition"@en , "Dienstwaardepropositie"@nl ;
    rdfs:comment
        "Een ValueProposition op het niveau van één specifieke dienst of
         regeling, gericht op een (sub)segment. Concreet en nauwkeurig
         in terms van benefits en sacrifices. Conformeert aan de
         BusinessValueProposition van de organisatie.
         In VALOR: de expliciete waardeclaim per publieke dienst — bruikbaar
         als Tessera in het Axia-perspectief. Conform Sales et al. (2017) §5.2.
         (DD-037)"@nl .


###############################################################################
#  §D — Properties
###############################################################################

#  ValueExperience ──enabledBy──► cover:ValueObject
cover:enabledBy
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "enabled by"@en ;
    rdfs:domain cover:ValueExperience ;
    rdfs:range  cover:ValueObject ;
    rdfs:comment
        "Het ValueObject dat de ValueExperience mogelijk maakt. Conform
         Sales et al. (2017) §4: ervaringen zijn typisch het gebruik/
         ondergaan van een ValueObject. De ValueExperience is de 'ultimate
         bearer'; het ValueObject is de enabler. (DD-039)"@nl .

#  ValueAscription ──hasComponent──► cover:VAComponent
cover:hasComponent
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasProperPart ;
    rdfs:label "has component"@en ;
    rdfs:domain cover:ValueAscription ;
    rdfs:range  cover:VAComponent ;
    rdfs:comment
        "Een VAComponent die deel uitmaakt van deze ValueAscription.
         Een ValueAscription bestaat uit één of meer VAComponents.
         subPropertyOf gufo:hasProperPart: VAComponents zijn constituerende
         delen van de ValueAscription-Relator. Conform Sales Fig. 2. (DD-038)"@nl .

#  ValueAscription ──hasBenefit──► cover:Benefit  (specialisatie van hasComponent)
cover:hasBenefit
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf cover:hasComponent ;
    rdfs:label "has benefit"@en ;
    rdfs:domain cover:ValueAscription ;
    rdfs:range  cover:Benefit ;
    rdfs:comment
        "Een Benefit-component van de ValueAscription. (DD-038)"@nl .

#  ValueAscription ──hasSacrifice──► cover:Sacrifice  (specialisatie van hasComponent)
cover:hasSacrifice
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf cover:hasComponent ;
    rdfs:label "has sacrifice"@en ;
    rdfs:domain cover:ValueAscription ;
    rdfs:range  cover:Sacrifice ;
    rdfs:comment
        "Een Sacrifice-component van de ValueAscription. (DD-038)"@nl .

#  VAComponent ──isFocusOf──► ufoc:IntentionalMode  (het mentale aspect)
cover:isFocusOf
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "is focus of"@en ;
    rdfs:domain cover:VAComponent ;
    rdfs:range  ufoc:IntentionalMode ;
    rdfs:comment
        "Het MentalAspect (IntentionalMode: doel, wens, zorg) van de
         ValueBeholder dat de focus vormt van dit VAComponent. De component
         beoordeelt de ValueExperience vanuit het perspectief van dit
         mentale aspect. Conform Sales et al. (2017) Fig. 2. (DD-038)"@nl .

#  VAComponent ──concernsExperience──► cover:ValueExperience
cover:concernsExperience
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "concerns experience"@en ;
    rdfs:domain cover:VAComponent ;
    rdfs:range  cover:ValueExperience ;
    rdfs:comment
        "De ValueExperience waarover dit VAComponent een deelbeoordeling
         uitspreekt. subPropertyOf gufo:mediates (VAComponent is een
         Relator). Conform Sales et al. (2017) Fig. 2. (DD-038)"@nl .

#  ValueProposition ──targetsSegment──► ufoc:Agent  (collectief/marksegment)
cover:targetsSegment
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "targets segment"@en ;
    rdfs:domain cover:ValueProposition ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "Het marktsegment of de doelgroep voor wie de ValueProposition geldt.
         In VALOR: de burgers of organisaties die de publieke dienst afnemen.
         subPropertyOf gufo:mediates (ValueProposition is een Relator via
         ValueAssertion). Conform Sales et al. (2017) §5.1. (DD-037)"@nl .

#  OfferingValueProposition ──conformsTo──► cover:BusinessValueProposition
cover:conformsTo
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "conforms to"@en ;
    rdfs:domain cover:OfferingValueProposition ;
    rdfs:range  cover:BusinessValueProposition ;
    rdfs:comment
        "De BusinessValueProposition waarmee deze OfferingValueProposition
         in overeenstemming moet zijn. Conform Sales et al. (2017) §5.2:
         'OVPs conform to the former [BVP].' (DD-037)"@nl .

###############################################################################
#  Einde module 00f-cover.ttl
###############################################################################
```

## Module: 00f-cover.shacl.ttl

```turtle
###############################################################################
#  VALOR-O — Module 00f SHACL: COVER Value Ascription Ontology (uitbouw)
#
#  Constraints:
#    §A  ValueObject
#      F1  ValueExperience.enabledBy       — optioneel, maar als aanwezig: ValueObject
#    §B  VAComponent
#      F2  VAComponent.isFocusOf           — vereist precies 1 IntentionalMode
#      F3  VAComponent.concernsExperience  — vereist precies 1 ValueExperience
#      F4  ValueAscription.hasComponent    — aanbevolen: ≥1 VAComponent
#    §C  ValueProposition
#      F5  ValueProposition: targetsSegment verplicht
#      F6  OfferingValueProposition.conformsTo — vereist precies 1 BusinessVP
###############################################################################

@prefix cover: <https://valor-ecosystem.nl/ontology/cover#> .
@prefix coodm: <https://valor-ecosystem.nl/ontology/coodm#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix sh:    <http://www.w3.org/ns/shacl#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .


###############################################################################
#  §A — ValueObject
###############################################################################

###############################################################################
#  F1 — enabledBy moet verwijzen naar een ValueObject (als aanwezig)
###############################################################################

cover:ValueExperienceEnablerShape
    a sh:NodeShape ;
    sh:targetClass cover:ValueExperience ;
    sh:name "ValueExperienceEnablerShape" ;
    sh:description
        "F1: Als een ValueExperience een enabledBy-relatie heeft, dan moet
         het bereik een cover:ValueObject zijn." ;

    sh:property [
        sh:path cover:enabledBy ;
        sh:class cover:ValueObject ;
        sh:severity sh:Violation ;
        sh:message "F1: cover:enabledBy vereist een cover:ValueObject als bereik."
    ] .


###############################################################################
#  §B — VAComponent
###############################################################################

###############################################################################
#  F2–F3 — VAComponent: MentalAspect en ValueExperience verplicht
###############################################################################

cover:VAComponentShape
    a sh:NodeShape ;
    sh:targetClass cover:VAComponent ;
    sh:name "VAComponentShape" ;
    sh:description
        "F2–F3: Een VAComponent moet (a) focussen op precies één
         IntentionalMode en (b) betrekking hebben op precies één
         ValueExperience. Conform Sales et al. (2017) Fig. 2." ;

    sh:property [
        sh:path cover:isFocusOf ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:IntentionalMode ;
        sh:severity sh:Violation ;
        sh:message "F2: VAComponent.isFocusOf vereist precies één ufoc:IntentionalMode."
    ] ;

    sh:property [
        sh:path cover:concernsExperience ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class cover:ValueExperience ;
        sh:severity sh:Violation ;
        sh:message "F3: VAComponent.concernsExperience vereist precies één cover:ValueExperience."
    ] .


###############################################################################
#  F4 — ValueAscription: aanbeveling voor ≥1 VAComponent
#  (Warning, niet Violation: een ascriptie zonder components is onvolledig
#   maar niet per se ongeldig in vroege modelleerstadia)
###############################################################################

cover:ValueAscriptionComponentShape
    a sh:NodeShape ;
    sh:targetClass cover:ValueAscription ;
    sh:name "ValueAscriptionComponentShape" ;
    sh:description
        "F4: Een ValueAscription wordt aanbevolen minimaal één VAComponent
         te hebben. Zonder components is de ascriptie inhoudsloos
         (Warning-niveau)." ;

    sh:property [
        sh:path cover:hasComponent ;
        sh:minCount 1 ;
        sh:class cover:VAComponent ;
        sh:severity sh:Warning ;
        sh:message "F4: ValueAscription heeft geen VAComponents — de ascriptie is inhoudsloos."
    ] .


###############################################################################
#  §C — ValueProposition
###############################################################################

###############################################################################
#  F5 — ValueProposition: doelgroep (targetsSegment) verplicht
###############################################################################

cover:ValuePropositionShape
    a sh:NodeShape ;
    sh:targetClass cover:ValueProposition ;
    sh:name "ValuePropositionShape" ;
    sh:description
        "F5: Een ValueProposition moet altijd een doelgroep hebben via
         cover:targetsSegment. Een waardepropositie zonder doelgroep
         is per definitie onvolledig. Conform Sales et al. (2017) §5.1." ;

    sh:property [
        sh:path cover:targetsSegment ;
        sh:minCount 1 ;
        sh:class ufoc:Agent ;
        sh:severity sh:Violation ;
        sh:message "F5: ValueProposition.targetsSegment vereist ten minste één ufoc:Agent (doelgroep)."
    ] .


###############################################################################
#  F6 — OfferingValueProposition: conformsTo BusinessValueProposition verplicht
###############################################################################

cover:OfferingVPShape
    a sh:NodeShape ;
    sh:targetClass cover:OfferingValueProposition ;
    sh:name "OfferingVPShape" ;
    sh:description
        "F6: Een OfferingValueProposition moet conformeren aan precies één
         BusinessValueProposition. Conform Sales et al. (2017) §5.2:
         'OVPs conform to the former [BVP] and should not violate its
         assumptions.'" ;

    sh:property [
        sh:path cover:conformsTo ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class cover:BusinessValueProposition ;
        sh:severity sh:Violation ;
        sh:message "F6: OfferingValueProposition.conformsTo vereist precies één cover:BusinessValueProposition."
    ] .

###############################################################################
#  Einde 00f-cover.shacl.ttl
###############################################################################
```

---

## Module: 00g-acta.ttl

```turtle
###############################################################################
#  VALOR-O — Module 00g: ACTA Transactieontologie
#
#  Namespace  : https://valor-ecosystem.nl/ontology/acta#  (prefix acta:)
#  Versie     : 0.1  (februari 2026)
#  Imports    : 00a-gufo-core, 00b-ufo-b, 00c-ufo-c, 00d-ufo-l, 00f-cover
#
#  Bron:
#    Almeida, J.P.A., Guizzardi, G. & Falbo, R. (2013).
#    Revisiting the DEMO Transaction Pattern with UFO. EEWC 2013.
#    [gecombineerd met] Dietz, J.L.G. & Mulder, H.B.F. (2020).
#    Enterprise Ontology: The DEMO Methodology. Springer.
#
#  Positie in VALOR:
#    Acta modelleert publieke dienstverlening als een netwerk van
#    transacties tussen burger en overheid. Een transactie is geen
#    procesflow maar een normatieve interactiestructuur: een SocialRelator
#    die Initiator en Executor verbindt via coördinatie-acts en een
#    productie-act die een transactioneel resultaat voortbrengt.
#
#  Relatie tot UFO-L:
#    Een transactie staat in twee richtingen in verhouding tot LegalRelators:
#    (1) GEGROND IN: een pre-existente LegalRelator (typisch CompetenceRelator
#        of ClaimRightRelator) maakt de transactie juridisch mogelijk
#        (acta:groundedIn);
#    (2) SCHEPT: de ProductionAct brengt een nieuwe LegalRelator tot stand
#        (acta:createsLegalRelator via gufo:wasCreatedIn).
#    Zie DD-040 en DD-041.
#
#  Relatie tot COVER:
#    Het TransactionResult (gufo:Situation) is het cover:ValueObject dat
#    ValueExperiences mogelijk maakt — de brug van Acta naar Axia.
#    Zie DD-042.
#
#  Structuur:
#    §A  Transactierollen (RoleMixin)
#    §B  Transaction (SocialRelator)
#    §C  Acts: CoordinationAct en ProductionAct
#    §D  TransactionResult en juridische uitkomsten
#    §E  Properties
#    §F  Geneste transacties
###############################################################################

@prefix acta:  <https://valor-ecosystem.nl/ontology/acta#> .
@prefix cover: <https://valor-ecosystem.nl/ontology/cover#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix ufol:  <https://valor-ecosystem.nl/ontology/ufo-l#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .

###############################################################################
#  Ontologie-declaratie
###############################################################################

<https://valor-ecosystem.nl/ontology/acta>
    a owl:Ontology ;
    rdfs:label "VALOR-O Module 00g — ACTA Transactieontologie"@nl ;
    owl:imports <https://valor-ecosystem.nl/ontology/gufo-core> ;
    owl:imports <https://valor-ecosystem.nl/ontology/ufo-b> ;
    owl:imports <https://valor-ecosystem.nl/ontology/ufo-c> ;
    owl:imports <https://valor-ecosystem.nl/ontology/ufo-l> ;
    owl:imports <https://valor-ecosystem.nl/ontology/cover> ;
    owl:versionInfo "0.1" ;
    rdfs:comment
        "Formaliseert het DEMO Complete Transaction Pattern in UFO,
         conform Almeida et al. (EEWC 2013). Fundeert het Acta-perspectief
         in VALOR: publieke dienstverlening als normatief transactienetwerk
         tussen burger en overheid."@nl .


###############################################################################
#  §A — Transactierollen  (RoleMixin)
#
#  Een agent speelt in de context van een transactie een rol.
#  Rollen zijn niet-rigide: dezelfde agent kan in verschillende
#  transacties Initiator én Executor zijn.
#
#  Conform DEMO: Initiator = de actor die de transactie start (burger,
#  aanvrager, opdrachtgever); Executor = de actor die de productie-act
#  uitvoert (overheid, uitvoerder, dienstverlener).
#
#  Conform Almeida 2013: rollen zijn RoleMixins op ufoc:Agent —
#  niet-sortale typen die agents karakteriseren in transactiecontext.
###############################################################################

acta:TransactionRole
    a owl:Class ;
    rdf:type gufo:RoleMixin ;
    gufo:ontoumlStereotype "roleMixin" ;
    rdfs:subClassOf gufo:RoleMixin ;
    rdfs:label "TransactionRole"@en , "Transactierol"@nl ;
    rdfs:comment
        "De overkoepelende RoleMixin voor agents die deelnemen aan een
         transactie. Twee subtypen: acta:Initiator en acta:Executor.
         Conform Almeida et al. (2013): rollen zijn RoleMixins op
         ufoc:Agent. (DD-040)"@nl .

acta:Initiator
    a owl:Class ;
    rdf:type gufo:RoleMixin ;
    gufo:ontoumlStereotype "roleMixin" ;
    rdfs:subClassOf acta:TransactionRole ;
    rdfs:label "Initiator"@en , "Initiator"@nl ;
    rdfs:comment
        "De agent die de transactie initieert door een RequestAct uit te
         voeren. In publieke dienstverlening: de burger, aanvrager of
         opdrachtgever. De Initiator heeft de intentie een bepaald
         transactioneel resultaat te verkrijgen.
         Conform DEMO: 'de actor die de transactie start.' (DD-040)"@nl .

acta:Executor
    a owl:Class ;
    rdf:type gufo:RoleMixin ;
    gufo:ontoumlStereotype "roleMixin" ;
    rdfs:subClassOf acta:TransactionRole ;
    rdfs:label "Executor"@en , "Uitvoerder"@nl ;
    rdfs:comment
        "De agent die de productie-act uitvoert en het transactionele
         resultaat voortbrengt. In publieke dienstverlening: de overheid,
         uitvoeringsorganisatie of dienstverlener.
         Conform DEMO: 'de actor die de transactie uitvoert.' (DD-040)"@nl .


###############################################################################
#  §B — Transaction
#
#  De Transaction is een ufoc:SocialRelator: een ExtrinsicAspect dat de
#  normatieve interactiestructuur tussen Initiator en Executor uitdrukt.
#  Conform Almeida et al. (2013): "a transaction is modelled as a Social
#  Relator mediating the initiator and executor."
#
#  Een Transaction bestaat uit:
#    - de Initiator (RoleMixin op Agent)
#    - de Executor (RoleMixin op Agent)
#    - een reeks CoordinationActs
#    - een ProductionAct
#    - een TransactionResult (gufo:Situation)
#
#  Verhouding tot LegalRelator (DD-040, DD-041):
#    - acta:groundedIn   → de pre-existente LegalRelator die de transactie
#                           juridisch mogelijk maakt (typisch CompetenceRelator
#                           of ClaimRightRelator vanuit de wet)
#    - acta:createsLegalRelator → de nieuwe LegalRelator die de ProductionAct
#                           tot stand brengt (typisch ClaimRightRelator:
#                           de vergunning, de beschikking, het recht)
#
#  Twee archetypen in publieke dienstverlening:
#    PublicServiceTransaction : burger vraagt dienst aan bij overheid
#    InternalTransaction      : overheid-interne uitvoeringstransactie
###############################################################################

acta:Transaction
    a owl:Class ;
    rdf:type gufo:RelationshipType ;
    gufo:ontoumlStereotype "relator" ;
    rdfs:subClassOf ufoc:SocialRelator ;
    rdfs:label "Transaction"@en , "Transactie"@nl ;
    rdfs:comment
        "Een normatieve interactiestructuur tussen een Initiator en een
         Executor, gemodelleerd als ufoc:SocialRelator. Bestaat uit een
         reeks CoordinationActs en een ProductionAct die samen het
         Complete Transaction Pattern (CTP) van DEMO realiseren.
         Conform Almeida et al. (2013): 'a transaction is a Social
         Relator mediating initiator and executor.' (DD-040)"@nl .

acta:PublicServiceTransaction
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf acta:Transaction ;
    rdfs:label "PublicServiceTransaction"@en , "Publieke-diensttransactie"@nl ;
    rdfs:comment
        "Een transactie waarbij een burger (Initiator) een publieke dienst
         aanvraagt bij een overheidsorganisatie (Executor). Het archetype
         voor het Acta-perspectief in VALOR: vergunningverlening,
         uitkeringsverstrekking, bezwaarprocedure, etc. (DD-040)"@nl .

acta:InternalTransaction
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf acta:Transaction ;
    rdfs:label "InternalTransaction"@en , "Interne transactie"@nl ;
    rdfs:comment
        "Een transactie tussen twee actoren binnen dezelfde organisatie.
         Conform DEMO B-organisatie: de ontologisch relevante
         coördinatiestructuur tussen interne actorrollen. (DD-040)"@nl .


###############################################################################
#  §C — Acts: CoordinationAct en ProductionAct
#
#  Conform DEMO Complete Transaction Pattern (CTP):
#
#    COÖRDINATIEWERELD (infologisch):
#      request  → promise  → (execute) → accept
#      request  → decline
#      promise  → revoke
#      accept   → revoke
#
#    PRODUCTIEWERELD (ontologisch):
#      execute  → TransactionResult (nieuwe situatie in het domein)
#
#  Acts zijn gufo:Action: intentionele events uitgevoerd door agents.
#  Elke Act heeft precies één performer (de agent die hem uitvoert)
#  en is onderdeel van precies één Transaction.
#
#  Logische precedentie (acta:precedes) is een specialisatie van
#  gufo:contributedToTrigger: een Situation (de toestand na een act)
#  draagt causaal bij aan het triggeren van de volgende act.
#
#  Conform Almeida 2013: het onderscheid tussen coördinatie-acts
#  (informationeel: afspraken maken) en de productie-act (ontologisch:
#  domeinverandering bewerkstelligen) is fundamenteel in DEMO en
#  weerspiegelt het UFO B/C-onderscheid tussen Events en SocialRelators.
###############################################################################

###############################################################################
#  §C1 — CoordinationAct (overkoepelend)
###############################################################################

acta:CoordinationAct
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Action ;
    rdfs:label "CoordinationAct"@en , "Coördinatie-act"@nl ;
    rdfs:comment
        "Een intentionele actie in de coördinatiewereld van een transactie:
         een afspraak, toezegging, weigering of bekrachtiging. In tegenstelling
         tot de ProductionAct brengt een CoordinationAct geen ontologische
         domeinwijziging teweeg maar constitueert de normatieve structuur
         van de transactie. Conform DEMO CTP en Almeida et al. (2013).
         (DD-040)"@nl .

###############################################################################
#  §C2 — CoordinationAct subtypen
###############################################################################

acta:RequestAct
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf acta:CoordinationAct ;
    rdfs:label "RequestAct"@en , "Aanvraag-act"@nl ;
    rdfs:comment
        "De Initiator vraagt de Executor een transactioneel resultaat
         voort te brengen. Start het Complete Transaction Pattern.
         Performer: Initiator. Conform DEMO CTP fase 1. (DD-040)"@nl .

acta:PromiseAct
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf acta:CoordinationAct ;
    rdfs:label "PromiseAct"@en , "Toezegging-act"@nl ;
    rdfs:comment
        "De Executor zegt toe de transactie te behandelen en een resultaat
         voort te brengen. Constitueert de normatieve behandelplicht.
         Performer: Executor. Conform DEMO CTP fase 2. (DD-040)"@nl .

acta:AcceptAct
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf acta:CoordinationAct ;
    rdfs:label "AcceptAct"@en , "Bekrachtiging-act"@nl ;
    rdfs:comment
        "De Initiator bekrachtigt het geleverde transactionele resultaat:
         de transactie is daarmee formeel voltooid.
         Performer: Initiator. Conform DEMO CTP fase 4. (DD-040)"@nl .

acta:DeclineAct
    a owl:Class ;
    rdf:type gufo:SubKind ;
    gufo:ontoumlStereotype "subkind" ;
    rdfs:subClassOf acta:CoordinationAct ;
    rdfs:label "DeclineAct"@en , "Weigering-act"@nl ;
    rdfs:comment
        "Een actor weigert de transactie voort te zetten: de Executor
         weigert te behandelen (afwijzing) of de Initiator verwerpt het
         resultaat (bezwaar). Performer: Initiator of Executor.
         Conform DEMO CTP alternatief pad. (DD-040)"@nl .

###############################################################################
#  §C3 — ProductionAct
#
#  De ProductionAct is de ontologisch centrale act: zij brengt een
#  toestandswijziging in het domein teweeg. In UFO-termen:
#    - ProductionAct is een gufo:Action
#    - zij 'wasCreatedIn' relateert het TransactionResult (gufo:Situation
#      of een nieuw Endurant) aan de ProductionAct
#    - zij kan een nieuwe LegalRelator tot stand brengen
#      (acta:createsLegalRelator, via gufo:wasCreatedIn)
#
#  DEMO-distinctie: de ProductionAct staat in de 'productiewereld'
#  (ontologisch niveau, B-organisatie), de CoordinationActs staan in de
#  'coördinatiewereld' (informationeel niveau, I-organisatie).
###############################################################################

acta:ProductionAct
    a owl:Class ;
    rdf:type gufo:EventType ;
    gufo:ontoumlStereotype "event" ;
    rdfs:subClassOf gufo:Action ;
    rdfs:label "ProductionAct"@en , "Productie-act"@nl ;
    rdfs:comment
        "De ontologisch centrale act van een transactie: zij brengt een
         toestandswijziging in het domein teweeg (het TransactionResult).
         In publieke dienstverlening: de verlening van een vergunning,
         de toekenning van een uitkering, het nemen van een beschikking.
         De ProductionAct kan een nieuwe LegalRelator scheppen
         (acta:createsLegalRelator). Performer: Executor.
         Conform DEMO CTP fase 3 en Almeida et al. (2013). (DD-041)"@nl .


###############################################################################
#  §D — TransactionResult en juridische uitkomsten
#
#  Het TransactionResult is de toestand die de ProductionAct voortbrengt.
#  In UFO-termen: een gufo:Situation (een bestaande toestand van de wereld).
#
#  In publieke dienstverlening zijn er twee hoofdtypen resultaat:
#    - een positief besluit: vergunning, uitkering, erkenning
#      → schept een nieuwe ClaimRightRelator (recht voor de burger)
#    - een negatief besluit: afwijzing, intrekking
#      → geen nieuwe LegalRelator; bestaande NormativeSituation blijft
#
#  De brug naar COVER (DD-042):
#    Het TransactionResult IS het cover:ValueObject: het geleverde resultaat
#    is de entiteit waarop burgers een ValueExperience kunnen hebben.
#    Een vergunning als Situation → enabledBy-relatie naar ValueExperience.
###############################################################################

acta:TransactionResult
    a owl:Class ;
    rdf:type gufo:SituationType ;
    gufo:ontoumlStereotype "situation" ;
    rdfs:subClassOf gufo:Situation ;
    rdfs:label "TransactionResult"@en , "Transactieresultaat"@nl ;
    rdfs:comment
        "De toestand die de ProductionAct voortbrengt: het resultaat
         van de transactie. In publieke dienstverlening: een beschikking,
         vergunning, uitkering, erkenning of afwijzing.
         gufo:Situation: de toestand bestaat nadat de ProductionAct
         plaatsvond en blijft bestaan tot zij wordt opgeheven.
         Dit is tevens het cover:ValueObject dat ValueExperiences
         bij de burger mogelijk maakt (brug Acta ↔ Axia). (DD-042)"@nl .

acta:PositiveResult
    a owl:Class ;
    rdf:type gufo:Phase ;
    gufo:ontoumlStereotype "phase" ;
    rdfs:subClassOf acta:TransactionResult ;
    rdfs:label "PositiveResult"@en , "Positief resultaat"@nl ;
    rdfs:comment
        "Een TransactionResult waarbij de Initiator het gevraagde resultaat
         verkrijgt. Schept typisch een nieuwe ufol:ClaimRightRelator
         (het recht van de burger op de dienst/het goed). (DD-041)"@nl .

acta:NegativeResult
    a owl:Class ;
    rdf:type gufo:Phase ;
    gufo:ontoumlStereotype "phase" ;
    rdfs:subClassOf acta:TransactionResult ;
    rdfs:label "NegativeResult"@en , "Negatief resultaat"@nl ;
    rdfs:comment
        "Een TransactionResult waarbij de Initiator het gevraagde resultaat
         niet verkrijgt (afwijzing, weigering). Schept geen nieuwe
         LegalRelator; de initiële NormativeSituation blijft van kracht.
         Opent typisch de mogelijkheid voor een BezwaarTransaction.
         (DD-041)"@nl .


###############################################################################
#  §E — Properties
###############################################################################

#  Transaction ──hasInitiator──► ufoc:Agent  (mediation)
acta:hasInitiator
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has initiator"@en ;
    rdfs:domain acta:Transaction ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De agent die de Initiator-rol speelt in deze transactie.
         subPropertyOf gufo:mediates: de Transaction-Relator medieert
         zijn Initiator. Conform Almeida et al. (2013). (DD-040)"@nl .

#  Transaction ──hasExecutor──► ufoc:Agent  (mediation)
acta:hasExecutor
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:subPropertyOf gufo:mediates ;
    rdfs:label "has executor"@en ;
    rdfs:domain acta:Transaction ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De agent die de Executor-rol speelt in deze transactie.
         subPropertyOf gufo:mediates: de Transaction-Relator medieert
         zijn Executor. Conform Almeida et al. (2013). (DD-040)"@nl .

#  Transaction ──comprisesAct──► acta:CoordinationAct of ProductionAct
acta:comprisesAct
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:hasProperPart ;
    rdfs:label "comprises act"@en ;
    rdfs:domain acta:Transaction ;
    rdfs:range  gufo:Action ;
    rdfs:comment
        "De acts (CoordinationActs en ProductionAct) die deel uitmaken
         van deze transactie. subPropertyOf gufo:hasProperPart:
         acts zijn constituerende delen van de transactiestructuur.
         (DD-040)"@nl .

#  Transaction ──hasTransactionResult──► acta:TransactionResult
acta:hasTransactionResult
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "creation" ;
    rdfs:label "has transaction result"@en ;
    rdfs:domain acta:Transaction ;
    rdfs:range  acta:TransactionResult ;
    rdfs:comment
        "Het TransactionResult dat door de ProductionAct van deze
         transactie tot stand is gebracht. Stereotyp «creation»:
         de transactie brengt haar resultaat tot bestaan.
         (DD-041, DD-042)"@nl .

#  Transaction ──groundedIn──► ufol:LegalRelator
#
#  De pre-existente LegalRelator die de transactie juridisch mogelijk maakt.
#  Typisch: CompetenceRelator (de overheid heeft de bevoegdheid)
#           of ClaimRightRelator (de burger heeft een wettelijk recht).
#  De LegalRelator is de juridische positie; de Transaction is het proces
#  waarmee die positie wordt gerealiseerd of uitgeoefend.
acta:groundedIn
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "grounded in"@en ;
    rdfs:domain acta:Transaction ;
    rdfs:range  ufol:LegalRelator ;
    rdfs:comment
        "De pre-existente LegalRelator (rechtsbetrekking of bevoegdheid)
         die de transactie juridisch mogelijk maakt. Twee archetypen:
         (1) CompetenceRelator: de overheid heeft de bevoegdheid de
             ProductionAct uit te voeren (bijv. vergunningverlening);
         (2) ClaimRightRelator: de burger heeft een wettelijk recht op
             dienstverlening (bijv. bijstandsaanvraag).
         Conform DD-040: de LegalRelator is de statische positie;
         de Transaction is het dynamische realisatieproces."@nl .

#  Transaction ──guidedByPolicy──► ufol:Policy
#
#  Analoog aan coodm:guidedByPolicy in 00e: het uitvoeringsbeleid
#  stuurt de Executor bij de beoordeling van de ProductionAct.
acta:guidedByPolicy
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "guided by policy"@en ;
    rdfs:domain acta:Transaction ;
    rdfs:range  ufol:Policy ;
    rdfs:comment
        "De Policy die de Executor stuurt bij de uitvoering van de
         transactie: het beleid dat bepaalt onder welke voorwaarden
         de ProductionAct wordt uitgevoerd.
         Analoog aan coodm:guidedByPolicy in module 00e. (DD-040)"@nl .

#  ProductionAct ──createsLegalRelator──► ufol:LegalRelator
#
#  De nieuwe LegalRelator die de ProductionAct tot stand brengt.
#  Gegrond in gufo:wasCreatedIn (inversorichtingsartikel):
#    ufol:LegalRelator.wasCreatedIn → acta:ProductionAct
#  Hier de functionele richting: ProductionAct → LegalRelator.
acta:createsLegalRelator
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "creation" ;
    rdfs:label "creates legal relator"@en ;
    rdfs:domain acta:ProductionAct ;
    rdfs:range  ufol:LegalRelator ;
    rdfs:comment
        "De nieuwe LegalRelator die de ProductionAct tot stand brengt.
         Voorbeeld: de beschikking (ProductionAct) schept een
         ClaimRightRelator waarbij de burger een RightMode verkrijgt.
         Gegrond in gufo:wasCreatedIn (endurant → creerende event).
         Conform DD-041: de transactie schept een nieuwe rechtsbetrekking."@nl .

#  ProductionAct ──isProductionActOf──► acta:Transaction
acta:isProductionActOf
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "componentOf" ;
    rdfs:subPropertyOf gufo:isPartOf ;
    rdfs:label "is production act of"@en ;
    rdfs:domain acta:ProductionAct ;
    rdfs:range  acta:Transaction ;
    rdfs:comment
        "De transactie waarvan deze ProductionAct de kern vormt.
         Inverso van acta:comprisesAct beperkt tot ProductionAct.
         (DD-040)"@nl .

#  CoordinationAct ──precedes──► CoordinationAct of ProductionAct
#
#  Logische (niet temporele!) precedentie: de toestand na act A draagt
#  causaal bij aan het triggeren van act B.
#  Gegrond in gufo:contributedToTrigger (Situation → Event):
#  de situatie die act A voortbrengt triggert act B.
acta:precedes
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "precedes"@en ;
    rdfs:domain gufo:Action ;
    rdfs:range  gufo:Action ;
    rdfs:comment
        "Logische precedentie tussen acts in het CTP: act A moet logisch
         voorafgaan aan act B (bijv. PromiseAct precedes ProductionAct).
         Geen temporele modellering maar causale/intentionele afhankelijkheid
         gegrond in gufo:contributedToTrigger. (DD-040)"@nl .

#  Act ──performedBy──► ufoc:Agent
acta:performedBy
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "participational" ;
    rdfs:subPropertyOf gufo:hasParticipant ;
    rdfs:label "performed by"@en ;
    rdfs:domain gufo:Action ;
    rdfs:range  ufoc:Agent ;
    rdfs:comment
        "De agent die de act uitvoert als intentionele handeling.
         subPropertyOf gufo:hasParticipant (Event → Object).
         Conform gUFO: een Action is een intentioneel Event waarbij
         de uitvoerende agent participant is. (DD-040)"@nl .

#  TransactionResult ──enablesExperience──► cover:ValueExperience
#
#  Brug Acta ↔ Axia (DD-042):
#  Het TransactionResult is het cover:ValueObject dat ValueExperiences
#  bij de burger mogelijk maakt. Inverso van cover:enabledBy.
acta:enablesExperience
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "enables experience"@en ;
    rdfs:domain acta:TransactionResult ;
    rdfs:range  cover:ValueExperience ;
    rdfs:comment
        "De ValueExperiences die dit TransactionResult bij de Initiator
         mogelijk maakt. Brug van Acta naar Axia: het transactionele
         resultaat (de beschikking, vergunning, uitkering) is het
         cover:ValueObject waarop waardebelevingen zijn gegrond.
         Inverso van cover:enabledBy. (DD-042)"@nl .


###############################################################################
#  §F — Geneste transacties
#
#  Conform DEMO: transacties kunnen worden genest. Een ProductionAct kan
#  een of meer sub-transacties vereisen (de Executor is dan Initiator
#  van een interne transactie). Dit is de B-organisatiestructuur van DEMO.
#
#  Modellering: acta:requiresTransaction koppelt een ProductionAct of
#  Transaction aan een sub-Transaction. De sub-Transaction heeft haar
#  eigen CTP, eigen Initiator/Executor en eigen LegalRelator-grondslag.
###############################################################################

acta:requiresTransaction
    a owl:ObjectProperty ;
    gufo:ontoumlStereotype "mediation" ;
    rdfs:label "requires transaction"@en ;
    rdfs:domain acta:Transaction ;
    rdfs:range  acta:Transaction ;
    rdfs:comment
        "Een sub-transactie die vereist is voor de voltooiing van deze
         transactie. Conform DEMO B-organisatie: geneste transactiestructuren
         waarbij een Executor van de bovenliggende transactie de Initiator
         is van de sub-transactie. (DD-040)"@nl .

###############################################################################
#  Einde module 00g-acta.ttl
###############################################################################
```

## Module: 00g-acta.shacl.ttl

```turtle
###############################################################################
#  VALOR-O — Module 00g SHACL: ACTA Transactieontologie
#
#  Constraints:
#    §A  Transaction
#      G1  Transaction.hasInitiator     — vereist precies 1 Agent
#      G2  Transaction.hasExecutor      — vereist precies 1 Agent
#      G3  Transaction.hasTransactionResult — vereist precies 1 Result
#      G4  Transaction: Initiator ≠ Executor (publieke transactie)
#    §B  ProductionAct
#      G5  ProductionAct.isProductionActOf — vereist precies 1 Transaction
#      G6  ProductionAct.performedBy    — vereist precies 1 Agent
#    §C  CoordinationAct
#      G7  CoordinationAct.performedBy  — vereist precies 1 Agent
#    §D  Juridische koppelingen
#      G8  PositiveResult → createsLegalRelator aanbeveling (Warning)
###############################################################################

@prefix acta:  <https://valor-ecosystem.nl/ontology/acta#> .
@prefix cover: <https://valor-ecosystem.nl/ontology/cover#> .
@prefix gufo:  <http://purl.org/nemo/gufo#> .
@prefix ufoc:  <https://valor-ecosystem.nl/ontology/ufo-c#> .
@prefix ufol:  <https://valor-ecosystem.nl/ontology/ufo-l#> .
@prefix sh:    <http://www.w3.org/ns/shacl#> .
@prefix owl:   <http://www.w3.org/2002/07/owl#> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .


###############################################################################
#  §A — Transaction constraints
###############################################################################

acta:TransactionShape
    a sh:NodeShape ;
    sh:targetClass acta:Transaction ;
    sh:name "TransactionShape" ;
    sh:description
        "G1–G3: Een transactie vereist precies één Initiator, één Executor
         en precies één TransactionResult. Conform DEMO CTP en
         Almeida et al. (2013)." ;

    sh:property [
        sh:path acta:hasInitiator ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:severity sh:Violation ;
        sh:message "G1: Transaction.hasInitiator vereist precies één ufoc:Agent."
    ] ;

    sh:property [
        sh:path acta:hasExecutor ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:severity sh:Violation ;
        sh:message "G2: Transaction.hasExecutor vereist precies één ufoc:Agent."
    ] ;

    sh:property [
        sh:path acta:hasTransactionResult ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class acta:TransactionResult ;
        sh:severity sh:Violation ;
        sh:message "G3: Transaction.hasTransactionResult vereist precies één acta:TransactionResult."
    ] .


###############################################################################
#  G4 — PublicServiceTransaction: Initiator ≠ Executor
#  (In een publieke transactie zijn burger en overheid per definitie
#   verschillende agents — dit is het archetype van dienstverlening)
###############################################################################

acta:PublicServiceTransactionShape
    a sh:NodeShape ;
    sh:targetClass acta:PublicServiceTransaction ;
    sh:name "PublicServiceTransactionShape" ;
    sh:description
        "G4: In een PublicServiceTransaction moeten de Initiator en
         Executor verschillende agents zijn. Een overheid kan niet
         tegelijk burger en dienstverlener zijn in dezelfde transactie." ;

    sh:sparql [
        sh:message "G4: PublicServiceTransaction.hasInitiator en hasExecutor mogen niet dezelfde Agent zijn." ;
        sh:severity sh:Violation ;
        sh:prefixes [
            sh:declare [
                sh:prefix "acta" ;
                sh:namespace "https://valor-ecosystem.nl/ontology/acta#"
            ]
        ] ;
        sh:select """
            SELECT $this WHERE {
                $this acta:hasInitiator ?initiator .
                $this acta:hasExecutor ?executor .
                FILTER (?initiator = ?executor)
            }
        """
    ] .


###############################################################################
#  §B — ProductionAct constraints
###############################################################################

acta:ProductionActShape
    a sh:NodeShape ;
    sh:targetClass acta:ProductionAct ;
    sh:name "ProductionActShape" ;
    sh:description
        "G5–G6: Een ProductionAct behoort tot precies één Transaction
         en heeft precies één performer (de Executor)." ;

    sh:property [
        sh:path acta:isProductionActOf ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class acta:Transaction ;
        sh:severity sh:Violation ;
        sh:message "G5: ProductionAct.isProductionActOf vereist precies één acta:Transaction."
    ] ;

    sh:property [
        sh:path acta:performedBy ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:severity sh:Violation ;
        sh:message "G6: ProductionAct.performedBy vereist precies één ufoc:Agent (de Executor)."
    ] .


###############################################################################
#  §C — CoordinationAct constraints
###############################################################################

acta:CoordinationActShape
    a sh:NodeShape ;
    sh:targetClass acta:CoordinationAct ;
    sh:name "CoordinationActShape" ;
    sh:description "G7: Een CoordinationAct heeft precies één performer." ;

    sh:property [
        sh:path acta:performedBy ;
        sh:minCount 1 ; sh:maxCount 1 ;
        sh:class ufoc:Agent ;
        sh:severity sh:Violation ;
        sh:message "G7: CoordinationAct.performedBy vereist precies één ufoc:Agent."
    ] .


###############################################################################
#  §D — Juridische koppelingen
###############################################################################

###############################################################################
#  G8 — PositiveResult: aanbeveling voor createsLegalRelator
#  (Warning: een positief resultaat dat geen nieuwe LegalRelator schept
#   is ontologisch onvolledig maar niet altijd fout — bijv. informatieverstrekking)
###############################################################################

acta:PositiveResultShape
    a sh:NodeShape ;
    sh:targetClass acta:PositiveResult ;
    sh:name "PositiveResultShape" ;
    sh:description
        "G8: Een PositiveResult wordt aanbevolen te zijn gekoppeld aan
         een nieuwe LegalRelator (via createsLegalRelator op de
         bijbehorende ProductionAct). Zonder LegalRelator is het
         ontologisch onduidelijk welk recht de burger verkrijgt." ;

    sh:sparql [
        sh:message "G8: Dit PositiveResult is niet gekoppeld aan een nieuwe LegalRelator via de ProductionAct — overweeg acta:createsLegalRelator toe te voegen." ;
        sh:severity sh:Warning ;
        sh:prefixes [
            sh:declare [
                sh:prefix "acta" ;
                sh:namespace "https://valor-ecosystem.nl/ontology/acta#"
            ]
        ] ;
        sh:select """
            SELECT $this WHERE {
                ?tx acta:hasTransactionResult $this .
                ?act acta:isProductionActOf ?tx .
                FILTER NOT EXISTS { ?act acta:createsLegalRelator ?lr }
            }
        """
    ] .

###############################################################################
#  Einde 00g-acta.shacl.ttl
###############################################################################
```

---
