"""
    dediac(s::String)

Dediacritize the input `String` object.
"""
function dediac(s::String)
    trans = Transliterator()
    isarabic = in(Symbol(s[1]), collect(keys(trans.encode))) ? true : false
    return !isarabic ? replace(s, trans.rx_diacs => s"") : 
        replace(s, trans.rx_ardiacs => s"")
end