Morphological Features
=====
QuranTree.jl provides complete types for all morphological features and part of speech of [The Quranic Arabic Corpus](https://corpus.quran.com/). 
## Parsing
The features of each token are encoded as `String` in its raw form, and in order to parse this as morphological feature, the function `parse(Features, x)` is used, where `x` is the raw `String` input. For example, the following will parse the 2nd part of the 3rd word of 1st verse of Chapter 1:
```@setup abc
using Pkg
Pkg.add("JuliaDB")
```
```@repl abc
using QuranTree
using JuliaDB

crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
crpsdata[1][1][3][2]
token = select(crpsdata[1][1][3][2].data, :features)
mfeat = parse(Features, token[1])
typeof(mfeat)
```
!!! info "Note"
    You need to install [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl) to successfully run the code. 
    ```julia
    using Pkg
    Pkg.add("JuliaDB")
    ```

## Extracting Detailed Description
To see the detailed description of the features, `@desc` is used.
```@repl abc
@desc mfeat
```
The Julia's `dump` function can be used as to how to access the properties of the `Stem` object.
```@repl abc
dump(mfeat)

# access other feats of the token
mfeat.feats
```
## Checking Parts of Speech
`isfeature(token, pos)` checks whether the `token`'s parsed feature is a particular part of speech (`pos`). For example, the following checks whether `mfeat` above, among others, is indeed `Masculine` and `Singular`.
```@repl abc
isfeature(mfeat, Masculine)
isfeature(mfeat, Feminine)
isfeature(mfeat, Singular)
isfeature(mfeat, Adjective) && isfeature(mfeat, Genetive)
```
Another example on checking whether the token has `Root` and `Lemma` features.
```@repl abc
isfeature(mfeat, Root) && isfeature(mfeat, Lemma)
```
!!! tip "Tips"
    `isfeature(...)` is useful when working with the JuliaDB.jl's filter function, instead of using regular expressions. For example,
    ```julia
    using Pkg
    Pkg.add("PrettyTables")
    ```
    ```julia
    using PrettyTables
    @ptconf vcrop_mode=:middle tf=tf_compact

    tbl = filter(t -> isfeature(parse(Features, t.features), ActiveParticle), crpsdata.data)

    @pt select(tbl, Not(:word, :part, :tag))
    ```
## Lemma, Root and Special
`root`, `lemma` and `special` functions are used for extracting the Root, Lemma and Special morphological features, respectively. 
```@repl abc
root(mfeat)
lemma(mfeat)

arabic(root(mfeat))
arabic(lemma(mfeat))
```
The following example shows token with `Special` feature:
```@repl abc
token2 = select(crpsdata.data, :features)[53]
mfeat2 = parse(Features, token2)
special(mfeat2)
arabic(special(mfeat2))
```
## Implied Verb Features
Some features of Quranic Arabic Verbs are implied. For example, the *Voice* feature of the Verb is default to *Active voice*, the *Mood* feature is default to *Indicative mood*, and the *Verb form* feature is default to *First form*. 
```@repl abc
token3 = select(crpsdata.data, :features)[27]
```
`token3` is a `Verb` with no *Mood* and *Verb form* features stated. However, parsing this will automatically add the default values of the said features as shown below:
```@repl abc
mfeat3 = parse(Features, token3)
@desc mfeat3
```
Another example where the *Voice* feature of the Verb is implied:
```@repl abc
token4 = select(crpsdata.data, :features)[27]
mfeat4 = parse(Features, token4)
@desc mfeat4
```
## POS Abstract Types
The table below contains the complete list of the Part of Speech with its corresponding types. As shown in the table below, each part of speech has a corresponding parent type, which is a superset type in the Type Hierarchy. This is useful for grouping. For example, instead of using `||` (or) in checking for all tokens that are either `FirstPerson`, `SecondPerson`, or `ThirdPerson`, the parent type `AbstractPerson` can be used.
```@repl abc
# without using parent type
function allpersons(t)
    is1st = isfeature(parse(Features, t.features), FirstPerson)
    is2nd = isfeature(parse(Features, t.features), SecondPerson)
    is3rd = isfeature(parse(Features, t.features), ThirdPerson)
    
    return is1st || is2nd || is3rd
end
tbl1 = filter(allpersons, crpsdata.data);
select(tbl1, (:form, :features))
# using parent type
tbl2 = filter(t -> isfeature(parse(Features, t.features), AbstractPerson), crpsdata.data);
select(tbl2, (:form, :features))

sum(select(tbl1, :features) .!== select(tbl2, :features))
```
## Part of Speech Types
```@raw html
<table>
<thead><td>Type</td><td>Parent Type</td><td>Tag</td><td>Description</td><td>Arabic Name</td></thead>
<tr><td><code> Noun</code></td><td><code>AbstractNoun</code></td><td><code>Symbol("N")</code></td><td>Noun</td><td style="text-align:right !important">اسم</td></tr>
<tr><td><code> ProperNoun</code></td><td><code>AbstractNoun</code></td><td><code>Symbol("PN")</code></td><td>Proper noun</td><td style="text-align:right !important">اسم علم</td></tr>

<tr><td><code> Adjective</code></td><td><code>AbstractDerivedNominal</code></td><td><code>Symbol("ADJ")</code></td><td>Adjective</td><td style="text-align:right !important">صفة</td></tr>
<tr><td><code> ImperativeVerbalNoun</code></td><td><code>AbstractDerivedNominal</code></td><td><code>Symbol("IMPN")</code></td><td>Imperative verbal noun</td><td style="text-align:right !important">اسم فعل أمر</td></tr>

<tr><td><code> Personal</code></td><td><code>AbstractPronoun</code></td><td><code>Symbol("PRON")</code></td><td>Personal pronoun</td><td style="text-align:right !important">ضمير</td></tr>
<tr><td><code> Demonstrative</code></td><td><code>AbstractPronoun</code></td><td><code>Symbol("DEM")</code></td><td>Demonstrative pronoun</td><td style="text-align:right !important">اسم اشارة</td></tr>
<tr><td><code> Relative</code></td><td><code>AbstractPronoun</code></td><td><code>Symbol("REL")</code></td><td>Relative pronoun</td><td style="text-align:right !important">اسم موصول</td></tr>

<tr><td><code> Time</code></td><td><code>AbstractAdverb</code></td><td><code>Symbol("T")</code></td><td>Time adverb</td><td style="text-align:right !important">ظرف زمان</td></tr>
<tr><td><code> Location</code></td><td><code>AbstractAdverb</code></td><td><code>Symbol("LOC")</code></td><td>Location adverb</td><td style="text-align:right !important">ظرف مكان</td></tr>

<tr><td><code> Preposition</code></td><td><code>AbstractPreposition</code></td><td><code>Symbol("P")</code></td><td>Preposition</td><td style="text-align:right !important">حرف جر</td></tr>

<tr><td><code> EmphaticLam</code></td><td><code>AbstractPrefix</code></td><td><code>Symbol("EMPH")</code></td><td>Emphatic lam prefix</td><td style="text-align:right !important">لام التوكيد</td></tr>
<tr><td><code> ImperativeLam</code></td><td><code>AbstractPrefix</code></td><td><code>Symbol("IMPV")</code></td><td>Imperative lam prefix</td><td style="text-align:right !important">لام الامر</td></tr>
<tr><td><code> PurposeLam</code></td><td><code>AbstractPrefix</code></td><td><code>Symbol("PRP")</code></td><td>Purpose lam prefix</td><td style="text-align:right !important">لام التعليل</td></tr>
<tr><td><code> EmphaticNun</code></td><td><code>AbstractPrefix</code></td><td><code>Symbol("+n:EMPH")</code></td><td>Emphatic lam prefix</td><td style="text-align:right !important">لام التوكيد</td></tr>

<tr><td><code> Coordinating</code></td><td><code>AbstractConjunction</code></td><td><code>Symbol("CONJ")</code></td><td>Coordinating conjunction</td><td style="text-align:right !important">حرف عطف</td></tr>
<tr><td><code> Subordinating</code></td><td><code>AbstractConjunction</code></td><td><code>Symbol("SUB")</code></td><td>Subordinating particle</td><td style="text-align:right !important">حرف مصدري</td></tr>

<tr><td><code> Accusative</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("ACC")</code></td><td>Accusative particle</td><td style="text-align:right !important">حرف نصب</td></tr>
<tr><td><code> Amendment</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("AMD")</code></td><td>Amendment particle</td><td style="text-align:right !important">حرف استدراك</td></tr>
<tr><td><code> Answer</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("ANS")</code></td><td>Answer particle</td><td style="text-align:right !important">حرف جواب</td></tr>
<tr><td><code> Aversion</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("AVR")</code></td><td>Aversion particle</td><td style="text-align:right !important">حرف ردع</td></tr>
<tr><td><code> Cause</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("CAUS")</code></td><td>Particle of cause</td><td style="text-align:right !important">حرف سببية</td></tr>
<tr><td><code> Certainty</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("CERT")</code></td><td>Particle of certainty</td><td style="text-align:right !important">حرف تحقيق</td></tr>
<tr><td><code> Circumstantial</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("CIRC")</code></td><td>Circumstantial particle</td><td style="text-align:right !important">حرف حال</td></tr>
<tr><td><code> Comitative</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("COM")</code></td><td>Comitative particle</td><td style="text-align:right !important">واو المعية</td></tr>
<tr><td><code> Conditional</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("COND")</code></td><td>Conditional particle</td><td style="text-align:right !important">حرف شرط</td></tr>
<tr><td><code> Equalization</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("EQ")</code></td><td>Equalization particle</td><td style="text-align:right !important">حرف تسوية</td></tr>
<tr><td><code> Exhortation</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("EXH")</code></td><td>Exhortation particle</td><td style="text-align:right !important">حرف تحضيض</td></tr>
<tr><td><code> Explanation</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("EXL")</code></td><td>Explanation particle</td><td style="text-align:right !important">حرف تفصيل</td></tr>
<tr><td><code> Exceptive</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("EXP")</code></td><td>Exceptive particle</td><td style="text-align:right !important">أداة استثناء</td></tr>
<tr><td><code> Future</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("FUT")</code></td><td>Future particle</td><td style="text-align:right !important">حرف استقبال</td></tr>
<tr><td><code> Inceptive</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("INC")</code></td><td>Inceptive particle</td><td style="text-align:right !important">حرف ابتداء</td></tr>
<tr><td><code> Interpretation</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("INT")</code></td><td>Inceptive particle</td><td style="text-align:right !important">حرف تفسير</td></tr>
<tr><td><code> Interogative</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("INTG")</code></td><td>Interogative particle</td><td style="text-align:right !important">حرف استفهام</td></tr>
<tr><td><code> Negative</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("NEG")</code></td><td>Negative particle</td><td style="text-align:right !important">حرف نفي</td></tr>
<tr><td><code> Preventive</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("PREV")</code></td><td>Preventive particle</td><td style="text-align:right !important">حرف كاف</td></tr>
<tr><td><code> Prohibition</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("PRO")</code></td><td>Prohibition particle</td><td style="text-align:right !important">حرف نهي</td></tr>
<tr><td><code> Resumption</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("REM")</code></td><td>Resumption particle</td><td style="text-align:right !important"حرف استئنافية</td></tr>
<tr><td><code> Restriction</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("RES")</code></td><td>Restriction particle</td><td style="text-align:right !important">أداة حصر</td></tr>
<tr><td><code> Retraction</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("RET")</code></td><td>Retraction particle</td><td style="text-align:right !important">حرف اضراب</td></tr>
<tr><td><code> Result</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("RSLT")</code></td><td>Result particle</td><td style="text-align:right !important">حرف واقع في جواب الشرط</td></tr>
<tr><td><code> Supplemental</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("SUP")</code></td><td>Suplemental particle</td><td style="text-align:right !important">حرف زائد</td></tr>
<tr><td><code> Surprise</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("SUR")</code></td><td>Surprise particle</td><td style="text-align:right !important">حرف فجاءة</td></tr>
<tr><td><code> Vocative</code></td><td><code>AbstractParticle</code></td><td><code>Symbol("VOC")</code></td><td>Vocative particle</td><td style="text-align:right !important">حرف نداء</td></tr>

<tr><td><code> DisconnectedLetters</code></td><td><code>AbstractDisLetters</code></td><td><code>Symbol("INL")</code></td><td>Quranic initials</td><td style="text-align:right !important">حروف مقطعة</td></tr>

<tr><td><code> FirstPerson</code></td><td><code>AbstractPerson</code></td><td><code>Symbol("1")</code></td><td>First person</td><td style="text-align:right !important">الاسناد</td></tr>
<tr><td><code> SecondPerson</code></td><td><code>AbstractPerson</code></td><td><code>Symbol("2")</code></td><td>Second person</td><td style="text-align:right !important">الاسناد</td></tr>
<tr><td><code> ThirdPerson</code></td><td><code>AbstractPerson</code></td><td><code>Symbol("3")</code></td><td>Third person</td><td style="text-align:right !important">الاسناد</td></tr>

<tr><td><code> Masculine</code></td><td><code>AbstractGender</code></td><td><code>Symbol("M")</code></td><td>Masculine</td><td style="text-align:right !important">الجنس</td></tr>
<tr><td><code> Feminine</code></td><td><code>AbstractGender</code></td><td><code>Symbol("F")</code></td><td>Feminine</td><td style="text-align:right !important">الجنس</td></tr>

<tr><td><code> Singular</code></td><td><code>AbstractNumber</code></td><td><code>Symbol("S")</code></td><td>Singular</td><td style="text-align:right !important">العدد</td></tr>
<tr><td><code> Dual</code></td><td><code>AbstractNumber</code></td><td><code>Symbol("D")</code></td><td>Dual</td><td style="text-align:right !important">العدد</td></tr>
<tr><td><code> Plural</code></td><td><code>AbstractNumber</code></td><td><code>Symbol("P")</code></td><td>Plural</td><td style="text-align:right !important">العدد</td></tr>

<tr><td><code> Verb</code></td><td><code>AbstractPartOfSpeech</code></td><td><code>Symbol("V")</code></td><td>Verb</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> Perfect</code></td><td><code>AbstractAspect</code></td><td><code>Symbol("PERF")</code></td><td>Perfect verb</td><td style="text-align:right !important">فعل ماض</td></tr>
<tr><td><code> Imperfect</code></td><td><code>AbstractAspect</code></td><td><code>Symbol("IMPF")</code></td><td>Imperfect verb</td><td style="text-align:right !important">فعل مضارع</td></tr>
<tr><td><code> Imperative</code></td><td><code>AbstractAspect</code></td><td><code>Symbol("IMPV")</code></td><td>Imperative verb</td><td style="text-align:right !important">فعل أمر</td></tr>
<tr><td><code> Indicative</code></td><td><code>AbstractMood</code></td><td><code>Symbol("IND")</code></td><td>Indicative mood (default)</td><td style="text-align:right !important">مرفوع</td></tr>
<tr><td><code> Subjunctive</code></td><td><code>AbstractMood</code></td><td><code>Symbol("SUBJ")</code></td><td>Subjunctive mood</td><td style="text-align:right !important">منصوب</td></tr>
<tr><td><code> Jussive</code></td><td><code>AbstractMood</code></td><td><code>Symbol("JUS")</code></td><td>Jussive mood</td><td style="text-align:right !important">مجزوم</td></tr>
<tr><td><code> Active</code></td><td><code>AbstractVoice</code></td><td><code>Symbol("ACT")</code></td><td>Active voice (default)</td><td style="text-align:right !important">مبني للمعلوم</td></tr>
<tr><td><code> Passive</code></td><td><code>AbstractVoice</code></td><td><code>Symbol("PASS")</code></td><td>Passive voice</td><td style="text-align:right !important">مبني للمجهول</td></tr>

<tr><td><code> VerbFormI</code></td><td><code>AbstractForm</code></td><td><code>Symbol("I")</code></td><td>First verb form (default)</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormII</code></td><td><code>AbstractForm</code></td><td><code>Symbol("II")</code></td><td>Second verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormIII</code></td><td><code>AbstractForm</code></td><td><code>Symbol("III")</code></td><td>Third verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormIV</code></td><td><code>AbstractForm</code></td><td><code>Symbol("IV")</code></td><td>Fourth verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormV</code></td><td><code>AbstractForm</code></td><td><code>Symbol("V")</code></td><td>Fifth verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormVI</code></td><td><code>AbstractForm</code></td><td><code>Symbol("VI")</code></td><td>Sixth verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormVII</code></td><td><code>AbstractForm</code></td><td><code>Symbol("VII")</code></td><td>Seventh verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormVIII</code></td><td><code>AbstractForm</code></td><td><code>Symbol("VIII")</code></td><td>Eighth verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormIX</code></td><td><code>AbstractForm</code></td><td><code>Symbol("IX")</code></td><td>Ninth verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormX</code></td><td><code>AbstractForm</code></td><td><code>Symbol("X")</code></td><td>Tenth verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormXI</code></td><td><code>AbstractForm</code></td><td><code>Symbol("XI")</code></td><td>Eleventh verb form</td><td style="text-align:right !important">فعل</td></tr>
<tr><td><code> VerbFormXII</code></td><td><code>AbstractForm</code></td><td><code>Symbol("XII")</code></td><td>Twelfth verb form</td><td style="text-align:right !important">فعل</td></tr>

<tr><td><code> ActiveParticle</code></td><td><code>AbstractDerivedNoun</code></td><td><code>Symbol("ACT PCPL")</code></td><td>Active particle</td><td style="text-align:right !important">اسم فاعل</td></tr>
<tr><td><code> PassiveParticle</code></td><td><code>AbstractDerivedNoun</code></td><td><code>Symbol("PASS PCPL")</code></td><td>Passive particle</td><td style="text-align:right !important">اسم مفعول</td></tr>
<tr><td><code> VerbalNoun</code></td><td><code>AbstractDerivedNoun</code></td><td><code>Symbol("VN")</code></td><td>Verbal noun</td><td style="text-align:right !important">مصدر</td></tr>

<tr><td><code> Definite</code></td><td><code>AbstractState</code></td><td><code>Symbol("DEF")</code></td><td>Definite state</td><td style="text-align:right !important">معرفة</td></tr>
<tr><td><code> Indefinite</code></td><td><code>AbstractState</code></td><td><code>Symbol("INDEF")</code></td><td>Indefinite state</td><td style="text-align:right !important">نكرة</td></tr>
<tr><td><code> Nominative</code></td><td><code>AbstractCase</code></td><td><code>Symbol("NOM")</code></td><td>Nominative case</td><td style="text-align:right !important">مرفوع</td></tr>
<tr><td><code> Genetive</code></td><td><code>AbstractCase</code></td><td><code>Symbol("GEN")</code></td><td>Genetive case</td><td style="text-align:right !important">مجرور</td></tr>
</table>
```