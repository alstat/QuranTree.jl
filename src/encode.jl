"""
    encode(::Type{SimpleEncoder}, s::String)

Encode the input `String` object as `SimpleEncoder`.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> basmala = arabic(verses(crpsdata[1][1])[1])
julia> encode(SimpleEncoder, basmala)
"Ba+Kasra | Seen+Sukun | Meem+Kasra | <space> | HamzatWasl | Lam | Lam+Shadda+Fatha | Ha+Kasra | <space> | HamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Sukun | Meem+Fatha | AlifKhanjareeya | Noon+Kasra | <space> | HamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Kasra | Ya | Meem+Kasra"
```
"""
function encode(::Type{SimpleEncoder}, s::String)
    sencoder = SimpleEncoder()
    words = ""; i = 1
    for c in s
        if c === ' '
            words *= " | <space>"
        else
            words *= encode(sencoder, c, i)
        end
        i += 1
    end
    return words
end

function encode(encoder::SimpleEncoder, c::Union{Char,String}, i::Int64)
    if in(Symbol(c), AR_DIACS)
        return string("+", encoder.encode[Symbol(c)])
    else
        if i > 1
            return string(" | ", encoder.encode[Symbol(c)])
        else
            return string(encoder.encode[Symbol(c)])
        end
    end
end

"""
    encode(s::Union{Char,String}, encoder::AbstractEncoder)

Transliterate the input `String` object using a custom `encoder`. Custom `encoder` is
generated using the `@transliterator`.
"""
function encode(s::Union{Char,String}, encoder::AbstractEncoder)
    words = ""
    for c in s
        if c === ' '
            words *= " "
        else
            if c === '\U0622'
                words *= string(encoder.encode[Symbol('\U0627')], encoder.encode[Symbol('\U0653')])
            else
                words *= string(encoder.encode[Symbol(c)])
            end
        end
    end
    return words
end

"""
    encode(s::String)

Transliterate the input `String` object using `Buckwalter`.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> basmala = arabic(verses(crpsdata[1][1])[1])
julia> encode(basmala)
"bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"
```
"""
function encode(s::String)
    trans = Transliterator()
    return encode(s, trans)
end

