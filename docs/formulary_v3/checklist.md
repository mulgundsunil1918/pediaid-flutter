# Drug Formulary 3.0 — extraction checklist

One line per entry, in book order: 489 entries (444 drug monographs + 45 cross-references such as “ACTH — See Corticotropin”), 95 tables.

Line format: `name — PDF pages · printed pages — output file — tables — completeness`.

* **completeness** is the per-drug multiset comparison against an independent pypdf pull (tokens *and* characters, see `tools/verify.py`): `exact` = no difference at all; `explained` = a difference that was inspected on the rendered page and is recorded in `progress/flagged.md` §5; anything else would read `UNEXPLAINED` (none).  This build: 472 exact, 17 explained, 0 unexplained.
* **tables** — every table was rebuilt from the page drawings and then read back against a rendered image of the page, cell by cell (all 95 tables).
* `[x]` = extracted, verified and written to `output/`.


## A  (`output/a.dart`)

- [x] ACETAMINOPHEN — PDF 31–32 · printed 840–841 — output/a.dart — 1 table — exact
- [x] ACETAZOLAMIDE — PDF 32–33 · printed 841–842 — output/a.dart — no tables — exact
- [x] ACETYLCYSTEINE — PDF 33–34 · printed 842–843 — output/a.dart — 1 table — exact
- [x] ACTH (cross-reference) — PDF 34 · printed 843 — output/a.dart — no tables — exact
- [x] ACYCLOVIR — PDF 34–36 · printed 843–845 — output/a.dart — no tables — exact
- [x] ADAPALENE ± BENZOYL PEROXIDE — PDF 36–37 · printed 845–846 — output/a.dart — no tables — exact
- [x] ADDERALL (cross-reference) — PDF 37 · printed 846 — output/a.dart — no tables — exact
- [x] ADENOSINE — PDF 37 · printed 846 — output/a.dart — no tables — exact
- [x] ALBUMIN, HUMAN — PDF 38 · printed 847 — output/a.dart — 1 table — exact
- [x] ALBUTEROL — PDF 38–39 · printed 847–848 — output/a.dart — no tables — exact
- [x] ALLOPURINOL — PDF 39–40 · printed 848–849 — output/a.dart — no tables — exact
- [x] ALMOTRIPTAN MALATE — PDF 40–41 · printed 849–850 — output/a.dart — no tables — exact
- [x] ALPROSTADIL — PDF 41 · printed 850 — output/a.dart — no tables — exact
- [x] ALTEPLASE — PDF 41–42 · printed 850–851 — output/a.dart — no tables — exact
- [x] ALUMINUM HYDROXIDE — PDF 42 · printed 851 — output/a.dart — no tables — exact
- [x] ALUMINUM HYDROXIDE WITH MAGNESIUM HYDROXIDE ± SIMETHICONE — PDF 43 · printed 852 — output/a.dart — no tables — exact
- [x] ALYFTREK (cross-reference) — PDF 43 · printed 852 — output/a.dart — no tables — exact
- [x] AMANTADINE HYDROCHLORIDE — PDF 43–44 · printed 852–853 — output/a.dart — no tables — exact
- [x] AMIKACIN SULFATE — PDF 44–45 · printed 853–854 — output/a.dart — 2 tables — explained (tilde)
- [x] AMINOCAPROIC ACID — PDF 45–46 · printed 854–855 — output/a.dart — no tables — exact
- [x] AMINOPHYLLINE — PDF 46–47 · printed 855–856 — output/a.dart — no tables — exact
- [x] AMIODARONE HCL — PDF 47–48 · printed 856–857 — output/a.dart — no tables — exact
- [x] AMITRIPTYLINE — PDF 48–50 · printed 857–859 — output/a.dart — 1 table — exact
- [x] AMLODIPINE — PDF 50 · printed 859 — output/a.dart — no tables — exact
- [x] AMMONUL (cross-reference) — PDF 50 · printed 859 — output/a.dart — no tables — exact
- [x] AMOXICILLIN — PDF 51 · printed 860 — output/a.dart — no tables — exact
- [x] AMOXICILLIN-CLAVULANIC ACID — PDF 51–53 · printed 860–862 — output/a.dart — no tables — exact
- [x] AMPHETAMINE — PDF 53–54 · printed 862–863 — output/a.dart — no tables — exact
- [x] AMPHOTERICIN B DEOXYCHOLATE (CONVENTIONAL) — PDF 54–55 · printed 863–864 — output/a.dart — no tables — exact
- [x] AMPHOTERICIN B LIPID COMPLEX — PDF 55–56 · printed 864–865 — output/a.dart — no tables — explained (soft hyphen)
- [x] AMPHOTERICIN B, LIPOSOMAL — PDF 56 · printed 865 — output/a.dart — no tables — exact
- [x] AMPICILLIN — PDF 57 · printed 866 — output/a.dart — no tables — exact
- [x] AMPICILLIN/SULBACTAM — PDF 58 · printed 867 — output/a.dart — no tables — exact
- [x] ANAKINRA — PDF 58–60 · printed 867–869 — output/a.dart — 1 table — exact
- [x] ARGININE HYDROCHLORIDE―INJECTABLE PREPARATION — PDF 60 · printed 869 — output/a.dart — no tables — explained (tilde)
- [x] ARIPIPRAZOLE — PDF 60–62 · printed 869–871 — output/a.dart — no tables — exact
- [x] ARNUITY ELLIPTA (cross-reference) — PDF 62 · printed 871 — output/a.dart — no tables — exact
- [x] ASCORBIC ACID — PDF 62 · printed 871 — output/a.dart — no tables — exact
- [x] ASPIRIN — PDF 63 · printed 872 — output/a.dart — no tables — exact
- [x] ATENOLOL — PDF 64 · printed 873 — output/a.dart — no tables — exact
- [x] ATOMOXETINE — PDF 64–65 · printed 873–874 — output/a.dart — no tables — exact
- [x] ATOVAQUONE — PDF 65–66 · printed 874–875 — output/a.dart — no tables — exact
- [x] ATROPINE SULFATE — PDF 66–67 · printed 875–876 — output/a.dart — no tables — exact
- [x] AZATHIOPRINE — PDF 67–68 · printed 876–877 — output/a.dart — no tables — exact
- [x] AZELASTINE — PDF 68 · printed 877 — output/a.dart — no tables — exact
- [x] AZELASTINE AND FLUTICASONE — PDF 69 · printed 878 — output/a.dart — no tables — exact
- [x] AZITHROMYCIN — PDF 69–71 · printed 878–880 — output/a.dart — no tables — exact
- [x] AZTREONAM — PDF 71–72 · printed 880–881 — output/a.dart — no tables — exact

## B  (`output/b.dart`)

- [x] BACITRACIN ± POLYMYXIN B — PDF 72 · printed 881 — output/b.dart — no tables — exact
- [x] BACLOFEN — PDF 72–74 · printed 881–883 — output/b.dart — no tables — exact
- [x] BECLOMETHASONE DIPROPIONATE — PDF 74–75 · printed 883–884 — output/b.dart — 1 table — exact
- [x] BENZOYL PEROXIDE — PDF 75–76 · printed 884–885 — output/b.dart — no tables — exact
- [x] BENZTROPINE MESYLATE — PDF 76–77 · printed 885–886 — output/b.dart — no tables — exact
- [x] BERACTANT (cross-reference) — PDF 77 · printed 886 — output/b.dart — no tables — exact
- [x] BETAMETHASONE — PDF 77–78 · printed 886–887 — output/b.dart — no tables — exact
- [x] BICITRA (cross-reference) — PDF 78 · printed 887 — output/b.dart — no tables — exact
- [x] BISACODYL — PDF 78–79 · printed 887–888 — output/b.dart — no tables — exact
- [x] BISMUTH SUBSALICYLATE — PDF 79 · printed 888 — output/b.dart — no tables — exact
- [x] BOSENTAN — PDF 80–81 · printed 889–890 — output/b.dart — 2 tables — exact
- [x] BREO ELLIPTA (cross-reference) — PDF 81 · printed 890 — output/b.dart — no tables — exact
- [x] BUDESONIDE — PDF 81–83 · printed 890–892 — output/b.dart — no tables — exact
- [x] BUDESONIDE AND FORMOTEROL — PDF 83–84 · printed 892–893 — output/b.dart — no tables — exact
- [x] BUMETANIDE — PDF 84–85 · printed 893–894 — output/b.dart — no tables — exact
- [x] BUTORPHANOL — PDF 85–86 · printed 894–895 — output/b.dart — no tables — exact

## C  (`output/c.dart`)

- [x] CAFFEINE CITRATE — PDF 86 · printed 895 — output/c.dart — no tables — exact
- [x] CALCITRIOL — PDF 86–87 · printed 895–896 — output/c.dart — no tables — exact
- [x] CALCIUM ACETATE — PDF 87 · printed 896 — output/c.dart — no tables — exact
- [x] CALCIUM CARBONATE — PDF 87–88 · printed 896–897 — output/c.dart — no tables — exact
- [x] CALCIUM CHLORIDE — PDF 88–89 · printed 897–898 — output/c.dart — no tables — exact
- [x] CALCIUM CITRATE — PDF 89 · printed 898 — output/c.dart — no tables — exact
- [x] CALCIUM GLUCONATE — PDF 89–90 · printed 898–899 — output/c.dart — no tables — exact
- [x] CALFACTANT (cross-reference) — PDF 90 · printed 899 — output/c.dart — no tables — exact
- [x] CANNABIDIOL — PDF 91 · printed 900 — output/c.dart — 1 table — exact
- [x] CAPTOPRIL — PDF 92 · printed 901 — output/c.dart — no tables — exact
- [x] CARBAMAZEPINE — PDF 92–93 · printed 901–902 — output/c.dart — no tables — exact
- [x] CARBAMIDE PEROXIDE — PDF 94 · printed 903 — output/c.dart — no tables — exact
- [x] CARBINOXAMINE — PDF 94–95 · printed 903–904 — output/c.dart — no tables — exact
- [x] CARNITINE — PDF 95 · printed 904 — output/c.dart — no tables — exact
- [x] CARVEDILOL — PDF 96 · printed 905 — output/c.dart — no tables — exact
- [x] CASPOFUNGIN — PDF 97 · printed 906 — output/c.dart — no tables — exact
- [x] CEFADROXIL — PDF 98 · printed 907 — output/c.dart — no tables — exact
- [x] CEFAZOLIN — PDF 98–99 · printed 907–908 — output/c.dart — no tables — exact
- [x] CEFDINIR — PDF 99 · printed 908 — output/c.dart — no tables — exact
- [x] CEFEPIME — PDF 99–100 · printed 908–909 — output/c.dart — no tables — exact
- [x] CEFIDEROCOL — PDF 100–101 · printed 909–910 — output/c.dart — no tables — exact
- [x] CEFIXIME — PDF 101 · printed 910 — output/c.dart — no tables — exact
- [x] CEFOTAXIME — PDF 102 · printed 911 — output/c.dart — no tables — exact
- [x] CEFOTETAN — PDF 102–103 · printed 911–912 — output/c.dart — no tables — exact
- [x] CEFOXITIN — PDF 103–104 · printed 912–913 — output/c.dart — no tables — exact
- [x] CEFPODOXIME PROXETIL — PDF 104 · printed 913 — output/c.dart — no tables — exact
- [x] CEFPROZIL — PDF 104–105 · printed 913–914 — output/c.dart — no tables — exact
- [x] CEFTAROLINE FOSAMIL — PDF 105 · printed 914 — output/c.dart — no tables — exact
- [x] CEFTAZIDIME — PDF 106 · printed 915 — output/c.dart — no tables — exact
- [x] CEFTAZIDIME WITH AVIBACTAM — PDF 106–107 · printed 915–916 — output/c.dart — no tables — exact
- [x] CEFTOLOZANE WITH TAZOBACTAM — PDF 107–108 · printed 916–917 — output/c.dart — no tables — exact
- [x] CEFTRIAXONE — PDF 108–109 · printed 917–918 — output/c.dart — no tables — exact
- [x] CEFUROXIME (IV, IM)/CEFUROXIME AXETIL (PO) — PDF 109–110 · printed 918–919 — output/c.dart — no tables — exact
- [x] CELECOXIB — PDF 110–111 · printed 919–920 — output/c.dart — no tables — exact
- [x] CEPHALEXIN — PDF 111 · printed 920 — output/c.dart — no tables — exact
- [x] CETIRIZINE ± PSEUDOEPHEDRINE — PDF 112–113 · printed 921–922 — output/c.dart — no tables — exact
- [x] CHARCOAL, ACTIVATED (cross-reference) — PDF 113 · printed 922 — output/c.dart — no tables — exact
- [x] CHLORAMPHENICOL — PDF 113–114 · printed 922–923 — output/c.dart — no tables — exact
- [x] CHLOROQUINE PHOSPHATE — PDF 114 · printed 923 — output/c.dart — no tables — exact
- [x] CHLOROTHIAZIDE — PDF 114–115 · printed 923–924 — output/c.dart — no tables — exact
- [x] CHLORPHENIRAMINE MALEATE — PDF 115 · printed 924 — output/c.dart — no tables — exact
- [x] CHLORPROMAZINE — PDF 116 · printed 925 — output/c.dart — no tables — exact
- [x] CHOLECALCIFEROL — PDF 116–118 · printed 925–927 — output/c.dart — 3 tables — exact
- [x] CHOLESTYRAMINE — PDF 118–119 · printed 927–928 — output/c.dart — no tables — exact
- [x] CICLESONIDE — PDF 119–120 · printed 928–929 — output/c.dart — 1 table — exact
- [x] CIDOFOVIR — PDF 120 · printed 929 — output/c.dart — no tables — exact
- [x] CIPROFLOXACIN — PDF 121–122 · printed 930–931 — output/c.dart — no tables — explained (tilde)
- [x] CITRATE MIXTURES — PDF 123 · printed 932 — output/c.dart — 1 table — exact
- [x] CLARITHROMYCIN — PDF 123–124 · printed 932–933 — output/c.dart — no tables — exact
- [x] CLINDAMYCIN — PDF 124–126 · printed 933–935 — output/c.dart — no tables — exact
- [x] CLOBAZAM — PDF 126–127 · printed 935–936 — output/c.dart — 2 tables — exact
- [x] CLONAZEPAM — PDF 127–128 · printed 936–937 — output/c.dart — no tables — exact
- [x] CLONIDINE — PDF 128–129 · printed 937–938 — output/c.dart — no tables — exact
- [x] CLOTRIMAZOLE — PDF 129–130 · printed 938–939 — output/c.dart — no tables — exact
- [x] CORTICOTROPIN — PDF 130 · printed 939 — output/c.dart — no tables — exact
- [x] CORTISONE ACETATE — PDF 131 · printed 940 — output/c.dart — no tables — exact
- [x] CO-TRIMOXAZOLE (cross-reference) — PDF 131 · printed 940 — output/c.dart — no tables — exact
- [x] CROMOLYN — PDF 131–132 · printed 940–941 — output/c.dart — no tables — exact
- [x] CYANOCOBALAMIN/VITAMIN B₁₂ — PDF 132 · printed 941 — output/c.dart — no tables — exact
- [x] CYCLOPENTOLATE — PDF 133 · printed 942 — output/c.dart — no tables — exact
- [x] CYCLOPENTOLATE WITH PHENYLEPHRINE — PDF 133 · printed 942 — output/c.dart — no tables — explained (pypdf fragment)
- [x] CYCLOSPORINE, CYCLOSPORINE MICROEMULSION, CYCLOSPORINE MODIFIED — PDF 133–135 · printed 942–944 — output/c.dart — no tables — exact
- [x] CYPROHEPTADINE — PDF 135–136 · printed 944–945 — output/c.dart — no tables — exact

## D  (`output/d.dart`)

- [x] DABIGATRAN ETEXILATE MESYLATE — PDF 136–137 · printed 945–946 — output/d.dart — 1 table — exact
- [x] DANTROLENE — PDF 137–138 · printed 946–947 — output/d.dart — 1 table — exact
- [x] DAPSONE — PDF 138–139 · printed 947–948 — output/d.dart — no tables — exact
- [x] DARBEPOETIN ALFA — PDF 139–141 · printed 948–950 — output/d.dart — 3 tables — exact
- [x] DEFEROXAMINE MESYLATE — PDF 142 · printed 951 — output/d.dart — no tables — exact
- [x] DESMOPRESSIN ACETATE — PDF 143–144 · printed 952–953 — output/d.dart — no tables — exact
- [x] DEXAMETHASONE — PDF 144–145 · printed 953–954 — output/d.dart — no tables — exact
- [x] DEXMEDETOMIDINE — PDF 145–146 · printed 954–955 — output/d.dart — no tables — exact
- [x] DEXMETHYLPHENIDATE — PDF 146–147 · printed 955–956 — output/d.dart — 1 table — exact
- [x] DEXTROAMPHETAMINE ± AMPHETAMINE — PDF 148–150 · printed 957–959 — output/d.dart — 2 tables — exact
- [x] DIAZEPAM — PDF 150–152 · printed 959–961 — output/d.dart — 1 table — exact
- [x] DIAZOXIDE — PDF 152 · printed 961 — output/d.dart — no tables — exact
- [x] DIGOXIN — PDF 153–154 · printed 962–963 — output/d.dart — 1 table — exact
- [x] DIGOXIN IMMUNE FAB (OVINE) — PDF 154 · printed 963 — output/d.dart — 1 table — exact
- [x] DILTIAZEM — PDF 155 · printed 964 — output/d.dart — no tables — exact
- [x] DIMENHYDRINATE — PDF 156 · printed 965 — output/d.dart — no tables — exact
- [x] DIPHENHYDRAMINE — PDF 156–157 · printed 965–966 — output/d.dart — no tables — exact
- [x] DIVALPROEX SODIUM — PDF 157 · printed 966 — output/d.dart — no tables — exact
- [x] DOBUTAMINE — PDF 157–158 · printed 966–967 — output/d.dart — no tables — explained (pypdf fragment)
- [x] DOCUSATE — PDF 158 · printed 967 — output/d.dart — no tables — exact
- [x] DOLASETRON — PDF 158–159 · printed 967–968 — output/d.dart — no tables — exact
- [x] DOPAMINE — PDF 159 · printed 968 — output/d.dart — no tables — exact
- [x] DORNASE ALFA/DNASE — PDF 160 · printed 969 — output/d.dart — no tables — exact
- [x] DOXYCYCLINE — PDF 160–161 · printed 969–970 — output/d.dart — no tables — exact
- [x] DRONABINOL — PDF 161–162 · printed 970–971 — output/d.dart — no tables — exact
- [x] DROPERIDOL — PDF 162–163 · printed 971–972 — output/d.dart — no tables — exact
- [x] DYMISTA (cross-reference) — PDF 163 · printed 972 — output/d.dart — no tables — exact

## E  (`output/e.dart`)

- [x] ELEXACAFTOR/TEZACAFTOR/IVACAFTOR — PDF 163–166 · printed 972–975 — output/e.dart — 1 table — exact
- [x] EMLA (cross-reference) — PDF 166 · printed 975 — output/e.dart — no tables — exact
- [x] ENALAPRIL MALEATE (PO), ENALAPRILAT (IV) — PDF 166–167 · printed 975–976 — output/e.dart — no tables — exact
- [x] ENOXAPARIN — PDF 167–169 · printed 976–978 — output/e.dart — 3 tables — exact
- [x] EPINEPHRINE HCL — PDF 169–171 · printed 978–980 — output/e.dart — no tables — exact
- [x] EPINEPHRINE, RACEMIC — PDF 172 · printed 981 — output/e.dart — no tables — exact
- [x] EPOETIN ALFA — PDF 172–173 · printed 981–982 — output/e.dart — no tables — exact
- [x] EPOPROSTENOL — PDF 173–174 · printed 982–983 — output/e.dart — no tables — exact
- [x] ERGOCALCIFEROL — PDF 174–175 · printed 983–984 — output/e.dart — no tables — exact
- [x] ERGOTAMINE TARTRATE ± CAFFEINE — PDF 175–176 · printed 984–985 — output/e.dart — no tables — exact
- [x] ERTAPENEM — PDF 176–177 · printed 985–986 — output/e.dart — no tables — exact
- [x] ERYTHROMYCIN PREPARATIONS — PDF 177–178 · printed 986–987 — output/e.dart — no tables — exact
- [x] ERYTHROPOIETIN (cross-reference) — PDF 178 · printed 987 — output/e.dart — no tables — exact
- [x] ESCITALOPRAM — PDF 178–179 · printed 987–988 — output/e.dart — no tables — exact
- [x] ESMOLOL HCL — PDF 179–180 · printed 988–989 — output/e.dart — no tables — exact
- [x] ESOMEPRAZOLE — PDF 180–181 · printed 989–990 — output/e.dart — no tables — exact
- [x] ETANERCEPT — PDF 181–182 · printed 990–991 — output/e.dart — no tables — exact
- [x] ETHAMBUTOL HCL — PDF 183 · printed 992 — output/e.dart — no tables — exact
- [x] ETHOSUXIMIDE — PDF 183–184 · printed 992–993 — output/e.dart — no tables — exact
- [x] ETOMIDATE — PDF 184 · printed 993 — output/e.dart — no tables — exact

## F  (`output/f.dart`)

- [x] FAMCICLOVIR — PDF 184–185 · printed 993–994 — output/f.dart — no tables — exact
- [x] FAMOTIDINE — PDF 185–186 · printed 994–995 — output/f.dart — no tables — exact
- [x] FELBAMATE — PDF 186–187 · printed 995–996 — output/f.dart — no tables — exact
- [x] FENTANYL — PDF 187–188 · printed 996–997 — output/f.dart — no tables — explained (formula)
- [x] FERRIC GLUCONATE (cross-reference) — PDF 188 · printed 997 — output/f.dart — no tables — exact
- [x] FERROUS SULFATE (cross-reference) — PDF 188 · printed 997 — output/f.dart — no tables — exact
- [x] FEXOFENADINE ± PSEUDOEPHEDRINE — PDF 189 · printed 998 — output/f.dart — no tables — exact
- [x] FIDAXOMICIN — PDF 189–190 · printed 998–999 — output/f.dart — no tables — exact
- [x] FILGRASTIM — PDF 190–191 · printed 999–1000 — output/f.dart — no tables — exact
- [x] FLUCONAZOLE — PDF 191–192 · printed 1000–1001 — output/f.dart — 2 tables — exact
- [x] FLUCYTOSINE — PDF 192–193 · printed 1001–1002 — output/f.dart — no tables — exact
- [x] FLUDROCORTISONE ACETATE — PDF 193 · printed 1002 — output/f.dart — no tables — exact
- [x] FLUMAZENIL — PDF 193–194 · printed 1002–1003 — output/f.dart — no tables — exact
- [x] FLUNISOLIDE — PDF 194 · printed 1003 — output/f.dart — no tables — exact
- [x] FLUORIDE — PDF 194–195 · printed 1003–1004 — output/f.dart — 1 table — exact
- [x] FLUOXETINE HYDROCHLORIDE — PDF 195–196 · printed 1004–1005 — output/f.dart — no tables — exact
- [x] FLUTICASONE FUROATE + VILANTEROL — PDF 196–197 · printed 1005–1006 — output/f.dart — no tables — exact
- [x] FLUTICASONE PREPARATIONS — PDF 197–199 · printed 1006–1008 — output/f.dart — 1 table — exact
- [x] FLUTICASONE PROPIONATE AND SALMETEROL — PDF 199–201 · printed 1008–1010 — output/f.dart — 2 tables — exact
- [x] FLUVOXAMINE — PDF 202 · printed 1011 — output/f.dart — no tables — exact
- [x] FOLIC ACID — PDF 202–203 · printed 1011–1012 — output/f.dart — no tables — exact
- [x] FOMEPIZOLE — PDF 203–204 · printed 1012–1013 — output/f.dart — no tables — exact
- [x] FOSCARNET — PDF 204–205 · printed 1013–1014 — output/f.dart — no tables — exact
- [x] FOSPHENYTOIN — PDF 205–206 · printed 1014–1015 — output/f.dart — no tables — exact
- [x] FUROSEMIDE — PDF 206–207 · printed 1015–1016 — output/f.dart — no tables — exact

## G  (`output/g.dart`)

- [x] GABAPENTIN — PDF 207–208 · printed 1016–1017 — output/g.dart — no tables — exact
- [x] GANCICLOVIR — PDF 208–209 · printed 1017–1018 — output/g.dart — no tables — exact
- [x] GATIFLOXACIN — PDF 209 · printed 1018 — output/g.dart — no tables — exact
- [x] GCSF (cross-reference) — PDF 209 · printed 1018 — output/g.dart — no tables — exact
- [x] GENTAMICIN — PDF 209–210 · printed 1018–1019 — output/g.dart — 1 table — explained (tilde)
- [x] GLUCAGON HCL — PDF 211–212 · printed 1020–1021 — output/g.dart — no tables — exact
- [x] GLYCERIN — PDF 212 · printed 1021 — output/g.dart — no tables — exact
- [x] GLYCOPYRROLATE — PDF 212–213 · printed 1021–1022 — output/g.dart — no tables — exact
- [x] GRANISETRON — PDF 213–214 · printed 1022–1023 — output/g.dart — no tables — exact
- [x] GRISEOFULVIN — PDF 214–215 · printed 1023–1024 — output/g.dart — no tables — exact
- [x] GUANFACINE — PDF 215–216 · printed 1024–1025 — output/g.dart — 1 table — exact

## H  (`output/h.dart`)

- [x] HALOPERIDOL — PDF 216–217 · printed 1025–1026 — output/h.dart — no tables — exact
- [x] HEPARIN SODIUM — PDF 217–218 · printed 1026–1027 — output/h.dart — 1 table — exact
- [x] HYALURONIDASE — PDF 218–219 · printed 1027–1028 — output/h.dart — no tables — exact
- [x] HYDRALAZINE HYDROCHLORIDE — PDF 219 · printed 1028 — output/h.dart — no tables — exact
- [x] HYDROCHLOROTHIAZIDE — PDF 219–220 · printed 1028–1029 — output/h.dart — no tables — exact
- [x] HYDROCORTISONE — PDF 220–221 · printed 1029–1030 — output/h.dart — no tables — exact
- [x] HYDROMORPHONE HCL — PDF 221–222 · printed 1030–1031 — output/h.dart — no tables — exact
- [x] HYDROXYCHLOROQUINE SULFATE — PDF 222–223 · printed 1031–1032 — output/h.dart — no tables — exact
- [x] HYDROXYZINE — PDF 223 · printed 1032 — output/h.dart — no tables — exact

## I  (`output/i.dart`)

- [x] IBUPROFEN — PDF 223–225 · printed 1032–1034 — output/i.dart — no tables — exact
- [x] ILOPROST — PDF 225 · printed 1034 — output/i.dart — no tables — exact
- [x] IMIPENEM AND CILASTATIN — PDF 225–226 · printed 1034–1035 — output/i.dart — no tables — exact
- [x] IMIPRAMINE — PDF 226–227 · printed 1035–1036 — output/i.dart — no tables — exact
- [x] IMMUNE GLOBULIN — PDF 227–231 · printed 1036–1040 — output/i.dart — 3 tables — explained (tilde)
- [x] INDOMETHACIN — PDF 231–232 · printed 1040–1041 — output/i.dart — 1 table — exact
- [x] INFLIXIMAB — PDF 232–234 · printed 1041–1043 — output/i.dart — no tables — exact
- [x] INSULIN PREPARATIONS — PDF 234 · printed 1043 — output/i.dart — no tables — exact
- [x] IODIDE (cross-reference) — PDF 234 · printed 1043 — output/i.dart — no tables — exact
- [x] IODIXANOL — PDF 234–235 · printed 1043–1044 — output/i.dart — no tables — exact
- [x] IOHEXOL — PDF 235–236 · printed 1044–1045 — output/i.dart — no tables — exact
- [x] IPRATROPIUM BROMIDE ± ALBUTEROL — PDF 236–238 · printed 1045–1047 — output/i.dart — no tables — exact
- [x] IRON DEXTRAN (cross-reference) — PDF 238 · printed 1047 — output/i.dart — no tables — exact
- [x] IRON SUCROSE (cross-reference) — PDF 238 · printed 1047 — output/i.dart — no tables — exact
- [x] IRON―INJECTABLE PREPARATIONS — PDF 238–240 · printed 1047–1049 — output/i.dart — no tables — explained (tilde)
- [x] IRON―ORAL PREPARATIONS — PDF 240–241 · printed 1049–1050 — output/i.dart — no tables — exact
- [x] ISAVUCONAZONIUM SULFATE — PDF 241–242 · printed 1050–1051 — output/i.dart — 2 tables — exact
- [x] ISONIAZID — PDF 242–243 · printed 1051–1052 — output/i.dart — no tables — exact
- [x] ISOPROTERENOL — PDF 243 · printed 1052 — output/i.dart — no tables — exact
- [x] ISOTRETINOIN — PDF 244 · printed 1053 — output/i.dart — no tables — exact
- [x] ISRADIPINE — PDF 244–245 · printed 1053–1054 — output/i.dart — no tables — exact
- [x] ITRACONAZOLE — PDF 245–246 · printed 1054–1055 — output/i.dart — no tables — exact
- [x] IVACAFTOR — PDF 246–247 · printed 1055–1056 — output/i.dart — 1 table — exact
- [x] IVERMECTIN — PDF 248–249 · printed 1057–1058 — output/i.dart — 2 tables — exact

## K  (`output/k.dart`)

- [x] KALYDECO (cross-reference) — PDF 249 · printed 1058 — output/k.dart — no tables — exact
- [x] KETAMINE — PDF 249–250 · printed 1058–1059 — output/k.dart — no tables — exact
- [x] KETOCONAZOLE — PDF 250–251 · printed 1059–1060 — output/k.dart — no tables — exact
- [x] KETOROLAC — PDF 251–252 · printed 1060–1061 — output/k.dart — no tables — exact

## L  (`output/l.dart`)

- [x] LABETALOL — PDF 252 · printed 1061 — output/l.dart — no tables — exact
- [x] LACOSAMIDE — PDF 253–255 · printed 1062–1064 — output/l.dart — 4 tables — exact
- [x] LACTULOSE — PDF 255 · printed 1064 — output/l.dart — no tables — exact
- [x] LAMIVUDINE — PDF 255–256 · printed 1064–1065 — output/l.dart — no tables — exact
- [x] LAMOTRIGINE — PDF 256–261 · printed 1065–1070 — output/l.dart — 4 tables — exact
- [x] LANSOPRAZOLE — PDF 261–262 · printed 1070–1071 — output/l.dart — no tables — exact
- [x] LETERMOVIR — PDF 262–263 · printed 1071–1072 — output/l.dart — 1 table — exact
- [x] LEVALBUTEROL — PDF 263 · printed 1072 — output/l.dart — no tables — exact
- [x] LEVETIRACETAM — PDF 264–265 · printed 1073–1074 — output/l.dart — no tables — exact
- [x] LEVOCARNITINE (cross-reference) — PDF 265 · printed 1074 — output/l.dart — no tables — exact
- [x] LEVOFLOXACIN — PDF 265–266 · printed 1074–1075 — output/l.dart — no tables — exact
- [x] LEVOTHYROXINE (T₄) — PDF 266–267 · printed 1075–1076 — output/l.dart — no tables — exact
- [x] LIDOCAINE — PDF 268–269 · printed 1077–1078 — output/l.dart — no tables — exact
- [x] LIDOCAINE AND PRILOCAINE — PDF 269–270 · printed 1078–1079 — output/l.dart — 1 table — exact
- [x] LINEZOLID — PDF 270–271 · printed 1079–1080 — output/l.dart — no tables — exact
- [x] LIRAGLUTIDE — PDF 271–272 · printed 1080–1081 — output/l.dart — no tables — exact
- [x] LISDEXAMFETAMINE — PDF 272–273 · printed 1081–1082 — output/l.dart — no tables — exact
- [x] LISINOPRIL — PDF 273–274 · printed 1082–1083 — output/l.dart — no tables — exact
- [x] LITHIUM — PDF 274 · printed 1083 — output/l.dart — no tables — exact
- [x] LOPERAMIDE — PDF 275 · printed 1084 — output/l.dart — no tables — exact
- [x] LORATADINE ± PSEUDOEPHEDRINE — PDF 275–276 · printed 1084–1085 — output/l.dart — no tables — exact
- [x] LORAZEPAM — PDF 276–277 · printed 1085–1086 — output/l.dart — no tables — exact
- [x] LOSARTAN — PDF 277–278 · printed 1086–1087 — output/l.dart — no tables — exact
- [x] LOW-MOLECULAR-WEIGHT HEPARIN (cross-reference) — PDF 278 · printed 1087 — output/l.dart — no tables — exact
- [x] LUMACAFTOR AND IVACAFTOR — PDF 278–280 · printed 1087–1089 — output/l.dart — 1 table — exact

## M  (`output/m.dart`)

- [x] MAGNESIUM CITRATE — PDF 280 · printed 1089 — output/m.dart — no tables — exact
- [x] MAGNESIUM HYDROXIDE — PDF 280–281 · printed 1089–1090 — output/m.dart — no tables — exact
- [x] MAGNESIUM OXIDE — PDF 281 · printed 1090 — output/m.dart — no tables — exact
- [x] MAGNESIUM SULFATE — PDF 281–282 · printed 1090–1091 — output/m.dart — no tables — exact
- [x] MANNITOL — PDF 282–283 · printed 1091–1092 — output/m.dart — no tables — exact
- [x] MEBENDAZOLE — PDF 283–284 · printed 1092–1093 — output/m.dart — no tables — exact
- [x] MEDROXYPROGESTERONE — PDF 284–285 · printed 1093–1094 — output/m.dart — no tables — exact
- [x] MEFLOQUINE HCL — PDF 285 · printed 1094 — output/m.dart — no tables — exact
- [x] MEROPENEM — PDF 286–287 · printed 1095–1096 — output/m.dart — no tables — exact
- [x] MESALAMINE — PDF 287–288 · printed 1096–1097 — output/m.dart — no tables — exact
- [x] METFORMIN — PDF 289–290 · printed 1098–1099 — output/m.dart — no tables — exact
- [x] METHADONE HCL — PDF 290 · printed 1099 — output/m.dart — no tables — exact
- [x] METHIMAZOLE — PDF 291 · printed 1100 — output/m.dart — no tables — exact
- [x] METHYLENE BLUE — PDF 291–292 · printed 1100–1101 — output/m.dart — no tables — exact
- [x] METHYLPHENIDATE HCL — PDF 292–295 · printed 1101–1104 — output/m.dart — 3 tables — exact
- [x] METHYLPREDNISOLONE — PDF 295–296 · printed 1104–1105 — output/m.dart — no tables — exact
- [x] METOCLOPRAMIDE — PDF 296 · printed 1105 — output/m.dart — no tables — exact
- [x] METOLAZONE — PDF 296–297 · printed 1105–1106 — output/m.dart — no tables — exact
- [x] METRONIDAZOLE — PDF 297–299 · printed 1106–1108 — output/m.dart — no tables — exact
- [x] MICAFUNGIN SODIUM — PDF 299–300 · printed 1108–1109 — output/m.dart — no tables — exact
- [x] MICONAZOLE — PDF 300–301 · printed 1109–1110 — output/m.dart — no tables — exact
- [x] MIDAZOLAM — PDF 301–302 · printed 1110–1111 — output/m.dart — no tables — exact
- [x] MILRINONE — PDF 302 · printed 1111 — output/m.dart — no tables — exact
- [x] MINERAL OIL — PDF 303 · printed 1112 — output/m.dart — no tables — exact
- [x] MINOCYCLINE — PDF 303–304 · printed 1112–1113 — output/m.dart — no tables — exact
- [x] MINOXIDIL — PDF 304–305 · printed 1113–1114 — output/m.dart — no tables — exact
- [x] MOMETASONE FUROATE ± FOMOTEROL FUMARATE — PDF 305–307 · printed 1114–1116 — output/m.dart — 1 table — exact
- [x] MONTELUKAST — PDF 307–308 · printed 1116–1117 — output/m.dart — no tables — exact
- [x] MORPHINE SULFATE — PDF 308–309 · printed 1117–1118 — output/m.dart — no tables — explained (formula)
- [x] MUPIROCIN — PDF 309–310 · printed 1118–1119 — output/m.dart — no tables — exact
- [x] MYCOPHENOLATE — PDF 310–311 · printed 1119–1120 — output/m.dart — no tables — exact

## N  (`output/n.dart`)

- [x] NAFCILLIN — PDF 312 · printed 1121 — output/n.dart — no tables — exact
- [x] NALOXONE — PDF 312–313 · printed 1121–1122 — output/n.dart — no tables — exact
- [x] NAPROXEN/NAPROXEN SODIUM — PDF 314–315 · printed 1123–1124 — output/n.dart — no tables — exact
- [x] NEO-POLYCIN HC (cross-reference) — PDF 315 · printed 1124 — output/n.dart — no tables — exact
- [x] NEO-POLYMYCIN OPHTHALMIC OINTMENT (cross-reference) — PDF 315 · printed 1124 — output/n.dart — no tables — exact
- [x] NEOMYCIN SULFATE — PDF 315 · printed 1124 — output/n.dart — no tables — exact
- [x] NEOMYCIN/POLYMYXIN B OPHTHALMIC PRODUCTS — PDF 316–317 · printed 1125–1126 — output/n.dart — no tables — exact
- [x] NEOMYCIN/POLYMYXIN B/BACITRACIN — PDF 317 · printed 1126 — output/n.dart — no tables — exact
- [x] NEOSTIGMINE — PDF 317–318 · printed 1126–1127 — output/n.dart — no tables — exact
- [x] NEVIRAPINE — PDF 318–319 · printed 1127–1128 — output/n.dart — no tables — exact
- [x] NIACIN/VITAMIN B₃ — PDF 319–320 · printed 1128–1129 — output/n.dart — no tables — exact
- [x] NICARDIPINE — PDF 320–321 · printed 1129–1130 — output/n.dart — no tables — exact
- [x] NIFEDIPINE — PDF 321–322 · printed 1130–1131 — output/n.dart — no tables — exact
- [x] NIRSEVIMAB — PDF 322 · printed 1131 — output/n.dart — no tables — exact
- [x] NITROFURANTOIN — PDF 323 · printed 1132 — output/n.dart — no tables — exact
- [x] NITROGLYCERIN — PDF 323–325 · printed 1132–1134 — output/n.dart — no tables — exact
- [x] NITROPRUSSIDE — PDF 325 · printed 1134 — output/n.dart — no tables — exact
- [x] NOREPINEPHRINE BITARTRATE — PDF 325 · printed 1134 — output/n.dart — no tables — exact
- [x] NORTRIPTYLINE HYDROCHLORIDE — PDF 326 · printed 1135 — output/n.dart — no tables — exact
- [x] NYSTATIN — PDF 326–327 · printed 1135–1136 — output/n.dart — no tables — exact

## O  (`output/o.dart`)

- [x] OCTREOTIDE ACETATE — PDF 327–328 · printed 1136–1137 — output/o.dart — no tables — exact
- [x] OFLOXACIN (OTIC AND OPHTHALMIC) — PDF 328 · printed 1137 — output/o.dart — no tables — exact
- [x] OLANZAPINE — PDF 329–331 · printed 1138–1140 — output/o.dart — no tables — exact
- [x] OLOPATADINE — PDF 331 · printed 1140 — output/o.dart — no tables — exact
- [x] OMEPRAZOLE — PDF 331–332 · printed 1140–1141 — output/o.dart — no tables — exact
- [x] OMNIPAQUE (cross-reference) — PDF 333 · printed 1142 — output/o.dart — no tables — exact
- [x] ONDANSETRON — PDF 333–334 · printed 1142–1143 — output/o.dart — no tables — exact
- [x] ORKAMBI (cross-reference) — PDF 334 · printed 1143 — output/o.dart — no tables — exact
- [x] OSELTAMIVIR PHOSPHATE — PDF 334–335 · printed 1143–1144 — output/o.dart — 1 table — exact
- [x] OXACILLIN — PDF 336 · printed 1145 — output/o.dart — no tables — exact
- [x] OXCARBAZEPINE — PDF 336–338 · printed 1145–1147 — output/o.dart — 1 table — exact
- [x] OXYBUTYNIN CHLORIDE — PDF 338–339 · printed 1147–1148 — output/o.dart — no tables — exact
- [x] OXYCODONE — PDF 339–340 · printed 1148–1149 — output/o.dart — no tables — exact
- [x] OXYCODONE AND ACETAMINOPHEN — PDF 340 · printed 1149 — output/o.dart — no tables — exact
- [x] OXYCODONE AND ASPIRIN — PDF 340–341 · printed 1149–1150 — output/o.dart — no tables — exact
- [x] OXYMETAZOLINE — PDF 341 · printed 1150 — output/o.dart — no tables — exact

## P  (`output/p.dart`)

- [x] PALIVIZUMAB — PDF 341–342 · printed 1150–1151 — output/p.dart — no tables — exact
- [x] PANCRELIPASE/PANCREATIC ENZYMES — PDF 342–344 · printed 1151–1153 — output/p.dart — 2 tables — explained (pypdf fragment)
- [x] PANTOPRAZOLE — PDF 344–345 · printed 1153–1154 — output/p.dart — no tables — exact
- [x] PAROMOMYCIN SULFATE — PDF 345–346 · printed 1154–1155 — output/p.dart — no tables — exact
- [x] PAROXETINE — PDF 346–347 · printed 1155–1156 — output/p.dart — no tables — exact
- [x] PENICILLIN G PREPARATIONS—AQUEOUS POTASSIUM AND SODIUM — PDF 347–348 · printed 1156–1157 — output/p.dart — no tables — exact
- [x] PENICILLIN G PREPARATIONS—BENZATHINE — PDF 348–349 · printed 1157–1158 — output/p.dart — no tables — exact
- [x] PENICILLIN G PREPARATIONS—PENICILLIN G BENZATHINE AND PENICILLIN G PROCAINE — PDF 349–350 · printed 1158–1159 — output/p.dart — no tables — exact
- [x] PENICILLIN V POTASSIUM — PDF 350 · printed 1159 — output/p.dart — no tables — exact
- [x] PENTAMIDINE ISETHIONATE — PDF 351 · printed 1160 — output/p.dart — no tables — exact
- [x] PENTOBARBITAL — PDF 351–352 · printed 1160–1161 — output/p.dart — no tables — exact
- [x] PERMETHRIN — PDF 352 · printed 1161 — output/p.dart — no tables — exact
- [x] PHENAZOPYRIDINE HCL — PDF 353 · printed 1162 — output/p.dart — no tables — exact
- [x] PHENOBARBITAL — PDF 353–354 · printed 1162–1163 — output/p.dart — no tables — exact
- [x] PHENTOLAMINE MESYLATE — PDF 354–355 · printed 1163–1164 — output/p.dart — 1 table — explained (alpha)
- [x] PHENYLEPHRINE HCL — PDF 355–356 · printed 1164–1165 — output/p.dart — no tables — exact
- [x] PHENYTOIN — PDF 356–357 · printed 1165–1166 — output/p.dart — no tables — exact
- [x] PHOSPHORUS SUPPLEMENTS — PDF 358 · printed 1167 — output/p.dart — no tables — exact
- [x] PHYSOSTIGMINE SALICYLATE — PDF 359 · printed 1168 — output/p.dart — no tables — exact
- [x] PHYTONADIONE/VITAMIN K₁ — PDF 359–360 · printed 1168–1169 — output/p.dart — no tables — exact
- [x] PILOCARPINE HCL — PDF 360–361 · printed 1169–1170 — output/p.dart — no tables — exact
- [x] PIMECROLIMUS — PDF 361 · printed 1170 — output/p.dart — no tables — exact
- [x] PIPERACILLIN WITH TAZOBACTAM — PDF 361–363 · printed 1170–1172 — output/p.dart — no tables — exact
- [x] POLYCITRA (cross-reference) — PDF 363 · printed 1172 — output/p.dart — no tables — exact
- [x] POLYETHYLENE GLYCOL—ELECTROLYTE SOLUTION — PDF 363–364 · printed 1172–1173 — output/p.dart — no tables — exact
- [x] POLYMYXIN B SULFATE AND BACITRACIN (cross-reference) — PDF 364 · printed 1173 — output/p.dart — no tables — exact
- [x] POLYMYXIN B SULFATE AND TRIMETHOPRIM SULFATE — PDF 364 · printed 1173 — output/p.dart — no tables — exact
- [x] POLYMYXIN B SULFATE, NEOMYCIN SULFATE, HYDROCORTISONE OTIC — PDF 365 · printed 1174 — output/p.dart — no tables — exact
- [x] POLYSPORIN (cross-reference) — PDF 365 · printed 1174 — output/p.dart — no tables — exact
- [x] POLYTRIM OPHTHALMIC SOLUTION (cross-reference) — PDF 365 · printed 1174 — output/p.dart — no tables — exact
- [x] PORACTANT ALFA (cross-reference) — PDF 365 · printed 1174 — output/p.dart — no tables — exact
- [x] POSACONAZOLE — PDF 365–367 · printed 1174–1176 — output/p.dart — no tables — exact
- [x] POTASSIUM IODIDE — PDF 367–368 · printed 1176–1177 — output/p.dart — no tables — exact
- [x] POTASSIUM SUPPLEMENTS — PDF 368–369 · printed 1177–1178 — output/p.dart — no tables — exact
- [x] PRALIDOXIME CHLORIDE ± ATROPINE — PDF 369–370 · printed 1178–1179 — output/p.dart — no tables — exact
- [x] PREDNISOLONE — PDF 370–371 · printed 1179–1180 — output/p.dart — no tables — exact
- [x] PREDNISONE — PDF 371–372 · printed 1180–1181 — output/p.dart — no tables — exact
- [x] PRIMAQUINE PHOSPHATE — PDF 372–373 · printed 1181–1182 — output/p.dart — no tables — exact
- [x] PRIMIDONE — PDF 373 · printed 1182 — output/p.dart — 1 table — exact
- [x] PROBENECID — PDF 374 · printed 1183 — output/p.dart — no tables — exact
- [x] PROCHLORPERAZINE — PDF 374–375 · printed 1183–1184 — output/p.dart — no tables — exact
- [x] PROMETHAZINE — PDF 375–376 · printed 1184–1185 — output/p.dart — no tables — exact
- [x] PROPRANOLOL — PDF 376–377 · printed 1185–1186 — output/p.dart — no tables — exact
- [x] PROPYLTHIOURACIL — PDF 377–378 · printed 1186–1187 — output/p.dart — no tables — exact
- [x] PROSTAGLANDIN E₁SEE ALPROSTADIL. (cross-reference) — PDF 378 · printed 1187 — output/p.dart — no tables — exact
- [x] PROTAMINE SULFATE — PDF 378–379 · printed 1187–1188 — output/p.dart — no tables — exact
- [x] PSEUDOEPHEDRINE — PDF 379 · printed 1188 — output/p.dart — no tables — exact
- [x] PSYLLIUM — PDF 380 · printed 1189 — output/p.dart — no tables — exact
- [x] PYRANTEL PAMOATE — PDF 380 · printed 1189 — output/p.dart — no tables — exact
- [x] PYRAZINAMIDE — PDF 381 · printed 1190 — output/p.dart — no tables — exact
- [x] PYRETHRINS WITH PIPERONYL BUTOXIDE — PDF 381–382 · printed 1190–1191 — output/p.dart — no tables — exact
- [x] PYRIDOSTIGMINE BROMIDE — PDF 382 · printed 1191 — output/p.dart — no tables — exact
- [x] PYRIDOXINE — PDF 382–383 · printed 1191–1192 — output/p.dart — no tables — exact
- [x] PYRIMETHAMINE — PDF 383–384 · printed 1192–1193 — output/p.dart — no tables — exact

## Q  (`output/q.dart`)

- [x] QUETIAPINE — PDF 384–387 · printed 1193–1196 — output/q.dart — 6 tables — exact
- [x] QUINIDINE — PDF 387–388 · printed 1196–1197 — output/q.dart — no tables — exact

## R  (`output/r.dart`)

- [x] RALTEGRAVIR — PDF 388–389 · printed 1197–1198 — output/r.dart — no tables — exact
- [x] RASBURICASE — PDF 389–390 · printed 1198–1199 — output/r.dart — no tables — exact
- [x] RHₒ(D) IMMUNE GLOBULIN INTRAVENOUS (HUMAN) — PDF 390–391 · printed 1199–1200 — output/r.dart — no tables — explained (subscript o)
- [x] RIBAVIRIN — PDF 391–392 · printed 1200–1201 — output/r.dart — no tables — exact
- [x] RIBOFLAVIN — PDF 392–393 · printed 1201–1202 — output/r.dart — no tables — exact
- [x] RIFABUTIN — PDF 393–394 · printed 1202–1203 — output/r.dart — no tables — exact
- [x] RIFAMPIN — PDF 394–395 · printed 1203–1204 — output/r.dart — no tables — exact
- [x] RIFAXIMIN — PDF 395–396 · printed 1204–1205 — output/r.dart — no tables — exact
- [x] RIMANTADINE — PDF 396 · printed 1205 — output/r.dart — no tables — exact
- [x] RISPERIDONE — PDF 397–399 · printed 1206–1208 — output/r.dart — no tables — exact
- [x] RIVAROXABAN — PDF 399–400 · printed 1208–1209 — output/r.dart — no tables — exact
- [x] RIZATRIPTAN BENZOATE — PDF 401 · printed 1210 — output/r.dart — no tables — exact
- [x] ROCURONIUM — PDF 401–402 · printed 1210–1211 — output/r.dart — no tables — exact
- [x] RUFINAMIDE — PDF 402–403 · printed 1211–1212 — output/r.dart — no tables — exact

## S  (`output/s.dart`)

- [x] SALMETEROL — PDF 403–404 · printed 1212–1213 — output/s.dart — no tables — exact
- [x] SCOPOLAMINE HYDROBROMIDE — PDF 404–405 · printed 1213–1214 — output/s.dart — no tables — exact
- [x] SELENIUM SULFIDE — PDF 405 · printed 1214 — output/s.dart — no tables — exact
- [x] SENNA/SENNOSIDES — PDF 406 · printed 1215 — output/s.dart — no tables — exact
- [x] SERTRALINE HCL — PDF 407 · printed 1216 — output/s.dart — no tables — exact
- [x] SILDENAFIL — PDF 408–409 · printed 1217–1218 — output/s.dart — no tables — exact
- [x] SILVER SULFADIAZINE — PDF 409 · printed 1218 — output/s.dart — no tables — exact
- [x] SIMETHICONE — PDF 409–410 · printed 1218–1219 — output/s.dart — no tables — exact
- [x] SIROLIMUS — PDF 410–411 · printed 1219–1220 — output/s.dart — no tables — exact
- [x] SODIUM BICARBONATE — PDF 411–412 · printed 1220–1221 — output/s.dart — no tables — exact
- [x] SODIUM CHLORIDE—INHALED PREPARATIONS — PDF 412–413 · printed 1221–1222 — output/s.dart — no tables — exact
- [x] SODIUM PHENYLACETATE AND SODIUM BENZOATE — PDF 413 · printed 1222 — output/s.dart — no tables — exact
- [x] SODIUM PHOSPHATE — PDF 414 · printed 1223 — output/s.dart — no tables — exact
- [x] SODIUM POLYSTYRENE SULFONATE — PDF 414–415 · printed 1223–1224 — output/s.dart — no tables — exact
- [x] SPIRONOLACTONE — PDF 415–416 · printed 1224–1225 — output/s.dart — no tables — exact
- [x] STREPTOMYCIN SULFATE — PDF 416–417 · printed 1225–1226 — output/s.dart — no tables — exact
- [x] SUCCIMER — PDF 417 · printed 1226 — output/s.dart — 1 table — exact
- [x] SUCCINYLCHOLINE — PDF 417–418 · printed 1226–1227 — output/s.dart — no tables — exact
- [x] SUCRALFATE — PDF 419 · printed 1228 — output/s.dart — no tables — exact
- [x] SUGAMMADEX — PDF 419–420 · printed 1228–1229 — output/s.dart — no tables — exact
- [x] SULFACETAMIDE SODIUM OPHTHALMIC — PDF 420 · printed 1229 — output/s.dart — no tables — exact
- [x] SULFADIAZINE — PDF 421 · printed 1230 — output/s.dart — no tables — exact
- [x] SULFAMETHOXAZOLE AND TRIMETHOPRIM — PDF 421–422 · printed 1230–1231 — output/s.dart — no tables — exact
- [x] SULFASALAZINE — PDF 423 · printed 1232 — output/s.dart — no tables — exact
- [x] SUMATRIPTAN SUCCINATE — PDF 424–425 · printed 1233–1234 — output/s.dart — no tables — exact
- [x] SURFACTANT, PULMONARY/BERACTANT — PDF 425–426 · printed 1234–1235 — output/s.dart — no tables — explained (soft hyphen)
- [x] SURFACTANT, PULMONARY/CALFACTANT — PDF 426 · printed 1235 — output/s.dart — no tables — exact
- [x] SURFACTANT, PULMONARY/PORACTANT ALFA — PDF 427 · printed 1236 — output/s.dart — no tables — exact
- [x] SYMDEKO (cross-reference) — PDF 427 · printed 1236 — output/s.dart — no tables — exact

## T  (`output/t.dart`)

- [x] TACROLIMUS — PDF 427–429 · printed 1236–1238 — output/t.dart — no tables — exact
- [x] TAZAROTENE — PDF 430 · printed 1239 — output/t.dart — no tables — exact
- [x] TERBINAFINE — PDF 430–431 · printed 1239–1240 — output/t.dart — no tables — exact
- [x] TERBUTALINE — PDF 432 · printed 1241 — output/t.dart — no tables — exact
- [x] TETRACYCLINE HCL — PDF 432–433 · printed 1241–1242 — output/t.dart — no tables — exact
- [x] TEZACAFTOR AND IVACAFTOR — PDF 433–434 · printed 1242–1243 — output/t.dart — 4 tables — exact
- [x] THEOPHYLLINE — PDF 435–436 · printed 1244–1245 — output/t.dart — 1 table — exact
- [x] THIAMINE — PDF 436 · printed 1245 — output/t.dart — no tables — exact
- [x] THIORIDAZINE — PDF 437 · printed 1246 — output/t.dart — no tables — exact
- [x] TIAGABINE — PDF 437–438 · printed 1246–1247 — output/t.dart — no tables — exact
- [x] TIOTROPIUM — PDF 438–439 · printed 1247–1248 — output/t.dart — no tables — exact
- [x] TOBRAMYCIN — PDF 439–441 · printed 1248–1250 — output/t.dart — 1 table — exact
- [x] TOLNAFTATE — PDF 441 · printed 1250 — output/t.dart — no tables — exact
- [x] TOPIRAMATE — PDF 442–443 · printed 1251–1252 — output/t.dart — 1 table — exact
- [x] TRAZODONE — PDF 444 · printed 1253 — output/t.dart — no tables — exact
- [x] TREPROSTINIL — PDF 444–445 · printed 1253–1254 — output/t.dart — no tables — exact
- [x] TRETINOIN—TOPICAL PREPARATIONS — PDF 445–447 · printed 1254–1256 — output/t.dart — no tables — exact
- [x] TRIMETHOBENZAMIDE HCL — PDF 447 · printed 1256 — output/t.dart — no tables — exact
- [x] TRIAMCINOLONE — PDF 447–449 · printed 1256–1258 — output/t.dart — no tables — exact
- [x] TRIAMTERENE — PDF 449 · printed 1258 — output/t.dart — no tables — exact
- [x] TRIFLURIDINE — PDF 449–450 · printed 1258–1259 — output/t.dart — no tables — exact
- [x] TRIKAFTA (cross-reference) — PDF 450 · printed 1259 — output/t.dart — no tables — exact
- [x] TRIMETHOPRIM AND SULFAMETHOXAZOLE (cross-reference) — PDF 450 · printed 1259 — output/t.dart — no tables — exact

## U  (`output/u.dart`)

- [x] URSODIOL — PDF 450–451 · printed 1259–1260 — output/u.dart — no tables — exact

## V  (`output/v.dart`)

- [x] VALACYCLOVIR — PDF 451–452 · printed 1260–1261 — output/v.dart — no tables — exact
- [x] VALGANCICLOVIR — PDF 452–454 · printed 1261–1263 — output/v.dart — no tables — exact
- [x] VALPROIC ACID/VALPROATE SODIUM — PDF 454–455 · printed 1263–1264 — output/v.dart — no tables — exact
- [x] VALSARTAN — PDF 455–456 · printed 1264–1265 — output/v.dart — no tables — exact
- [x] VANCOMYCIN — PDF 456–458 · printed 1265–1267 — output/v.dart — 3 tables — exact
- [x] VANZACAFTOR + TEZACAFTOR + DEUTIVACAFTOR — PDF 458–460 · printed 1267–1269 — output/v.dart — 1 table — explained (pypdf fragment)
- [x] VARICELLA-ZOSTER IMMUNE GLOBULIN (HUMAN) — PDF 460–461 · printed 1269–1270 — output/v.dart — no tables — exact
- [x] VASOPRESSIN — PDF 461–462 · printed 1270–1271 — output/v.dart — no tables — exact
- [x] VECURONIUM BROMIDE — PDF 462 · printed 1271 — output/v.dart — no tables — exact
- [x] VIGABATRIN — PDF 462–463 · printed 1271–1272 — output/v.dart — 1 table — exact
- [x] VITAMIN A — PDF 464 · printed 1273 — output/v.dart — no tables — exact
- [x] VITAMIN B₁ (cross-reference) — PDF 464 · printed 1273 — output/v.dart — no tables — exact
- [x] VITAMIN B₂ (cross-reference) — PDF 464 · printed 1273 — output/v.dart — no tables — exact
- [x] VITAMIN B₃ (cross-reference) — PDF 465 · printed 1274 — output/v.dart — no tables — exact
- [x] VITAMIN B₆ (cross-reference) — PDF 465 · printed 1274 — output/v.dart — no tables — exact
- [x] VITAMIN B₁₂ (cross-reference) — PDF 465 · printed 1274 — output/v.dart — no tables — exact
- [x] VITAMIN C (cross-reference) — PDF 465 · printed 1274 — output/v.dart — no tables — exact
- [x] VITAMIN D₂ (cross-reference) — PDF 465 · printed 1274 — output/v.dart — no tables — exact
- [x] VITAMIN D₃ (cross-reference) — PDF 465 · printed 1274 — output/v.dart — no tables — exact
- [x] VITAMIN E/α-TOCOPHEROL — PDF 465 · printed 1274 — output/v.dart — no tables — explained (alpha)
- [x] VITAMIN K (cross-reference) — PDF 466 · printed 1275 — output/v.dart — no tables — exact
- [x] VORICONAZOLE — PDF 466–468 · printed 1275–1277 — output/v.dart — 1 table — exact

## W  (`output/w.dart`)

- [x] WARFARIN — PDF 468–470 · printed 1277–1279 — output/w.dart — 2 tables — exact

## Z  (`output/z.dart`)

- [x] ZIDOVUDINE — PDF 470–472 · printed 1279–1281 — output/z.dart — 1 table — exact
- [x] ZINC SALTS, SYSTEMIC — PDF 472 · printed 1281 — output/z.dart — no tables — exact
- [x] ZOLMITRIPTAN — PDF 473–474 · printed 1282–1283 — output/z.dart — no tables — exact
- [x] ZONISAMIDE — PDF 474 · printed 1283 — output/z.dart — no tables — exact

Letters with no entries in the book (the files exist and hold an empty list): J, X, Y.
