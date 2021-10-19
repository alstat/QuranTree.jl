# import DataFrames: DataFrame

"""
    load(data::QuranData)

Load the raw `QuranData` as a `ReadOnlyArray` for both Quranic Corpus and Tanzil Data.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data);
```
"""
function load(data::QuranData)
    corpus = ReadOnlyArray(readlines(data.path.corpus))
    tanzil = ReadOnlyArray(readlines(data.path.tanzil))
    
    return CorpusRaw(corpus), TanzilRaw(tanzil)
end

"""
    table(crps::CorpusRaw)

Convert the `CorpusRaw` read-only array into a tabularized `CorpusData`
using `IndexedTable`.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> crpsdata = table(crps);
```
"""
function table(crps::CorpusRaw)
    rowdata = NamedTuple[];
    for i in crps.data[58:end]
        row = split(i, "\t")
        loc = [parse(Int, j) for j in split(row[1][2:end-1], ":")]
        push!(
            rowdata,
            (
                chapter = loc[1],
                verse = loc[2],
                word = loc[3],
                part = loc[4],
                form = string(row[2]),
                tag = string(row[3]),
                features = string(row[4]),
            ),
        )
    end
    return CorpusData(DataFrame(rowdata), MetaData(typeof(crps)))
end

"""
    table(tnzl::TanzilRaw)

Convert the `TanzilRaw` read-only array into a tabularized `TanzilData`
using `IndexedTable`.

# Examples
```julia-repl
julia> data = QuranData()
julia> crps, tnzl = load(data)
julia> tnzldata = table(tnzl);
```
"""
function table(tnzl::TanzilRaw)
    rowdata = NamedTuple[];
    tnzldata = filter(x -> occursin(r"^\d", x), tnzl.data)
    for i in tnzldata
        loc = split(i, "|")
        push!(
            rowdata, 
            (
                chapter = parse(Int64, loc[1]),
                verse = parse(Int64, loc[2]),
                form = string(loc[3]),
            )
        )
    end
    return TanzilData(DataFrame(rowdata), MetaData(typeof(tnzl)))
end