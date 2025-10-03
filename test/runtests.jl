using QuranTree
using Test
using Suppressor: @capture_out
using DataFrames
using Yunir

function capture_io(x)
    io = IOBuffer()
    println(io, x)
    return String(take!(io))
end

@testset "QuranTree.jl" begin
    data = QuranData()
    crps, tnzl = load(data)
    # nrow(crps.data)
    # data
    out = capture_io(crps)[1:3000]
    @test out === "CorpusRaw([\"# PLEASE DO NOT REMOVE OR CHANGE THIS COPYRIGHT BLOCK\", \"#====================================================================\", \"#\", \"#  Quranic Arabic Corpus (morphology, version 0.4)\", \"#  Copyright (C) 2011 Kais Dukes\", \"#  License: GNU General Public License\", \"#\", \"#  The Quranic Arabic Corpus includes syntactic and morphological\", \"#  annotation of the Quran, and builds on the verified Arabic text\", \"#  distributed by the Tanzil project.\", \"#\", \"#  TERMS OF USE:\", \"#\", \"#  - Permission is granted to copy and distribute verbatim copies\", \"#    of this file, but CHANGING IT IS NOT ALLOWED.\", \"#\", \"#  - This annotation can be used in any website or application,\", \"#    provided its source (the Quranic Arabic Corpus) is clearly\", \"#    indicated, and a link is made to http://corpus.quran.com to enable\", \"#    users to keep track of changes.\", \"#\", \"#  - This copyright notice shall be included in all verbatim copies\", \"#    of the text, and shall be reproduced appropriately in all works\", \"#    derived from or containing substantial portion of this file.\", \"#\", \"#  Please check updates at: http://corpus.quran.com/download\", \"\", \"# PLEASE DO NOT REMOVE OR CHANGE THIS COPYRIGHT BLOCK\", \"#====================================================================\", \"#\", \"#  Tanzil Quran Text (Uthmani, version 1.0.2)\", \"#  Copyright (C) 2008-2009 Tanzil.info\", \"#  License: Creative Commons BY-ND 3.0 Unported\", \"#\", \"#  This copy of quran text is carefully produced, highly\", \"#  verified and continuously monitored by a group of specialists\", \"#  at Tanzil project.\", \"#\", \"#  TERMS OF USE:\", \"#\", \"#  - Permission is granted to copy and distribute verbatim copies\", \"#    of this text, but CHANGING IT IS NOT ALLOWED.\", \"#\", \"#  - This quran text can be used in any website or application,\", \"#    provided its source (Tanzil.info) is clearly indicated, and\", \"#    a link is made to http://tanzil.info to enable users to keep\", \"#    track of changes.\", \"#\", \"#  - This copyright notice shall be included in all verbatim copies\", \"#    of the text, and shall be reproduced appropriately in all files\", \"#    derived from or containing substantial portion of this text.\", \"#\", \"#  Please check updates at: http://tanzil.info/updates/\", \"#\", \"#====================================================================\", \"\", \"LOCATION\\tFORM\\tTAG\\tFEATURES\", \"(1:1:1:1)\\tbi\\tP\\tPREFIX|bi+\", \"(1:1:1:2)\\tsomi\\tN\\tSTEM|POS:N|LEM:{som|ROOT:smw|M|GEN\", \"(1:1:2:1)\\t{ll~ahi\\tPN\\tSTEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\", \"(1:1:3:1)\\t{l\\tDET\\tPREFIX|Al+\", \"(1:1:3:2)\\tr~aHoma`ni\\tADJ\\tSTEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\", \"(1:1:4:1)\\t{l\\tDET\\tPREFIX|Al+\", \"(1:1:4:2)\\tr~aHiymi\\tADJ\\tSTEM|POS:ADJ|LEM:r~aHiym|ROOT:rHm|MS|GEN\", \"(1:2:1:1)\\t{lo\\tDET\\tPREFIX|Al+\", \"(1:2:1:2)\\tHamodu\\tN\\tSTEM|POS:N|LEM:Hamod|ROOT:Hmd|M|NOM\", \"(1:2:2:1)\\tli\\tP\\tPREFIX|l:P+\", \"(1:2:2:2)\\tl~ahi\\tPN\\tSTEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\", \"(1:2:3:1)\\trab~i\\tN\\tSTEM|POS:N|LEM:rab~|ROOT:rbb|M|GEN\", \"(1:2:4"

    out = capture_io(tnzl)[1:1000]
    @test out === "TanzilRaw([\"1|1|بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\", \"1|2|ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ\", \"1|3|ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\", \"1|4|مَٰلِكِ يَوْمِ ٱلدِّينِ\", \"1|5|إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\", \"1|6|ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ\", \"1|7|صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ\", \"2|1|بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ الٓمٓ\", \"2|2|ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ\", \"2|3|ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُو"

    @test crps[end] === "(114:6:3:3)\tn~aAsi\tN\tSTEM|POS:N|LEM:n~aAs|ROOT:nws|MP|GEN"
    @test tnzl[begin] === "1|1|بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test typeof(crps) === CorpusRaw
    @test typeof(tnzl) === TanzilRaw

    # indexing
    crpsdata = table(crps)
    tnzldata = table(tnzl)
    
    out = capture_io(crpsdata)[1:1000]
    @test out === "Quranic Arabic Corpus (morphology)\n(C) 2011 Kais Dukes\n\n128219×7 DataFrame\n    Row │ chapter  verse  word   part   form              tag     features\n        │ Int64    Int64  Int64  Int64  String            String  String\n────────┼───────────────────────────────────────────────────────────────────────────────────────────\n      1 │       1      1      1      1  bi                P       PREFIX|bi+\n      2 │       1      1      1      2  somi              N       STEM|POS:N|LEM:{som|ROOT:smw|M|G…\n      3 │       1      1      2      1  {ll~ahi           PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n      4 │       1      1      3      1  {l                DET     PREFIX|Al+\n      5 │       1      1      3      2  r~aHoma`ni        ADJ     STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:…\n "
    
    out = capture_io(tnzldata)[1:1000]
    @test out === "Tanzil Quran Text (Uthmani)\n(C) 2008-2010 Tanzil.net\n\n6236×3 DataFrame\n  Row │ chapter  verse  form\n      │ Int64    Int64  String\n──────┼───────────────────────────────────────────────────\n    1 │       1      1  بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\n    2 │       1      2  ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ\n    3 │       1      3  ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\n    4 │       1      4  مَٰلِكِ يَوْمِ ٱلدِّينِ\n    5 │       1      5  إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n    6 │       1      6  ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ\n    7 │       1      7  صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُو…\n    8 │   "

    @test crpsdata[begin].data[1, :form] === "bi"
    @test crpsdata[114][2][1][1].data[1, :features] === "STEM|POS:N|LEM:malik|ROOT:mlk|MS|GEN"
    @test crpsdata[114][2][1:2][1].data[2, :features] === "PREFIX|Al+"
    @test crpsdata[114][4][[1,2,3]][1].data[2, :features] === "STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|GEN"
    
    @test crpsdata[114][1:3][1][1].data[3, :features] === "STEM|POS:N|LEM:<ila`h|ROOT:Alh|MS|GEN"
    @test crpsdata[112][1:3][1:3][2].data[1, :features] === "STEM|POS:N|LEM:S~amad|ROOT:Smd|MS|NOM"
    @test crpsdata[112][1:3][[2,4]][1].data[3, :features] === "PREFIX|Al+"
    
    @test crpsdata[111][[2,3]][1][1].data[1, :features] === "STEM|POS:NEG|LEM:maA"
    @test crpsdata[111][[2,3]][1:3][2].data[2, :features] === "STEM|POS:V|IMPF|LEM:yaSolaY|ROOT:Sly|3MS"
    @test crpsdata[111][[2,3]][[1,3]][1].data[4, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test crpsdata[111:112][1][1][1].data[2, :features] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test crpsdata[111:112][1][1:3][1].data[4, :features] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test crpsdata[111:112][1][[1,2,3]][1].data[4, :features] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"

    @test crpsdata[111:112][1:3][1][1].data[5, :features] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test crpsdata[111:112][1:3][1:3][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test crpsdata[111:112][1:3][[1,2,3]][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test crpsdata[111:112][[1,2,3]][1][1].data[5, :features] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test crpsdata[111:112][[1,2,3]][1:3][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test crpsdata[111:112][[1,2,3]][[1,2,3]][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test crpsdata[[111,112]][1][1][1].data[2, :features] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test crpsdata[[111,112]][1][1:3][1].data[4, :features] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test crpsdata[[111,112]][1][[1,2,3]][1].data[4, :features] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"

    @test crpsdata[[111,112]][1:3][1][1].data[5, :features] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test crpsdata[[111,112]][1:3][1:3][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test crpsdata[[111,112]][1:3][[1,2,3]][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test crpsdata[[111,112]][[1,2,3]][1][1].data[5, :features] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test crpsdata[[111,112]][[1,2,3]][1:3][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test crpsdata[[111,112]][[1,2,3]][[1,2,3]][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test crpsdata[end-3:end-2][[1,2,3]][1][1].data[5, :features] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test crpsdata[end-3:end-2][[1,2,3]][1:3][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test crpsdata[end-3:end-2][[1,2,3]][[1,2,3]][1].data[9, :features] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test tnzldata[1].data[7, :form] === "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ"
    @test tnzldata[111:113].data[10, :form] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"
    @test tnzldata[[111,112,113]].data[10, :form] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"
    @test tnzldata[end-3:end-1].data[10, :form] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"

    # verses
    @test verses(crpsdata[1])[7] === "Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"
    @test verses(crpsdata[1][1:7])[7] === "Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"
    @test verses(crpsdata[1][7])[1] === "Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"
    @test verses(tnzldata[1][1])[1] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test verses(tnzldata[1][1:2])[2] === "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ"
    @test verses(tnzldata)[1] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    
    # number
    @test verses(crpsdata[113:114], number=true)[1] === "113:(1,5)"
    @test verses(crpsdata[113:114], number=true, start_end=false)[1] == ([113], [1, 2, 3, 4, 5])

    # words
    @test words(tnzldata[1][7])[1] === "صِرَٰطَ"

    # chapter_name
    @test chapter_name(crpsdata[13][2][1]) === "ٱلرَّعْد"
    @test chapter_name(tnzldata[13][2]) === "ٱلرَّعْد"
    @test chapter_name(tnzldata[1], lang=:english) === "The Opening"

    # features
    @test root(parse(QuranFeatures, crpsdata[112].data[1, :features])) === "qwl"
    @test lemma(parse(QuranFeatures, crpsdata[112].data[1, :features])) === "qaAla"
    @test special(parse(QuranFeatures, crpsdata.data[53, :features])) === "<in~"
    @test isfeat(parse(QuranFeatures, crpsdata[1].data[2, :features]), Stem) === true
    @test isfeat(parse(QuranFeatures, crpsdata[1].data[end-4, :features]), Suffix) === true
    @test isfeat(parse(QuranFeatures, crpsdata[1].data[end-3, :features]), Prefix) === true
    @test isfeat(parse(QuranFeatures, crpsdata[1].data[2, :features]), Noun) === true
    @test isfeat(parse(QuranFeatures, crpsdata[1].data[3, :features]), ProperNoun) === true
    @test isfeat(parse(QuranFeatures, crpsdata[1].data[5, :features]), Adjective) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[68054, :features]), ImperativeVerbalNoun) === true
    @test isfeat(parse(QuranFeatures, crpsdata[1].data[23, :features]), Personal) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[50, :features]), Demonstrative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[35, :features]), Relative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[210, :features]), Time) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[291, :features]), Location) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[14, :features]), Plural) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[38, :features]), Preposition) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[419, :features]), EmphaticLam) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[5717, :features]), ImperativeLam) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[2131, :features]), PurposeLam) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[997, :features]), EmphaticNun) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[25, :features]), Coordinating) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[245, :features]), Subordinating) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[31, :features]), Accusative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[233, :features]), Amendment) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[2252, :features]), Answer) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[66305, :features]), Aversion) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[926, :features]), Cause) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[1544, :features]), Certainty) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[166, :features]), Circumstantial) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[14139, :features]), Comitative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[416, :features]), Conditional) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[120, :features]), Equalization) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[3532, :features]), Exhortation) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[618, :features]), Explanation) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[821, :features]), Exceptive) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[17319, :features]), Future) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[226, :features]), Inceptive) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[3758, :features]), Interpretation) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[640, :features]), Interogative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[46, :features]), Negative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[223, :features]), Preventive) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[214, :features]), Prohibition) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[72, :features]), Resumption) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[182, :features]), Restriction) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[2542, :features]), Retraction) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[504, :features]), Result) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[232, :features]), Supplemental) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[18810, :features]), Surprise) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[10975, :features]), Vocative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[49, :features]), DisconnectedLetters) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[24, :features]), FirstPerson) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[23, :features]), SecondPerson) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[39, :features]), ThirdPerson) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[2, :features]), Masculine) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[71, :features]), Feminine) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[5, :features]), Singular) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[2303, :features]), Dual) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[14, :features]), Plural) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[24, :features]), Verb) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[36, :features]), Perfect) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[24, :features]), Imperfect) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[28, :features]), Imperative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[531, :features]), Subjunctive) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[126, :features]), Jussive) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[86, :features]), Passive) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[499, :features]), VerbFormII) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[171, :features]), VerbFormIII) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[36, :features]), VerbFormIV) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[970, :features]), VerbFormV) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[591, :features]), VerbFormVI) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[1538, :features]), VerbFormVII) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[60, :features]), VerbFormVIII) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[13216, :features]), VerbFormIX) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[27, :features]), VerbFormX) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[114155, :features]), VerbFormXI) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[9063, :features]), VerbFormXII) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[19, :features]), ActiveParticle) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[42, :features]), PassiveParticle) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[305, :features]), VerbalNoun) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[57, :features]), Indefinite) === true # no verse with DEF feature
    @test isfeat(parse(QuranFeatures, crpsdata.data[9, :features]), Nominative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[2, :features]), Genitive) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[24, :features]), VerbFormI) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[27, :features]), VerbFormI) === false
    @test isfeat(parse(QuranFeatures, crpsdata.data[27, :features]), Indicative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[126, :features]), Indicative) === false
    @test isfeat(parse(QuranFeatures, crpsdata.data[86, :features]), Active) === false
    @test isfeat(parse(QuranFeatures, crpsdata.data[36, :features]), Active) === true

    @test parse(SimpleEncoding, verses(tnzldata)[1]) === "Ba+Kasra | Seen+Sukun | Meem+Kasra | <space> | AlifHamzatWasl | Lam | Lam+Shadda+Fatha | Ha+Kasra | <space> | AlifHamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Sukun | Meem+Fatha+AlifKhanjareeya | Noon+Kasra | <space> | AlifHamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Kasra | Ya | Meem+Kasra"
    # printing
    out = capture_io(crpsdata[1][1][1][1]);
    @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerse 1\n\n1×5 DataFrame\n Row │ word   part   form    tag     features\n     │ Int64  Int64  String  String  String\n─────┼──────────────────────────────────────────\n   1 │     1      1  bi      P       PREFIX|bi+\n\n"

    out = capture_io(tnzldata[1][1]);
    @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerse 1\n\n1×1 DataFrame\n Row │ form\n     │ String\n─────┼────────────────────────\n   1 │ بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\n\n"

    out = capture_io(Noun());
    @test out === "N\n"

    out = capture_io(crps);
    @test out[5000:6000] === "ka\\tDEM\\tSTEM|POS:DEM|LEM:*a`lik|MS\", \"(2:2:2:1)\\t{lo\\tDET\\tPREFIX|Al+\", \"(2:2:2:2)\\tkita`bu\\tN\\tSTEM|POS:N|LEM:kita`b|ROOT:ktb|M|NOM\", \"(2:2:3:1)\\tlaA\\tNEG\\tSTEM|POS:NEG|LEM:laA|SP:<in~\", \"(2:2:4:1)\\trayoba\\tN\\tSTEM|POS:N|LEM:rayob|ROOT:ryb|M|ACC\", \"(2:2:5:1)\\tfiy\\tP\\tSTEM|POS:P|LEM:fiY\", \"(2:2:5:2)\\thi\\tPRON\\tSUFFIX|PRON:3MS\", \"(2:2:6:1)\\thudFY\\tN\\tSTEM|POS:N|LEM:hudFY|ROOT:hdy|M|INDEF|NOM\", \"(2:2:7:1)\\tl~i\\tP\\tPREFIX|l:P+\", \"(2:2:7:2)\\tlo\\tDET\\tPREFIX|Al+\", \"(2:2:7:3)\\tmut~aqiyna\\tN\\tSTEM|POS:N|ACT|PCPL|(VIII)|LEM:mut~aqiyn|ROOT:wqy|MP|GEN\", \"(2:3:1:1)\\t{l~a*iyna\\tREL\\tSTEM|POS:REL|LEM:{l~a*iY|MP\", \"(2:3:2:1)\\tyu&ominu\\tV\\tSTEM|POS:V|IMPF|(IV)|LEM:'aAmana|ROOT:Amn|3MP\", \"(2:3:2:2)\\twna\\tPRON\\tSUFFIX|PRON:3MP\", \"(2:3:3:1)\\tbi\\tP\\tPREFIX|bi+\", \"(2:3:3:2)\\t{lo\\tDET\\tPREFIX|Al+\", \"(2:3:3:3)\\tgayobi\\tN\\tSTEM|POS:N|LEM:gayob|ROOT:gyb|M|GEN\", \"(2:3:4:1)\\twa\\tCONJ\\tPREFIX|w:CONJ+\", \"(2:3:4:2)\\tyuqiymu\\tV\\tSTEM|POS:V|IMPF|(IV)|LEM:>aqaAma|ROOT:qwm|3MP\", \"(2:3:4:3)\\twna\\tPRON\\tSUFFIX|PRON:3MP\""

    out = capture_io(tnzl);
    @test out[5000:5110] === "ن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ\", \"2|22|ٱلَّذِى جَعَلَ لَكُ"

    out = capture_io(crpsdata[1]);
    @test out === "Chapter 1: ٱلْفَاتِحَة (The Opening)\n\n48×6 DataFrame\n Row │ verse  word   part   form         tag     features\n     │ Int64  Int64  Int64  String       String  String\n─────┼─────────────────────────────────────────────────────────────────────────────\n   1 │     1      1      1  bi           P       PREFIX|bi+\n   2 │     1      1      2  somi         N       STEM|POS:N|LEM:{som|ROOT:smw|M|G…\n   3 │     1      2      1  {ll~ahi      PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   4 │     1      3      1  {l           DET     PREFIX|Al+\n   5 │     1      3      2  r~aHoma`ni   ADJ     STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:…\n   6 │     1      4      1  {l           DET     PREFIX|Al+\n   7 │     1      4      2  r~aHiymi     ADJ     STEM|POS:ADJ|LEM:r~aHiym|ROOT:rH…\n   8 │     2      1      1  {lo          DET     PREFIX|Al+\n   9 │     2      1      2  Hamodu       N       STEM|POS:N|LEM:Hamod|ROOT:Hmd|M|…\n  10 │     2      2      1  li           P       PREFIX|l:P+\n  11 │     2      2      2  l~ahi        PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n  12 │     2      3      1  rab~i        N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  13 │     2      4      1  {lo          DET     PREFIX|Al+\n  14 │     2      4      2  Ea`lamiyna   N       STEM|POS:N|LEM:Ea`lamiyn|ROOT:El…\n  15 │     3      1      1  {l           DET     PREFIX|Al+\n  16 │     3      1      2  r~aHoma`ni   ADJ     STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:…\n  17 │     3      2      1  {l           DET     PREFIX|Al+\n  18 │     3      2      2  r~aHiymi     ADJ     STEM|POS:ADJ|LEM:r~aHiym|ROOT:rH…\n  19 │     4      1      1  ma`liki      N       STEM|POS:N|ACT|PCPL|LEM:ma`lik|R…\n  20 │     4      2      1  yawomi       N       STEM|POS:N|LEM:yawom|ROOT:ywm|M|…\n  21 │     4      3      1  {l           DET     PREFIX|Al+\n  22 │     4      3      2  d~iyni       N       STEM|POS:N|LEM:diyn|ROOT:dyn|M|G…\n  23 │     5      1      1  <iy~aAka     PRON    STEM|POS:PRON|LEM:<iy~aA|2MS\n  24 │     5      2      1  naEobudu     V       STEM|POS:V|IMPF|LEM:Eabada|ROOT:…\n  25 │     5      3      1  wa           CONJ    PREFIX|w:CONJ+\n  26 │     5      3      2  <iy~aAka     PRON    STEM|POS:PRON|LEM:<iy~aA|2MS\n  27 │     5      4      1  nasotaEiynu  V       STEM|POS:V|IMPF|(X)|LEM:{sotaEiy…\n  28 │     6      1      1  {hodi        V       STEM|POS:V|IMPV|LEM:hadaY|ROOT:h…\n  29 │     6      1      2  naA          PRON    SUFFIX|PRON:1P\n  30 │     6      2      1  {l           DET     PREFIX|Al+\n  31 │     6      2      2  S~ira`Ta     N       STEM|POS:N|LEM:Sira`T|ROOT:SrT|M…\n  32 │     6      3      1  {lo          DET     PREFIX|Al+\n  33 │     6      3      2  musotaqiyma  ADJ     STEM|POS:ADJ|ACT|PCPL|(X)|LEM:m~…\n  34 │     7      1      1  Sira`Ta      N       STEM|POS:N|LEM:Sira`T|ROOT:SrT|M…\n  35 │     7      2      1  {l~a*iyna    REL     STEM|POS:REL|LEM:{l~a*iY|MP\n  36 │     7      3      1  >anoEamo     V       STEM|POS:V|PERF|(IV)|LEM:>anoEam…\n  37 │     7      3      2  ta           PRON    SUFFIX|PRON:2MS\n  38 │     7      4      1  Ealayo       P       STEM|POS:P|LEM:EalaY`\n  39 │     7      4      2  himo         PRON    SUFFIX|PRON:3MP\n  40 │     7      5      1  gayori       N       STEM|POS:N|LEM:gayor|ROOT:gyr|M|…\n  41 │     7      6      1  {lo          DET     PREFIX|Al+\n  42 │     7      6      2  magoDuwbi    N       STEM|POS:N|PASS|PCPL|LEM:magoDuw…\n  43 │     7      7      1  Ealayo       P       STEM|POS:P|LEM:EalaY`\n  44 │     7      7      2  himo         PRON    SUFFIX|PRON:3MP\n  45 │     7      8      1  wa           CONJ    PREFIX|w:CONJ+\n  46 │     7      8      2  laA          NEG     STEM|POS:NEG|LEM:laA\n  47 │     7      9      1  {l           DET     PREFIX|Al+\n  48 │     7      9      2  D~aA^l~iyna  N       STEM|POS:N|ACT|PCPL|LEM:DaA^l~|R…\n\n"

    out = capture_io(crpsdata[[112,113]]);
    @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\n\n49×7 DataFrame\n Row │ chapter  verse  word   part   form          tag     features\n     │ Int64    Int64  Int64  Int64  String        String  String\n─────┼───────────────────────────────────────────────────────────────────────────────────────\n   1 │     112      1      1      1  qulo          V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   2 │     112      1      2      1  huwa          PRON    STEM|POS:PRON|3MS\n   3 │     112      1      3      1  {ll~ahu       PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   4 │     112      1      4      1  >aHadN        N       STEM|POS:N|LEM:>aHad|ROOT:AHd|M|…\n   5 │     112      2      1      1  {ll~ahu       PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   6 │     112      2      2      1  {l            DET     PREFIX|Al+\n   7 │     112      2      2      2  S~amadu       N       STEM|POS:N|LEM:S~amad|ROOT:Smd|M…\n   8 │     112      3      1      1  lamo          NEG     STEM|POS:NEG|LEM:lam\n   9 │     112      3      2      1  yalido        V       STEM|POS:V|IMPF|LEM:walada|ROOT:…\n  10 │     112      3      3      1  wa            CONJ    PREFIX|w:CONJ+\n  11 │     112      3      3      2  lamo          NEG     STEM|POS:NEG|LEM:lam\n  12 │     112      3      4      1  yuwlado       V       STEM|POS:V|IMPF|PASS|LEM:walada|…\n  13 │     112      4      1      1  wa            CONJ    PREFIX|w:CONJ+\n  14 │     112      4      1      2  lamo          NEG     STEM|POS:NEG|LEM:lam\n  15 │     112      4      2      1  yakun         V       STEM|POS:V|IMPF|LEM:kaAna|ROOT:k…\n  16 │     112      4      3      1  l~a           P       PREFIX|l:P+\n  17 │     112      4      3      2  hu,           PRON    STEM|POS:PRON|3MS\n  18 │     112      4      4      1  kufuwFA       N       STEM|POS:N|LEM:kufuw|ROOT:kfA|M|…\n  19 │     112      4      5      1  >aHadN[       N       STEM|POS:N|LEM:>aHad|ROOT:AHd|M|…\n  20 │     113      1      1      1  qulo          V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n  21 │     113      1      2      1  >aEuw*u       V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n  22 │     113      1      3      1  bi            P       PREFIX|bi+\n  23 │     113      1      3      2  rab~i         N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  24 │     113      1      4      1  {lo           DET     PREFIX|Al+\n  25 │     113      1      4      2  falaqi        N       STEM|POS:N|LEM:falaq|ROOT:flq|M|…\n  26 │     113      2      1      1  min           P       STEM|POS:P|LEM:min\n  27 │     113      2      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  28 │     113      2      3      1  maA           REL     STEM|POS:REL|LEM:maA\n  29 │     113      2      4      1  xalaqa        V       STEM|POS:V|PERF|LEM:xalaqa|ROOT:…\n  30 │     113      3      1      1  wa            CONJ    PREFIX|w:CONJ+\n  31 │     113      3      1      2  min           P       STEM|POS:P|LEM:min\n  32 │     113      3      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  33 │     113      3      3      1  gaAsiqK       N       STEM|POS:N|ACT|PCPL|LEM:gaAsiq|R…\n  34 │     113      3      4      1  <i*aA         T       STEM|POS:T|LEM:<i*aA\n  35 │     113      3      5      1  waqaba        V       STEM|POS:V|PERF|LEM:waqaba|ROOT:…\n  36 │     113      4      1      1  wa            CONJ    PREFIX|w:CONJ+\n  37 │     113      4      1      2  min           P       STEM|POS:P|LEM:min\n  38 │     113      4      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  39 │     113      4      3      1  {l            DET     PREFIX|Al+\n  40 │     113      4      3      2  n~af~a`va`ti  N       STEM|POS:N|LEM:n~af~a`va`t|ROOT:…\n  41 │     113      4      4      1  fiY           P       STEM|POS:P|LEM:fiY\n  42 │     113      4      5      1  {lo           DET     PREFIX|Al+\n  43 │     113      4      5      2  Euqadi        N       STEM|POS:N|LEM:Euqodap|ROOT:Eqd|…\n  44 │     113      5      1      1  wa            CONJ    PREFIX|w:CONJ+\n  45 │     113      5      1      2  min           P       STEM|POS:P|LEM:min\n  46 │     113      5      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  47 │     113      5      3      1  HaAsidK       N       STEM|POS:N|ACT|PCPL|LEM:HaAsid|R…\n  48 │     113      5      4      1  <i*aA         T       STEM|POS:T|LEM:<i*aA\n  49 │     113      5      5      1  Hasada        V       STEM|POS:V|PERF|LEM:Hasada|ROOT:…\n\n"

    out = capture_io(crpsdata[end-1:end]);
    @test out === "Chapter 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\n\n60×7 DataFrame\n Row │ chapter  verse  word   part   form          tag     features\n     │ Int64    Int64  Int64  Int64  String        String  String\n─────┼───────────────────────────────────────────────────────────────────────────────────────\n   1 │     113      1      1      1  qulo          V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   2 │     113      1      2      1  >aEuw*u       V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n   3 │     113      1      3      1  bi            P       PREFIX|bi+\n   4 │     113      1      3      2  rab~i         N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n   5 │     113      1      4      1  {lo           DET     PREFIX|Al+\n   6 │     113      1      4      2  falaqi        N       STEM|POS:N|LEM:falaq|ROOT:flq|M|…\n   7 │     113      2      1      1  min           P       STEM|POS:P|LEM:min\n   8 │     113      2      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n   9 │     113      2      3      1  maA           REL     STEM|POS:REL|LEM:maA\n  10 │     113      2      4      1  xalaqa        V       STEM|POS:V|PERF|LEM:xalaqa|ROOT:…\n  11 │     113      3      1      1  wa            CONJ    PREFIX|w:CONJ+\n  12 │     113      3      1      2  min           P       STEM|POS:P|LEM:min\n  13 │     113      3      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  14 │     113      3      3      1  gaAsiqK       N       STEM|POS:N|ACT|PCPL|LEM:gaAsiq|R…\n  15 │     113      3      4      1  <i*aA         T       STEM|POS:T|LEM:<i*aA\n  16 │     113      3      5      1  waqaba        V       STEM|POS:V|PERF|LEM:waqaba|ROOT:…\n  17 │     113      4      1      1  wa            CONJ    PREFIX|w:CONJ+\n  18 │     113      4      1      2  min           P       STEM|POS:P|LEM:min\n  19 │     113      4      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  20 │     113      4      3      1  {l            DET     PREFIX|Al+\n  21 │     113      4      3      2  n~af~a`va`ti  N       STEM|POS:N|LEM:n~af~a`va`t|ROOT:…\n  22 │     113      4      4      1  fiY           P       STEM|POS:P|LEM:fiY\n  23 │     113      4      5      1  {lo           DET     PREFIX|Al+\n  24 │     113      4      5      2  Euqadi        N       STEM|POS:N|LEM:Euqodap|ROOT:Eqd|…\n  25 │     113      5      1      1  wa            CONJ    PREFIX|w:CONJ+\n  26 │     113      5      1      2  min           P       STEM|POS:P|LEM:min\n  27 │     113      5      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  28 │     113      5      3      1  HaAsidK       N       STEM|POS:N|ACT|PCPL|LEM:HaAsid|R…\n  29 │     113      5      4      1  <i*aA         T       STEM|POS:T|LEM:<i*aA\n  30 │     113      5      5      1  Hasada        V       STEM|POS:V|PERF|LEM:Hasada|ROOT:…\n  31 │     114      1      1      1  qulo          V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n  32 │     114      1      2      1  >aEuw*u       V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n  33 │     114      1      3      1  bi            P       PREFIX|bi+\n  34 │     114      1      3      2  rab~i         N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  35 │     114      1      4      1  {l            DET     PREFIX|Al+\n  36 │     114      1      4      2  n~aAsi        N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n  37 │     114      2      1      1  maliki        N       STEM|POS:N|LEM:malik|ROOT:mlk|MS…\n  38 │     114      2      2      1  {l            DET     PREFIX|Al+\n  39 │     114      2      2      2  n~aAsi        N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n  40 │     114      3      1      1  <ila`hi       N       STEM|POS:N|LEM:<ila`h|ROOT:Alh|M…\n  41 │     114      3      2      1  {l            DET     PREFIX|Al+\n  42 │     114      3      2      2  n~aAsi        N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n  43 │     114      4      1      1  min           P       STEM|POS:P|LEM:min\n  44 │     114      4      2      1  \$ar~i         N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  45 │     114      4      3      1  {lo           DET     PREFIX|Al+\n  46 │     114      4      3      2  wasowaAsi     N       STEM|POS:N|LEM:wasowaAs|ROOT:wsw…\n  47 │     114      4      4      1  {lo           DET     PREFIX|Al+\n  48 │     114      4      4      2  xan~aAsi      ADJ     STEM|POS:ADJ|LEM:xan~aAs|ROOT:xn…\n  49 │     114      5      1      1  {l~a*iY       REL     STEM|POS:REL|LEM:{l~a*iY|MS\n  50 │     114      5      2      1  yuwasowisu    V       STEM|POS:V|IMPF|LEM:wasowasa|ROO…\n  51 │     114      5      3      1  fiY           P       STEM|POS:P|LEM:fiY\n  52 │     114      5      4      1  Suduwri       N       STEM|POS:N|LEM:Sador|ROOT:Sdr|MP…\n  53 │     114      5      5      1  {l            DET     PREFIX|Al+\n  54 │     114      5      5      2  n~aAsi        N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n  55 │     114      6      1      1  mina          P       STEM|POS:P|LEM:min\n  56 │     114      6      2      1  {lo           DET     PREFIX|Al+\n  57 │     114      6      2      2  jin~api       N       STEM|POS:N|LEM:jin~ap|ROOT:jnn|F…\n  58 │     114      6      3      1  wa            CONJ    PREFIX|w:CONJ+\n  59 │     114      6      3      2  {l            DET     PREFIX|Al+\n  60 │     114      6      3      3  n~aAsi        N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n\n"

    out = capture_io(crpsdata[1][1]);
    @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerse 1\n\n7×5 DataFrame\n Row │ word   part   form        tag     features\n     │ Int64  Int64  String      String  String\n─────┼─────────────────────────────────────────────────────────────────────\n   1 │     1      1  bi          P       PREFIX|bi+\n   2 │     1      2  somi        N       STEM|POS:N|LEM:{som|ROOT:smw|M|G…\n   3 │     2      1  {ll~ahi     PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   4 │     3      1  {l          DET     PREFIX|Al+\n   5 │     3      2  r~aHoma`ni  ADJ     STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:…\n   6 │     4      1  {l          DET     PREFIX|Al+\n   7 │     4      2  r~aHiymi    ADJ     STEM|POS:ADJ|LEM:r~aHiym|ROOT:rH…\n\n"

    out = capture_io(crpsdata[1][1:2]);
    @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerses 1-2\n\n14×6 DataFrame\n Row │ verse  word   part   form        tag     features\n     │ Int64  Int64  Int64  String      String  String\n─────┼────────────────────────────────────────────────────────────────────────────\n   1 │     1      1      1  bi          P       PREFIX|bi+\n   2 │     1      1      2  somi        N       STEM|POS:N|LEM:{som|ROOT:smw|M|G…\n   3 │     1      2      1  {ll~ahi     PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   4 │     1      3      1  {l          DET     PREFIX|Al+\n   5 │     1      3      2  r~aHoma`ni  ADJ     STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:…\n   6 │     1      4      1  {l          DET     PREFIX|Al+\n   7 │     1      4      2  r~aHiymi    ADJ     STEM|POS:ADJ|LEM:r~aHiym|ROOT:rH…\n   8 │     2      1      1  {lo         DET     PREFIX|Al+\n   9 │     2      1      2  Hamodu      N       STEM|POS:N|LEM:Hamod|ROOT:Hmd|M|…\n  10 │     2      2      1  li          P       PREFIX|l:P+\n  11 │     2      2      2  l~ahi       PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n  12 │     2      3      1  rab~i       N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  13 │     2      4      1  {lo         DET     PREFIX|Al+\n  14 │     2      4      2  Ea`lamiyna  N       STEM|POS:N|LEM:Ea`lamiyn|ROOT:El…\n\n"

    out = capture_io(crpsdata[1][[1,2]]);
    @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerses 1, 2\n\n14×7 DataFrame\n Row │ chapter  verse  word   part   form        tag     features\n     │ Int64    Int64  Int64  Int64  String      String  String\n─────┼─────────────────────────────────────────────────────────────────────────────────────\n   1 │       1      1      1      1  bi          P       PREFIX|bi+\n   2 │       1      1      1      2  somi        N       STEM|POS:N|LEM:{som|ROOT:smw|M|G…\n   3 │       1      1      2      1  {ll~ahi     PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   4 │       1      1      3      1  {l          DET     PREFIX|Al+\n   5 │       1      1      3      2  r~aHoma`ni  ADJ     STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:…\n   6 │       1      1      4      1  {l          DET     PREFIX|Al+\n   7 │       1      1      4      2  r~aHiymi    ADJ     STEM|POS:ADJ|LEM:r~aHiym|ROOT:rH…\n   8 │       1      2      1      1  {lo         DET     PREFIX|Al+\n   9 │       1      2      1      2  Hamodu      N       STEM|POS:N|LEM:Hamod|ROOT:Hmd|M|…\n  10 │       1      2      2      1  li          P       PREFIX|l:P+\n  11 │       1      2      2      2  l~ahi       PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n  12 │       1      2      3      1  rab~i       N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  13 │       1      2      4      1  {lo         DET     PREFIX|Al+\n  14 │       1      2      4      2  Ea`lamiyna  N       STEM|POS:N|LEM:Ea`lamiyn|ROOT:El…\n\n"
    
    out = capture_io(crpsdata[end-1:end][1]);
    @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerse 1\n\n12×7 DataFrame\n Row │ chapter  verse  word   part   form     tag     features\n     │ Int64    Int64  Int64  Int64  String   String  String\n─────┼──────────────────────────────────────────────────────────────────────────────────\n   1 │     113      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   2 │     113      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n   3 │     113      1      3      1  bi       P       PREFIX|bi+\n   4 │     113      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n   5 │     113      1      4      1  {lo      DET     PREFIX|Al+\n   6 │     113      1      4      2  falaqi   N       STEM|POS:N|LEM:falaq|ROOT:flq|M|…\n   7 │     114      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   8 │     114      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n   9 │     114      1      3      1  bi       P       PREFIX|bi+\n  10 │     114      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  11 │     114      1      4      1  {l       DET     PREFIX|Al+\n  12 │     114      1      4      2  n~aAsi   N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n\n"

    out = capture_io(crpsdata[end-1:end][[1,2]]);
    @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerses 1, 2\n\n19×7 DataFrame\n Row │ chapter  verse  word   part   form     tag     features\n     │ Int64    Int64  Int64  Int64  String   String  String\n─────┼──────────────────────────────────────────────────────────────────────────────────\n   1 │     113      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   2 │     113      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n   3 │     113      1      3      1  bi       P       PREFIX|bi+\n   4 │     113      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n   5 │     113      1      4      1  {lo      DET     PREFIX|Al+\n   6 │     113      1      4      2  falaqi   N       STEM|POS:N|LEM:falaq|ROOT:flq|M|…\n   7 │     113      2      1      1  min      P       STEM|POS:P|LEM:min\n   8 │     113      2      2      1  \$ar~i    N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n   9 │     113      2      3      1  maA      REL     STEM|POS:REL|LEM:maA\n  10 │     113      2      4      1  xalaqa   V       STEM|POS:V|PERF|LEM:xalaqa|ROOT:…\n  11 │     114      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n  12 │     114      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n  13 │     114      1      3      1  bi       P       PREFIX|bi+\n  14 │     114      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  15 │     114      1      4      1  {l       DET     PREFIX|Al+\n  16 │     114      1      4      2  n~aAsi   N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n  17 │     114      2      1      1  maliki   N       STEM|POS:N|LEM:malik|ROOT:mlk|MS…\n  18 │     114      2      2      1  {l       DET     PREFIX|Al+\n  19 │     114      2      2      2  n~aAsi   N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n\n"

    out = capture_io(crpsdata[end-1:end][1:2]);
    @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerses 1-2\n\n19×7 DataFrame\n Row │ chapter  verse  word   part   form     tag     features\n     │ Int64    Int64  Int64  Int64  String   String  String\n─────┼──────────────────────────────────────────────────────────────────────────────────\n   1 │     113      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   2 │     113      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n   3 │     113      1      3      1  bi       P       PREFIX|bi+\n   4 │     113      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n   5 │     113      1      4      1  {lo      DET     PREFIX|Al+\n   6 │     113      1      4      2  falaqi   N       STEM|POS:N|LEM:falaq|ROOT:flq|M|…\n   7 │     113      2      1      1  min      P       STEM|POS:P|LEM:min\n   8 │     113      2      2      1  \$ar~i    N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n   9 │     113      2      3      1  maA      REL     STEM|POS:REL|LEM:maA\n  10 │     113      2      4      1  xalaqa   V       STEM|POS:V|PERF|LEM:xalaqa|ROOT:…\n  11 │     114      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n  12 │     114      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n  13 │     114      1      3      1  bi       P       PREFIX|bi+\n  14 │     114      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  15 │     114      1      4      1  {l       DET     PREFIX|Al+\n  16 │     114      1      4      2  n~aAsi   N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n  17 │     114      2      1      1  maliki   N       STEM|POS:N|LEM:malik|ROOT:mlk|MS…\n  18 │     114      2      2      1  {l       DET     PREFIX|Al+\n  19 │     114      2      2      2  n~aAsi   N       STEM|POS:N|LEM:n~aAs|ROOT:nws|MP…\n\n"

    out = capture_io(crpsdata[[112,113]][1]);
    @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerse 1\n\n10×7 DataFrame\n Row │ chapter  verse  word   part   form     tag     features\n     │ Int64    Int64  Int64  Int64  String   String  String\n─────┼──────────────────────────────────────────────────────────────────────────────────\n   1 │     112      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   2 │     112      1      2      1  huwa     PRON    STEM|POS:PRON|3MS\n   3 │     112      1      3      1  {ll~ahu  PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   4 │     112      1      4      1  >aHadN   N       STEM|POS:N|LEM:>aHad|ROOT:AHd|M|…\n   5 │     113      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   6 │     113      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n   7 │     113      1      3      1  bi       P       PREFIX|bi+\n   8 │     113      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n   9 │     113      1      4      1  {lo      DET     PREFIX|Al+\n  10 │     113      1      4      2  falaqi   N       STEM|POS:N|LEM:falaq|ROOT:flq|M|…\n\n"

    out = capture_io(crpsdata[[112,113]][[1,2]]);
    @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerses 1, 2\n\n17×7 DataFrame\n Row │ chapter  verse  word   part   form     tag     features\n     │ Int64    Int64  Int64  Int64  String   String  String\n─────┼──────────────────────────────────────────────────────────────────────────────────\n   1 │     112      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   2 │     112      1      2      1  huwa     PRON    STEM|POS:PRON|3MS\n   3 │     112      1      3      1  {ll~ahu  PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   4 │     112      1      4      1  >aHadN   N       STEM|POS:N|LEM:>aHad|ROOT:AHd|M|…\n   5 │     112      2      1      1  {ll~ahu  PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   6 │     112      2      2      1  {l       DET     PREFIX|Al+\n   7 │     112      2      2      2  S~amadu  N       STEM|POS:N|LEM:S~amad|ROOT:Smd|M…\n   8 │     113      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   9 │     113      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n  10 │     113      1      3      1  bi       P       PREFIX|bi+\n  11 │     113      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  12 │     113      1      4      1  {lo      DET     PREFIX|Al+\n  13 │     113      1      4      2  falaqi   N       STEM|POS:N|LEM:falaq|ROOT:flq|M|…\n  14 │     113      2      1      1  min      P       STEM|POS:P|LEM:min\n  15 │     113      2      2      1  \$ar~i    N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  16 │     113      2      3      1  maA      REL     STEM|POS:REL|LEM:maA\n  17 │     113      2      4      1  xalaqa   V       STEM|POS:V|PERF|LEM:xalaqa|ROOT:…\n\n"

    out = capture_io(crpsdata[[112,113]][1:2]);
    @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerses 1-2\n\n17×7 DataFrame\n Row │ chapter  verse  word   part   form     tag     features\n     │ Int64    Int64  Int64  Int64  String   String  String\n─────┼──────────────────────────────────────────────────────────────────────────────────\n   1 │     112      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   2 │     112      1      2      1  huwa     PRON    STEM|POS:PRON|3MS\n   3 │     112      1      3      1  {ll~ahu  PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   4 │     112      1      4      1  >aHadN   N       STEM|POS:N|LEM:>aHad|ROOT:AHd|M|…\n   5 │     112      2      1      1  {ll~ahu  PN      STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|…\n   6 │     112      2      2      1  {l       DET     PREFIX|Al+\n   7 │     112      2      2      2  S~amadu  N       STEM|POS:N|LEM:S~amad|ROOT:Smd|M…\n   8 │     113      1      1      1  qulo     V       STEM|POS:V|IMPV|LEM:qaAla|ROOT:q…\n   9 │     113      1      2      1  >aEuw*u  V       STEM|POS:V|IMPF|LEM:Eu*o|ROOT:Ew…\n  10 │     113      1      3      1  bi       P       PREFIX|bi+\n  11 │     113      1      3      2  rab~i    N       STEM|POS:N|LEM:rab~|ROOT:rbb|M|G…\n  12 │     113      1      4      1  {lo      DET     PREFIX|Al+\n  13 │     113      1      4      2  falaqi   N       STEM|POS:N|LEM:falaq|ROOT:flq|M|…\n  14 │     113      2      1      1  min      P       STEM|POS:P|LEM:min\n  15 │     113      2      2      1  \$ar~i    N       STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|…\n  16 │     113      2      3      1  maA      REL     STEM|POS:REL|LEM:maA\n  17 │     113      2      4      1  xalaqa   V       STEM|POS:V|PERF|LEM:xalaqa|ROOT:…\n\n"

    meta = MetaData(
        "Quranic Arabic Corpus (morphology)",
        "Kais Dukes",
        "The Quranic Arabic Corpus includes syntactic and morphological\nannotation of the Qur'an, and builds on the verified Arabic text\ndistributed by the Tanzil project.",
        "http://corpus.quran.com/",
        "English",
        "2011",
        "GNU General Public License",
        "0.4"
    )
    out = capture_io(meta);
    @test out === "Quranic Arabic Corpus (morphology) v0.4\nCopyright (C) 2011 Kais Dukes\nGNU General Public License\nhttp://corpus.quran.com/\n\nThe Quranic Arabic Corpus includes syntactic and morphological\nannotation of the Qur'an, and builds on the verified Arabic text\ndistributed by the Tanzil project.\n\n"

    out = @capture_out begin
        QuranTree.description(parse(QuranFeatures, crpsdata[1].data[1, :features]))
    end;
    @test out === "Prefix\n──────\nPreposition:\n ├ data: P\n ├ desc: Preposition prefix ('by', 'with', 'in')\n └ ar_label: حرف جر\n"

    out = @capture_out begin
        @desc parse(QuranFeatures, crpsdata[1].data[end, :features])
    end;
    @test out === """Stem
    ────
    Noun:
     ├ data: N
     ├ desc: Noun
     └ ar_label: اسم
    QuranTree.Lemma:
     └ data: DaA^l~
    QuranTree.Root:
     └ data: Dll
    ActiveParticle:
     ├ data: ACT PCPL
     ├ desc: Active particle
     └ ar_label: اسم فاعل
    Active:
     ├ data: ACT
     ├ desc: Active voice (default)
     └ ar_label: مبني للمعلوم
    Masculine:
     ├ data: M
     ├ desc: Masculine
     └ ar_label: الجنس
    Plural:
     ├ data: P
     ├ desc: Plural
     └ ar_label: العدد
    Genitive:
     ├ data: GEN
     ├ desc: Genitive case
     └ ar_label: مجرور\n"""
    
    out = @capture_out begin
        @desc(1) 
    end
    @test out === missing;

end