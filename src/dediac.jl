"""
    dediac(s::String)

Dediacritize the input `String` object.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> dediac(verses(crpsdata[1][1])[1])
"bsm {llh {lrHm`n {lrHym"
julia> dediac(arabic(verses(crpsdata[1][1])[1]))
"بسم ٱلله ٱلرحمٰن ٱلرحيم"
```
"""
function dediac(s::String)
    trans = Transliterator()
    isarabic = in(Symbol(s[1]), collect(keys(trans.encode))) ? true : false
    return !isarabic ? replace(s, trans.rx_diacs => s"") : 
        replace(s, trans.rx_ardiacs => s"")
end