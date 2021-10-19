# using DataFrames: Not
# import PrettyTables: pretty_table, tf_html_simple, TextFormat, tf_mysql
# const _TF_COMPACT_ = TextFormat(up_right_corner = '─',
#                    up_left_corner      = '─',
#                    bottom_left_corner  = '─',
#                    bottom_right_corner = '─',
#                    up_intersection     = '─',
#                    left_intersection   = '─',
#                    right_intersection  = '─',
#                    middle_intersection = '─',
#                    bottom_intersection = '─',
#                    column              = ' ',
#                    row                 = '─',
#                    hlines              = [:begin,:header,:end],
#                    vlines              = :all);

# function pretty_table(quran::AbstractQuran; kwargs...)
#     if quran isa Chapter
#         if quran.numbers isa Int64
#             tbl = select(quran.data, Not(:chapter))
#         else
#             tbl = quran.data
#         end
#     elseif quran isa Verse
#         if quran.chapters isa Int64 && quran.numbers isa Int64
#             tbl = select(quran.data, Not(:chapter, :verse))
#         elseif quran.chapters isa Int64 && quran.numbers isa UnitRange{Int64}
#             tbl = select(quran.data, Not(:chapter))
#         elseif quran.chapters isa UnitRange{Int64} && quran.numbers isa Int64
#             tbl = quran.data
#         else
#             tbl = quran.data
#         end
#     elseif quran isa Word
#         if quran.chapters isa Int64 && quran.verses isa Int64 && quran.numbers isa Int64
#             tbl = select(quran.data, Not(:chapter, :verse, :word))
#         elseif quran.chapters isa Int64 && quran.verses isa Int64 && quran.numbers isa UnitRange{Int64}
#             tbl = select(quran.data, Not(:chapter, :verse))
#         elseif quran.chapters isa Int64 && quran.verses isa UnitRange{Int64} && quran.numbers isa Int64
#             tbl = select(quran.data, Not(:chapter))
#         elseif quran.chapters isa Int64 && quran.verses isa UnitRange{Int64} && quran.numbers isa UnitRange{Int64}
#             tbl = select(quran.data, Not(:chapter))
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa Int64 && quran.numbers isa Int64
#             tbl = quran.data
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa Int64 && quran.numbers isa UnitRange{Int64}
#             tbl = quran.data
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa UnitRange{Int64} && quran.numbers isa Int64
#             tbl = quran.data
#         else
#             tbl = quran.data
#         end
#     elseif quran isa Part
#         if quran.chapters isa Int64 && quran.verses isa Int64 && quran.words isa Int64 && quran.numbers isa Int64
#             tbl = select(quran.data, Not(:chapter, :verse, :word, :part))
#         elseif quran.chapters isa Int64 && quran.verses isa Int64 && quran.words isa Int64 && quran.numbers isa UnitRange{Int64}
#             tbl = select(quran.data, Not(:chapter, :verse, :word))
#         elseif quran.chapters isa Int64 && quran.verses isa Int64 && quran.words isa UnitRange{Int64} && quran.numbers isa UnitRange{Int64}
#             tbl = select(quran.data, Not(:chapter, :verse))
#         elseif quran.chapters isa Int64 && quran.verses isa Int64 && quran.words isa UnitRange{Int64} && quran.numbers isa Int64
#             tbl = select(quran.data, Not(:chapter, :verse))
#         elseif quran.chapters isa Int64 && quran.verses isa UnitRange{Int64} && quran.words isa UnitRange{Int64} && quran.numbers isa UnitRange{Int64}
#             tbl = select(quran.data, Not(:chapter, :verse))
#         elseif quran.chapters isa Int64 && quran.verses isa UnitRange{Int64} && quran.words isa UnitRange{Int64} && quran.numbers isa Int64
#             tbl = select(quran.data, Not(:chapter, :verse))
#         elseif quran.chapters isa Int64 && quran.verses isa UnitRange{Int64} && quran.words isa Int64 && quran.numbers isa UnitRange{Int64}
#             tbl = select(quran.data, Not(:chapter))
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa UnitRange{Int64} && quran.words isa UnitRange{Int64} && quran.numbers isa UnitRange{Int64}
#             tbl = quran.data
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa UnitRange{Int64} && quran.words isa UnitRange{Int64} && quran.numbers isa Int64
#             tbl = quran.data
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa UnitRange{Int64} && quran.words isa Int64 && quran.numbers isa UnitRange{Int64}
#             tbl = quran.data
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa Int64 && quran.words isa UnitRange{Int64} && quran.numbers isa UnitRange{Int64}
#             tbl = quran.data
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa UnitRange{Int64} && quran.words isa Int64 && quran.numbers isa Int64
#             tbl = quran.data
#         elseif quran.chapters isa Int64 && quran.verses isa Int64 && quran.words isa UnitRange{Int64} && quran.numbers isa UnitRange{Int64}
#             tbl = select(quran.data, Not(:chapter, :verse))
#         elseif quran.chapters isa Int64 && quran.verses isa UnitRange{Int64} && quran.words isa UnitRange{Int64} && quran.numbers isa Int64
#             tbl = select(quran.data, Not(:chapter))
#         elseif quran.chapters isa UnitRange{Int64} && quran.verses isa Int64 && quran.words isa Int64 && quran.numbers isa UnitRange{Int64}
#             tbl = quran.data
#         else
#             tbl = quran.data
#         end
#     else 
#         tbl = quran.data
#     end
#     pretty_table(tbl; kwargs...)
# end

function description(feat::Union{Lemma,Root,Special})
    println(typeof(feat), ":")
    println(" └ data: ", feat.data)
end

function description(feat::AbstractPartOfSpeech)
    println(typeof(feat), ":"); j = 1
    fields = fieldnames(typeof(feat))
    for f in fields
        if j < length(fields)
            if length(fields) > 1
                println(" ├ ", f, ": ", getproperty(feat, f))
            else
                println(" └ ", f, ": ", getproperty(feat, f))
            end
        else
            println(" └ ", f, ": ", getproperty(feat, f))
        end
        j += 1
    end
end

function description(feat::Union{Prefix,Stem,Suffix})
    println(typeof(feat))
    println(join(repeat(["─"], length(string(typeof(feat))))))
    if length(fieldnames(typeof(feat))) < 3
        description(feat.pos)
    else
        description(feat.pos)
        for f in feat.feats
            description(f)
        end
    end
end

"""
    @desc(expr)

Extract the detailed description of a `AbstractFeature`.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps);
julia> tnzldata = table(tnzl);
julia> feat = parse(Features, select(crpsdata.data, :features)[53])
julia> @desc feat
Stem
────
Negative:
 ├ data: NEG
 ├ desc: Negative particle
 └ ar_label: حرف نفي
Lemma:
 └ data: laA
Special:
 └ data: <in~
```
"""
macro desc(expr)
    esc(quote
        try
            return description(eval($expr))
        catch
            return missing
        end
    end)
end

"""
    @data(expr)

Extract the data property object.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps);
julia> tnzldata = table(tnzl);
julia> feat = parse(Features, select(crpsdata.data, :features)[53])
julia> @data feat
:NEG
```
"""
macro data(expr)
    return esc(Meta.parse(string(expr) * ".data"))
end

function Base.show(io::IO, t::AbstractPartOfSpeech)
    print(io, t.data)
end

function Base.show(io::IO, t::SimpleEncoder)
    println(io, typeof(t), ":")
    println(io, " └ encoder: ", t.encode)
end

function Base.show(io::IO, m::MetaData)
    println(io, m.title, " v", m.version)
    println(io, "Copyright (C) ", m.year, " ", m.author)
    println(io, m.license)
    println(io, m.website, "\n")
    println(io, m.description)
end

function Base.show(io::IO, ::MIME"text/plain", c::CorpusRaw)
    print(io, "(CorpusRaw) ")
    show(io, "text/plain", c.data)
end

function Base.show(io::IO, ::MIME"text/plain", c::TanzilRaw)
    print(io, "(TanzilRaw) ")
    show(io, "text/plain", c.data)
end

function Base.show(io::IO, m::CorpusData)
    println(io, m.meta.title)
    println(io, "(C) ", m.meta.year, " ", m.meta.author, "\n")
    println(io, m.data)
end

function Base.show(io::IO, m::TanzilData)
    println(io, m.meta.title)
    println(io, "(C) ", m.meta.year, " ", m.meta.author, "\n")
    println(io, m.data)
end

function Base.show(io::IO, quran::Chapter)
    chapterlab = ChapterLabel()
    if quran.numbers isa Int64
        println(io, "Chapter ", quran.numbers, ": ", chapterlab.arabic[quran.numbers], " (", chapterlab.english[quran.numbers], ")\n")
        println(io, quran.data[!, Not(:chapter)])
    elseif quran.numbers isa Array{Int64}
        println(io, "Chapters: "); j = 1
        for i in quran.numbers
            if j < length(quran.numbers)
                if length(quran.numbers) > 1
                    print(io, " ├")
                    println(io, lpad(i, 3), " (", chapterlab.arabic[i], "-", chapterlab.english[i], ") ")
                else
                    print(io, " └")
                    print(io, i, " (", chapterlab.arabic[i], "-", chapterlab.english[i], ") ")
                end
            else
                print(io, " └")
                print(io, lpad(i, 3), " (", chapterlab.arabic[i], "-", chapterlab.english[i], ")")
            end
            j += 1
        end
        println(io, "\n")
        println(io, quran.data)
    else
        println(io, "Chapter ", quran.numbers.start, "-", quran.numbers.stop, ": ", 
            chapterlab.arabic[quran.numbers.start], "-", chapterlab.arabic[quran.numbers.stop], 
            " (", chapterlab.english[quran.numbers.start], "-", chapterlab.english[quran.numbers.stop], ")\n")
        println(io, quran.data)
    end
end

function Base.show(io::IO, quran::Union{Verse,Word,Part})
    if quran isa Union{Word,Part}
        verse = quran.verses
    else
        verse = quran.numbers
    end
    chapterlab = ChapterLabel()
    if quran.chapters isa Int64 && verse isa Int64
        println(io, "Chapter ", quran.chapters, " ", chapterlab.arabic[quran.chapters], " (", chapterlab.english[quran.chapters], ")")
        println(io, "Verse ", verse, "\n")
        println(io, quran.data[!, Not([:chapter, :verse])])
    elseif quran.chapters isa Int64 && verse isa UnitRange{Int64}
        println(io, "Chapter ", quran.chapters, " ", chapterlab.arabic[quran.chapters], " (", chapterlab.english[quran.chapters], ")")
        println(io, "Verses ", verse.start, "-", verse.stop, "\n")
        println(io, quran.data[!, Not(:chapter)])
    elseif quran.chapters isa Int64 && verse isa Array{Int64,1}
        println(io, "Chapter ", quran.chapters, " ", chapterlab.arabic[quran.chapters], " (", chapterlab.english[quran.chapters], ")")
        if length(verse) > 1
            print(io, "Verses ")
        else
            print(io, "Verse ")
        end
        j = 1
        for i in verse
            if j < length(verse)
                print(io, i, ", ")
            else
                println(io, i)
            end
            j += 1
        end
        println(io, "\n", quran.data)
    elseif quran.chapters isa UnitRange{Int64} && verse isa Int64
        println(io, "Chapters ", quran.chapters.start, "-", quran.chapters.stop, ": ", 
            chapterlab.arabic[quran.chapters.start], "-", chapterlab.arabic[quran.chapters.stop], 
            " (", chapterlab.english[quran.chapters.start], "-", chapterlab.english[quran.chapters.stop], ")")
        println(io, "Verse ", verse, "\n")
        println(io, quran.data)
    elseif quran.chapters isa UnitRange{Int64} && verse isa Array{Int64,1}
        println(io, "Chapters ", quran.chapters.start, "-", quran.chapters.stop, ": ", 
            chapterlab.arabic[quran.chapters.start], "-", chapterlab.arabic[quran.chapters.stop], 
            " (", chapterlab.english[quran.chapters.start], "-", chapterlab.english[quran.chapters.stop], ")")
        if length(verse) > 1
            print(io, "Verses ")
        else
            print(io, "Verse ")
        end
        j = 1
        for i in verse
            if j < length(verse)
                print(io, i, ", ")
            else
                println(io, i)
            end
            j += 1
        end
        println(io, "\n", quran.data)
    elseif quran.chapters isa UnitRange{Int64} && verse isa UnitRange{Int64}
        println(io, "Chapters ", quran.chapters.start, "-", quran.chapters.stop, ": ", 
            chapterlab.arabic[quran.chapters.start], "-", chapterlab.arabic[quran.chapters.stop], 
            " (", chapterlab.english[quran.chapters.start], "-", chapterlab.english[quran.chapters.stop], ")")
        println(io, "Verses ", verse.start, "-", verse.stop, "\n")
        println(io, quran.data)
    elseif quran.chapters isa Array{Int64,1} && verse isa UnitRange{Int64}
        if length(quran.chapters) > 1
            println(io, "Chapters: ")
        else
            println(io, "Chapter: ")
        end
        
        j = 1
        for i in quran.chapters
            if j < length(quran.chapters)
                if length(quran.chapters) > 1
                    print(io, " ├")
                    println(io, lpad(i, 3), " (", chapterlab.arabic[i], "-", chapterlab.english[i], ") ")
                else
                    print(io, " └")
                    print(io, i, " (", chapterlab.arabic[i], "-", chapterlab.english[i], ") ")
                end
            else
                print(io, " └")
                print(io, lpad(i, 3), " (", chapterlab.arabic[i], "-", chapterlab.english[i], ")")
            end
            j += 1
        end
        println(io, "\nVerses ", verse.start, "-", verse.stop, "\n")
        println(io, quran.data)
    elseif quran.chapters isa Array{Int64,1} && verse isa Int64
        if length(quran.chapters) > 1
            println(io, "Chapters: ")
        else
            println(io, "Chapter: ")
        end
        
        j = 1
        for i in quran.chapters
            if j < length(quran.chapters)
                if length(quran.chapters) > 1
                    print(io, " ├")
                    println(io, lpad(i, 3), " (", chapterlab.arabic[i], "-", chapterlab.english[i], ") ")
                else
                    print(io, " └")
                    print(io, i, " (", chapterlab.arabic[i], "-", chapterlab.english[i], ") ")
                end
            else
                print(io, " └")
                print(io, lpad(i, 3), " (", chapterlab.arabic[i], "-", chapterlab.english[i], ")")
            end
            j += 1
        end
        println(io, "\nVerse ", verse, "\n")
        println(io, quran.data)
    else
        if length(quran.chapters) > 1
            println(io, "Chapters: ")
        else
            println(io, "Chapter: ")
        end
        
        j = 1
        for i in quran.chapters
            if j < length(quran.chapters)
                if length(quran.chapters) > 1
                    print(io, " ├")
                    println(io, lpad(i, 3), " (", chapterlab.arabic[i], "-", chapterlab.english[i], ") ")
                else
                    print(io, " └")
                    print(io, i, " (", chapterlab.arabic[i], "-", chapterlab.english[i], ") ")
                end
            else
                print(io, " └")
                print(io, lpad(i, 3), " (", chapterlab.arabic[i], "-", chapterlab.english[i], ")")
            end
            j += 1
        end
        if length(verse) > 1
            print(io, "\nVerses ")
        else
            print(io, "\nVerse ")
        end
        j = 1
        for i in verse
            if j < length(verse)
                print(io, i, ", ")
            else
                println(io, i)
            end
            j += 1
        end
        println(io, "\n", quran.data)
    end
end