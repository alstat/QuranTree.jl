import Base: parse
import Yunir: isfeat
"""
    QuranFeatures(data::String)

Convert a string to morphological feature object.
"""
struct QuranFeatures <: AbstractQuranFeature
    data::String
end

"""
    Prefix(data::Symbol, pos::AbstractPartOfSpeech)

Create a new `Prefix` object with data as the symbol of the morphological feature with pos as 
the corresponding Part of Speech.
"""
struct Prefix <: AbstractQuranFeature
    data::Symbol
    pos::AbstractPartOfSpeech
end

"""
    Suffix(data::Symbol, pos::AbstractPartOfSpeech)

Create a new `Suffix` object with data as the symbol of the morphological feature with pos as 
the corresponding Part of Speech.
"""
struct Suffix <: AbstractQuranFeature
    data::Symbol
    pos::AbstractPartOfSpeech
    feats::Array{AbstractQuranFeature,1}
end

"""
    Stem(data::Symbol, pos::AbstractPartOfSpeech)

Create a new `Stem` object with data as the symbol of the morphological feature with `pos` as 
the corresponding Part of Speech.
"""
struct Stem <: AbstractQuranFeature
    data::Symbol
    pos::AbstractPartOfSpeech
    feats::Array{AbstractQuranFeature,1}
end

"""
    Lemma(data::String)

Convert a string to a `Lemma` object.
"""
struct Lemma <: AbstractQuranFeature
    data::String
end

"""
    Root(data::String)

Convert a string to a `Root` object.
"""
struct Root <: AbstractQuranFeature
    data::String
end

"""
    Special(data::String)

Convert a string to a `Special` object.
"""
struct Special <: AbstractQuranFeature
    data::String
end

function derivednoun(strs::Array{String,1})
    idx_pcpl = findfirst(x -> occursin(r"PCPL", x), strs)
    if !isa(idx_pcpl, Nothing)
        pos_lab = Symbol(string(strs[idx_pcpl-1], " ", strs[idx_pcpl]))
        return PARTOFSPEECH[pos_lab]
    else
        return nothing
    end
end

function accusative(s::String, strs::Array{String,1}, other_feats::Array{AbstractQuranFeature,1})
    isstate = in("DEF", strs) || in("INDEF", strs)
    return isstate ? 
        push!(other_feats, PARTOFSPEECH[Symbol(s * "C")]) : 
        push!(other_feats, PARTOFSPEECH[Symbol(s)])
end

function defaultverb(pos::AbstractPartOfSpeech, other_feats::Array{AbstractQuranFeature,1})
    feats = vcat(pos, other_feats)
    out = findfirst(x -> x isa Verb, feats)
    if !isa(out, Nothing)
        mood = findfirst(x -> x isa AbstractMood, feats)
        if mood isa Nothing
            push!(other_feats, Indicative())
        end
        
        voice = findfirst(x -> x isa AbstractVoice, feats)
        if voice isa Nothing
            push!(other_feats, Active())
        end
        
        vform = findfirst(x -> x isa AbstractForm, feats) # change this to AbstractForm
        if vform isa Nothing
            push!(other_feats, VerbFormI())
        end
        return other_feats
    else
        return other_feats
    end
end

function stem(feat::QuranFeatures)
    occursin("STEM", feat.data) || 
        throw(DomainError(feat, "Expected STEM feature, got " * string(split(feat.data, "|")[1]) * "."))
    strs = split(feat.data, "|")[2:end]
    
    pos = string(split(strs[1], ":")[2])
    other_feats = AbstractQuranFeature[]
    
    idx_lemma = findfirst(x -> occursin(r"^LEM", x), strs)
    idx_root = findfirst(x -> occursin(r"^ROOT", x), strs)
    idx_sp = findfirst(x -> occursin(r"^SP", x), strs)
    idx_mood = findfirst(x -> occursin(r"^MOOD", x), strs)
    if !isa(idx_lemma, Nothing) 
        lemma = Lemma(string(split(strs[idx_lemma], ":")[2]))
        push!(other_feats, lemma)
    end
    if !isa(idx_root, Nothing)
        root = Root(string(split(strs[idx_root], ":")[2]))
        push!(other_feats, root)
    end
    if !isa(idx_sp, Nothing)
        sp = Special(string(split(strs[idx_sp], ":")[2]))
        push!(other_feats, sp)
    end
    if !isa(idx_mood, Nothing)
        mood = PARTOFSPEECH[Symbol(string(split(strs[idx_mood], ":")[2]))]
        push!(other_feats, mood)
    end
    
    idx_others = findall(x -> !occursin(r"POS|LEM|ROOT|SP|MOOD", x), strs)
    drvnoun = derivednoun(string.(strs[idx_others]))

    if !isa(drvnoun, Nothing)
        push!(other_feats, drvnoun)
    end
    
    idx_others = findall(x -> !occursin(r"POS|LEM|ROOT|SP|MOOD|PCPL", x), strs)
    remaining = string.(strs[idx_others])
    for s in remaining
        try
            if s === "ACC"
                other_feats = accusative(s, remaining, other_feats)
            else
                push!(other_feats, PARTOFSPEECH[Symbol(s)])
            end
        catch
            for c in s
                if c === 'P'
                    push!(other_feats, PARTOFSPEECH[Symbol(c * "L")])
                else
                    push!(other_feats, PARTOFSPEECH[Symbol(c)])
                end
            end
        end
    end
    other_feats = defaultverb(PARTOFSPEECH[Symbol(pos)], other_feats)
    return Stem(Symbol(pos), PARTOFSPEECH[Symbol(pos)], other_feats)
end

function prefix(feat::QuranFeatures)
    occursin("PREFIX", feat.data) || 
        throw(DomainError(feat, "Expected PREFIX feature, got " * string(split(feat.data, "|")[1]) * "."))
    strs = string(split(feat.data, "|")[2])
    return Prefix(Symbol(strs), PARTOFSPEECH[Symbol(strs)])
end

function suffix(feat::QuranFeatures)
    occursin("SUFFIX", feat.data) || 
        throw(DomainError(feat, "Expected SUFFIX feature, got " * string(split(feat.data, "|")[1]) * "."))
    strs = string(split(feat.data, "|")[2])
    if occursin("PRON", strs)
        suff_feat = split(strs, ":")
        
        if length(suff_feat[2]) === 2
            if string(suff_feat[2][1]) === "P"
                person = Symbol(suff_feat[2][1] * "L")
            else
                person = Symbol(suff_feat[2][1])
            end
            number = Symbol(suff_feat[2][2])
            other_feats = [PARTOFSPEECH[person], PARTOFSPEECH[number]]
        else
            if string(suff_feat[2][1]) === "P"
                person = Symbol(suff_feat[2][1] * "L")
            else
                person = Symbol(suff_feat[2][1])
            end
            gender = Symbol(suff_feat[2][2])
            number = Symbol(suff_feat[2][3])
            other_feats = [PARTOFSPEECH[person], PARTOFSPEECH[gender], PARTOFSPEECH[number]]                
        end
        return Suffix(Symbol(suff_feat[1]), PARTOFSPEECH[Symbol(suff_feat[1])], other_feats)
    else
        return Suffix(Symbol(strs), PARTOFSPEECH[Symbol(strs)], AbstractQuranFeature[])
    end
end

"""
    parse(::Type{QuranFeatures}, f::AbstractString)

Extract the features of a morphological `Feature` object.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> parse(QuranFeatures, select(crpsdata.data, :features)[53])
Stem(:NEG, NEG, AbstractQuranFeature[Lemma("laA"), Special("<in~")])
```
"""
function parse(::Type{QuranFeatures}, f::AbstractString)
    try
        return prefix(QuranFeatures(f))
    catch
        try
            return stem(QuranFeatures(f))
        catch
            return suffix(QuranFeatures(f))
        end
    end
end

"""
    isfeat(feat::QuranFeatures, pos::Type{<:AbstractQuranFeature})

Check if the morphological `Feature` object is a type of `pos`.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> isfeat(parse(QuranFeatures, select(crpsdata[1].data, :features)[2]), Stem)
true
```
"""
function isfeat(feat::AbstractQuranFeature, pos::Type{<:AbstractQuranFeature})
    try        
        feats = vcat(feat, feat.pos, feat.feats)
        out = findfirst(x -> x isa pos, feats)
        return out isa Nothing ? false : true
    catch
        feats = vcat(feat, feat.pos)
        out = findfirst(x -> x isa pos, feats)
        return out isa Nothing ? false : true
    end
end

"""
    root(feat::AbstractQuranFeature)

Extract the root of the feature.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> root(parse(QuranFeatures, select(crpsdata[112].data, :features)[1]))
"qwl"
```
"""
function root(feat::AbstractQuranFeature)
    try
        idx = findfirst(x -> x isa Root, feat.feats)
        return idx isa Nothing ? missing : feat.feats[idx].data 
    catch
        return missing
    end
end

function parse(::Type{Lemma}, l::AbstractString)
    idx = findfirst(r"\d", l)
    if idx isa Nothing
        return Lemma(l)
    else
        out = AbstractQuranFeature[]
        push!(out, Lemma(l[1:idx.start-1]))
        push!(out, PARTOFSPEECH[Symbol(l[idx])])
        return out
    end
end

"""
    lemma(feat::AbstractQuranFeature)

Extract the lemma of the feature.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> lemma(parse(QuranFeatures, select(crpsdata[112].data, :features)[1]))
"qaAla"
```
"""
function lemma(feat::AbstractQuranFeature)
    try
        idx = findfirst(x -> x isa Lemma, feat.feats)
        if idx isa Nothing
            return missing
        else
            lem = parse(Lemma, feat.feats[idx].data)
            if lem isa Lemma
                lem = lem.data
            else
                lem[1].data
            end
        end
    catch
        return missing
    end
end

"""
    special(feat::AbstractQuranFeature)
    
Extract the special feature of the token.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps)
julia> tnzldata = table(tnzl)
julia> special(parse(QuranFeatures, select(crpsdata.data, :features)[53]))
"<in~"
```
"""
function special(feat::AbstractQuranFeature)
    try
        idx = findfirst(x -> x isa Special, feat.feats)
        return idx isa Nothing ? missing : feat.feats[idx].data 
    catch
        return missing
    end
end
