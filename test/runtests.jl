using QuranTree
using Test
using JuliaDB: select
using PrettyTables: pretty_table
using Suppressor: @capture_out

function capture_io(x)
    io = IOBuffer()
    println(io, x)
    return String(take!(io))
end

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
    
    @test select(crpsdata[begin].data, :form)[1] === "bi"
    @test select(crpsdata[114][2][1][1].data, :features)[1] === "STEM|POS:N|LEM:malik|ROOT:mlk|MS|GEN"
    @test select(crpsdata[114][2][1:2][1].data, :features)[2] === "PREFIX|Al+"
    @test select(crpsdata[114][4][[1,2,3]][1].data, :features)[2] === "STEM|POS:N|LEM:\$ar~|ROOT:\$rr|MS|GEN"
    
    @test select(crpsdata[114][1:3][1][1].data, :features)[3] === "STEM|POS:N|LEM:<ila`h|ROOT:Alh|MS|GEN"
    @test select(crpsdata[112][1:3][1:3][2].data, :features)[1] === "STEM|POS:N|LEM:S~amad|ROOT:Smd|MS|NOM"
    @test select(crpsdata[112][1:3][[2,4]][1].data, :features)[3] === "PREFIX|Al+"
    
    @test select(crpsdata[111][[2,3]][1][1].data, :features)[1] === "STEM|POS:NEG|LEM:maA"
    @test select(crpsdata[111][[2,3]][1:3][2].data, :features)[2] === "STEM|POS:V|IMPF|LEM:yaSolaY|ROOT:Sly|3MS"
    @test select(crpsdata[111][[2,3]][[1,3]][1].data, :features)[4] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[111:112][1][1][1].data, :features)[2] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test select(crpsdata[111:112][1][1:3][1].data, :features)[4] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test select(crpsdata[111:112][1][[1,2,3]][1].data, :features)[4] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"

    @test select(crpsdata[111:112][1:3][1][1].data, :features)[5] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[111:112][1:3][1:3][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[111:112][1:3][[1,2,3]][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[111:112][[1,2,3]][1][1].data, :features)[5] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[111:112][[1,2,3]][1:3][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[111:112][[1,2,3]][[1,2,3]][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[[111,112]][1][1][1].data, :features)[2] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test select(crpsdata[[111,112]][1][1:3][1].data, :features)[4] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"
    @test select(crpsdata[[111,112]][1][[1,2,3]][1].data, :features)[4] === "STEM|POS:V|IMPV|LEM:qaAla|ROOT:qwl|2MS"

    @test select(crpsdata[[111,112]][1:3][1][1].data, :features)[5] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[[111,112]][1:3][1:3][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[[111,112]][1:3][[1,2,3]][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[[111,112]][[1,2,3]][1][1].data, :features)[5] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[[111,112]][[1,2,3]][1:3][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[[111,112]][[1,2,3]][[1,2,3]][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(crpsdata[end-3:end-2][[1,2,3]][1][1].data, :features)[5] === "STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|NOM"
    @test select(crpsdata[end-3:end-2][[1,2,3]][1:3][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"
    @test select(crpsdata[end-3:end-2][[1,2,3]][[1,2,3]][1].data, :features)[9] === "STEM|POS:N|LEM:*uw|FS|ACC"

    @test select(tnzldata[1].data, :form)[7] === "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ"
    @test select(tnzldata[111:113].data, :form)[10] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"
    @test select(tnzldata[[111,112,113]].data, :form)[10] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"
    @test select(tnzldata[end-3:end-1].data, :form)[10] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ"

    # verses
    @test verses(crpsdata[1])[7] === "Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"
    @test verses(crpsdata[1][1:7])[7] === "Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"
    @test verses(crpsdata[1][7])[1] === "Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"
    @test verses(tnzldata[1][1])[1] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test verses(tnzldata[1][1:2])[2] === "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ"
    @test verses(tnzldata)[1] === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    # arabic
    @test arabic(verses(crpsdata[114])[1]) === "قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ"
    @test arabic(verses(crpsdata[1][7])[1]) === "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ"
    # number
    @test verses(crpsdata[113:114], number=true)[1] === "113:(1,5)"
    @test verses(crpsdata[113:114], number=true, start_end=false)[1] == ([113], [1, 2, 3, 4, 5])

    # words
    @test words(tnzldata[1][7])[1] === "صِرَٰطَ"

    # encoding
    @test encode(arabic(verses(crpsdata[1][7])[1])) === verses(crpsdata[1][7])[1]

    # chapter_name
    @test chapter_name(crpsdata[13][2][1]) === "ٱلرَّعْد"
    @test chapter_name(crpsdata[13][2][1], lang=:english) === "Thunder"
    @test chapter_name(tnzldata[13][2]) === "ٱلرَّعْد"
    @test chapter_name(tnzldata[13][2], lang=:english) === "Thunder"
    @test chapter_name(tnzldata[1], true) === "{lofaAtiHap"
    @test chapter_name(tnzldata[1], true, lang=:english) === "The Opening"

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

    @test normalize(verses(tnzldata[1][1])[1], :alif_khanjareeya) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَانِ ٱلرَّحِيمِ"
    @test normalize(verses(tnzldata[1][1])[1], :hamzat_wasl) === "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
    @test normalize(verses(tnzldata[2][4])[1], :alif_maddah) === "وَٱلَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ"
    @test normalize(verses(tnzldata[2][4])[1], :alif_hamza_above) === "وَٱلَّذِينَ يُؤْمِنُونَ بِمَآ اُنزِلَ إِلَيْكَ وَمَآ اُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ"
    @test normalize(verses(tnzldata[1][5])[1], :alif_hamza_below) === "اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِينُ"
    @test normalize(verses(tnzldata[2][3])[1], :waw_hamza_above) === "ٱلَّذِينَ يُوْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ"
    @test normalize(verses(tnzldata[2][15])[1], :ya_hamza_above) === "ٱللَّهُ يَسْتَهْزِيُ بِهِمْ وَيَمُدُّهُمْ فِى طُغْيَٰنِهِمْ يَعْمَهُونَ"
    @test normalize(verses(tnzldata[2][2])[1], :alif_maksura) === "ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًي لِّلْمُتَّقِينَ"
    @test normalize(verses(tnzldata[2][3])[1], :ta_marbuta) === "ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰهَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ"
    @test normalize(verses(tnzldata[1][1])[1], [:alif_khanjareeya, :hamzat_wasl]) === "بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ"

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
    @test root(parse(Features, select(crpsdata[112].data, :features)[1])) === "qwl"
    @test lemma(parse(Features, select(crpsdata[112].data, :features)[1])) === "qaAla"
    @test special(parse(Features, select(crpsdata.data, :features)[53])) === "<in~"
    @test isfeature(parse(Features, select(crpsdata[1].data, :features)[2]), Stem) === true
    @test isfeature(parse(Features, select(crpsdata[1].data, :features)[end-4]), Suffix) === true
    @test isfeature(parse(Features, select(crpsdata[1].data, :features)[end-3]), Prefix) === true
    @test isfeature(parse(Features, select(crpsdata[1].data, :features)[2]), Noun) === true
    @test isfeature(parse(Features, select(crpsdata[1].data, :features)[3]), ProperNoun) === true
    @test isfeature(parse(Features, select(crpsdata[1].data, :features)[5]), Adjective) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[68054]), ImperativeVerbalNoun) === true
    @test isfeature(parse(Features, select(crpsdata[1].data, :features)[23]), Personal) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[50]), Demonstrative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[35]), Relative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[210]), Time) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[291]), Location) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[14]), Plural) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[38]), Preposition) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[419]), EmphaticLam) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[5717]), ImperativeLam) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[2131]), PurposeLam) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[997]), EmphaticNun) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[25]), Coordinating) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[245]), Subordinating) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[31]), Accusative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[233]), Amendment) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[2252]), Answer) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[66305]), Aversion) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[926]), Cause) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[1544]), Certainty) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[166]), Circumstantial) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[14139]), Comitative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[416]), Conditional) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[120]), Equalization) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[3532]), Exhortation) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[618]), Explanation) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[821]), Exceptive) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[17319]), Future) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[226]), Inceptive) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[3758]), Interpretation) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[640]), Interogative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[46]), Negative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[223]), Preventive) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[214]), Prohibition) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[72]), Resumption) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[182]), Restriction) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[2542]), Retraction) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[504]), Result) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[232]), Supplemental) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[18810]), Surprise) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[10975]), Vocative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[49]), DisconnectedLetters) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[24]), FirstPerson) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[23]), SecondPerson) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[39]), ThirdPerson) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[2]), Masculine) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[71]), Feminine) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[5]), Singular) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[2303]), Dual) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[14]), Plural) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[24]), Verb) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[36]), Perfect) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[24]), Imperfect) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[28]), Imperative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[531]), Subjunctive) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[126]), Jussive) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[86]), Passive) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[499]), VerbFormII) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[171]), VerbFormIII) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[36]), VerbFormIV) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[970]), VerbFormV) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[591]), VerbFormVI) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[1538]), VerbFormVII) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[60]), VerbFormVIII) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[13216]), VerbFormIX) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[27]), VerbFormX) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[114155]), VerbFormXI) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[9063]), VerbFormXII) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[19]), ActiveParticle) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[42]), PassiveParticle) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[305]), VerbalNoun) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[57]), Indefinite) === true # no verse with DEF feature
    @test isfeature(parse(Features, select(crpsdata.data, :features)[9]), Nominative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[2]), Genetive) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[24]), VerbFormI) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[27]), VerbFormI) === false
    @test isfeature(parse(Features, select(crpsdata.data, :features)[27]), Indicative) === true
    @test isfeature(parse(Features, select(crpsdata.data, :features)[126]), Indicative) === false
    @test isfeature(parse(Features, select(crpsdata.data, :features)[86]), Active) === false
    @test isfeature(parse(Features, select(crpsdata.data, :features)[36]), Active) === true

    @test encode(SimpleEncoder, basmala) === "Ba+Kasra | Seen+Sukun | Meem+Kasra | <space> | HamzatWasl | Lam | Lam+Shadda+Fatha | Ha+Kasra | <space> | HamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Sukun | Meem+Fatha | AlifKhanjareeya | Noon+Kasra | <space> | HamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Kasra | Ya | Meem+Kasra"

    # printing
    out = capture_io(crpsdata)
    @test out === "Quranic Arabic Corpus (morphology)\n(C) 2011 Kais Dukes\n\nTable with 128219 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    out = capture_io(tnzldata)
    @test out === "Tanzil Quran Text (Uthmani)\n(C) 2008-2010 Tanzil.net\n\nTable with 6236 rows, 3 columns:\nchapter  verse  form\n─────────────────────────────────────────────────────────────────────\n1        1      \"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\"\n1        2      \"ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ\"\n1        3      \"ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\"\n1        4      \"مَٰلِكِ يَوْمِ ٱلدِّينِ\"\n1        5      \"إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\"\n1        6      \"ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ\"\n1        7      \"صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ\"\n2        1      \"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ الٓمٓ\"\n2        2      \"ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ\"\n⋮\n113      4      \"وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِى ٱلْعُقَدِ\"\n113      5      \"وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\"\n114      1      \"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ\"\n114      2      \"مَلِكِ ٱلنَّاسِ\"\n114      3      \"إِلَٰهِ ٱلنَّاسِ\"\n114      4      \"مِن شَرِّ ٱلْوَسْوَاسِ ٱلْخَنَّاسِ\"\n114      5      \"ٱلَّذِى يُوَسْوِسُ فِى صُدُورِ ٱلنَّاسِ\"\n114      6      \"مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ\"\n\n"

    out = capture_io(Noun())
    @test out === "N\n"

    out = capture_io(SimpleEncoder())
    @test out === "SimpleEncoder:\n └ encoder: Dict(:ذ => :Thal,:ء => :Hamza,Symbol(\"ۜ\") => :SmallHighSeen,Symbol(\"َ\") => :Fatha,Symbol(\"ٰ\") => :AlifKhanjareeya,:ي => :Ya,:ن => :Noon,:ب => :Ba,:ص => :Sad,:ا => :Alif,:ى => :AlifMaksura,Symbol(\"۫\") => :EmptyCenterHighStop,:ؤ => :HamzaAbove,Symbol(\"۟\") => :SmallHighRoundedZero,Symbol(\"ْ\") => :Sukun,:س => :Seen,:ۦ => :SmallYa,:و => :Waw,Symbol(\"ً\") => :Fathatan,:خ => :Kha,:ع => :Ain,:د => :Dal,:ه => :Ha,Symbol(\"ّ\") => :Shadda,:ظ => :DTha,Symbol(\"ٔ\") => :HamzaAbove,:ز => :Zain,:ض => :DDad,Symbol(\"ُ\") => :Damma,:ل => :Lam,Symbol(\"ۣ\") => :SmallLowSeen,:ة => :TaMarbuta,:ۥ => :SmallWaw,:ت => :Ta,:ٱ => :HamzatWasl,:ث => :Tha,:إ => :HamzaBelow,:ج => :Jeem,Symbol(\"ٍ\") => :Kasratan,Symbol(\"ٓ\") => :Maddah,Symbol(\"ۨ\") => :SmallHighNoon,:ئ => :HamzaAbove,Symbol(\"ٌ\") => :Dammatan,Symbol(\"۪\") => :EmptyCenterLowStop,:ش => :Sheen,Symbol(\"۬\") => :RoundedHighStopWithFilledCenter,:غ => :Ghain,:ط => :TTa,:ح => :HHa,:أ => :HamzaAbove,:ـ => :Tatweel,:م => :Meem,Symbol(\"ِ\") => :Kasra,Symbol(\"۠\") => :SmallHighUprightRectangularZero,Symbol(\"ۭ\") => :SmallLowMeem,:ك => :Kaf,:ر => :Ra,Symbol(\"ۢ\") => :SmallHighMeemIsolatedForm,:ف => :Fa,:آ => Symbol(\"Alif+Maddah\"),:ق => :Qaf)\n\n"

    out = capture_io(crps);
    @test out[5000:6000] === "ka\\tDEM\\tSTEM|POS:DEM|LEM:*a`lik|MS\", \"(2:2:2:1)\\t{lo\\tDET\\tPREFIX|Al+\", \"(2:2:2:2)\\tkita`bu\\tN\\tSTEM|POS:N|LEM:kita`b|ROOT:ktb|M|NOM\", \"(2:2:3:1)\\tlaA\\tNEG\\tSTEM|POS:NEG|LEM:laA|SP:<in~\", \"(2:2:4:1)\\trayoba\\tN\\tSTEM|POS:N|LEM:rayob|ROOT:ryb|M|ACC\", \"(2:2:5:1)\\tfiy\\tP\\tSTEM|POS:P|LEM:fiY\", \"(2:2:5:2)\\thi\\tPRON\\tSUFFIX|PRON:3MS\", \"(2:2:6:1)\\thudFY\\tN\\tSTEM|POS:N|LEM:hudFY|ROOT:hdy|M|INDEF|NOM\", \"(2:2:7:1)\\tl~i\\tP\\tPREFIX|l:P+\", \"(2:2:7:2)\\tlo\\tDET\\tPREFIX|Al+\", \"(2:2:7:3)\\tmut~aqiyna\\tN\\tSTEM|POS:N|ACT|PCPL|(VIII)|LEM:mut~aqiyn|ROOT:wqy|MP|GEN\", \"(2:3:1:1)\\t{l~a*iyna\\tREL\\tSTEM|POS:REL|LEM:{l~a*iY|MP\", \"(2:3:2:1)\\tyu&ominu\\tV\\tSTEM|POS:V|IMPF|(IV)|LEM:'aAmana|ROOT:Amn|3MP\", \"(2:3:2:2)\\twna\\tPRON\\tSUFFIX|PRON:3MP\", \"(2:3:3:1)\\tbi\\tP\\tPREFIX|bi+\", \"(2:3:3:2)\\t{lo\\tDET\\tPREFIX|Al+\", \"(2:3:3:3)\\tgayobi\\tN\\tSTEM|POS:N|LEM:gayob|ROOT:gyb|M|GEN\", \"(2:3:4:1)\\twa\\tCONJ\\tPREFIX|w:CONJ+\", \"(2:3:4:2)\\tyuqiymu\\tV\\tSTEM|POS:V|IMPF|(IV)|LEM:>aqaAma|ROOT:qwm|3MP\", \"(2:3:4:3)\\twna\\tPRON\\tSUFFIX|PRON:3MP\""

    out = capture_io(tnzl);
    @test out[5000:5110] === "ن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ\", \"2|22|ٱلَّذِى جَعَلَ لَكُ"

    out = capture_io(crpsdata[1])
    @test out === "Chapter 1: ٱلْفَاتِحَة (The Opening)\n\nTable with 48 rows, 6 columns:\nColumns:\n#  colname   type\n───────────────────\n1  verse     Int64\n2  word      Int64\n3  part      Int64\n4  form      String\n5  tag       String\n6  features  String\n\n"

    out = capture_io(crpsdata[[112,113]])
    @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\n\nTable with 49 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    out = capture_io(crpsdata[end-1:end])
    @test out === "Chapter 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\n\nTable with 60 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    out = capture_io(crpsdata[1][1])
    @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerse 1\n\nTable with 7 rows, 5 columns:\nword  part  form          tag    features\n─────────────────────────────────────────────────────────────────────────────\n1     1     \"bi\"          \"P\"    \"PREFIX|bi+\"\n1     2     \"somi\"        \"N\"    \"STEM|POS:N|LEM:{som|ROOT:smw|M|GEN\"\n2     1     \"{ll~ahi\"     \"PN\"   \"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\"\n3     1     \"{l\"          \"DET\"  \"PREFIX|Al+\"\n3     2     \"r~aHoma`ni\"  \"ADJ\"  \"STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\"\n4     1     \"{l\"          \"DET\"  \"PREFIX|Al+\"\n4     2     \"r~aHiymi\"    \"ADJ\"  \"STEM|POS:ADJ|LEM:r~aHiym|ROOT:rHm|MS|GEN\"\n\n"

    out = capture_io(crpsdata[1][1:2])
    @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerses 1-2\n\nTable with 14 rows, 6 columns:\nColumns:\n#  colname   type\n───────────────────\n1  verse     Int64\n2  word      Int64\n3  part      Int64\n4  form      String\n5  tag       String\n6  features  String\n\n"

    out = capture_io(crpsdata[1][[1,2]])
    @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerses 1, 2\n\nTable with 14 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"
    
    out = capture_io(crpsdata[end-1:end][1])
    @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerse 1\n\nTable with 12 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    out = capture_io(crpsdata[end-1:end][[1,2]])
    @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerses 1, 2\n\nTable with 19 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    out = capture_io(crpsdata[end-1:end][1:2])
    @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerses 1-2\n\nTable with 19 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    out = capture_io(crpsdata[[112,113]][1])
    @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerse 1\n\nTable with 10 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    out = capture_io(crpsdata[[112,113]][[1,2]])
    @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerses 1, 2\n\nTable with 17 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

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
    out = capture_io(meta)
    @test out === "Quranic Arabic Corpus (morphology) v0.4\nCopyright (C) 2011 Kais Dukes\nGNU General Public License\nhttp://corpus.quran.com/\n\nThe Quranic Arabic Corpus includes syntactic and morphological\nannotation of the Qur'an, and builds on the verified Arabic text\ndistributed by the Tanzil project.\n\n"

    out = capture_io(crpsdata[[112,113]][1:2])
    @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerses 1-2\n\nTable with 17 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    out = @capture_out begin
        description(parse(Features, select(crpsdata[1].data, :features)[1]))
    end;
    @test out === """Prefix
    ──────
    Preposition:
     ├ data: P
     ├ desc: Preposition prefix ('by', 'with', 'in')
     └ ar_label: حرف جر\n"""

    out = @capture_out begin
        @desc parse(Features, select(crpsdata[1].data, :features)[end])
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
    
    out = @capture_out begin crpsdata[1][1][1][1] end;
    out === """Chapter 1 ٱلْفَاتِحَة (The Opening)
    Verse 1
    
    Table with 1 rows, 5 columns:
    word  part  form  tag  features
    ─────────────────────────────────────────────
    1     1     "bi"  "P"  Features("PREFIX|bi+")\n""";

    out = @desc(1)
    @test out === missing;
    
    
    # out = @capture_out(pretty_table(crpsdata));
    # @test out[1000:2000] === "────────────────────────────────────────────────────────\n        1       1       1       1                 bi        P                                                             Features(\"PREFIX|bi+\")\n        1       1       1       2               somi        N                                     Features(\"STEM|POS:N|LEM:{som|ROOT:smw|M|GEN\")\n        1       1       2       1            {ll~ahi       PN                                    Features(\"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\")\n        1       1       3       1                 {l      DET                                                             Features(\"PREFIX|Al+\")\n        1       1       3       2         r~aHoma`ni      ADJ                             Features(\"STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\")\n        1       1       4       1                 {l      DET                                              "
    
    # out = @capture_out(pretty_table(crpsdata[1]));
    # @test out[1000:2000] === "                                                Features(\"PREFIX|bi+\")\n      1       1       2          somi        N                         Features(\"STEM|POS:N|LEM:{som|ROOT:smw|M|GEN\")\n      1       2       1       {ll~ahi       PN                        Features(\"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\")\n      1       3       1            {l      DET                                                 Features(\"PREFIX|Al+\")\n      1       3       2    r~aHoma`ni      ADJ                 Features(\"STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\")\n      1       4       1            {l      DET                                                 Features(\"PREFIX|Al+\")\n      1       4       2      r~aHiymi      ADJ                   Features(\"STEM|POS:ADJ|LEM:r~aHiym|ROOT:rHm|MS|GEN\")\n      2       1       1           {lo      DET                                                 Features(\"PREFIX|Al+\")\n      2       1       2        Hamodu        N                        Features(\"STEM|POS:N|LEM:Hamod|ROO"
    
    # out = @capture_out(pretty_table(crpsdata[1][1]))
    # @test out === "────────────────────────────────────────────────────────────────────────────────────────────────\n   word    part         form      tag                                                 features\n  Int64   Int64       String   String                                                 Features\n────────────────────────────────────────────────────────────────────────────────────────────────\n      1       1           bi        P                                   Features(\"PREFIX|bi+\")\n      1       2         somi        N           Features(\"STEM|POS:N|LEM:{som|ROOT:smw|M|GEN\")\n      2       1      {ll~ahi       PN          Features(\"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\")\n      3       1           {l      DET                                   Features(\"PREFIX|Al+\")\n      3       2   r~aHoma`ni      ADJ   Features(\"STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\")\n      4       1           {l      DET                                   Features(\"PREFIX|Al+\")\n      4       2     r~aHiymi      ADJ     Features(\"STEM|POS:ADJ|LEM:r~aHiym|ROOT:rHm|MS|GEN\")\n────────────────────────────────────────────────────────────────────────────────────────────────\n"
    
    # out = @capture_out(pretty_table(crpsdata[1][1:2]))
    # @test out[end-1000:end] === "{lo      DET                                   Features(\"PREFIX|Al+\")\n      2       1       2       Hamodu        N          Features(\"STEM|POS:N|LEM:Hamod|ROOT:Hmd|M|NOM\")\n      2       2       1           li        P                                  Features(\"PREFIX|l:P+\")\n      2       2       2        l~ahi       PN          Features(\"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\")\n      2       3       1        rab~i        N           Features(\"STEM|POS:N|LEM:rab~|ROOT:rbb|M|GEN\")\n      2       4       1          {lo      DET                                   Features(\"PREFIX|Al+\")\n      2       4       2   Ea`lamiyna        N     Features(\"STEM|POS:N|LEM:Ea`lamiyn|ROOT:Elm|MP|GEN\")\n────────────────────────────────────────────────────────────────────────────────────────────────────────\n"
    
    # remaining todo:
    #   check pretty_table
    #   test display/show
    #   use suppressor

end
