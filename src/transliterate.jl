function genproperties(encoder::Dict{Symbol,Symbol})
    decoder = Dict(collect(values(encoder)) .=> collect(keys(encoder)))
    decoder_diac = [encoder[Symbol(s[1])] for s in split(AR_DIACS_REGEX.pattern, "|")]
    idx = map(x -> in(x[1], SP_REGEX_CHARS), string.(decoder_diac))
    decoder_diac[idx] = Symbol.(raw"\\" .* string.(decoder_diac[idx]))
    decoder_diac = Regex(join(string.(decoder_diac), "|"))

    return decoder, decoder_diac
end

function Transliterator(x::Bool) end

abstract type AbstractEncoder end

"""
    @transliterator(dict, name)

Create a custom transliterator using an input `dict` (`Dict` object) with its corresponding
`name` as `String` object. This will automatically update the transliterator inside all 
functions like `arabic`, `verses`, and `encode`.
"""
macro transliterator(dict, name)
    T = Symbol(uppercasefirst(name))
    esc(quote
            prop = genproperties(eval($dict))
            struct $T <: AbstractEncoder
                encode::Dict{Symbol,Symbol}
                decode::Dict{Symbol,Symbol}
                rx_diacs::Regex
                rx_ardiacs::Regex
            end
            QuranTree.Transliterator() = $T($dict, prop[1], prop[2], $AR_DIACS_REGEX)
            function Base.show(io::IO, t::$T)
                println(io, $T, ":")
                println(io, " ├ encode: ", Transliterator().encode)
                println(io, " ├ decode: ", Transliterator().decode)
                println(io, " ├ rx_diacs: ", Transliterator().rx_diacs)
                println(io, " └ rx_ardiacs: ", Transliterator().rx_ardiacs)
            end
        end
    )
end

"""
    @transliterator(dict)

Fallback to the default `Buckwalter` transliterator.
"""
macro transliterator(symbl)
    esc(quote
        if string($symbl) === "default"
            eval(:(@transliterator(BW_ENCODING, "Buckwalter")))
        else
            throw(DomainError("Expects :default, got " * string(symbl)))
        end
    end)
end

@transliterator BW_ENCODING "Buckwalter"