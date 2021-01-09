const DERIVED_NOUNS = Dict(
    Symbol("ACT PCPL") => ActiveParticle(),
    Symbol("PASS PCPL") => PassiveParticle(),
    Symbol("VN") => VerbalNoun()
)
const VERB_ASPECTS = Dict(
    Symbol("PERF") => Perfect(),
    Symbol("IMPF") => Imperfect(),
    Symbol("IMPV") => Imperative()
)
const VERB_MOODS = Dict(
    Symbol("IND") => Indicative(),
    Symbol("SUBJ") => Subjunctive(),
    Symbol("JUS") => Jussive()
)
const VERB_VOICES = Dict(
    Symbol("ACT") => Active(),
    Symbol("PASS") => Passive()
)
const VERB_FORMS = Dict(
    Symbol("(I)") => VerbFormI(),
    Symbol("(II)") => VerbFormII(),
    Symbol("(III)") => VerbFormIII(),
    Symbol("(IV)") => VerbFormIV(),
    Symbol("(V)") => VerbFormV(),
    Symbol("(VI)") => VerbFormVI(),
    Symbol("(VII)") => VerbFormVII(),
    Symbol("(VIII)") => VerbFormVIII(),    
    Symbol("(IX)") => VerbFormIX(),
    Symbol("(X)") => VerbFormX(),    
    Symbol("(XI)") => VerbFormXI(),
    Symbol("(XII)") => VerbFormXII()
)
const NOMINAL_CASES = Dict(
    Symbol("NOM") => Nominative(),
    Symbol("ACCC") => Accusative(Symbol("ACC"), "Accusative case", "منصوب"),
    Symbol("GEN") => Genetive()
)
const NOMINAL_STATES = Dict(
    Symbol("DEF") => Definite(),
    Symbol("INDEF") => Indefinite()
)
const NOUNS = Dict(
    Symbol("N") => Noun(),
    Symbol("PN") => ProperNoun()
)
const DERIVED_NOMINALS = Dict(
    Symbol("ADJ") => Adjective(),
    Symbol("IMPN") => ImperativeVerbalNoun()
)
const PRONOUNS = Dict(
    Symbol("PRON") => Personal(),
    Symbol("DEM") => Demonstrative(),
    Symbol("REL") => Relative()
)
const ADVERBS = Dict(
    Symbol("T") => Time(),
    Symbol("LOC") => Location()
)
const PREPOSITIONS = Dict(
    Symbol("P") => Preposition(),
    Symbol("Al+") => Preposition(Symbol("P"), "Determiner prefix ('the')", "حرف جر"),
    Symbol("bi+") => Preposition(Symbol("P"), "Preposition prefix ('by', 'with', 'in')", "حرف جر"),
    Symbol("ka+") => Preposition(Symbol("P"), "Preposition prefix ('like' or 'thus')", "حرف جر"),
    Symbol("ta+") => Preposition(Symbol("P"), "particle of oath prefix used as a preposition ('by Allah')", "حرف جر"),
    Symbol("w:P+") => Preposition(Symbol("P"), "Particle of oath prefix used as a preposition ('by the pen')", "حرف جر"),
    Symbol("l:P+") => Preposition(Symbol("P"), "Lam as a prefixed preposition", "حرف جر")
)
const LAM_PREFIXES = Dict(
    Symbol("l:EMPH+") => EmphaticLam(),
    Symbol("l:IMPV+") => ImperativeLam(),
    Symbol("l:PRP+") => PurposeLam()
)
const CONJUNCTIONS = Dict(
    Symbol("CONJ") => Coordinating(),
    Symbol("SUB") => Subordinating(),
    Symbol("w:CONJ+") => Coordinating(Symbol("CONJ"), "Waw as a conjunctin prefix ('and')", "حرف عطف"),
    Symbol("f:CONJ+") => Coordinating(Symbol("CONJ"), "Fa as a conjunction prefix ('and')", "حرف عطف")
)
const SUFFIXES = Dict(
    Symbol("+VOC") => Vocative(Symbol("VOC"), "Vocative suffix", "حرف نداء"),
    Symbol("+n:EMPH") => EmphaticNun(Symbol("+n:EMPH"), "Emphatic nun", "لام التوكيد")
)
const PARTICLES = Dict(
    Symbol("sa+") => Future(Symbol("FUT"), "Prefixed particle indicating the future ('they will')", "حرف استقبال"),
    Symbol("ya+") => Vocative(Symbol("VOC"), "A vocative prefix usually translated as 'O'", "حرف نداء"),
    Symbol("ha+") => Vocative(Symbol("VOC"), "A vocative prefix usually translated as 'Lo!'", "حرف نداء"),
    Symbol("A:INTG+") => Interogative(Symbol("INTG"), "Alif as a prefixed interrogative particle ('is?', 'did?', 'do?')", "حرف استفهام"),
    Symbol("A:EQ+") => Equalization(Symbol("EQ"), "Alif as a prefixed equalization particle ('whether')", "حرف تسوية"),
    Symbol("w:REM+") => Resumption(Symbol("REM"), "Waw as a resumption prefix ('then' or 'so')", "حرف استئنافية"),
    Symbol("w:CIRC+") => Circumstantial(Symbol("CIRC"), "Waw as a circumstantial prefix ('while')", "حرف حال"),
    Symbol("w:SUP+") => Supplemental(Symbol("SUP"), "Waw as a supplemental perfix ('then' pr 'so')", "حرف زائد"),
    Symbol("w:COM+") => Comitative(Symbol("COM"), "Waw as a comitative perfix ('with')", "واو المعية"),
    Symbol("f:REM+") => Resumption(Symbol("REM"), "Fa as a resumption prefix ('then' or 'so')", "حرف استئنافية"),
    Symbol("f:RSLT+") => Result(Symbol("RSLT"), "Fa as a result prefix ('then')", "حرف واقع في جواب الشرط"),
    Symbol("f:SUP+") => Supplemental(Symbol("SUP"), "Fa as a supplemental prefix ('then' or 'so')", "حرف زائد"),
    Symbol("f:CAUS+") => Cause(Symbol("CAUS"), "Fa as a cause prefix ('then' or 'so')", "حرف سببية"),
    Symbol("ACC") => Accusative(),
    Symbol("AMD") => Amendment(),
    Symbol("ANS") => Answer(),
    Symbol("AVR") => Aversion(),
    Symbol("CAUS") => Cause(),
    Symbol("CERT") => Certainty(),
    Symbol("CIRC") => Circumstantial(),
    Symbol("COM") => Comitative(),
    Symbol("COND") => Conditional(),
    Symbol("EQ") => Equalization(),
    Symbol("EXH") => Exhortation(),
    Symbol("EXL") => Explanation(),
    Symbol("EXP") => Exceptive(),
    Symbol("FUT") => Future(),
    Symbol("INC") => Inceptive(),
    Symbol("INT") => Interpretation(),
    Symbol("INTG") => Interogative(),
    Symbol("NEG") => Negative(),
    Symbol("PREV") => Preventive(),
    Symbol("PRO") => Prohibition(),
    Symbol("REM") => Resumption(),
    Symbol("RES") => Restriction(),
    Symbol("RET") => Retraction(),
    Symbol("RSLT") => Result(),
    Symbol("SUP") => Supplemental(),
    Symbol("SUR") => Surprise(),
    Symbol("VOC") => Vocative()
)
const DISCONNECTED = Dict(Symbol("INL") => DisconnectedLetters())
const PERSONS = Dict(
    Symbol("1") => FirstPerson(),
    Symbol("2") => SecondPerson(),
    Symbol("3") => ThirdPerson()
)
const GENDERS = Dict(
    Symbol("M") => Masculine(),
    Symbol("F") => Feminine()
)
const NUMBERS = Dict(
    Symbol("S") => Singular(),
    Symbol("D") => Dual(),
    Symbol("PL") => Plural()
)
const PARTOFSPEECH = Dict(
    VERB_VOICES..., VERB_ASPECTS..., VERB_MOODS..., VERB_FORMS..., NOMINAL_CASES..., 
    NOMINAL_STATES..., NOUNS..., PRONOUNS..., DERIVED_NOMINALS..., CONJUNCTIONS..., ADVERBS...,
    DERIVED_NOUNS..., PREPOSITIONS..., DISCONNECTED..., LAM_PREFIXES..., PARTICLES...,
    PERSONS..., GENDERS..., NUMBERS..., SUFFIXES..., Symbol("V") => Verb()
)
const SIMPLE_ENCODING = Dict(
    Symbol(Char(0x0621)) => Symbol("Hamza"),
    Symbol(Char(0x0622)) => Symbol("Alif+Maddah"),
    Symbol(Char(0x0623)) => Symbol("HamzaAbove"),
    Symbol(Char(0x0624)) => Symbol("HamzaAbove"),
    Symbol(Char(0x0625)) => Symbol("HamzaBelow"),
    Symbol(Char(0x0626)) => Symbol("HamzaAbove"),
    Symbol(Char(0x0627)) => Symbol("Alif"),
    Symbol(Char(0x0628)) => Symbol("Ba"),
    Symbol(Char(0x0629)) => Symbol("TaMarbuta"),
    Symbol(Char(0x062A)) => Symbol("Ta"),
    Symbol(Char(0x062B)) => Symbol("Tha"),
    Symbol(Char(0x062C)) => Symbol("Jeem"),
    Symbol(Char(0x062D)) => Symbol("HHa"),
    Symbol(Char(0x062E)) => Symbol("Kha"),
    Symbol(Char(0x062F)) => Symbol("Dal"),
    Symbol(Char(0x0630)) => Symbol("Thal"),
    Symbol(Char(0x0631)) => Symbol("Ra"),
    Symbol(Char(0x0632)) => Symbol("Zain"),
    Symbol(Char(0x0633)) => Symbol("Seen"),
    Symbol(Char(0x0634)) => Symbol("Sheen"),
    Symbol(Char(0x0635)) => Symbol("Sad"),
    Symbol(Char(0x0636)) => Symbol("DDad"),
    Symbol(Char(0x0637)) => Symbol("TTa"),
    Symbol(Char(0x0638)) => Symbol("DTha"),
    Symbol(Char(0x0639)) => Symbol("Ain"),
    Symbol(Char(0x063A)) => Symbol("Ghain"),
    Symbol(Char(0x0640)) => Symbol("Tatweel"),
    Symbol(Char(0x0641)) => Symbol("Fa"),
    Symbol(Char(0x0642)) => Symbol("Qaf"),
    Symbol(Char(0x0643)) => Symbol("Kaf"),
    Symbol(Char(0x0644)) => Symbol("Lam"),
    Symbol(Char(0x0645)) => Symbol("Meem"),
    Symbol(Char(0x0646)) => Symbol("Noon"),
    Symbol(Char(0x0647)) => Symbol("Ha"),
    Symbol(Char(0x0648)) => Symbol("Waw"),
    Symbol(Char(0x0649)) => Symbol("AlifMaksura"),
    Symbol(Char(0x064A)) => Symbol("Ya"),
    Symbol(Char(0x064B)) => Symbol("Fathatan"),
    Symbol(Char(0x064C)) => Symbol("Dammatan"),
    Symbol(Char(0x064D)) => Symbol("Kasratan"),
    Symbol(Char(0x064E)) => Symbol("Fatha"),
    Symbol(Char(0x064F)) => Symbol("Damma"),
    Symbol(Char(0x0650)) => Symbol("Kasra"),
    Symbol(Char(0x0651)) => Symbol("Shadda"),
    Symbol(Char(0x0652)) => Symbol("Sukun"),
    Symbol(Char(0x0653)) => Symbol("Maddah"),
    Symbol(Char(0x0654)) => Symbol("HamzaAbove"),
    Symbol(Char(0x0670)) => Symbol("AlifKhanjareeya"),
    Symbol(Char(0x0671)) => Symbol("HamzatWasl"),
    Symbol(Char(0x06DC)) => Symbol("SmallHighSeen"),
    Symbol(Char(0x06DF)) => Symbol("SmallHighRoundedZero"),
    Symbol(Char(0x06E0)) => Symbol("SmallHighUprightRectangularZero"),
    Symbol(Char(0x06E2)) => Symbol("SmallHighMeemIsolatedForm"),
    Symbol(Char(0x06E3)) => Symbol("SmallLowSeen"),
    Symbol(Char(0x06E5)) => Symbol("SmallWaw"),
    Symbol(Char(0x06E6)) => Symbol("SmallYa"),
    Symbol(Char(0x06E8)) => Symbol("SmallHighNoon"),
    Symbol(Char(0x06EA)) => Symbol("EmptyCenterLowStop"),
    Symbol(Char(0x06EB)) => Symbol("EmptyCenterHighStop"),
    Symbol(Char(0x06EC)) => Symbol("RoundedHighStopWithFilledCenter"),
    Symbol(Char(0x06ED)) => Symbol("SmallLowMeem")
);
const BW_ENCODING = Dict(
    Symbol(Char(0x0621)) => Symbol('\''),
    Symbol(Char(0x0622)) => Symbol('('),
    Symbol(Char(0x0623)) => Symbol('>'),
    Symbol(Char(0x0624)) => Symbol('&'),
    Symbol(Char(0x0625)) => Symbol('<'),
    Symbol(Char(0x0626)) => Symbol('}'),
    Symbol(Char(0x0627)) => Symbol('A'),
    Symbol(Char(0x0628)) => Symbol('b'),
    Symbol(Char(0x0629)) => Symbol('p'),
    Symbol(Char(0x062A)) => Symbol('t'),
    Symbol(Char(0x062B)) => Symbol('v'),
    Symbol(Char(0x062C)) => Symbol('j'),
    Symbol(Char(0x062D)) => Symbol('H'),
    Symbol(Char(0x062E)) => Symbol('x'),
    Symbol(Char(0x062F)) => Symbol('d'),
    Symbol(Char(0x0630)) => Symbol('*'),
    Symbol(Char(0x0631)) => Symbol('r'),
    Symbol(Char(0x0632)) => Symbol('z'),
    Symbol(Char(0x0633)) => Symbol('s'),
    Symbol(Char(0x0634)) => Symbol('$'),
    Symbol(Char(0x0635)) => Symbol('S'),
    Symbol(Char(0x0636)) => Symbol('D'),
    Symbol(Char(0x0637)) => Symbol('T'),
    Symbol(Char(0x0638)) => Symbol('Z'),
    Symbol(Char(0x0639)) => Symbol('E'),
    Symbol(Char(0x063A)) => Symbol('g'),
    Symbol(Char(0x0640)) => Symbol('_'),
    Symbol(Char(0x0641)) => Symbol('f'),
    Symbol(Char(0x0642)) => Symbol('q'),
    Symbol(Char(0x0643)) => Symbol('k'),
    Symbol(Char(0x0644)) => Symbol('l'),
    Symbol(Char(0x0645)) => Symbol('m'),
    Symbol(Char(0x0646)) => Symbol('n'),
    Symbol(Char(0x0647)) => Symbol('h'),
    Symbol(Char(0x0648)) => Symbol('w'),
    Symbol(Char(0x0649)) => Symbol('Y'),
    Symbol(Char(0x064A)) => Symbol('y'),
    Symbol(Char(0x064B)) => Symbol('F'),
    Symbol(Char(0x064C)) => Symbol('N'),
    Symbol(Char(0x064D)) => Symbol('K'),
    Symbol(Char(0x064E)) => Symbol('a'),
    Symbol(Char(0x064F)) => Symbol('u'),
    Symbol(Char(0x0650)) => Symbol('i'),
    Symbol(Char(0x0651)) => Symbol('~'),
    Symbol(Char(0x0652)) => Symbol('o'),
    Symbol(Char(0x0653)) => Symbol('^'),
    Symbol(Char(0x0654)) => Symbol('#'),
    Symbol(Char(0x0670)) => Symbol('`'),
    Symbol(Char(0x0671)) => Symbol('{'),
    Symbol(Char(0x06DC)) => Symbol(':'),
    Symbol(Char(0x06DF)) => Symbol('@'),
    Symbol(Char(0x06E0)) => Symbol('\"'),
    Symbol(Char(0x06E2)) => Symbol('['),
    Symbol(Char(0x06E3)) => Symbol(';'),
    Symbol(Char(0x06E5)) => Symbol(','),
    Symbol(Char(0x06E6)) => Symbol('.'),
    Symbol(Char(0x06E8)) => Symbol('!'),
    Symbol(Char(0x06EA)) => Symbol('-'),
    Symbol(Char(0x06EB)) => Symbol('+'),
    Symbol(Char(0x06EC)) => Symbol('%'),
    Symbol(Char(0x06ED)) => Symbol(']')
);
const AR_DIACS_REGEX = Regex(
    string(
        Char(0x064B)[1], "|", 
        Char(0x064C)[1], "|", 
        Char(0x064D)[1], "|", 
        Char(0x064E)[1], "|", 
        Char(0x064F)[1], "|", 
        Char(0x0640)[1], "|", # move this to special diac
        Char(0x0650)[1], "|", 
        Char(0x0651)[1], "|", 
        Char(0x0652)[1], "|", 
        Char(0x0653)[1], "|",
        Char(0x0654)[1]
    )
);
const AR_DIACS = Symbol.(split(AR_DIACS_REGEX.pattern, "|"));
const SP_DEDIAC_MAPPING = Dict(
    Symbol(Char(0x0622)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0623)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0670)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0671)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0625)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0624)) => Symbol(Char(0x0648)),
    Symbol(Char(0x0626)) => Symbol(Char(0x064A)),
    Symbol(Char(0x0649)) => Symbol(Char(0x064A)),
    Symbol(Char(0x0629)) => Symbol(Char(0x0647))
);
const SP_DEDIAC_KEYS = collect(keys(SP_DEDIAC_MAPPING));
const SP_REGEX_CHARS = ['\\', '^', '$', '.', '|', '?', '*', '+', ')', '(', ']', '[', '}', '{'];
const EN_CHAPTER_LABELS = ["The Opening", "The Cow", "The Family of 'Imran", "Women", "The Feast", 
    "Livestock", "The Heights", "Battle Gains", "Repentance", "Jonah", 
    "Hud", "Joseph", "Thunder", "Abraham", "Al-Hijr", "The Bee", "The Night Journey",
    "The Cave", "Mary", "Ta Ha", "The Prophets", "The Pilgrimage", "The Believers",
    "The Light", "The Differentiator", "The Poets", "The Ants", "The Story", "The Spider",
    "The Byzantines", "Luqman", "Bowing Down In Worship", "The Joint Forces", 
    "Sheba", "The Creator", "Ya Sin", "Ranged In Rows", "Saad", "The Throngs",
    "The Foregiver", "[Verses] Made Clear", "Consultation", "Ornaments Of Gold", 
    "Smoke", "Kneeling", "The Sand Dunes", "Muhammad", "Triumph", "The Private Rooms", 
    "Qaaf", "Scattering [Winds]", "The Mountain", "The Star", "The Moon", "The Lord Of Mercy",
    "That Which Is Coming", "Iron", "The Dispute", "The Gathering [Of Forces]", "The Women Tested",
    "Solid Lines", "The Day of Congregation", "The Hypocrites", "Mutual Neglect", 
    "Divorce", "Prohibition", "Control", "The Pen", "The Inevitable Hour", "The Ways Of Ascent", 
    "Noah", "The Jinn", "Enfolded", "Wrapped In His Cloak", "The Resurrection", "Man", 
    "[Winds] Sent Forth", "The Announcement", "The Forceful Chargers", "He Frowned",
    "The Rolling Up", "The Breaking", "Those Who Give Short Measure", "The Cracking", 
    "The Towering Constellations", "The Night-Comer", "The Most High", "The Overwhelming Event",
    "Daybreak", "The City", "The Sun", "The Night", "The Morning Brightness", "Relief", 
    "The Fig", "The Clinging Form", "The Night Of Glory", "Clear Evidence", "The Earthquake",
    "The Charging Steeds", "The Crashing Blow", "Competing For More", "The Fading Day",
    "The Backbiter", "The Elephant", "Quraysh", "Common Kindness", "Abundance", "The Disbelievers",
    "Help", "Palm Fibre", "Purity of Faith", "Daybreak", "People"];
const AR_CHAPTER_LABELS = ["ٱلْفَاتِحَة" ,"ٱلْبَقَرَة", "آلِ عِمْرَان", "ٱلنِّسَاء", "ٱلْمَائِدَة" , "ٱلْأَنْعَام", "ٱلْأَعْرَاف", "ٱلْأَنْفَال",
    "ٱلتَّوْبَة", "يُونُس", "هُود", "يُوسُف", "ٱلرَّعْد", "إِبْرَاهِيم", "ٱلْحِجْر", "ٱلنَّحْل",
    "ٱلْإِسْرَاء", "ٱلْكَهْف", "مَرْيَم", "طه", "ٱلْأَنْبِيَاء", "ٱلْحَجّ", "ٱلْمُؤْمِنُون", "ٱلنُّور", 
    "ٱلْفُرْقَان", "ٱلشُّعَرَاء", "ٱلنَّمْل", "ٱلْقَصَص", "ٱلْعَنْكَبُوت", "ٱلرُّوم", "لُقْمَان", 
    "ٱلسَّجْدَة", "ٱلْأَحْزَاب", "سَبَأ", "فَاطِر", "يس", "ٱلصَّافَّات", "ص", "ٱلزُّمَر", "غَافِر", 
    "فُصِّلَت", "ٱلشُّورىٰ", "ٱلْزُّخْرُف", "ٱلدُّخَان", "ٱلْجَاثِيَة", "ٱلْأَحْقَاف", "مُحَمَّد", "ٱلْفَتْح", 
    "ٱلْحُجُرَات", "ق", "ٱلذَّارِيَات", "ٱلطُّور", "ٱلنَّجْم", "ٱلْقَمَر", "ٱلرَّحْمَٰن", "ٱلْوَاقِعَة", "ٱلْحَدِيد",
    "ٱلْمُجَادِلَة", "ٱلْحَشْر", "ٱلْمُمْتَحَنَة", "ٱلصَّفّ", "ٱلْجُمُعَة", "ٱلْمُنَافِقُون", "ٱلتَّغَابُن", "ٱلطَّلَاق", 
    "ٱلتَّحْرِيم", "ٱلْمُلْك", "ٱلْقَلَم", "ٱلْحَاقَّة", "ٱلْمَعَارِج", "نُوح", "ٱلْجِنّ", "ٱلْمُزَّمِّل",
    "ٱلْمُدَّثِّر", "ٱلْقِيَامَة", "ٱلْإِنْسَان", "ٱلْمُرْسَلَات", "ٱلنَّبَأ", "ٱلنَّازِعَات", "عَبَسَ", "ٱلتَّكْوِير",
    "ٱلْإِنْفِطَار", "ٱلْمُطَفِّفِين", "ٱلْإِنْشِقَاق", "ٱلْبُرُوج", "ٱلطَّارِق", "ٱلْأَعْلَىٰ", "ٱلْغَاشِيَة", 
    "ٱلْفَجْ", "ٱلْبَلَد", "ٱلشَّمْس", "ٱللَّيْل", "ٱلضُّحَىٰ", "ٱلشَّرْح", "ٱلتِّين", "ٱلْعَلَق",
    "ٱلْقَدْر", "ٱلْبَيِّنَة", "ٱلزَّلْزَلَة", "ٱلْعَادِيَات", "ٱلْقَارِعَة", "ٱلتَّكَاثُر", "ٱلْعَصْر",
    "ٱلْهُمَزَة", "ٱلْفِيل", "قُرَيْش", "ٱلْمَاعُون", "ٱلْكَوْثَر", "ٱلْكَافِرُون", "ٱلنَّصْر", "ٱلْمَسَد",
    "ٱلْإِخْلَاص", "ٱلْفَلَق", "ٱلنَّاس"];