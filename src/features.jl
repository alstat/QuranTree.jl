import Base: parse
"""
    Features(data::String)

Convert a string to morphological feature object.
"""
struct Features <: AbstractFeature
    data::String
end

"""
    Prefix(data::Symbol, pos::AbstractPartOfSpeech)

Create a new `Prefix` object with data as the symbol of the morphological feature with pos as 
the corresponding Part of Speech.
"""
struct Prefix <: AbstractFeature
    data::Symbol
    pos::AbstractPartOfSpeech
end

"""
    Suffix(data::Symbol, pos::AbstractPartOfSpeech)

Create a new `Suffix` object with data as the symbol of the morphological feature with pos as 
the corresponding Part of Speech.
"""
struct Suffix <: AbstractFeature
    data::Symbol
    pos::AbstractPartOfSpeech
    feats::Array{AbstractFeature,1}
end

"""
    Stem(data::Symbol, pos::AbstractPartOfSpeech)

Create a new `Stem` object with data as the symbol of the morphological feature with `pos` as 
the corresponding Part of Speech.
"""
struct Stem <: AbstractFeature
    data::Symbol
    pos::AbstractPartOfSpeech
    feats::Array{AbstractFeature,1}
end

"""
    Lemma(data::String)

Convert a string to a `Lemma` object.
"""
struct Lemma <: AbstractFeature
    data::String
end

"""
    Root(data::String)

Convert a string to a `Root` object.
"""
struct Root <: AbstractFeature
    data::String
end

"""
    Special(data::String)

Convert a string to a `Special` object.
"""
struct Special <: AbstractFeature
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

function accusative(s::String, strs::Array{String,1}, other_feats::Array{AbstractFeature,1})
    isstate = in("DEF", strs) || in("INDEF", strs)
    return isstate ? 
        push!(other_feats, PARTOFSPEECH[Symbol(s * "C")]) : 
        push!(other_feats, PARTOFSPEECH[Symbol(s)])
end

function defaultverb(pos::AbstractPartOfSpeech, other_feats::Array{AbstractFeature,1})
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

function stem(feat::Features)
    occursin("STEM", feat.data) || 
        throw(DomainError(feat, "Expected STEM feature, got " * string(split(feat.data, "|")[1]) * "."))
    strs = split(feat.data, "|")[2:end]
    
    pos = string(split(strs[1], ":")[2])
    other_feats = AbstractFeature[]
    
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

function prefix(feat::Features)
    occursin("PREFIX", feat.data) || 
        throw(DomainError(feat, "Expected PREFIX feature, got " * string(split(feat.data, "|")[1]) * "."))
    strs = string(split(feat.data, "|")[2])
    return Prefix(Symbol(strs), PARTOFSPEECH[Symbol(strs)])
end

function suffix(feat::Features)
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
        return Suffix(Symbol(strs), PARTOFSPEECH[Symbol(strs)], AbstractFeature[])
    end
end

"""
    parse(::Type{Features}, f::AbstractString)

Extract the features of a morphological `Feature` object.
"""
function parse(::Type{Features}, f::AbstractString)
    try
        return prefix(Features(f))
    catch
        try
            return stem(Features(f))
        catch
            return suffix(Features(f))
        end
    end
end

"""
    isfeature(feat::Features, pos::Type{<:AbstractFeature})

Check if the morphological `Feature` object is a type of `pos`.
"""
function isfeature(feat::AbstractFeature, pos::Type{<:AbstractFeature})
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

function root(feat::AbstractFeature)
    try
        idx = findfirst(x -> x isa Root, feat.feats)
        return idx isa Nothing ? missing : feat.feats[idx].data 
    catch
        return missing
    end
end

function lemma(feat::AbstractFeature)
    try
        idx = findfirst(x -> x isa Lemma, feat.feats)
        return idx isa Nothing ? missing : feat.feats[idx].data 
    catch
        return missing
    end
end

function special(feat::AbstractFeature)
    try
        idx = findfirst(x -> x isa Special, feat.feats)
        return idx isa Nothing ? missing : feat.feats[idx].data 
    catch
        return missing
    end
end
