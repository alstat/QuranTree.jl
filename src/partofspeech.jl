abstract type AbstractFeature end
abstract type AbstractPartOfSpeech <: AbstractFeature end
abstract type AbstractNominal <: AbstractPartOfSpeech end
abstract type AbstractState <: AbstractNominal end
abstract type AbstractCase <: AbstractNominal end
abstract type AbstractPreposition <: AbstractPartOfSpeech end
abstract type AbstractParticle <: AbstractPartOfSpeech end
abstract type AbstractDisLetters <: AbstractPartOfSpeech end
abstract type AbstractConjunction <: AbstractPartOfSpeech end
abstract type AbstractPerson <: AbstractPartOfSpeech end
abstract type AbstractGender <: AbstractPartOfSpeech end
abstract type AbstractNumber <: AbstractPartOfSpeech end
abstract type AbstractNoun <: AbstractPartOfSpeech end
abstract type AbstractDerivedNominal <: AbstractPartOfSpeech end
abstract type AbstractPronoun <: AbstractPartOfSpeech end
abstract type AbstractAdverb <: AbstractPartOfSpeech end
abstract type AbstractVerb <: AbstractPartOfSpeech end
abstract type AbstractAspect <: AbstractVerb end
abstract type AbstractMood <: AbstractVerb end
abstract type AbstractVoice <: AbstractVerb end
abstract type AbstractForm <: AbstractVerb end
abstract type AbstractPrefix <: AbstractPartOfSpeech end
abstract type AbstractSuffix <: AbstractPartOfSpeech end
abstract type AbstractDerivedNoun <: AbstractPartOfSpeech end

macro partofspeech(name, parent, data, desc, ar_label)
    esc(quote
        struct $name <: $parent
            data::Symbol
            desc::String
            ar_label::String
        end
        
        $name() = $name($data, $desc, $ar_label)
    end)
end

@partofspeech Noun AbstractNoun Symbol("N") "Noun" "اسم"
@partofspeech ProperNoun AbstractNoun Symbol("PN") "Proper noun" "اسم علم"

@partofspeech Adjective AbstractDerivedNominal Symbol("ADJ") "Adjective" "صفة"
@partofspeech ImperativeVerbalNoun AbstractDerivedNominal Symbol("IMPN") "Imperative verbal noun" "اسم فعل أمر"

@partofspeech Personal AbstractPronoun Symbol("PRON") "Personal pronoun" "ضمير"
@partofspeech Demonstrative AbstractPronoun Symbol("DEM") "Demonstrative pronoun" "اسم اشارة"
@partofspeech Relative AbstractPronoun Symbol("REL") "Relative pronoun" "اسم موصول"

@partofspeech Time AbstractAdverb Symbol("T") "Time adverb" "ظرف زمان"
@partofspeech Location AbstractAdverb Symbol("LOC") "Location adverb" "ظرف مكان"

@partofspeech Preposition AbstractPreposition Symbol("P") "Preposition" "حرف جر"

@partofspeech EmphaticLam AbstractPrefix Symbol("EMPH") "Emphatic lam prefix" "لام التوكيد"
@partofspeech ImperativeLam AbstractPrefix Symbol("IMPV") "Imperative lam prefix" "لام الامر"
@partofspeech PurposeLam AbstractPrefix Symbol("PRP") "Purpose lam prefix" "لام التعليل"
@partofspeech EmphaticNun AbstractPrefix Symbol("+n:EMPH") "Emphatic lam prefix" "لام التوكيد"

@partofspeech Coordinating AbstractConjunction Symbol("CONJ") "Coordinating conjunction" "حرف عطف"
@partofspeech Subordinating AbstractConjunction Symbol("SUB") "Subordinating particle" "حرف مصدري"

@partofspeech Accusative AbstractParticle Symbol("ACC") "Accusative particle" "حرف نصب"
@partofspeech Amendment AbstractParticle Symbol("AMD") "Amendment particle" "حرف استدراك"
@partofspeech Answer AbstractParticle Symbol("ANS") "Answer particle" "حرف جواب"
@partofspeech Aversion AbstractParticle Symbol("AVR") "Aversion particle" "حرف ردع"
@partofspeech Cause AbstractParticle Symbol("CAUS") "Particle of cause" "حرف سببية"
@partofspeech Certainty AbstractParticle Symbol("CERT") "Particle of certainty" "حرف تحقيق"
@partofspeech Circumstantial AbstractParticle Symbol("CIRC") "Circumstantial particle" "حرف حال"
@partofspeech Comitative AbstractParticle Symbol("COM") "Comitative particle" "واو المعية"
@partofspeech Conditional AbstractParticle Symbol("COND") "Conditional particle" "حرف شرط"
@partofspeech Equalization AbstractParticle Symbol("EQ") "Equalization particle" "حرف تسوية"
@partofspeech Exhortation AbstractParticle Symbol("EXH") "Exhortation particle" "حرف تحضيض"
@partofspeech Explanation AbstractParticle Symbol("EXL") "Explanation particle" "حرف تفصيل"
@partofspeech Exceptive AbstractParticle Symbol("EXP") "Exceptive particle" "أداة استثناء"
@partofspeech Future AbstractParticle Symbol("FUT") "Future particle" "حرف استقبال"
@partofspeech Inceptive AbstractParticle Symbol("INC") "Inceptive particle" "حرف ابتداء"
@partofspeech Interpretation AbstractParticle Symbol("INT") "Inceptive particle" "حرف تفسير"
@partofspeech Interogative AbstractParticle Symbol("INTG") "Interogative particle" "حرف استفهام"
@partofspeech Negative AbstractParticle Symbol("NEG") "Negative particle" "حرف نفي"
@partofspeech Preventive AbstractParticle Symbol("PREV") "Preventive particle" "حرف كاف"
@partofspeech Prohibition AbstractParticle Symbol("PRO") "Prohibition particle" "حرف نهي"
@partofspeech Resumption AbstractParticle Symbol("REM") "Resumption particle" "حرف استئنافية"
@partofspeech Restriction AbstractParticle Symbol("RES") "Restriction particle" "أداة حصر"
@partofspeech Retraction AbstractParticle Symbol("RET") "Retraction particle" "حرف اضراب"
@partofspeech Result AbstractParticle Symbol("RSLT") "Result particle" "حرف واقع في جواب الشرط"
@partofspeech Supplemental AbstractParticle Symbol("SUP") "Suplemental particle" "حرف زائد"
@partofspeech Surprise AbstractParticle Symbol("SUR") "Surprise particle" "حرف فجاءة"
@partofspeech Vocative AbstractParticle Symbol("VOC") "Vocative particle" "حرف نداء"

@partofspeech DisconnectedLetters AbstractDisLetters Symbol("INL") "Quranic initials" "حروف مقطعة"

@partofspeech FirstPerson AbstractPerson Symbol("1") "First person" "الاسناد"
@partofspeech SecondPerson AbstractPerson Symbol("2") "Second person" "الاسناد"
@partofspeech ThirdPerson AbstractPerson Symbol("3") "Third person" "الاسناد"

@partofspeech Masculine AbstractGender Symbol("M") "Masculine" "الجنس"
@partofspeech Feminine AbstractGender Symbol("F") "Feminine" "الجنس"

@partofspeech Singular AbstractNumber Symbol("S") "Singular" "العدد"
@partofspeech Dual AbstractNumber Symbol("D") "Dual" "العدد"
@partofspeech Plural AbstractNumber Symbol("P") "Plural" "العدد"

@partofspeech Verb AbstractPartOfSpeech Symbol("V") "Verb" "فعل"
@partofspeech Perfect AbstractAspect Symbol("PERF") "Perfect verb" "فعل ماض"
@partofspeech Imperfect AbstractAspect Symbol("IMPF") "Imperfect verb" "فعل مضارع"
@partofspeech Imperative AbstractAspect Symbol("IMPV") "Imperative verb" "فعل أمر"
@partofspeech Indicative AbstractMood Symbol("IND") "Indicative mood (default)" "مرفوع"
@partofspeech Subjunctive AbstractMood Symbol("SUBJ") "Subjunctive mood" "منصوب"
@partofspeech Jussive AbstractMood Symbol("JUS") "Jussive mood" "مجزوم"
@partofspeech Active AbstractVoice Symbol("ACT") "Active voice (default)" "مبني للمعلوم"
@partofspeech Passive AbstractVoice Symbol("PASS") "Passive voice" "مبني للمجهول"

@partofspeech VerbFormI AbstractForm Symbol("I") "First verb form (default)" "فعل"
@partofspeech VerbFormII AbstractForm Symbol("II") "Second verb form" "فعل"
@partofspeech VerbFormIII AbstractForm Symbol("III") "Third verb form" "فعل"
@partofspeech VerbFormIV AbstractForm Symbol("IV") "Fourth verb form" "فعل"
@partofspeech VerbFormV AbstractForm Symbol("V") "Fifth verb form" "فعل"
@partofspeech VerbFormVI AbstractForm Symbol("VI") "Sixth verb form" "فعل"
@partofspeech VerbFormVII AbstractForm Symbol("VII") "Seventh verb form" "فعل"
@partofspeech VerbFormVIII AbstractForm Symbol("VIII") "Eighth verb form" "فعل"
@partofspeech VerbFormIX AbstractForm Symbol("IX") "Ninth verb form" "فعل"
@partofspeech VerbFormX AbstractForm Symbol("X") "Tenth verb form" "فعل"
@partofspeech VerbFormXI AbstractForm Symbol("XI") "Eleventh verb form" "فعل"
@partofspeech VerbFormXII AbstractForm Symbol("XII") "Twelfth verb form" "فعل"

@partofspeech ActiveParticle AbstractDerivedNoun Symbol("ACT PCPL") "Active particle" "اسم فاعل" 
@partofspeech PassiveParticle AbstractDerivedNoun Symbol("PASS PCPL") "Passive particle" "اسم مفعول"  
@partofspeech VerbalNoun AbstractDerivedNoun Symbol("VN") "Verbal noun" "مصدر"

@partofspeech Definite AbstractState Symbol("DEF") "Definite state" "معرفة"
@partofspeech Indefinite AbstractState Symbol("INDEF") "Indefinite state" "نكرة"
@partofspeech Nominative AbstractCase Symbol("NOM") "Nominative case" "مرفوع"
@partofspeech Genetive AbstractCase Symbol("GEN") "Genetive case" "مجرور"