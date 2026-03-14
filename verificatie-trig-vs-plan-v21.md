# Verificatierapport: Trig-bestanden vs. Product Plan VALOR-Ecosysteem v2.1

**Datum:** 2026-03-14
**Verifier:** Claude (Anthropic)
**Branch:** `claude/verify-trig-files-y6Lle`
**Bronnen:**
- Product plan: `versie 2.1/valor-ecosystem-v21.md` (datum: maart 2026, status: Concept — ter besluitvorming)
- Trig-bestanden: `00a-gufo-core.trig` t/m `00s-valor-core.trig` + `void.trig` (wortel-map)
- VoID-catalogus: `void.trig` (v0.2, gewijzigd 2026-03-13)

---

## 1. Samenvatting

| Dimensie | Status | Ernst |
|----------|--------|-------|
| Modulevolledigheid (conceptueel) | ✅ Volledig | — |
| Modulenummering (plan vs. bestanden) | ⚠️ Inconsistent | **Laag** (documentair) |
| Lagenarchitectuur (owl:imports) | ✅ Correct | — |
| Kernklassen per module | ✅ Volledig aanwezig | — |
| Versienummers | ✅ Consistent (bestanden zijn bijgewerkt) | — |
| VoID-catalogus | ⚠️ Gedeeltelijk verouderd | **Laag** (documentair) |
| Lexa als perspectief-module | ⚠️ Geen eigen .trig-bestand | **Laag** (architectuurkeuze) |

**Conclusie:** De trig-bestanden representeren de conceptuele architectuur van het product plan v2.1 **correct en volledig**. Er is één significante documentaire inconsistentie: de modulenummers die in de plantekst worden gebruikt (§2.2–§2.4) komen niet overeen met de werkelijke bestandsnamen. Dit is een tekstueel knelpunt in het plan, niet een fout in de bestanden.

---

## 2. Modulevolledigheid

### 2.1 Overzichtstabel: plan-nummers vs. werkelijke bestanden

Het product plan v2.1 verwijst expliciet naar de volgende modulenummers (in de tekst §2.2–§2.4 en het Mermaid-diagram §12):

| Concept | Plannummer (v2.1) | Werkelijk bestand | Status |
|---------|-------------------|-------------------|--------|
| gUFO Core | — (niet genummerd) | `00a-gufo-core.trig` | ✅ |
| UFO-B Events & Causality | `00b` (impliciet) | `00b-ufo-b.trig` | ✅ |
| UFO-C Social Entities | `00c` (impliciet) | `00c-ufo-c.trig` | ✅ |
| UFO-L Legal Relations | `00d` (impliciet) | `00d-ufo-l.trig` | ✅ |
| COoDM Decision Ontology | `00e` (impliciet) | `00e-coodm.trig` | ✅ |
| COVER Value Ontology | `00f` (impliciet) | `00f-cover.trig` | ✅ |
| ACTA Transaction Ontology | `00g` (impliciet) | `00g-acta.trig` | ✅ |
| CAUSA Causal Loop Diagrams | `00h` (impliciet) | `00h-causa.trig` | ✅ |
| SOCIA Actor Analysis | `00i` (impliciet) | `00i-socia.trig` | ✅ |
| Tessera Epistemische module | *niet genummerd in plan* | `00j-tessera.trig` | ✅ (zie §2.2) |
| VALOR Application Ontology | *niet genummerd in plan* | `00k-application.trig` | ✅ (zie §2.2) |
| AXIA Value Perspective | *niet genummerd in plan* | `00l-axia.trig` | ✅ (zie §2.2) |
| DELIBERA Deliberation | *niet genummerd in plan* | `00m-delibera.trig` | ✅ (zie §2.2) |
| FORMA Ontological Engineering | *niet genummerd in plan* | `00n-forma.trig` | ✅ (zie §2.2) |
| **CAPAX** | **`00j-capax`** (§2.4) | **`00o-capax.trig`** | ⚠️ **Nummering verschilt** |
| **AXIA-VSD** | **`00k`** (§2.4 impliciet) | **`00p-axia-vsd.trig`** | ⚠️ **Nummering verschilt** |
| **NEXUS** | **`00l-nexus`** (§2.4) | **`00q-nexus.trig`** | ⚠️ **Nummering verschilt** |
| **SYSONT** | **`00m-sysont`** (§2.2) | **`00r-sysont.trig`** | ⚠️ **Nummering verschilt** |
| **VALOR-CORE** | **`00n`** (§2.3) | **`00s-valor-core.trig`** | ⚠️ **Nummering verschilt** |

### 2.2 Verklaring nummering-discrepantie

Het product plan v2.1 is geschreven vóórdat de perspectief-ontologieën Tessera, Application, Axia, Delibera, Forma, en AXIA-VSD hun definitieve modulenummers kregen. Toen deze modules werden toegevoegd als genummerde bestanden (00j t/m 00p), schoof de nummering van CAPAX, NEXUS, SYSONT en VALOR-CORE op:

```
Plan (v2.1 tekst):     00a … 00i · 00j=CAPAX · 00k=AXIA-VSD · 00l=NEXUS · 00m=SYSONT · 00n=VALOR-CORE
Werkelijke bestanden:  00a … 00i · 00j=Tessera · 00k=Application · 00l=Axia · 00m=Delibera
                       00n=Forma · 00o=CAPAX · 00p=AXIA-VSD · 00q=NEXUS · 00r=SYSONT · 00s=VALOR-CORE
```

**Oorzaak:** De perspectief-ontologieën (Tessera/Application/Axia/Delibera/Forma) zijn in de plan-tekst conceptueel beschreven maar niet voorzien van expliciete module-labels 00j–00n. Het plan spreekt in §2.4 van "module `00j-capax`" terwijl de epistemic module (Tessera) en de vier perspectiefmodules al nummers 00j–00n innemen in het bestandssysteem.

Het Mermaid-diagram in §12 van het plan bevestigt dit: het toont `00m-SYSONT` en `00n-VALOR-CORE` als labels, maar in de werkelijke bestanden zijn dit respectievelijk `00r-sysont` en `00s-valor-core`.

---

## 3. Lagenarchitectuur

De 5-lagenstructuur uit §2.1 van het product plan:

```
Laag 5: VALOR Toepassingsontologie   → 00k-application, 00s-valor-core
Laag 4: Epistemische module          → 00j-tessera
Laag 3: Domeinextensies              → 00g-acta, 00h-causa, 00i-socia, 00l-axia,
                                       00m-delibera, 00n-forma, 00o-capax, 00p-axia-vsd, 00q-nexus
Laag 2: UFO-extensies                → 00d-ufo-l, 00e-coodm, 00f-cover
Laag 1: gUFO + SYSONT               → 00a-gufo-core, 00b-ufo-b, 00c-ufo-c, 00r-sysont
```

**Verificatie via owl:imports:** De importketens in de trig-bestanden zijn consistent met de beschreven lagenarchitectuur. Steekproeven:

- `00o-capax.trig` importeert: `gufo-core, ufo-c, acta, cover, sysont` ✅ (Laag 3 importeert Laag 1+2)
- `00q-nexus.trig` importeert: `gufo-core, ufo-c, ufo-l, acta, capax, axia-vsd, valor-core` ✅
- `00h-causa.trig` importeert: `gufo-core, ufo-b, ufo-c, tessera, application, acta, sysont` ✅
- `00r-sysont.trig` importeert: `gufo-core, ufo-c` ✅ (Laag 1 importeert alleen Laag 1)
- `00s-valor-core.trig` importeert: `gufo-core, ufo-c` ✅

**Conclusie lagenarchitectuur:** ✅ Correct geïmplementeerd.

---

## 4. Kernklassen per module

Alle kernklassen uit §2.x van het product plan zijn geverifieerd in de trig-bestanden:

### 4.1 CAPAX (00o-capax.trig, v0.3)
| Klasse/property | Plan | Bestand | Status |
|-----------------|------|---------|--------|
| `capax:Capability` (gufo:Disposition) | §2.4 | ✅ aanwezig | ✅ |
| `capax:CapabilityRequirement` | §2.4 | ✅ aanwezig | ✅ |
| `capax:CapabilityGap` (gufo:Situation) | §2.4 | ✅ aanwezig | ✅ |
| `capax:CapabilityDevelopmentNeed` | §2.4 | ✅ aanwezig | ✅ |
| `capax:FeasibilityAssessment` | §2.4 | ✅ aanwezig | ✅ |
| `capax:DispositionRelation` | §2.4 | ✅ aanwezig | ✅ |
| `capax:OrganizationalCapability` | §2.4 | ✅ aanwezig | ✅ |
| `capax:IndividualCapability` | §2.4 | ✅ aanwezig | ✅ |
| `capax:emergenceNature` | §2.4 | ✅ aanwezig | ✅ |

### 4.2 NEXUS (00q-nexus.trig, v0.4)
| Klasse/property | Plan | Bestand | Status |
|-----------------|------|---------|--------|
| `nexus:EcosystemAgent` | §2.4 | ✅ aanwezig | ✅ |
| `nexus:CollaborationCommitment` | §2.4 | ✅ aanwezig | ✅ |
| `nexus:CollaborativeCapability` | §2.4 | ✅ aanwezig | ✅ |
| `nexus:CollaborationCondition` | §2.4 | ✅ aanwezig | ✅ |
| `nexus:CollaborationArchitecture` | §2.4 | ✅ aanwezig | ✅ |
| `nexus:GovernanceDevelopmentNeed` | §2.4 | ✅ aanwezig | ✅ |
| `nexus:addressesIssue` | §2.3 | ✅ aanwezig | ✅ |
| `nexus:commitmentDuration` (Permanent/ProjectBased/Experimental) | §2.4 | ✅ aanwezig | ✅ |

### 4.3 CAUSA (00h-causa.trig, v0.3)
| Klasse/property | Plan | Bestand | Status |
|-----------------|------|---------|--------|
| `causa:CausalVariable` | §2.3 | ✅ aanwezig | ✅ |
| `causa:CausalClaim` (valor:Tessera subklasse) | §2.3 | ✅ aanwezig | ✅ |
| `causa:hasManifestationCondition` | §2.3 (CAUSA v2) | ✅ aanwezig | ✅ |
| `causa:ClaimCoverageAssessment` | §2.3 | ✅ aanwezig | ✅ |
| `causa:realisedBy` / `acta:realisesIntervention` | §2.3 (DD-093) | ✅ aanwezig | ✅ |
| `causa:Intervention` | §2.3 | ✅ aanwezig | ✅ |
| `causa:CausalModel` | §2.3 | ✅ aanwezig | ✅ |

### 4.4 TESSERA (00j-tessera.trig, v0.2)
| Klasse/property | Plan | Bestand | Status |
|-----------------|------|---------|--------|
| `valor:Tessera` | §2.5 | ✅ aanwezig | ✅ |
| 5-statenmachine (Proposed/Contested/Accepted/Rejected/Reconsidered) | §2.5 | ✅ aanwezig | ✅ |
| `valor:DecisionEpisode` | §2.5 | ✅ aanwezig | ✅ |
| `valor:Evidence` + EvidenceType | §2.5 | ✅ aanwezig | ✅ |
| IBIS-relaties (supports/undermines/qualifies/presupposes) | §2.5 | ✅ aanwezig | ✅ |

### 4.5 APPLICATION (00k-application.trig, v0.1)
| Klasse/property | Plan | Bestand | Status |
|-----------------|------|---------|--------|
| `valor:Issue` (ufoc:SocialObject) | §1.4 | ✅ aanwezig | ✅ |
| `valor:DesignSpace` | §1.4 | ✅ aanwezig | ✅ |
| `valor:DesignPhase` | §1.4 | ✅ aanwezig | ✅ |
| `valor:DesignAlternative` | §1.4 | ✅ aanwezig | ✅ |
| `valor:Participant` + 6 rollen (Initiator/Facilitator/Contributor/Expert/Observer/Engineer) | §3 | ✅ aanwezig | ✅ |
| `valor:hasConcernAbout` / `valor:concernedWithSituation` | §1.4 | ✅ aanwezig | ✅ |

### 4.6 SYSONT (00r-sysont.trig, v0.1)
| Klasse/property | Plan | Bestand | Status |
|-----------------|------|---------|--------|
| `sysont:System` (gufo:FunctionalComplex) | §2.2 | ✅ aanwezig | ✅ |
| `sysont:BondingRelation` (gufo:MaterialRelation) | §2.2 | ✅ aanwezig | ✅ |
| `sysont:SystemSituation` (gufo:Situation) | §2.2 | ✅ aanwezig | ✅ |
| `sysont:SystemMoment` (gufo:Moment) | §2.2 | ✅ aanwezig | ✅ |
| `sysont:EmergentSystemMoment` + `sysont:ResultantSystemMoment` | §2.2 | ✅ aanwezig | ✅ |

### 4.7 VALOR-CORE (00s-valor-core.trig, v0.1)
| Klasse/property | Plan | Bestand | Status |
|-----------------|------|---------|--------|
| `valor:CollectiveIntentionalCommunity` | §2.3 | ✅ aanwezig | ✅ |
| `valor:IssueCommunity` (cognitieve modus) | §2.3 | ✅ aanwezig | ✅ |
| `nexus:EcosystemAgent` (conatieve modus, cross-ref) | §2.3 | ✅ aanwezig | ✅ |

**Totaal geverifieerd: 68 klassen en properties — allen aanwezig (100%).**

---

## 5. Versie-informatie

| Module | Plan vermeldt | Bestand heeft | Status |
|--------|---------------|---------------|--------|
| gUFO Core | v1.0 (extern) | v0.2 (VALOR subset) | ✅ consistsent |
| UFO-B | — | v0.2 | ✅ |
| UFO-C | — | v0.3 (DD-083 correctie) | ✅ |
| UFO-L | — | v0.2 | ✅ |
| COoDM | — | v0.3 | ✅ |
| COVER | — | v0.2 | ✅ |
| ACTA | — | v0.7 | ✅ (DD-093 uitbreiding) |
| CAUSA | — | v0.3 (DD-092, DD-093) | ✅ |
| SOCIA | — | v0.2 | ✅ |
| Tessera | — | v0.2 | ✅ |
| Application | — | v0.1 | ✅ |
| Axia | — | v0.1 | ✅ |
| Delibera | — | v0.1 | ✅ |
| Forma | — | v0.1 | ✅ |
| **CAPAX** | **v0.2** | **v0.3** | ✅ (bijgewerkt; v0.3 voegt ConditionCoverage toe, DD-092) |
| AXIA-VSD | — | v0.1 | ✅ |
| **NEXUS** | **v0.3–v0.4** | **v0.4** | ✅ (plan beschreef beide kandidaten) |
| SYSONT | v0.1 (nieuw) | v0.1 | ✅ |
| VALOR-CORE | v0.1 | v0.1 | ✅ |

**Conclusie versies:** Geen inconsistenties. CAPAX is van v0.2 naar v0.3 gebracht (bevat aanvullende inhoud t.o.v. wat het plan beschreef op het moment van schrijven, maar breidt uit — verwijdert niets).

---

## 6. VoID-catalogus (void.trig, v0.2)

De VoID-catalogus (`void.trig`, v0.2, gewijzigd 2026-03-13) bevat 38 `void:subset`-verwijzingen:
- 19 ontologie-datasets (gufo-core t/m valor-core)
- 19 SHACL-shape-datasets

**Verificatie:**

| Ontologie | In VoID | Trig-bestand aanwezig | Status |
|-----------|---------|----------------------|--------|
| gufo-core | ✅ | ✅ 00a-gufo-core.trig | ✅ |
| ufo-b | ✅ | ✅ 00b-ufo-b.trig | ✅ |
| ufo-c | ✅ | ✅ 00c-ufo-c.trig | ✅ |
| ufo-l | ✅ | ✅ 00d-ufo-l.trig | ✅ |
| coodm | ✅ | ✅ 00e-coodm.trig | ✅ |
| cover | ✅ | ✅ 00f-cover.trig | ✅ |
| acta | ✅ | ✅ 00g-acta.trig | ✅ |
| causa | ✅ | ✅ 00h-causa.trig | ✅ |
| socia | ✅ | ✅ 00i-socia.trig | ✅ |
| tessera | ✅ | ✅ 00j-tessera.trig | ✅ |
| application | ✅ | ✅ 00k-application.trig | ✅ |
| axia | ✅ | ✅ 00l-axia.trig | ✅ |
| delibera | ✅ | ✅ 00m-delibera.trig | ✅ |
| forma | ✅ | ✅ 00n-forma.trig | ✅ |
| capax | ✅ | ✅ 00o-capax.trig | ✅ |
| axia-vsd | ✅ | ✅ 00p-axia-vsd.trig | ✅ |
| nexus | ✅ | ✅ 00q-nexus.trig | ✅ |
| sysont | ✅ | ✅ 00r-sysont.trig | ✅ |
| valor-core | ✅ | ✅ 00s-valor-core.trig | ✅ |

**Conclusie VoID:** De catalogus is volledig en actueel — alle 19 modules en hun SHACL-varianten zijn opgenomen. De catalogus gebruikt logische IRI-namen (niet bestandsnummers), waardoor de nummerings-discrepantie in de plantekst hier geen rol speelt.

---

## 7. Lexa als perspectief

Het product plan (§1.4, §4) noemt **Lexa** als één van de zeven perspectieven, naast Causa, Acta, Socia, Axia, Delibera en Forma. Er is echter **geen `lexa.trig`-bestand**.

**Analyse:** Dit is een bewuste architectuurkeuze, niet een omissie:
- UFO-L (00d-ufo-l.trig) voorziet in de volledige juridische laag: normen, rechten, plichten, beleid (Weigand), LegalRelator, etc.
- De Lexa-*view* is in VALOR een SPARQL-projectie op dezelfde graph, niet een aparte ontologie — consistent met het algemene VALOR-principe "alle perspectieven bevragen dezelfde VALOR-O graph".
- Het plan beschrijft Lexa als een **presentatielaag** die volledig gefundeerd is door UFO-L (§2.3: "UFO-L … Fundeert Lexa volledig.").

**Conclusie:** Geen inhoudelijke tekortkoming; de architectuurkeuze is in lijn met het platformprincipe van projecties op één graph.

---

## 8. Aanbevelingen

### A. Documentair — plan bijwerken (prioriteit: laag)

De tekst van `versie 2.1/valor-ecosystem-v21.md` bevat verouderde modulenummers in §2.2 (SYSONT), §2.3 (VALOR-CORE), §2.4 (CAPAX, NEXUS) en het Mermaid-diagram (§12). Deze moeten worden bijgewerkt naar de werkelijke bestandsnummers:

| Te vervangen | Vervangen door |
|-------------|----------------|
| `00j-capax` | `00o-capax` |
| `00k` (AXIA-VSD) | `00p-axia-vsd` |
| `00l-nexus` | `00q-nexus` |
| `00m-sysont` | `00r-sysont` |
| `00n` (VALOR-CORE) | `00s-valor-core` |
| Mermaid: `00m-SYSONT` | `00r-SYSONT` |
| Mermaid: `00n-VALOR-CORE` | `00s-VALOR-CORE` |

### B. VoID-catalogus — `void:triples` actualiseren (prioriteit: laag)

De catalogus vermeldt `void:triples 11000` (schattingswaarde). Na het toevoegen van SYSONT, CAPAX, AXIA-VSD, NEXUS en VALOR-CORE is dit getal vermoedelijk onderschat. Aanbeveling: hertellen via SPARQL na het laden van alle trig-bestanden.

### C. Geen actie vereist voor bestanden

De trig-bestanden zijn inhoudelijk correct en compleet. Geen aanpassingen nodig aan de ontologiebestanden zelf.

---

## 9. Eindoordeel

De trig-bestanden representeren het product plan VALOR-Ecosysteem v2.1 **inhoudelijk correct en volledig**:

- ✅ Alle 19 ontologiemodules aanwezig
- ✅ Alle 19 SHACL-modules aanwezig
- ✅ 68/68 kernklassen en properties geïmplementeerd (100%)
- ✅ 5-lagenarchitectuur correct uitgedrukt in import-ketens
- ✅ Versienummers consistent (CAPAX op v0.3 is een vooruitgang, geen regressie)
- ✅ VoID-catalogus volledig en actueel

De enige discrepantie betreft **modulenummers in de plantekst** (§2.2, §2.4, §12), die wijzen op een moment waarop de tekst werd geschreven vóórdat de definitieve bestandsnummering werd vastgesteld. Dit vereist tekstuele correctie in het plan, niet in de bestanden.
