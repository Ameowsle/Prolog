# Durchgeh-Checkliste pro Problem

Ein Ordner nach dem anderen. Pro Ordner zuerst Teil A (Loesungsreview, das
Inhaltliche), dann Teil B (Hygiene und Mechanik), danach in der Tabelle abhaken.
Die ausfuehrliche Begruendung der Kriterien steht in CLEANING_CHECKLIST.md.

---

## Logik-Befunde aus dem Referenzvergleich (zuerst lesen)

Sinn des Referenzvergleichs ist NICHT nur, Counts kreuzzupruefen, sondern zu
entscheiden, ob der eigene Ansatz tragfaehig oder schlecht ist. Wo er schlecht
ist, soll die LOGIK geaendert werden, nicht nur der Kommentar.

Wichtig: Ein anderer Ansatz als die Referenz ist ausdruecklich erlaubt, solange
er korrekt ist und Sinn ergibt. Die Referenz ist Plausibilitaetscheck und
Anregung, keine Vorlage zum Nachbauen. Die eigene Logik soll NUR geaendert werden,
wenn sie nachweislich falsch oder klar schlecht ist (z. B. verstecktes
generate-and-test statt Propagation), nicht schon, weil sie anders ist als die
Referenz. Eine eigenstaendige, gut begruendete Modellierung ist ein Vorzug, kein
Mangel. Im Zweifel den eigenen Ansatz behalten und die Abweichung begruenden.

Bei Unklarheiten soll der Agent die Referenzen in reference/NNN/ (und
REFERENCE_COMPARISON.md) noch einmal anschauen, statt zu raten.

Stand: Der Referenzvergleich ist bereits gemacht und in REFERENCE_COMPARISON.md
pro Problem dokumentiert (C3 Count-Abgleich wo lauffaehig, C4 Strukturvergleich,
Performance). Was bisher fehlt: aus diesen Urteilen die noetigen Logikaenderungen
auch umzusetzen. Bisher wurden an den .pl-Dateien nur Kommentare und Whitespace
angefasst, keine Logik (ausser dem bereits committeten 006-Fix gegen doppelte
Loesungen).

Vorgehen pro Problem mit Logikbedarf:
- [ ] Den betreffenden Abschnitt in REFERENCE_COMPARISON.md zuerst selbst
      reproduzieren (Smoke-Test, Count nachmessen). Die Urteile stammen vom
      vorherigen Durchgang und sind bisher nur fuer 006 unabhaengig nachgemessen.
      Nicht auf eine unbelegte Behauptung hin umschreiben.
- [ ] Vor dem Aendern dem Nutzer zeigen, was geaendert werden soll und warum
      (vorgeschlagene Aenderung plus Begruendung), und auf Freigabe warten. Nicht
      ungefragt die Logik umschreiben.
- [ ] Pro Problem festhalten, was geaendert wurde (oder bewusst nicht): kurze
      Notiz je Problem unten unter "Logik-Aenderungsprotokoll", damit
      nachvollziehbar bleibt, welche Logik angefasst wurde und welche absichtlich
      blieb.

### Urteil pro Problem (aus REFERENCE_COMPARISON.md)

| Problem | Urteil ueber den Ansatz | Logik aendern? |
|---|---|---|
| 006 Golomb | deckungsgleich mit allen vier Referenzen | nein (optional first_fail) |
| 007 All-Interval | all_distinct-Modell staerker als die schwachen mzn-Varianten | nein |
| 012 Nonogram (CLP) | CLP ist reines generate-and-test: labelt alle 0/1-Belegungen und testet danach (ca. 1,07 Mrd. Inferenzen, 25 s). Referenzen nutzen regular/Automat mit Propagation. Verletzt A2 (versteckter generate-and-test) | JA, ernsthafter Kandidat |
| 015 Schur | eigene Loesung korrekter als die Referenz schur.mzn (die x=y ignoriert) | nein, sogar besser |
| 019 Magic | CLP nutzt global_cardinality wie die beste mzn; Backtracking unpraktikabel (didaktisch) | nein (BT ist Varianten-Entscheid) |
| 024 Langford | BT skaliert besser als CLP, Modell in Ordnung | nein |
| 028 BIBD | CLP zaehlt 1, BT zaehlt 151200 (verschiedene Aequivalenzklassen). Kein Bug, aber muss im README erklaert werden. Referenz jetzt vorhanden (reference/028/bibd.mzn), CLP deckungsgleich (1/1/24) | nein, aber dokumentieren |
| 049 Partitioning | CLP nah an SICStus, BT schneller | nein |
| 054 N-Queens | CLP modellgleich mit den staerksten Referenzen | nein (Naive ist Varianten-Entscheid) |
| 057 Killer Sudoku | eigene Cage-Modellierung vollstaendiger als die mzn (explizites all_different je Cage) | nein (sechs Varianten = Entscheid) |
| 067 Quasigroup | Instanz im Solver verdrahtet (quasigroup(Sol) :- partial(Sol)), A3-Antimuster; Referenz jetzt vorhanden, CLP == mzn (42 auf gleicher Instanz); CLP-Datei nutzt aber andere Instanz als BT-Dateien (README-Perf inkonsistent) | JA, Refactor auf Instanz-als-Argument |
| 076 Costas | Modell deckungsgleich mit der Referenz, BT schneller | nein |

### Konkrete Aufgaben, die aus dem Vergleich folgen

1. [ ] 012 Nonogram CLP: reproduzieren (alle drei .pl smoke-testen, CLP-Inferenzen
       messen). Wenn bestaetigt reines generate-and-test, eine propagierende
       CLP-Variante bauen (clpfd-Constraints, die die Block-Clues waehrend der
       Suche propagieren, statt erst nach label/1 zu testen), oder, falls das zu
       weit fuehrt, im README klar als nicht-idiomatische Variante einordnen und
       die effiziente Variante (RowByRow) als Hauptloesung fuehren.
2. [ ] 067 Quasigroup: Solver auf Instanz-als-Argument umstellen
       (quasigroup(Puzzle, Solution) statt quasigroup(Solution) :- partial(...)),
       sodass dieselbe Relation jede Instanz loest. Referenz erledigt:
       reference/067/ enthaelt zwei QCP-mzn, Count-Abgleich gemacht (CLP,
       perCell, perCell+DC == 42 auf gemeinsamer Instanz, REFERENCE_COMPARISON.md).
       Nebenbefund: die CLP-Datei nutzt eine andere Instanz als die BT-Dateien,
       die README-Performance-Tabelle ist dadurch instanz-inkonsistent und sollte
       auf eine gemeinsame Instanz gestellt werden.
3. [ ] 028 BIBD: im README die Zaehldifferenz CLP (1, kanonisch per lex_chain) vs
       BT (151200, zeilengeordnete Inzidenzmatrizen) ausdruecklich erklaeren,
       damit die Counts nicht widerspruechlich wirken. BIBD-Referenz erledigt:
       reference/028/bibd.mzn abgeglichen, CLP deckungsgleich (1/1/24, gleicher
       lex-Symmetriebruch), BT-Count 151200 gegen symmetriefreie mzn-Kopie
       bestaetigt (REFERENCE_COMPARISON.md).
4. [ ] Querschnitt (optional, keine Korrektheitsfrage): CLP-Solver nutzen meist
       label/1 ohne first_fail. Eine ff-Heuristik beschleunigt das Aufzaehlen
       teils deutlich. Nur aendern, wenn es die Loesungsreihenfolge nicht stoert
       und gemessen etwas bringt; sonst bewusst so lassen und nicht als Mangel
       behandeln.
5. [ ] Varianten-Entscheide (kein Logikproblem, nur welche Dateien bleiben):
       012, 019, 054, 057, 067. Siehe Teil B Punkt 2 und die Notizen in der
       Fortschrittstabelle.

### Logik-Aenderungsprotokoll

Pro Problem eine Zeile, sobald an der Logik etwas geaendert wurde oder bewusst
nichts geaendert wird. Knapp halten: was, warum, oder warum absichtlich gelassen.

| Problem | Logik geaendert? | Was und warum (oder warum nicht) |
|---|---|---|
| 006 Golomb | ja (committed) | doppelte Loesungen gefixt (ueberlappende pairwise_diffs([_],[])-Klausel entfernt); sonst Ansatz korrekt, belassen |
| 007 All-Interval | nein | Ansatz korrekt und tragfaehig (all_distinct auf Werten und auf Diffs). Counts selbst nachgemessen: n=8..12 = 40/120/296/648/1328 (OEIS A006323), CLP == BT, und extern gegen all_interval4.mzn (kein Symmetriebruch, gecode) bestaetigt (n=8/10/12 = 40/296/1328). Nur Hygiene: Mode-Kommentare, expliziter library(lists)-Import im BT, README auf ASCII gebracht. Bewusst kein Symmetriebruch (aufgabentreu, volle Loesungsmenge) |
| 012 Nonogram |  |  |
| 015 Schur |  |  |
| 019 Magic |  |  |
| 024 Langford | nein | Modell korrekt und idiomatisch (CLP: element/3 + all_distinct; BT: groesste Zahl zuerst, frueher Fail via nth1). Counts selbst nachgemessen (n=3,4,7,8 -> 2,2,52,300, Randfaelle 0), extern per langford2_nosym.mzn/Gecode bestaetigt (k=3,4,7 -> 2,2,52 = 2x OEIS A014552). BT skaliert besser, kein Symmetriebruch (aufgabentreu). Nur Hygiene: README Non-ASCII (Haken, Ellipse) entfernt, zwei ,%-Kommentare mit Leerzeichen |
| 030 BIBD |  |  |
| 049 Partitioning | nein | CLP nutzt echte clpfd-Constraints (sum/3, zweimal scalar_product/4) mit Propagation vor label/1, kein generate-and-test; BT prunt frueh bei Summen-/Quadratsummen-/Groessen-Ueberschuss. Counts 1/1/7/24/296 (N=8,12,16,20,24) selbst nachgemessen, CLP==BT, Anker 296 fuer N=24; Negativtests N=2,4,6,7 false. Korrekt und idiomatisch, belassen. Nur README-Hygiene: Non-ASCII (Pfeil, Haken) im Beispiel raus, Performance-Tabelle ergaenzt |
| 054 N-Queens |  |  |
| 057 Killer Sudoku |  |  |
| 067 Quasigroup |  |  |
| 076 Costas | nein | Modell korrekt und idiomatisch (CLP: all_distinct je Ebene des Differenzdreiecks via level_diffs/3 vor label/1, kein generate-and-test; BT: inkrementeller per-Ebene-Bucket-Check \+ memberchk vor der Rekursion, frueher Fail). Counts selbst nachgemessen n=3..9 -> 4,12,40,116,200,444,760 = OEIS A008404, CLP==BT. Extern per reference/076/costas_count.mzn (MiniZinc/Gecode, symmetriefrei) n=3..7 -> 4,12,40,116,200 bestaetigt. Nur Hygiene: README an die 006-Vorlage angeglichen (Titel # Problem 076, Problem Constraints, Approaches, Performance frisch nachgemessen, How to Run), Non-ASCII O(n^2)-Superskript entfernt, Mode-Kommentare ergaenzt |

---

## Teil A: Loesungsreview (zuerst, das Wichtigste)

In Prioritaetsreihenfolge. A1 ist das wichtigste Kriterium ueberhaupt.

### A1. Erfuellt die Loesung die Problemanforderung? (!!!)

- [ ] Die CSPLib-Problembeschreibung lesen und jede einzelne Anforderung als
      Liste herausschreiben (alle Constraints, nicht nur die offensichtlichen).
- [ ] Fuer jede Anforderung im Code die Stelle zeigen, die sie durchsetzt.
      Bleibt eine Anforderung ohne Code-Stelle, fehlt sie.
- [ ] Keine zusaetzliche oder falsche Einschraenkung, die das Problem
      verfaelscht (z. B. ungewollt nur Spezialfaelle loest).
- [ ] Positivtest: eine erzeugte Loesung von Hand gegen alle Constraints
      pruefen, nicht nur dem Solver glauben.
- [ ] Negativtest: eine bekannt unloesbare Instanz muss fehlschlagen
      (keine falschen Positiven). Beispiel Schur: `schur(14,3,_)` muss `false`.
- [ ] Vollstaendigkeit, falls relevant: findet die Loesung alle Loesungen bzw.
      die korrekte Anzahl? Keine fehlenden, keine doppelten (Symmetrie pruefen).
- [ ] Randfaelle: kleinstes N, N ohne Loesung, triviale Parameter.
- [ ] Stimmt die behauptete Performance-Tabelle? Zahlen frisch nachmessen.
- [ ] Kreuzpruefung gegen eine unabhaengige Referenz: stimmen Loesung bzw.
      Loesungs-Anzahl ueberein? Reihenfolge der Quellen:
      1. eigene CLP- und Backtracking-Variante liefern dasselbe Ergebnis;
      2. bekannte CSPLib-Ergebnisse (z. B. Solution-Counts);
      3. heruntergeladene Fremdloesungen (MiniZinc, ECLiPSe, ... nur zur
         Korrektheit, nicht als Stilvorlage). Diese in einen getrennten,
         per `.gitignore` ausgeschlossenen Ordner (z. B. `reference/`), damit
         sie nicht mit den eigenen nummerierten Loesungen vermischt werden.

### A2. Ergibt die Loesung Sinn fuer Prolog? (idiomatisch)

- [ ] Nutzt Unifikation, Rekursion und Backtracking natuerlich, statt
      imperative Muster (Zaehlschleifen, Flags) nachzubauen.
- [ ] CLP-Variante: echte `clpfd`-Constraints plus `label`/`labeling`, nicht
      verstecktes generate-and-test.
- [ ] Backtracking-Variante: prunt frueh (constrain-then-generate), nicht erst
      am Ende eine fertige Belegung testen.
- [ ] Verwendet Bibliothekspraedikate (`maplist`, `findall`, `nth1`,
      `transpose`, `sum`, ...) statt sie von Hand nachzubauen.
- [ ] Keine unnoetigen Cuts; vorhandene Cuts sind begruendet (moeglichst gruen).
- [ ] Determinismus: keine uebrig gebliebenen Choice-Points, wo das Ergebnis
      eindeutig sein soll.
- [ ] Relationale, aussagekraeftige Praedikatnamen; saubere Modes.

### A3. Ergeben die Methoden und die Aufteilung Sinn?

- [ ] Jedes Praedikat hat eine klare, einzelne Aufgabe (eine Verantwortung).
- [ ] Hilfspraedikate sind sinnvoll benannt und auf der richtigen Granularitaet,
      kein Riesenpraedikat, das alles macht.
- [ ] Keine Ueberzerstueckelung in triviale Einzeiler, die das Lesen erschweren.
- [ ] CLP- und Backtracking-Variante modellieren dasselbe Problem erkennbar
      gleich (gleiche Begriffe, gleiche Zerlegung), nur mit anderer Strategie.
- [ ] Instanz als Argument, nicht im Solver verdrahtet. Die konkrete Instanz
      (Sudoku-Matrix, Cages, Zeilen/Spalten-Constraints, ...) bleibt als Fakt
      im File, aber der Solver bekommt sie als Eingabe-Parameter, statt den Fakt
      selbst aufzurufen. So loest dieselbe Relation jede Instanz.
      - falsch: `sudoku(Solution) :- puzzle(Solution), ...`
        Aufruf `?- sudoku(S).` loest nur das eine Puzzle.
      - richtig: `sudoku(Puzzle, Solution) :- Solution = Puzzle, ...`
        Aufruf `?- puzzle(P), sudoku(P, S).` loest jede Instanz.
      - betrifft: Sudoku, 057 Killer Sudoku (Puzzle + Cages), 067 Quasigroup,
        012 Nonogram (Zeilen + Spalten). Die parametrischen Probleme (006, 007,
        028, 049, 076, ...) machen es schon richtig.

### A4. Ist die Loesung nicht zu komplex?

- [ ] Liesse sich dasselbe einfacher (weniger Praedikate, weniger Code)
      ausdruecken, ohne Klarheit oder Geschwindigkeit zu verlieren?
- [ ] Kein toter Code, keine ungenutzten Praedikate oder Variablen, keine
      redundanten Constraints.
- [ ] Keine vorzeitige Optimierung, die das Modell verschleiert. Zusaetzliche
      Komplexitaet muss sich lohnen und das messbar (Beispiel: `lex_chain` in
      028 ist schneller, also gerechtfertigt; ohne Messung raus).

---

## Teil B: Hygiene und Mechanik

1. [ ] Dateinamen: Schema `NNNProblemNameApproach.pl`, kein `:`, keine Tippfehler.
2. [ ] Varianten: kein `backup/`. Eine Variante entweder als vollwertige Datei
       im Root behalten (wenn sie im README vorgefuehrt oder verglichen wird)
       oder loeschen (und aus dem README entfernen), nichts dazwischen parken.
       Einzel-Ansatz-Probleme: genau ein bestes CLP und ein bestes Backtracking.
       Mehr-Ansatz-Probleme (012, 054, 057, 067) duerfen mehrere zeigen, solange
       jede Datei im README steht. Sind zwei gleichwertig und verschieden,
       nachfragen.
3. [ ] Code je behaltener `.pl`:
       - Bibliotheken oben mit `:- use_module(library(...)).`
       - Mode-Deklaration vor nicht-trivialen Praedikaten
       - dichte `%`-Kommentare, die das Warum erklaeren
       - Englisch, keine Tippfehler, keine grammatikfehler, konsistente sprache.
       - kommentare sollten der language des problems entspreichen
4. [ ] Hygiene: keine em/en-Dashes, keine Emojis, kein trailing whitespace,
       finale Newline.
5. [ ] README an Vorlage: CSPLib-URL oben, Problembeschreibung,
       `## Problem Constraints`, `## Approaches` (ein `###`-Abschnitt pro Ansatz),
       optionale `## Performance Comparison`-Tabelle, `## How to Run`.
       Titel im Format `# Problem NNN: Name`.
6. [ ] Smoke-Test: jede behaltene `.pl` laedt ohne Warnung
       (`swipl -g halt -t 'halt(1)' datei.pl`) und der Haupt-Query liefert eine
       Loesung. Inferences bei Bedarf via `time/1` fuer die Performance-Tabelle.
7. [ ] Commit pro Problem, gezielt per Pathspec, ohne AI-Nennung:
       `git commit -m "NNN: ..." -- pfad1 pfad2`, danach `git push`.

---

## Teil C: Referenzloesung waehlen und nutzen

Zweck: Korrektheit kreuzpruefen und das eigene Modell gegenchecken. Nicht zum
Kopieren. Hoechstens ein bis zwei Referenzen pro Problem.

**Pflicht, nicht optional.** Teil C gilt nur als erledigt, wenn mindestens eine
echte externe Referenz tatsaechlich angeschaut wurde, inhaltlich UND strukturell:

- Quelle 1 der Prioritaetsliste (eigene CLP- und Backtracking-Variante liefern
  dasselbe) zaehlt NICHT als Referenzabgleich. Das ist nur ein interner
  Konsistenztest. Ein selbst geschriebener Validator ebenfalls nicht.
- Mindestens eine externe Referenz (SICStus, ECLiPSe, B-Prolog, MiniZinc, ...)
  nach `reference/NNN/` holen und laufen lassen. Laeuft sie nicht, die im
  Modell oder Kommentar dokumentierten erwarteten Ergebnisse (Count, Optimum)
  als externen Anker nehmen.
- Ergebnis in der Notiz-Spalte festhalten: welche Referenz, lief sie ja/nein,
  welcher Count bzw. welches Optimum, stimmt es ueberein. Ohne diesen Eintrag
  gilt Teil C als nicht erledigt, auch wenn der Rest fertig ist.
- Nicht behaupten, der Abgleich sei gemacht, wenn nur Quelle 1 lief. Lieber
  offen `[ ]` lassen und als offenen Punkt notieren.

### C1. Welche herunterladen (Prioritaet von oben)

1. [ ] SWI-Prolog, falls vorhanden: laeuft direkt, beste Referenz (selten).
2. [ ] SICStus Prolog (`*_sicstus.pl` / `.pl`): `clpfd` fast wie SWI, laeuft oft
       mit kleinen Anpassungen. Beste realistische Prolog-Referenz.
3. [ ] ECLiPSe (`.ecl`): Prolog + CLP(FD), gute Vergleichsbasis fuers CLP-Modell.
4. [ ] B-Prolog (`*_bp.pl`): Prolog, aber staerker abweichender Dialekt.
5. [ ] MiniZinc (`.mzn`): sauberstes deklaratives Modell, ideal fuer Modell- und
       Count-Abgleich.

Nur wenn nichts davon existiert, fuer den reinen Count-Abgleich (nicht als
Stilvorlage): Gecode/C++, or-tools/Python, oder was sonst da ist. Eine genuegt.
Ueberspringen: imperative und Nischen-DSLs (ASP/Gringo, Essence, EssencePrime,
JSR-331, OscaR, Comet, Numberjack, PyCSP3), ausser sie sind die einzige Quelle.

Lokal installiert und lauffaehig (Stand: jetzt): `swipl`, `minizinc`, `gprolog`
(GNU-Prolog mit clp(FD), Aufruf z. B. `gprolog --query-goal "..."`) und
`ortools` (Python CP-SAT, `from ortools.sat.python import cp_model`). Damit ist
fuer fast jedes Problem mindestens eine echt laufende externe Referenz moeglich:
`gprolog` fuer den Prolog+CLP-Abgleich, `ortools` oder `minizinc` fuer den
unabhaengigen Count-Abgleich. Nicht installiert (nur strukturell vergleichen):
SICStus (kommerziell), ECLiPSe, B-Prolog. Picat (B-Prolog-naher Dialekt) ist
per `brew install picat` nachruestbar, falls eine `*_bp.pl`-Referenz wichtig wird.

### C2. Wohin

- [ ] Ablage in `reference/NNN/`, per `.gitignore` ausgeschlossen. Nie in den
      eigenen Loesungsordner, nie als eigener Ansatz ins README.

### C3. Korrektheit pruefen

- [ ] Gleiche Instanz: liefert deine Loesung dieselbe konkrete Loesung (oder eine
      gueltige, falls mehrere existieren)?
- [ ] Anzahl: stimmt der Solution-Count ueberein? Das ist der staerkste Test.
- [ ] Zaehl-Semantik pruefen, bevor man Counts vergleicht: ein Count ist nur
      vergleichbar, wenn beide Modelle dasselbe zaehlen (gleiche Schranken,
      gleicher Symmetriebruch, gleiche Variablensicht). Haengt deine Zahl an
      einer eigenen Schrankenwahl (z. B. `0..N*N` bei Golomb), ist sie nur ein
      interner CLP-vs-BT-Test, kein externer Beleg. Dann eine extern
      dokumentierte Groesse als Anker nehmen (optimale Linealaenge, publizierter
      Count fuer eine Standard-Instanz, OEIS-Folge).
- [ ] Randfaelle und unloesbare Instanzen: beide schlagen fehl?
- [ ] Laeuft die Referenz nicht: nur die im Modell/Kommentar genannten erwarteten
      Ergebnisse bzw. Counts als Referenz nehmen.

### C4. Form vergleichen (Anregung, nicht uebernehmen)

- [ ] Wie uebergibt die Referenz die Instanz? Fast immer als Daten getrennt vom
      Modell, das bestaetigt die Argument-Konvention aus A3.
- [ ] Welche Sicht aufs Problem (z. B. Positionen vs Werte als Variablen)? Ist
      deine Sicht gleich gut oder besser begruendet?
- [ ] Welche globalen Constraints nutzt das CP-Modell (`all_different`,
      `global_cardinality`, `sum`, ...)? Hast du das idiomatische Pendant?
- [ ] Symmetriebruch vorhanden? Mit deinem vergleichen.
- [ ] Constraints, die der Referenz fehlen oder die bei dir redundant sind?
- [ ] Suchstrategie und Labeling: welche Variablen- und Werteordnung
      (`first_fail`, `min`/`max`, ...)? Beim Optimieren branch-and-bound oder
      iterative Schranke? Nutzt deine Variante etwas Vergleichbares oder
      bewusst etwas anderes?
- [ ] Datenstruktur: Listen vs Arrays/Matrizen, 0- vs 1-basierte Indizes. Passt
      deine Wahl zum idiomatischen Prolog oder hast du eine Array-Sicht
      nachgebaut, die Listen besser ausdruecken?
- [ ] Skalierung und grobe Effizienz: bis zu welcher Instanzgroesse loest die
      Referenz in welcher Zeit? Grobe Einordnung (Zeit, Backtracks, Inferences),
      nur als Plausibilitaet, kein exakter Cross-Solver-Benchmark.
- [ ] Erwartete Ergebnisse aus Referenz-Kommentaren mitnehmen (dokumentierte
      Counts, Optima, Beispielloesungen) als Ankerwerte fuer C3.
- [ ] Wichtig: imperativen Code nicht 1:1 uebersetzen. Prolog-Idiom bleibt
      Prolog-Idiom.

### C5. Fallback, wenn keine Prolog- oder CP-Referenz existiert

- [ ] Irgendeine vorhandene Loesung (Python etc.) NUR zum Count-Abgleich nehmen,
      klar in `reference/`, nie als Stilvorlage, nie als Ansatz im README.

### C6. Ergebnis: zwei Fragen beantworten plus Verbesserungsvorschlaege (Pflicht)

C1 bis C5 sind die Mechanik. C6 ist das, was der Vergleich fuer mich liefern
soll. Die Referenz (die fremde, schon auf CSPLib hochgeladene Loesung) ist nur
der Massstab und wird NICHT bewertet. Bewertet wird meine eigene Loesung. Ohne
ausgefuellten C6-Block gilt Teil C als nicht erledigt. Der Block kommt in die
Notiz-Spalte der Fortschritt-Tabelle (bzw. in REFERENCE_COMPARISON.md, falls
dorthin gesammelt).

Der Agent beantwortet pro Problem genau diese zwei Fragen, klar und direkt:

**Frage 1: Ist meine Loesung korrekt?**

- [ ] Liefert meine Loesung dasselbe Ergebnis bzw. denselben Count/das Optimum
      wie die Referenz? (ja / nein, mit konkreten Zahlen). Vorher Zaehl-Semantik
      pruefen (C3), sonst ist der Vergleich wertlos.
- [ ] Falls nein: woran liegt es? Fehlt ein Constraint, ist die Frage anders
      modelliert, oder ist es nur eine andere (gueltige) Loesung von mehreren?

**Frage 2: Ist meine Loesung gut genug, um sie CSPLib vorzuschlagen?**

- [ ] Idiomatisch fuer Prolog, nicht unnoetig kompliziert, nicht "dumm"
      (Massstab ist Teil A2 bis A4).
- [ ] Anders als die Referenz ist erlaubt (andere Sprache, andere Sicht), solange
      es begruendbar gleich gut oder besser ist, nicht nur weil es anders ist.
- [ ] Was bringt meine Loesung, das die vorhandene CSPLib-Loesung nicht hat?
      (z. B. erste SWI-Prolog-Variante, CLP-vs-Backtracking-Gegenueberstellung,
      klarer dokumentiert, schneller). Das ist die Begruendung fuer den PR (Teil D).
- [ ] Klares Urteil in einem Satz: solide / verbesserbar / falsch verstanden.

**Verbesserungsvorschlaege (falls nicht "solide"):**

- [ ] Konkrete, umsetzbare Vorschlaege: was genau aendern, in welcher Datei, an
      welcher Zeile oder welchem Constraint. Kein vages "koennte besser sein".
- [ ] Klare Empfehlung pro Vorschlag: behalten wie ist / aendern (was) / NICHT
      committen (warum).
- [ ] Bei Urteil "falsch verstanden" oder Empfehlung "NICHT committen": vor der
      weiteren Mechanik (Teil B) stoppen und nachfragen, nicht still
      weiterarbeiten.

---

## Teil D: Beitrag an CSPLib (PR) entscheiden

Pro Problem entscheiden, ob sich ein Pull Request lohnt. Nicht alle 13 muessen
eingereicht werden, nur die mit echtem Mehrwert.

- [ ] Existiert auf CSPLib schon eine **SWI-Prolog**-Loesung fuer dieses Problem?
      Nein -> starker Kandidat.
- [ ] Nur ein anderer Dialekt vorhanden (B-Prolog, SICStus, ECLiPSe)? Das zaehlt
      nicht als vorhanden, deine SWI-Variante ist eine eigenstaendige Toolchain.
- [ ] Bringt deine Variante etwas Eigenes (die CLP-vs-Backtracking-Gegenueber-
      stellung tut das fast immer; sonst: klarer, schneller, besser dokumentiert)?
- [ ] Wenn ja: Korrektheit ist Pflicht (A1 + C3 Count-Abgleich), dann Dateien
      nach CSPLib-Konvention benennen und ggf. vorher ein Issue aufmachen.
- [ ] Wenn nein: bleibt nur im eigenen Repo (Portfolio), kein PR. Kein Verlust.
- [ ] Wie viele Dateien in den PR? Hoechstens zwei: das CLP(FD)-Modell und eine
      Backtracking-Loesung. Beide haben Wert (CSPLib ist eine Constraint-
      Benchmark-Bibliothek, das CLP-Modell zaehlt dort am meisten; die
      Backtracking-Loesung ist eine schoene Plain-Prolog-Ergaenzung).
      Zwischenvarianten (Naive, AllAtOnce, per-Line, per-Cell, Generalisation)
      kommen NICHT in den PR, die sind nur fuers eigene Repo.

### Beitrags-Uebersicht (Stand der CSPLib-Recherche, Juni 2026)

Geprueft am CSPLib-Repo (`csplib/csplib`, Branch `main`). Fuer keines der
Probleme existiert dort eine SWI-Prolog-Loesung, also ist ueberall die SWI-
Variante distinkt. PR? = lohnt sich ein Pull Request.

| Problem | Vorhandene Prolog-Lsg auf CSPLib | SWI da? | PR-Wert | PR gemacht |
|---|---|---|---|---|
| 006 Golomb Ruler        | SICStus, B-Prolog, ECLiPSe | nein | gut | [ ] |
| 007 All-Interval Series | SICStus, B-Prolog, ECLiPSe | nein | gut | [ ] |
| 012 Nonogram            | SICStus, ECLiPSe           | nein | gut | [ ] |
| 015 Schur's Lemma       | SICStus                    | nein | gut | [ ] |
| 019 Magic Squares       | SICStus, B-Prolog          | nein | gut | [ ] |
| 024 Langford            | SICStus, B-Prolog, ECLiPSe | nein | gut | [ ] |
| 028 BIBD                | ? (neu pruefen, SICStus-Eintrag galt BACP/prob030) | nein | gut | [ ] |
| 049 Number Partitioning | SICStus, B-Prolog, ECLiPSe | nein | gut | [ ] |
| 054 N-Queens            | B-Prolog, ECLiPSe          | nein | gut | [ ] |
| 057 Killer Sudoku       | SICStus, B-Prolog, ECLiPSe | nein | gut | [ ] |
| 067 Quasigroup Compl.   | keine (nur Essence, MiniZinc) | nein | sehr hoch, erste Prolog-Lsg | [ ] |
| 076 Costas Array        | keine (nur Python)         | nein | sehr hoch, erste Prolog-Lsg | [ ] |
| Sudoku                  | n/a, kein passendes CSPLib-Problem (prob040 ist etwas anderes) | n/a | kein PR, nur eigenes Repo | n/a |

### Staging-Workflow (`csplib_pr/`)

Der eigene Loesungsordner (`028_BIBD/028BIBDCLP.pl`, ...) bleibt im eigenen
Schema. Fuer den PR werden umbenannte **Kopien** in einem getrennten,
gitignoreten Ordner gesammelt, der die CSPLib-Struktur spiegelt:

```
csplib_pr/Problems/probNNN/models/
  <problem>_swi_clp.pl
  <problem>_swi_clp.pl.metadata            -> Type: SWI-Prolog
  <problem>_swi_backtracking.pl
  <problem>_swi_backtracking.pl.metadata
```

- [ ] Kopie immer als **letzter Schritt nach dem Review** eines Problems anlegen,
      damit sie die finale, saubere Version enthaelt (nicht aus ungeprueften
      Dateien, sonst veraltet).
- [ ] Namensschema `<problemname>_swi_<ansatz>.pl`, parallel zu CSPLibs
      `golomb_ruler_bp.pl` / `set_partition_sicstus.pl`.
- [ ] Je Datei eine `.metadata` (`---` / optional `Title:` / `Type: SWI-Prolog`
      / `---`).
- [ ] `csplib_pr/` und `reference/` stehen in `.gitignore`, tauchen also nicht im
      eigenen Repo-Git auf.
- [ ] Der eigentliche PR (Inhalt von `csplib_pr/` in den Fork kopieren und
      einreichen) passiert erst ganz am Schluss, wenn alles reviewt ist.

PR-Mechanik: Fork von `csplib/csplib`, Dateien unter
`Problems/probNNN/models/` ablegen, je Datei eine `<datei>.metadata`
(YAML mit `Title:` und `Type: SWI-Prolog`), dann Pull Request. Vorab ggf. ein
Issue aufmachen.

---

## Solutions-Ordner (fertige Dateien sammeln)

Sammelort fuer die fertigen Loesungen, getrennt von den Arbeitsordnern.

- `Solutions/` enthaelt fuer jedes Problem einen leeren Unterordner
  (`Solutions/006_Golomb_Ruler/`, ...), bereit zum Befuellen.
- Sobald ein Problem in der Fortschritt-Tabelle in allen Spalten `[x]` steht,
  die behaltenen Dateien dieses Problems (die `.pl`-Solver und die `README.md`)
  nach `Solutions/NNN_Name/` kopieren.
- Nur **Kopien**, das Original bleibt im nummerierten Ordner. `backup/` und
  `.DS_Store` nie mitkopieren.
- Welche Ansatz-Varianten mitkommen, ist erst nach dem Review entschieden
  (Teil B, Punkt 2). Darum den Ordner immer erst nach dem Abhaken befuellen,
  damit nur die finale Auswahl drinsteht.

---

## Fortschritt

Status: [ ] offen, [x] erledigt.
Spalten: Anf = Anforderung erfuellt (A1, !!!), Qual = Prolog/Aufteilung/Komplexitaet
(A2-A4), N = Namen, V = Varianten (CLP+BT), C = Code/Kommentare, R = README,
S = Smoke-Test, Ref = Referenzabgleich (Teil C, echte externe Referenz, nicht nur
CLP==BT), P = gepusht.

| Problem | Anf | Qual | N | V | C | R | S | Ref | P | Notiz |
|---|---|---|---|---|---|---|---|---|---|---|
| 006 Golomb Ruler        | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [x] | fertig inkl. Teil C. Externer Count-Abgleich mit MiniZinc/Gecode (reference/006/golomb_count.mzn: Symmetriebrechung raus + solve satisfy): m=4,5,6 = 354/4618/60010, exakt wie CLP==BT. Modellform deckt sich mit allen vier Referenzen (MiniZinc/ECLiPSe/SICStus/B-Prolog): Schranke n=m*m, mark[1]=0, streng steigend, alldifferent ueber Paardifferenzen. Optimum-Anker N=5/6/7 = 11/17/25 (OGR/ECLiPSe-Tabelle). CLP-Doppelloesung (ueberlappende pairwise_diffs([_],[])) gefixt; redundanten golomb/1 entfernt; README ASCII + Zaehl-Benchmark |
| 007 All-Interval Series | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [x] | sauberes Paar, Logik korrekt belassen (kein Symmetriebruch, aufgabentreu). Counts selbst nachgemessen n=8..12 = 40/120/296/648/1328 (OEIS A006323), CLP==BT, extern gegen all_interval4.mzn (gecode, kein Symmetriebruch) bestaetigt. Hygiene: Mode-Kommentare, library(lists)-Import im BT, README ASCII |
| 012 Nonogram            | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [x] | [ ] | BT-Datei heisst `RowByRow`, nicht `Backtracking`; drei Ansaetze im Root; Titel "Prolog Nonogram Solver" angleichen; Ref: automaton2-mzn gleiche Instanz, eindeutig (REFERENCE_COMPARISON.md) |
| 015 Schur's Lemma       | [x] | [x] | [ ] | [x] | [x] | [x] | [x] | [x] | [ ] | geprueft, README im neuen Format; Ref: Grenzfall S(3)=13 bestaetigt, schur.mzn-Referenz hat x=y-Fehler (REFERENCE_COMPARISON.md); dann committen+pushen |
| 019 Magic Squares       | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [x] | [ ] | zwei Probleme: Magic Square und Magic Sequence (je CLP+BT). Entscheiden, ob beide bleiben; Ref: Square n=3->8/n=4->7040, Sequence eindeutig (REFERENCE_COMPARISON.md) |
| 024 Langford            | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [x] | [ ] | sauberes Paar; Ref: 2x OEIS A014552, langford2_nosym.mzn gleich (REFERENCE_COMPARISON.md) |
| 028 BIBD                | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [x] | WICHTIG: war faelschlich als prob030 abgelegt, aber prob030 ist BACP; BIBD ist prob028. Umbenannt: Ordner 028_BIBD, Dateien 028BIBD*.pl, README-Titel + URL auf prob028. Commit/Push der Umbenennung steht noch aus. Ref ERLEDIGT: bibd.mzn in reference/028/ abgeglichen, CLP == bibd.mzn exakt (1/1/24 fuer (7,7,3,3,1),(6,10,5,3,2),(7,14,6,3,2), gleicher lex-Symmetriebruch auf Zeilen und Spalten). BT zaehlt 151200 (labeled, gegen symmetriefreie mzn-Kopie bestaetigt = 30 x 7!), diese Differenz im README erklaeren (REFERENCE_COMPARISON.md) |
| 049 Number Partitioning | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [ ] | sauberes Paar (frueher committed). Counts 1/1/7/24/296 selbst nachgemessen (CLP==BT, Anker 296 fuer N=24), Negativtests N=2,4,6,7 false. Logik korrekt/idiomatisch, belassen. README: Non-ASCII raus, Performance-Tabelle ergaenzt. Ref: partition.mzn/set_partition.mzn (REFERENCE_COMPARISON.md). P offen bis Commit/Push |
| 054 N-Queens            | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [x] | [ ] | Naive jetzt im Root (drei Ansaetze); Titel "Prolog N-Queens Solver" angleichen; Ref: OEIS A000170 + queens3/queens5.mzn-Counts bestaetigt (REFERENCE_COMPARISON.md) |
| 057 Killer Sudoku       | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [x] | [ ] | sechs Dateien im Root (Basis + Generalisation je CLP/BT, plus zwei Naive). Entscheiden, welche bleiben; Ref: killer_sudoku.mzn gleiche Instanz/eindeutig; Vergleich empfiehlt nur 2 Generalisierungs-Solver, Rest redundant (REFERENCE_COMPARISON.md) |
| 067 Quasigroup Compl.   | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [x] | [ ] | vier Ansaetze im Root (CLP + drei BT-Varianten); Ref ERLEDIGT: beide QCP-mzn in reference/067/ abgeglichen, CLP/perCell/perCell+DC == 42 auf gleicher Instanz. ABER: CLP-Datei nutzt andere Instanz als die BT-Dateien, README-Perf-Tabelle dadurch instanz-inkonsistent; A3-Antipattern (Instanz verdrahtet), Refactor auf Instanz-als-Argument offen (REFERENCE_COMPARISON.md) |
| 076 Costas Array        | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [x] | [ ] | sauberes Paar; Logik korrekt, keine Aenderung (Protokoll). Counts n=3..9 selbst nachgemessen = OEIS A008404, CLP==BT, extern per reference/076/costas_count.mzn (Gecode) n=3..7 bestaetigt. README an 006-Vorlage angeglichen, Non-ASCII (O(n^2)) raus, Performance frisch nachgemessen. Push offen |
| Sudoku                  | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | kein Nummernpraefix (CSPLib prob040), Dateinamen noch klein `9x9sudoku_...`; drei Varianten |

---

## Offene Grundsatzfragen

- 019: Magic Square und Magic Sequence im selben Ordner lassen oder Sequence
  auslagern bzw. entfernen?
- 057: Soll das verallgemeinerte Paar (Generalisation, beliebiges N) oder das
  9x9-Basispaar die eine CLP- und Backtracking-Loesung sein?
- Sudoku: nummerieren als `040_Sudoku` (passt zum CSPLib-Schema) oder als
  `Sudoku` belassen?
