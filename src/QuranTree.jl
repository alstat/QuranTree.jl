module QuranTree
using DataFrames: DataFrame, Not, groupby, filter, nrow, combine

include("partofspeech.jl")
include("constants.jl")
include("features.jl")
include("qurantypes.jl")
include("index.jl")
include("decode.jl")
include("load.jl")
include("print.jl")

export @data, @desc, load, table, verses, chapter_name, lemma, root, words, special
export CorpusRaw, TanzilRaw, CorpusData, TanzilData, QuranData, Suffix, Prefix, Stem, QuranFeatures, MetaData, Root, Lemma, Special
export AbstractQuran, AbstractQuranFeature, AbstractPartOfSpeech,
       AbstractNominal, AbstractState, AbstractCase,
       AbstractPreposition, AbstractParticle, AbstractDisLetters,
       AbstractConjunction, AbstractPerson, AbstractGender,
       AbstractNumber, AbstractNoun, AbstractDerivedNominal,
       AbstractPronoun, AbstractAdverb, AbstractVerb, 
       AbstractAspect, AbstractMood, AbstractVoice, 
       AbstractVerbForm, AbstractPrefix, AbstractSuffix
export Noun, ProperNoun, Adjective, ImperativeVerbalNoun,
       Personal, Demonstrative, Relative, Time, Location,
       Preposition, EmphaticLam, ImperativeLam, PurposeLam,
       EmphaticNun, Coordinating, Subordinating, Accusative,
       Amendment, Answer, Aversion, Cause, Certainty,
       Circumstantial, Comitative, Conditional, Equalization,
       Exhortation, Explanation, Exceptive, Future,
       Inceptive, Interpretation, Interogative, Negative,
       Preventive, Prohibition, Resumption, Restriction, 
       Retraction, Result, Supplemental, Surprise, Vocative,
       DisconnectedLetters, FirstPerson, SecondPerson,
       ThirdPerson, Masculine, Feminine, Singular, Dual,
       Plural, Verb, Perfect, Imperfect, Imperative, 
       Indicative, Subjunctive, Jussive, Active, Passive,
       VerbFormI, VerbFormII, VerbFormIII, VerbFormIV,
       VerbFormV, VerbFormVI, VerbFormVII, VerbFormVIII,
       VerbFormIX, VerbFormX, VerbFormXI, VerbFormXII,
       ActiveParticle, PassiveParticle, VerbalNoun, Definite,
       Indefinite, Nominative, Genetive
end