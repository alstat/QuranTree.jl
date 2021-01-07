using QuranTree
using Test
using JuliaDB: select
using Suppressor: @capture_out

@testset "QuranTree.jl" begin
    data = QuranData()
    crps, tnzl = load(data)
    
    # data
    @test crps[end] === "(114:6:3:3)\tn~aAsi\tN\tSTEM|POS:N|LEM:n~aAs|ROOT:nws|MP|GEN"
    @test tnzl[begin] === "1|1|بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test typeof(crps) === CorpusRaw
    @test typeof(tnzl) === TanzilRaw

    # indexing
    crpsdata = table(crps)
    tnzldata = table(tnzl)

    @test select(crpsdata[114][2][1][1].data, :features)[1].data === "STEM|POS:N|LEM:malik|ROOT:mlk|MS|GEN"
    @test select(crpsdata[114][2][1:2][1].data, :features)[2].data === "PREFIX|Al+"
    @test select(crpsdata[114][4][[1,2,3]][1].data, :features)[2].data === "STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|GEN"
    
    @test select(crpsdata[114][1:3][1][1].data, :features)[3].data === "STEM|POS:N|LEM:<ila`h|ROOT:Alh|MS|GEN"
    @test select(crpsdata[112][1:3][1:3][2].data, :features)[1].data === "STEM|POS:N|LEM:S~amad|ROOT:Smd|MS|NOM"
    @test select(crpsdata[112][1:3][[2,4]][1].data, :features)[3].data === "PREFIX|Al+"
    
    @test select(crpsdata[111][[2,3]][1][1].data, :features)[1].data === "STEM|POS:NEG|LEM:maA"
    @test select(crpsdata[111][[2,3]][1:3][2].data, :features)[2].data === "STEM|POS:V|IMPF|LEM:yaSolaY|ROOT:Sly|3MS"
    @test select(crpsdata[111][[2,3]][[1,3]][1].data, :features)[4].data === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[111:112][1][1][1].data, :features)[2].data === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test select(crpsdata[111:112][1][1:3][1].data, :features)[4].data === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test select(crpsdata[111:112][1][[1,2,3]][1].data, :features)[4].data === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"

    @test select(crpsdata[111:112][1:3][1][1].data, :features)[5].data === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[111:112][1:3][1:3][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[111:112][1:3][[1,2,3]][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[111:112][[1,2,3]][1][1].data, :features)[5].data === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[111:112][[1,2,3]][1:3][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[111:112][[1,2,3]][[1,2,3]][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[[111,112]][1][1][1].data, :features)[2].data === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test select(crpsdata[[111,112]][1][1:3][1].data, :features)[4].data === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test select(crpsdata[[111,112]][1][[1,2,3]][1].data, :features)[4].data === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"

    @test select(crpsdata[[111,112]][1:3][1][1].data, :features)[5].data === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[[111,112]][1:3][1:3][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[[111,112]][1:3][[1,2,3]][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[[111,112]][[1,2,3]][1][1].data, :features)[5].data === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[[111,112]][[1,2,3]][1:3][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[[111,112]][[1,2,3]][[1,2,3]][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[end-3:end-2][[1,2,3]][1][1].data, :features)[5].data === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[end-3:end-2][[1,2,3]][1:3][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[end-3:end-2][[1,2,3]][[1,2,3]][1].data, :features)[9].data === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(tnzldata[1].data, :form)[7] === "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ"
    @test select(tnzldata[111:113].data, :form)[10] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"
    @test select(tnzldata[[111,112,113]].data, :form)[10] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"
    @test select(tnzldata[end-3:end-1].data, :form)[10] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"

    # verses
    @test verses(crpsdata[1])[7] === "Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"
    @test verses(crpsdata[1][7])[1] === "Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"

    # arabic
    @test arabic(verses(crpsdata[114])[1]) === "قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ"
    @test arabic(verses(crpsdata[1][7])[1]) === "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ"

    # encoding
    @test encode(arabic(verses(crpsdata[1][7])[1])) === verses(crpsdata[1][7])[1]

    # chapter_name
    @test chapter_name(crpsdata[13][2][1]) === "ٱلرَّعْد"
    @test chapter_name(crpsdata[13][2][1], lang=:english) === "Thunder"
    @test chapter_name(tnzldata[13][2]) === "ٱلرَّعْد"
    @test chapter_name(tnzldata[13][2], lang=:english) === "Thunder"

    # dediac
    @test dediac(verses(crpsdata[1][1])[1]) === "bsm {llh {lrHm`n {lrHym"
    @test dediac(arabic(verses(crpsdata[1][1])[1])) === "بسم ٱلله ٱلرحمٰن ٱلرحيم"
    @test dediac(arabic(verses(crpsdata[1][1])[1])) === arabic(dediac(verses(crpsdata[1][1])[1]))

    # normalize
    @test normalize(dediac(verses(crpsdata[1][1])[1])) === "bsm Allh AlrHmAn AlrHym"
    @test normalize(dediac(verses(crpsdata[1][1])[1])) === dediac(normalize(verses(crpsdata[1][1])[1]))
    @test normalize(arabic(verses(crpsdata[1][1])[1]), :alif_khanjareeya) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَانِ ٱلرَّحِيمِ"
    @test normalize(arabic(verses(crpsdata[1][1])[1]), :hamzat_wasl) === "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
    @test normalize(arabic(verses(crpsdata[2][4])[1]), :alif_maddah) === "وَٱلَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ"
    @test normalize(arabic(verses(crpsdata[2][4])[1]), :alif_hamza_above) === "وَٱلَّذِينَ يُؤْمِنُونَ بِمَآ اُنزِلَ إِلَيْكَ وَمَآ اُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ"
    @test normalize(arabic(verses(crpsdata[1][5])[1]), :alif_hamza_below) === "اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِينُ"
    @test normalize(arabic(verses(crpsdata[2][3])[1]), :waw_hamza_above) === "ٱلَّذِينَ يُوْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ"
    @test normalize(arabic(verses(crpsdata[2][15])[1]), :ya_hamza_above) === "ٱللَّهُ يَسْتَهْزِيُ بِهِمْ وَيَمُدُّهُمْ فِى طُغْيَٰنِهِمْ يَعْمَهُونَ"
    @test normalize(arabic(verses(crpsdata[2][2])[1]), :alif_maksura) === "ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًي لِّلْمُتَّقِينَ"
    @test normalize(arabic(verses(crpsdata[2][3])[1]), :ta_marbuta) === "ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰهَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ"
    @test normalize(arabic(verses(crpsdata[1][1])[1]), [:alif_khanjareeya, :hamzat_wasl]) === "بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ"

    # setting new transliterator
    old_keys = collect(keys(BW_ENCODING))
    new_vals = reverse(collect(values(BW_ENCODING)))
    my_encoder = Dict(old_keys .=> new_vals);

    basmala = arabic(verses(crpsdata[1][1])[1])

    @transliterator my_encoder "MyEncoder"
    @test encode(basmala) === "\"S%gAS zppj[KS zp`j[&gA[r]S zp`j[&SkAS"
    @test arabic(encode(basmala)) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test dediac(encode(basmala)) === "\"%A zppK zp`&Ar] zp`&kA"
    @test normalize(encode(basmala)) === "\"S%gAS mppj[KS mp`j[&gA[m]S mp`j[&SkAS"

    @transliterator :default
    @test encode(basmala) === "bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"
    @test arabic(encode(basmala)) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test dediac(encode(basmala)) === "bsm {llh {lrHm`n {lrHym"
    @test normalize(encode(basmala)) === "bisomi All~ahi Alr~aHomaAni Alr~aHiymi"

    # features
    @test isfeature(select(crpsdata[1].data, :features)[2], Stem) === true
    @test isfeature(select(crpsdata[1].data, :features)[end-4], Suffix) === true
    @test isfeature(select(crpsdata[1].data, :features)[end-3], Prefix) === true
    @test isfeature(select(crpsdata[1].data, :features)[2], Noun) === true
    @test isfeature(select(crpsdata[1].data, :features)[3], ProperNoun) === true
    @test isfeature(select(crpsdata[1].data, :features)[5], Adjective) === true
    @test isfeature(select(crpsdata.data, :features)[68054], ImperativeVerbalNoun) === true
    @test isfeature(select(crpsdata[1].data, :features)[23], Personal) === true
    @test isfeature(select(crpsdata.data, :features)[50], Demonstrative) === true
    @test isfeature(select(crpsdata.data, :features)[35], Relative) === true
    @test isfeature(select(crpsdata.data, :features)[210], Time) === true
    @test isfeature(select(crpsdata.data, :features)[291], Location) === true
    @test isfeature(select(crpsdata.data, :features)[14], Plural) === true
    @test isfeature(select(crpsdata.data, :features)[38], Preposition) === true
    @test isfeature(select(crpsdata.data, :features)[419], EmphaticLam) === true
    @test isfeature(select(crpsdata.data, :features)[5717], ImperativeLam) === true
    @test isfeature(select(crpsdata.data, :features)[2131], PurposeLam) === true
    @test isfeature(select(crpsdata.data, :features)[997], EmphaticNun) === true
    @test isfeature(select(crpsdata.data, :features)[25], Coordinating) === true
    @test isfeature(select(crpsdata.data, :features)[245], Subordinating) === true
    @test isfeature(select(crpsdata.data, :features)[31], Accusative) === true
    @test isfeature(select(crpsdata.data, :features)[233], Amendment) === true
    @test isfeature(select(crpsdata.data, :features)[2252], Answer) === true
    @test isfeature(select(crpsdata.data, :features)[66305], Aversion) === true
    @test isfeature(select(crpsdata.data, :features)[926], Cause) === true
    @test isfeature(select(crpsdata.data, :features)[1544], Certainty) === true
    @test isfeature(select(crpsdata.data, :features)[166], Circumstantial) === true
    @test isfeature(select(crpsdata.data, :features)[14139], Comitative) === true
    @test isfeature(select(crpsdata.data, :features)[416], Conditional) === true
    @test isfeature(select(crpsdata.data, :features)[120], Equalization) === true
    @test isfeature(select(crpsdata.data, :features)[3532], Exhortation) === true
    @test isfeature(select(crpsdata.data, :features)[618], Explanation) === true
    @test isfeature(select(crpsdata.data, :features)[821], Exceptive) === true
    @test isfeature(select(crpsdata.data, :features)[17319], Future) === true
    @test isfeature(select(crpsdata.data, :features)[226], Inceptive) === true
    @test isfeature(select(crpsdata.data, :features)[3758], Interpretation) === true
    @test isfeature(select(crpsdata.data, :features)[640], Interogative) === true
    @test isfeature(select(crpsdata.data, :features)[46], Negative) === true
    @test isfeature(select(crpsdata.data, :features)[223], Preventive) === true
    @test isfeature(select(crpsdata.data, :features)[214], Prohibition) === true
    @test isfeature(select(crpsdata.data, :features)[72], Resumption) === true
    @test isfeature(select(crpsdata.data, :features)[182], Restriction) === true
    @test isfeature(select(crpsdata.data, :features)[2542], Retraction) === true
    @test isfeature(select(crpsdata.data, :features)[504], Result) === true
    @test isfeature(select(crpsdata.data, :features)[232], Supplemental) === true
    @test isfeature(select(crpsdata.data, :features)[18810], Surprise) === true
    @test isfeature(select(crpsdata.data, :features)[10975], Vocative) === true
    @test isfeature(select(crpsdata.data, :features)[49], DisconnectedLetters) === true
    @test isfeature(select(crpsdata.data, :features)[24], FirstPerson) === true
    @test isfeature(select(crpsdata.data, :features)[23], SecondPerson) === true
    @test isfeature(select(crpsdata.data, :features)[39], ThirdPerson) === true
    @test isfeature(select(crpsdata.data, :features)[2], Masculine) === true
    @test isfeature(select(crpsdata.data, :features)[71], Feminine) === true
    @test isfeature(select(crpsdata.data, :features)[5], Singular) === true
    @test isfeature(select(crpsdata.data, :features)[2303], Dual) === true
    @test isfeature(select(crpsdata.data, :features)[14], Plural) === true
    @test isfeature(select(crpsdata.data, :features)[24], Verb) === true
    @test isfeature(select(crpsdata.data, :features)[36], Perfect) === true
    @test isfeature(select(crpsdata.data, :features)[24], Imperfect) === true
    @test isfeature(select(crpsdata.data, :features)[28], Imperative) === true
    @test isfeature(select(crpsdata.data, :features)[531], Subjunctive) === true
    @test isfeature(select(crpsdata.data, :features)[126], Jussive) === true
    @test isfeature(select(crpsdata.data, :features)[86], Passive) === true
    @test isfeature(select(crpsdata.data, :features)[499], VerbFormII) === true
    @test isfeature(select(crpsdata.data, :features)[171], VerbFormIII) === true
    @test isfeature(select(crpsdata.data, :features)[36], VerbFormIV) === true
    @test isfeature(select(crpsdata.data, :features)[970], VerbFormV) === true
    @test isfeature(select(crpsdata.data, :features)[591], VerbFormVI) === true
    @test isfeature(select(crpsdata.data, :features)[1538], VerbFormVII) === true
    @test isfeature(select(crpsdata.data, :features)[60], VerbFormVIII) === true
    @test isfeature(select(crpsdata.data, :features)[13216], VerbFormIX) === true
    @test isfeature(select(crpsdata.data, :features)[27], VerbFormX) === true
    @test isfeature(select(crpsdata.data, :features)[114155], VerbFormXI) === true
    @test isfeature(select(crpsdata.data, :features)[9063], VerbFormXII) === true
    @test isfeature(select(crpsdata.data, :features)[19], ActiveParticle) === true
    @test isfeature(select(crpsdata.data, :features)[42], PassiveParticle) === true
    @test isfeature(select(crpsdata.data, :features)[305], VerbalNoun) === true
    @test isfeature(select(crpsdata.data, :features)[57], Indefinite) === true # no verse with DEF feature
    @test isfeature(select(crpsdata.data, :features)[9], Nominative) === true
    @test isfeature(select(crpsdata.data, :features)[2], Genetive) === true
    @test isfeature(select(crpsdata.data, :features)[24], VerbFormI) === true
    @test isfeature(select(crpsdata.data, :features)[27], VerbFormI) === false
    @test isfeature(select(crpsdata.data, :features)[27], Indicative) === true
    @test isfeature(select(crpsdata.data, :features)[126], Indicative) === false
    @test isfeature(select(crpsdata.data, :features)[86], Active) === false
    @test isfeature(select(crpsdata.data, :features)[36], Active) === true

    out = @capture_out begin
        description(feature(select(crpsdata[1].data, :features)[1]))
    end;
    @test out === """Prefix
    ──────
    Preposition:
     ├ data: P
     ├ desc: Preposition prefix ('by', 'with', 'in')
     └ ar_label: حرف جر\n"""

    out = @capture_out begin
        @desc feature(select(crpsdata[1].data, :features)[end])
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
    Genetive:
     ├ data: GEN
     ├ desc: Genetive case
     └ ar_label: مجرور\n"""
    
    out = @capture_out crpsdata[1][1][1][1]
    out === """Chapter 1 ٱلْفَاتِحَة (The Opening)
    Verse 1
    
    Table with 1 rows, 5 columns:
    word  part  form  tag  features
    ─────────────────────────────────────────────
    1     1     "bi"  "P"  Features("PREFIX|bi+")\n"""

    out = @desc 1
    println(out)
    @test out === missing
     # remaining todo:
    #   check pretty_table
    #   test display/show
    #   use suppressor
end
