function decode(c::Union{Char,String}, encoder::AbstractEncoder)
    return string(encoder.decode[Symbol(c)])
end

"""
    arabic(s::String[, encoder::AbstractEncoder])

Encode the `String` object into Arabic characters. Custom `encoder`
generated from `@transliterator` can be provided, but default is `Buckwalter`.
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
    verses(quran::AbstractQuran)

Extract the verses of a `AbstractQuran` object.
"""
function verses(quran::AbstractQuran)
    endidx = length(rows(quran.data))
    return verses(quran.data, 1, endidx)
end

"""
    verses(quran::TanzilData)

Extract the verses of a `TanzilData` object.
"""
function verses(quran::TanzilData)
    return select(quran.data, :form)
end

"""
    verses(data::IndexedTable[, a::Int64[, b::Int64]])

Extract the verses of a `IndexedTable` object from row `a` to row `b`.
"""
function verses(data::IndexedTable, a::Int64, b::Int64)
    verses = String[]; words = ""; j = 1
    for i in select(data, :form)[a:b]
        if j > 1
            prev_word  = select(data, :word)[j-1]
            next_word  = select(data, :word)[j]
            prev_verse = select(data, :verse)[j-1]
            next_verse = select(data, :verse)[j]
            
            if prev_word !== next_word && prev_verse !== next_verse
                push!(verses, words)
                words = ""
            elseif prev_word !== next_word && prev_verse === next_verse
                words *= " "
            elseif prev_word === next_word && prev_verse !== next_verse
                push!(verses, words)
                words = ""
            end
            words *= i 
            if j === b
                push!(verses, words)
            end
        else 
            words *= i
            if j === b
                push!(verses, words)
            end
        end
        j += 1
    end
    return verses
end

"""
    chapter_name(quran::AbstractQuran, transliterate::Bool=false; lang::Symbol=:arabic)

Extracts the chapter label of the input quran, in either `:arabic` (default) or `:english`
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