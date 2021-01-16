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
function verses(quran::AbstractQuran; number=false, start_end=true)
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
"""
function verses(quran::TanzilData)
    return select(quran.data, :form)
end

"""
    verses(data::IndexedTable[, a::Int64[, b::Int64]])

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