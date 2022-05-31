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
    @test crps[end] === "(114:6:3:3)\tn~aAsi\tN\tSTEM|POS:N|LEM:n~aAs|ROOT:nws|MP|GEN"
    @test tnzl[begin] === "1|1|بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test typeof(crps) === CorpusRaw
    @test typeof(tnzl) === TanzilRaw

    # indexing
    crpsdata = table(crps)
    tnzldata = table(tnzl)
    
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
    
    # arabic
    @test arabic(verses(crpsdata[114])[1]) === "قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ"
    @test arabic(verses(crpsdata[1][7])[1]) === "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ"
    # # number
    @test verses(crpsdata[113:114], number=true)[1] === "113:(1,5)"
    @test verses(crpsdata[113:114], number=true, start_end=false)[1] == ([113], [1, 2, 3, 4, 5])

    # words
    @test words(tnzldata[1][7])[1] === "صِرَٰطَ"

    # encoding
    @test encode(arabic(verses(crpsdata[1][7])[1])) === verses(crpsdata[1][7])[1]

    # chapter_name
    @test chapter_name(crpsdata[13][2][1]) === "ٱلرَّعْد"
    @test chapter_name(tnzldata[13][2]) === "ٱلرَّعْد"
    @test chapter_name(tnzldata[1], lang=:english) === "The Opening"

    # # dediac
    @test dediac(verses(crpsdata[1][1])[1]) === "bsm {llh {lrHmn {lrHym"
    @test dediac(arabic(verses(crpsdata[1][1])[1])) === "بسم ٱلله ٱلرحمن ٱلرحيم"
    @test dediac(arabic(verses(crpsdata[1][1])[1])) === arabic(dediac(verses(crpsdata[1][1])[1]))

    # # normalize
    @test normalize(dediac(verses(crpsdata[1][1])[1])) === "bsm Allh AlrHmn AlrHym"
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
    my_encoder = Dict(
        Symbol(Char(0x0621)) => Symbol('('),
        Symbol(Char(0x0622)) => Symbol('\''),
        Symbol(Char(0x0623)) => Symbol('&'),
        Symbol(Char(0x0624)) => Symbol('>'),
        Symbol(Char(0x0625)) => Symbol('}'),
        Symbol(Char(0x0626)) => Symbol('<'),
        Symbol(Char(0x0627)) => Symbol('b'),
        Symbol(Char(0x0628)) => Symbol('A'),
        Symbol(Char(0x0629)) => Symbol('t'),
        Symbol(Char(0x062A)) => Symbol('p'),
        Symbol(Char(0x062B)) => Symbol('j'),
        Symbol(Char(0x062C)) => Symbol('v'),
        Symbol(Char(0x062D)) => Symbol('x'),
        Symbol(Char(0x062E)) => Symbol('H'),
        Symbol(Char(0x062F)) => Symbol('*'),
        Symbol(Char(0x0630)) => Symbol('d'),
        Symbol(Char(0x0631)) => Symbol('z'),
        Symbol(Char(0x0632)) => Symbol('r'),
        Symbol(Char(0x0633)) => Symbol('$'),
        Symbol(Char(0x0634)) => Symbol('s'),
        Symbol(Char(0x0635)) => Symbol('D'),
        Symbol(Char(0x0636)) => Symbol('S'),
        Symbol(Char(0x0637)) => Symbol('Z'),
        Symbol(Char(0x0638)) => Symbol('T'),
        Symbol(Char(0x0639)) => Symbol('g'),
        Symbol(Char(0x063A)) => Symbol('E'),
        Symbol(Char(0x0640)) => Symbol('f'),
        Symbol(Char(0x0641)) => Symbol('_'),
        Symbol(Char(0x0642)) => Symbol('k'),
        Symbol(Char(0x0643)) => Symbol('q'),
        Symbol(Char(0x0644)) => Symbol('m'),
        Symbol(Char(0x0645)) => Symbol('l'),
        Symbol(Char(0x0646)) => Symbol('h'),
        Symbol(Char(0x0647)) => Symbol('n'),
        Symbol(Char(0x0648)) => Symbol('Y'),
        Symbol(Char(0x0649)) => Symbol('w'),
        Symbol(Char(0x064A)) => Symbol('F'),
        Symbol(Char(0x064B)) => Symbol('y'),
        Symbol(Char(0x064C)) => Symbol('K'),
        Symbol(Char(0x064D)) => Symbol('N'),
        Symbol(Char(0x064E)) => Symbol('u'),
        Symbol(Char(0x064F)) => Symbol('a'),
        Symbol(Char(0x0650)) => Symbol('~'),
        Symbol(Char(0x0651)) => Symbol('i'),
        Symbol(Char(0x0652)) => Symbol('^'),
        Symbol(Char(0x0653)) => Symbol('o'),
        Symbol(Char(0x0654)) => Symbol('`'),
        Symbol(Char(0x0670)) => Symbol('#'),
        Symbol(Char(0x0671)) => Symbol(':'),
        Symbol(Char(0x06DC)) => Symbol('{'),
        Symbol(Char(0x06DF)) => Symbol('\"'),
        Symbol(Char(0x06E0)) => Symbol('@'),
        Symbol(Char(0x06E2)) => Symbol(';'),
        Symbol(Char(0x06E3)) => Symbol('['),
        Symbol(Char(0x06E5)) => Symbol('.'),
        Symbol(Char(0x06E6)) => Symbol(','),
        Symbol(Char(0x06E8)) => Symbol('-'),
        Symbol(Char(0x06EA)) => Symbol('!'),
        Symbol(Char(0x06EB)) => Symbol('%'),
        Symbol(Char(0x06EC)) => Symbol('+'),
        Symbol(Char(0x06ED)) => Symbol(']')
    );

    basmala = arabic(verses(crpsdata[1][1])[1])

    @transliterator my_encoder "MyEncoder"
    @test encode(basmala) === "A~\$^l~ :mmiun~ :mziux^lu#h~ :mziux~Fl~"
    @test arabic(encode(basmala)) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test dediac(encode(basmala)) === "A\$l :mmn :mzxlh :mzxFl"
    @test normalize(encode(basmala)) === "A~\$^l~ bmmiun~ bmziux^lubh~ bmziux~Fl~"

    @transliterator :default
    @test encode(basmala) === "bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"
    @test arabic(encode(basmala)) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
    @test dediac(encode(basmala)) === "bsm {llh {lrHmn {lrHym"
    @test normalize(encode(basmala)) === "bisomi All~ahi Alr~aHomaAni Alr~aHiymi"

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
    @test isfeat(parse(QuranFeatures, crpsdata.data[2, :features]), Genetive) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[24, :features]), VerbFormI) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[27, :features]), VerbFormI) === false
    @test isfeat(parse(QuranFeatures, crpsdata.data[27, :features]), Indicative) === true
    @test isfeat(parse(QuranFeatures, crpsdata.data[126, :features]), Indicative) === false
    @test isfeat(parse(QuranFeatures, crpsdata.data[86, :features]), Active) === false
    @test isfeat(parse(QuranFeatures, crpsdata.data[36, :features]), Active) === true

    @test parse(SimpleEncoding, verses(tnzldata)[1]) === "Ba+Kasra | Seen+Sukun | Meem+Kasra | <space> | AlifHamzatWasl | Lam | Lam+Shadda+Fatha | Ha+Kasra | <space> | AlifHamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Sukun | Meem+Fatha+AlifKhanjareeya | Noon+Kasra | <space> | AlifHamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Kasra | Ya | Meem+Kasra"
    # printing
    # out = capture_io(crpsdata[1][1][1][1]);
    # @test out === """
    # Chapter 1 ٱلْفَاتِحَة (The Opening)
    # Verse 1
    
    # 1×5 DataFrame
    # │ Row │ word  │ part  │ form   │ tag    │ features   │
    # │     │ Int64 │ Int64 │ String │ String │ String     │
    # ├─────┼───────┼───────┼────────┼────────┼────────────┤
    # │ 1   │ 1     │ 1     │ bi     │ P      │ PREFIX|bi+ │
    # """

    # out = capture_io(tnzldata);
    # @test out === "Tanzil Quran Text (Uthmani)\n(C) 2008-2010 Tanzil.net\n\nTable with 6236 rows, 3 columns:\nchapter  verse  form\n─────────────────────────────────────────────────────────────────────\n1        1      \"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\"\n1        2      \"ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ\"\n1        3      \"ٱلرَّحْمَٰنِ ٱلرَّحِيمِ\"\n1        4      \"مَٰلِكِ يَوْمِ ٱلدِّينِ\"\n1        5      \"إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\"\n1        6      \"ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ\"\n1        7      \"صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ\"\n2        1      \"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ الٓمٓ\"\n2        2      \"ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ\"\n⋮\n113      4      \"وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِى ٱلْعُقَدِ\"\n113      5      \"وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ\"\n114      1      \"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ\"\n114      2      \"مَلِكِ ٱلنَّاسِ\"\n114      3      \"إِلَٰهِ ٱلنَّاسِ\"\n114      4      \"مِن شَرِّ ٱلْوَسْوَاسِ ٱلْخَنَّاسِ\"\n114      5      \"ٱلَّذِى يُوَسْوِسُ فِى صُدُورِ ٱلنَّاسِ\"\n114      6      \"مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ\"\n\n"

    # out = capture_io(Noun());
    # @test out === "N\n"

    # out = capture_io(crps);
    # @test out[5000:6000] === "ka\\tDEM\\tSTEM|POS:DEM|LEM:*a`lik|MS\", \"(2:2:2:1)\\t{lo\\tDET\\tPREFIX|Al+\", \"(2:2:2:2)\\tkita`bu\\tN\\tSTEM|POS:N|LEM:kita`b|ROOT:ktb|M|NOM\", \"(2:2:3:1)\\tlaA\\tNEG\\tSTEM|POS:NEG|LEM:laA|SP:<in~\", \"(2:2:4:1)\\trayoba\\tN\\tSTEM|POS:N|LEM:rayob|ROOT:ryb|M|ACC\", \"(2:2:5:1)\\tfiy\\tP\\tSTEM|POS:P|LEM:fiY\", \"(2:2:5:2)\\thi\\tPRON\\tSUFFIX|PRON:3MS\", \"(2:2:6:1)\\thudFY\\tN\\tSTEM|POS:N|LEM:hudFY|ROOT:hdy|M|INDEF|NOM\", \"(2:2:7:1)\\tl~i\\tP\\tPREFIX|l:P+\", \"(2:2:7:2)\\tlo\\tDET\\tPREFIX|Al+\", \"(2:2:7:3)\\tmut~aqiyna\\tN\\tSTEM|POS:N|ACT|PCPL|(VIII)|LEM:mut~aqiyn|ROOT:wqy|MP|GEN\", \"(2:3:1:1)\\t{l~a*iyna\\tREL\\tSTEM|POS:REL|LEM:{l~a*iY|MP\", \"(2:3:2:1)\\tyu&ominu\\tV\\tSTEM|POS:V|IMPF|(IV)|LEM:'aAmana|ROOT:Amn|3MP\", \"(2:3:2:2)\\twna\\tPRON\\tSUFFIX|PRON:3MP\", \"(2:3:3:1)\\tbi\\tP\\tPREFIX|bi+\", \"(2:3:3:2)\\t{lo\\tDET\\tPREFIX|Al+\", \"(2:3:3:3)\\tgayobi\\tN\\tSTEM|POS:N|LEM:gayob|ROOT:gyb|M|GEN\", \"(2:3:4:1)\\twa\\tCONJ\\tPREFIX|w:CONJ+\", \"(2:3:4:2)\\tyuqiymu\\tV\\tSTEM|POS:V|IMPF|(IV)|LEM:>aqaAma|ROOT:qwm|3MP\", \"(2:3:4:3)\\twna\\tPRON\\tSUFFIX|PRON:3MP\""

    # out = capture_io(tnzl);
    # @test out[5000:5110] === "ن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ\", \"2|22|ٱلَّذِى جَعَلَ لَكُ"

    # out = capture_io(crpsdata[1]);
    # @test out === "Chapter 1: ٱلْفَاتِحَة (The Opening)\n\nTable with 48 rows, 6 columns:\nColumns:\n#  colname   type\n───────────────────\n1  verse     Int64\n2  word      Int64\n3  part      Int64\n4  form      String\n5  tag       String\n6  features  String\n\n"

    # out = capture_io(crpsdata[[112,113]]);
    # @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\n\nTable with 49 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    # out = capture_io(crpsdata[end-1:end]);
    # @test out === "Chapter 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\n\nTable with 60 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    # out = capture_io(crpsdata[1][1]);
    # @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerse 1\n\nTable with 7 rows, 5 columns:\nword  part  form          tag    features\n─────────────────────────────────────────────────────────────────────────────\n1     1     \"bi\"          \"P\"    \"PREFIX|bi+\"\n1     2     \"somi\"        \"N\"    \"STEM|POS:N|LEM:{som|ROOT:smw|M|GEN\"\n2     1     \"{ll~ahi\"     \"PN\"   \"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\"\n3     1     \"{l\"          \"DET\"  \"PREFIX|Al+\"\n3     2     \"r~aHoma`ni\"  \"ADJ\"  \"STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\"\n4     1     \"{l\"          \"DET\"  \"PREFIX|Al+\"\n4     2     \"r~aHiymi\"    \"ADJ\"  \"STEM|POS:ADJ|LEM:r~aHiym|ROOT:rHm|MS|GEN\"\n\n"

    # out = capture_io(crpsdata[1][1:2]);
    # @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerses 1-2\n\nTable with 14 rows, 6 columns:\nColumns:\n#  colname   type\n───────────────────\n1  verse     Int64\n2  word      Int64\n3  part      Int64\n4  form      String\n5  tag       String\n6  features  String\n\n"

    # out = capture_io(crpsdata[1][[1,2]]);
    # @test out === "Chapter 1 ٱلْفَاتِحَة (The Opening)\nVerses 1, 2\n\nTable with 14 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"
    
    # out = capture_io(crpsdata[end-1:end][1]);
    # @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerse 1\n\nTable with 12 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    # out = capture_io(crpsdata[end-1:end][[1,2]]);
    # @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerses 1, 2\n\nTable with 19 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    # out = capture_io(crpsdata[end-1:end][1:2]);
    # @test out === "Chapters 113-114: ٱلْفَلَق-ٱلنَّاس (Daybreak-People)\nVerses 1-2\n\nTable with 19 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    # out = capture_io(crpsdata[[112,113]][1]);
    # @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerse 1\n\nTable with 10 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    # out = capture_io(crpsdata[[112,113]][[1,2]]);
    # @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerses 1, 2\n\nTable with 17 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    # meta = MetaData(
    #     "Quranic Arabic Corpus (morphology)",
    #     "Kais Dukes",
    #     "The Quranic Arabic Corpus includes syntactic and morphological\nannotation of the Qur'an, and builds on the verified Arabic text\ndistributed by the Tanzil project.",
    #     "http://corpus.quran.com/",
    #     "English",
    #     "2011",
    #     "GNU General Public License",
    #     "0.4"
    # )
    # out = capture_io(meta);
    # @test out === "Quranic Arabic Corpus (morphology) v0.4\nCopyright (C) 2011 Kais Dukes\nGNU General Public License\nhttp://corpus.quran.com/\n\nThe Quranic Arabic Corpus includes syntactic and morphological\nannotation of the Qur'an, and builds on the verified Arabic text\ndistributed by the Tanzil project.\n\n"

    # out = capture_io(crpsdata[[112,113]][1:2]);
    # @test out === "Chapters: \n ├112 (ٱلْإِخْلَاص-Purity of Faith) \n └113 (ٱلْفَلَق-Daybreak)\nVerses 1-2\n\nTable with 17 rows, 7 columns:\nColumns:\n#  colname   type\n───────────────────\n1  chapter   Int64\n2  verse     Int64\n3  word      Int64\n4  part      Int64\n5  form      String\n6  tag       String\n7  features  String\n\n"

    # out = @capture_out begin
    #     description(parse(QuranFeatures, select(crpsdata[1].data, :features)[1]))
    # end;
    # @test out === """Prefix
    # ──────
    # Preposition:
    #  ├ data: P
    #  ├ desc: Preposition prefix ('by', 'with', 'in')
    #  └ ar_label: حرف جر\n"""

    out = @capture_out begin
        @desc parse(QuranFeatures, select(crpsdata[1].data, :features)[end])
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
    
    # out = @capture_out begin crpsdata[1][1][1][1] end;
    # out === """Chapter 1 ٱلْفَاتِحَة (The Opening)
    # Verse 1
    
    # Table with 1 rows, 5 columns:
    # word  part  form  tag  features
    # ─────────────────────────────────────────────
    # 1     1     "bi"  "P"  QuranFeatures("PREFIX|bi+")\n""";

    # out = @desc(1)
    # @test out === missing;
    
    
    # # out = @capture_out(pretty_table(crpsdata));
    # # @test out[1000:2000] === "────────────────────────────────────────────────────────\n        1       1       1       1                 bi        P                                                             QuranFeatures(\"PREFIX|bi+\")\n        1       1       1       2               somi        N                                     QuranFeatures(\"STEM|POS:N|LEM:{som|ROOT:smw|M|GEN\")\n        1       1       2       1            {ll~ahi       PN                                    QuranFeatures(\"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\")\n        1       1       3       1                 {l      DET                                                             QuranFeatures(\"PREFIX|Al+\")\n        1       1       3       2         r~aHoma`ni      ADJ                             QuranFeatures(\"STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\")\n        1       1       4       1                 {l      DET                                              "
    
    # # out = @capture_out(pretty_table(crpsdata[1]));
    # # @test out[1000:2000] === "                                                QuranFeatures(\"PREFIX|bi+\")\n      1       1       2          somi        N                         QuranFeatures(\"STEM|POS:N|LEM:{som|ROOT:smw|M|GEN\")\n      1       2       1       {ll~ahi       PN                        QuranFeatures(\"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\")\n      1       3       1            {l      DET                                                 QuranFeatures(\"PREFIX|Al+\")\n      1       3       2    r~aHoma`ni      ADJ                 QuranFeatures(\"STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\")\n      1       4       1            {l      DET                                                 QuranFeatures(\"PREFIX|Al+\")\n      1       4       2      r~aHiymi      ADJ                   QuranFeatures(\"STEM|POS:ADJ|LEM:r~aHiym|ROOT:rHm|MS|GEN\")\n      2       1       1           {lo      DET                                                 QuranFeatures(\"PREFIX|Al+\")\n      2       1       2        Hamodu        N                        QuranFeatures(\"STEM|POS:N|LEM:Hamod|ROO"
    
    # # out = @capture_out(pretty_table(crpsdata[1][1]))
    # # @test out === "────────────────────────────────────────────────────────────────────────────────────────────────\n   word    part         form      tag                                                 features\n  Int64   Int64       String   String                                                 QuranFeatures\n────────────────────────────────────────────────────────────────────────────────────────────────\n      1       1           bi        P                                   QuranFeatures(\"PREFIX|bi+\")\n      1       2         somi        N           QuranFeatures(\"STEM|POS:N|LEM:{som|ROOT:smw|M|GEN\")\n      2       1      {ll~ahi       PN          QuranFeatures(\"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\")\n      3       1           {l      DET                                   QuranFeatures(\"PREFIX|Al+\")\n      3       2   r~aHoma`ni      ADJ   QuranFeatures(\"STEM|POS:ADJ|LEM:r~aHoma`n|ROOT:rHm|MS|GEN\")\n      4       1           {l      DET                                   QuranFeatures(\"PREFIX|Al+\")\n      4       2     r~aHiymi      ADJ     QuranFeatures(\"STEM|POS:ADJ|LEM:r~aHiym|ROOT:rHm|MS|GEN\")\n────────────────────────────────────────────────────────────────────────────────────────────────\n"
    
    # # out = @capture_out(pretty_table(crpsdata[1][1:2]))
    # # @test out[end-1000:end] === "{lo      DET                                   QuranFeatures(\"PREFIX|Al+\")\n      2       1       2       Hamodu        N          QuranFeatures(\"STEM|POS:N|LEM:Hamod|ROOT:Hmd|M|NOM\")\n      2       2       1           li        P                                  QuranFeatures(\"PREFIX|l:P+\")\n      2       2       2        l~ahi       PN          QuranFeatures(\"STEM|POS:PN|LEM:{ll~ah|ROOT:Alh|GEN\")\n      2       3       1        rab~i        N           QuranFeatures(\"STEM|POS:N|LEM:rab~|ROOT:rbb|M|GEN\")\n      2       4       1          {lo      DET                                   QuranFeatures(\"PREFIX|Al+\")\n      2       4       2   Ea`lamiyna        N     QuranFeatures(\"STEM|POS:N|LEM:Ea`lamiyn|ROOT:Elm|MP|GEN\")\n────────────────────────────────────────────────────────────────────────────────────────────────────────\n"
    
    # # remaining todo:
    # #   check pretty_table
    # #   test display/show
    # #   use suppressor

end