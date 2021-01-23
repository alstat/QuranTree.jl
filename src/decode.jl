function decode(c::Union{Char,String}, encoder::AbstractEncoder)
    return string(encoder.decode[Symbol(c)])
end

"""
    arabic(s::String[, encoder::AbstractEncoder])

Encode the `String` object into Arabic characters. Custom `encoder`
generated from `@transliterator` can be provided, but default is `Buckwalter`.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> arabic(verses(crpsdata[114])[1])
"قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ"
```
"""
function arabic(s::String)
    trans = Transliterator()
    return arabic(s, trans)
end

function arabic(s::String, encoder::AbstractEncoder)
    words = ""
    for c in s
        if c === ' '
            words *= " "
        else
            words *= decode(c, encoder)
        end
    end
    return words
end

"""
    verses(quran::AbstractQuran; number=false, start_end=true)

Extract the verses of a `AbstractQuran` object.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> verses(crpsdata[1])[7]
"Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna"
julia> verses(crpsdata[113:114], number=true)[1]
"113:(1,5)"
julia> verses(crpsdata[113:114], number=true, start_end=false)[1]
([113], [1, 2, 3, 4, 5])
```
"""
function verses(quran::AbstractQuran; number::Bool=false, start_end::Bool=true)
    try
        endidx = length(rows(quran.data))
        return verses(quran.data, 1, endidx; number=number, start_end=start_end)
    catch
        return select(quran.data, :form)
    end
end

"""
    verses(quran::TanzilData)

Extract the verses of a `TanzilData` object.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> verses(tnzldata)[1]
"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
```
"""
function verses(quran::TanzilData)
    return select(quran.data, :form)
end

"""
    verses(data::IndexedTable[, a::Int64[, b::Int64]]; number=false, start_end=true)

Extract the verses of a `IndexedTable` object from row `a` to row `b`.
"""
function verses(data::IndexedTable, a::Int64, b::Int64; number::Bool=false, start_end::Bool=true)
    if number
        if start_end
            verse_out = String[]
            verse_nos = ""
        else
            verse_out = Tuple{Array{Int64,1},Array{Int64,1}}[]
            chapter_nos = Int64[] 
            verse_nos = Int64[]
        end
    else
        verse_out = String[]; words = ""
    end

    j = 1
    for i in select(data, :form)[a:b]
        if j > 1
            prev_word  = select(data, :word)[j-1]
            next_word  = select(data, :word)[j]
            prev_verse = select(data, :verse)[j-1]
            next_verse = select(data, :verse)[j]
            prev_chapter = select(data, :chapter)[j-1]
            next_chapter = select(data, :chapter)[j]
            
            if prev_word !== next_word && prev_verse !== next_verse
                if number
                    if prev_chapter !== next_chapter
                        if start_end
                            push!(verse_out, verse_nos * ")")
                            verse_nos = string(next_chapter) * ":(" * string(next_verse)
                        else
                            push!(verse_out, (chapter_nos, verse_nos))
                            chapter_nos = Int64[] 
                            verse_nos = Int64[]

                            push!(chapter_nos, next_chapter)
                            push!(verse_nos, next_verse)
                        end
                    else
                        if start_end
                            if occursin(",", verse_nos)
                                verse_nos = replace(verse_nos, "," * string(prev_verse) => "," * string(next_verse))
                            else
                                verse_nos *= "," * string(next_verse)
                            end
                        else
                            push!(verse_nos, next_verse)
                        end
                    end
                else
                    push!(verse_out, words)
                    words = ""
                end
            elseif prev_word !== next_word && prev_verse === next_verse
                if !number
                    words *= " "
                end
            elseif prev_word === next_word && prev_verse !== next_verse
                if number 
                    if prev_chapter !== next_chapter
                        if start_end
                            push!(verse_out, verse_nos * ")")
                            verse_nos = string(next_chapter) * ":(" * string(next_verse)
                        else
                            push!(verse_out, (chapter_nos, verse_nos))
                            chapter_nos = Int64[] 
                            verse_nos = Int64[]

                            push!(chapter_nos, next_chapter)
                            push!(verse_nos, next_verse)
                        end
                    else
                        if start_end
                            if occursin(",", verse_nos)
                                verse_nos = replace(verse_nos, "," * string(prev_verse) => "," * string(next_verse))
                            else
                                verse_nos *= "," * string(next_verse)
                            end
                        else
                            push!(verse_nos, next_verse)
                        end
                    end
                else
                    push!(verse_out, words)
                    words = ""
                end
            end

            if !number
                words *= i 
            end

            if j === b
                if number
                    if start_end
                        push!(verse_out, verse_nos * ")")
                    else
                        push!(verse_out, (chapter_nos, verse_nos))
                    end
                else
                    push!(verse_out, words)
                end
            end
        else 
            if number
                if start_end
                    verse_nos = string(select(data, :chapter)[j]) * ":(" * string(select(data, :verse)[j])
                else
                    push!(chapter_nos, select(data, :chapter)[j])
                    push!(verse_nos, select(data, :verse)[j])
                end
            else
                words *= i
            end

            if j === b
                if number
                    if start_end
                        push!(verse_out, verse_nos * ")")
                    else
                        push!(verse_out, (chapter_nos, verse_nos))
                    end
                else
                    push!(verse_out, words)
                end
            end
        end
        j += 1
    end
    return verse_out
end


"""
    words(quran::AbstractQuran)

Extract words of the input quran.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> words(tnzldata[1][7])[1]
"صِرَٰطَ"
```
"""
function words(quran::AbstractQuran)
    return string.(vcat(split.(verses(quran), " ")...))
end

"""
    chapter_name(quran::AbstractQuran, transliterate::Bool=false; lang::Symbol=:arabic)

Extract the chapter name of the input quran, in either `:arabic` (default) or `:english`

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> chapter_name(crpsdata[13][2][1])
"ٱلرَّعْد"
```
"""
function chapter_name(quran::AbstractQuran, transliterate::Bool=false; lang::Symbol=:arabic)
    chapterlabel = ChapterLabel()
    chapterlabel = getproperty(chapterlabel, lang)
    chapterindex = quran isa Chapter ? quran.numbers : quran.chapters
    if transliterate && lang === :arabic
        trans = Transliterator()
        name = ""
        for c in chapterlabel[chapterindex]
            if c == ' '
                name *= " "
            else
                name *= encode(c, trans)
            end
        end
        return name
    elseif transliterate && lang === :english
        @warn "transliterate only applies for :arabic lang."
        return chapterlabel[chapterindex]
    elseif !transliterate && lang === :arabic
        return chapterlabel[chapterindex]
    else
        return chapterlabel[chapterindex]
    end
end