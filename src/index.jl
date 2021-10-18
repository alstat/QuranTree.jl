# import DataFrames: DataFrame, groupby, filter
function Base.getindex(crps::Union{CorpusRaw,TanzilRaw}, i::Union{Int64,Array{Int64,1},UnitRange{Int64}})
    if i isa Int64
        1 <= i <= length(crps.data) || throw(BoundsError(crps, i))
        return crps.data[i]
    elseif i isa Array{Int64}
        1 <= maximum(i) <= length(crps.data) || throw(BoundsError(crps, maximum(i)))
        return crps.data[i]
    else
        1 <= i.stop <= length(crps.data) || throw(BoundsError(crps, i))
        return crps.data[i.start:i.stop]
    end
end
Base.firstindex(crps::Union{CorpusRaw,TanzilRaw}) = 1
Base.lastindex(crps::Union{CorpusRaw,TanzilRaw}) = length(crps.data)

function Base.getindex(crps::Union{CorpusData,TanzilData}, i::Union{Int64,Array{Int64,1},UnitRange{Int64}})
    if i isa Int64
        1 <= i <= 114 || throw(BoundsError(crps, i)) 
        tbl = filter(t -> t.chapter === i, crps.data)
        verses = tbl[!, :verse]
        if crps isa TanzilData
            return Chapter(tbl, i, verses, true)
        else
            return Chapter(tbl, i, verses)
        end
    else
        1 <= maximum(i) <= 114 || throw(BoundsError(crps, maximum(i))) 
        tbl = filter(t -> in(t.chapter, i), crps.data)
        chpgrp = groupby(tbl, :chapter)
        vrstbl = combine(chpgrp) do sdf
            DataFrame(verse = unique(sdf.verse)[end])
        end
        # vrstbl = groupby((verse = :verse => x -> unique(x)[end],), tbl, :chapter)

        verses = vrstbl[!, :verse]
        if crps isa TanzilData
            return Chapter(tbl, i, verses, true)
        else
            return Chapter(tbl, i, verses)
        end
    end
end
Base.firstindex(crps::Union{CorpusData,TanzilData}) = 1
Base.lastindex(crps::Union{CorpusData,TanzilData}) = 114

function Base.getindex(chapter::Chapter, i::Union{Int64,Array{Int64,1},UnitRange{Int64},Tuple})
    if i isa Int64
        1 <= i <= maximum(unique(chapter.verses)) || throw(BoundsError(chapter, i))
        tbl = filter(t -> t.verse === i, chapter.data)
        try
            if chapter.numbers isa Int64
                words = tbl[!, :word]
                return Verse(tbl, i, chapter.numbers, words, chapter.istanzil)
            else
                chpgrp = groupby(tbl, :chapter)
                wrdtbl = combine(chpgrp) do sdf
                    DataFrame(word = unique(sdf.word)[end])
                end
                # wrdtbl = groupby((word = :word => x -> unique(x)[end],), tbl, :chapter)
                words = wrdtbl[!, :word]
                return Verse(tbl, i, chapter.numbers, words, chapter.istanzil)
            end
        catch
            words = missing
            return Verse(tbl, i, chapter.numbers, words, chapter.istanzil)
        end
    else
        1 <= maximum(i) <= maximum(unique(chapter.verses)) || throw(BoundsError(chapter, maximum(i)))
        tbl = filter(t -> in(t.verse, i), chapter.data)
        try
            if chapter.numbers isa Int64
                vrsgrp = groupby(tbl, :verse)
                wrdtbl = combine(vrsgrp) do sdf
                    DataFrame(word = unique(sdf.word)[end])
                end
                # wrdtbl = groupby((word = :word => x -> unique(x)[end],), tbl, :verse)
            else
                vrsgrp = groupby(tbl, [:chapter, :verse])
                wrdtbl = combine(vrsgrp) do sdf
                    DataFrame(word = unique(sdf.word)[end])
                end
                # wrdtbl = groupby((word = :word => x -> unique(x)[end],), tbl, (:chapter, :verse))
            end
            words = wrdtbl[!, :word]
            return Verse(tbl, i, chapter.numbers, words, chapter.istanzil)
        catch
            words = missing
            return Verse(tbl, i, chapter.numbers, words, chapter.istanzil)
        end
    end
end

function Base.getindex(verse::Verse, i::Union{Int64,Array{Int64,1},UnitRange{Int64},Tuple})
    !verse.istanzil || throw(DomainError("TanzilData: No column word to index.")) 
    
    if i isa Int64
        1 <= i <= maximum(unique(verse.words)) || throw(BoundsError(verse, i))    
        tbl = filter(t -> t.word === i, verse.data)
        if verse.numbers isa Int64
            if verse.chapters isa Int64
                parts = tbl[!, :part]
                return Word(tbl, i, verse.chapters, verse.numbers, parts)
            else
                chpgrp = groupby(tbl, :chapter)
                prttbl = combine(chpgrp) do sdf
                    DataFrame(part = unique(sdf.part)[end])
                end
                # prttbl = groupby((part = :part => x -> unique(x)[end],), tbl, :chapter)
                parts = prttbl[!, :part]
                return Word(tbl, i, verse.chapters, verse.numbers, parts)
            end
        else
            if verse.chapters isa Int64
                vrsgrp = groupby(tbl, :verse)
                prttbl = combine(vrsgrp) do sdf
                    DataFrame(part = unique(sdf.part)[end])
                end
                # prttbl = groupby((part = :part => x -> unique(x)[end],), tbl, :verse)  
            else
                wrdgrp = groupby(tbl, [:chapter, :verse, :word])
                prttbl = combine(wrdgrp) do sdf
                    DataFrame(part = unique(sdf.part)[end])
                end
                # prttbl = groupby((part = :part => x -> unique(x)[end],), tbl, (:chapter, :verse, :word))
            end
            parts = prttbl[!, :part]
            return Word(tbl, i, verse.chapters, verse.numbers, parts)
        end 
    else
        1 <= maximum(i) <= maximum(unique(verse.words)) || throw(BoundsError(verse, maximum(i)))
        tbl = filter(t -> in(t.word, i), verse.data)
        if verse.numbers isa Int64
            if verse.chapters isa Int64
                wrdgrp = groupby(tbl, [:chapter, :verse, :word])
                prttbl = combine(wrdgrp) do sdf
                    DataFrame(part = unique(sdf.part)[end])
                end
                # prttbl = groupby((part = :part => x -> unique(x)[end],), tbl, (:chapter, :verse, :word))
            else
                wrdgrp = groupby(tbl, [:chapter, :verse, :word])
                prttbl = combine(wrdgrp) do sdf
                    DataFrame(part = unique(sdf.part)[end])
                end
                # prttbl = groupby((part = :part => x -> unique(x)[end],), tbl, (:chapter, :verse, :word))
            end          
        else
            if verse.chapters isa Int64
                wrdgrp = groupby(tbl, [:verse, :word])
                prttbl = combine(wrdgrp) do sdf
                    DataFrame(part = unique(sdf.part)[end])
                end
                # prttbl = groupby((part = :part => x -> unique(x)[end],), tbl, (:verse, :word))
            else
                wrdgrp = groupby(tbl, [:chapter, :verse, :word])
                prttbl = combine(wrdgrp) do sdf
                    DataFrame(part = unique(sdf.part)[end])
                end
                # prttbl = groupby((part = :part => x -> unique(x)[end],), tbl, (:chapter, :verse, :word))
            end
        end
        parts = prttbl[!, :part]
        return Word(tbl, i, verse.chapters, verse.numbers, parts)               
    end
end

function Base.getindex(word::Word, i::Union{Int64,Array{Int64,1},UnitRange{Int64},Tuple})
    if i isa Int64
        1 <= i <= unique(word.parts)[end] || throw(BoundsError(word, i))
        tbl = filter(t -> t.part === i, word.data)
        return Part(tbl, i, word.chapters, word.verses, word.numbers)
    else
        1 <= maximum(i) <= maximum(word.parts) || throw(BoundsError(word, maximum(i)))
        tbl = filter(t -> in(t.part, i), word.data)
        return Part(tbl, i, word.chapters, word.verses, word.numbers)
    end
end