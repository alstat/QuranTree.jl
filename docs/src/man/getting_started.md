Getting Started
=====

```@meta
CurrentModule = QuranTree
DocTestSetup = quote
    using QuranTree
end
```

There are two datasets included in the library, namely the [Quranic Arabic Corpus](https://corpus.quran.com/download/) and the [Tanzil](http://tanzil.net/download) data. To load, simply run the following:
```@repl abc
using QuranTree

data = QuranData()
crps, tnzl = load(data);
```
The `QuranData()` is a `struct` containing the default file path of the data. The `load` function returns a `tuple` for both the Quranic Corpus and the Tanzil Data. The loaded data is encoded in a immutable (read-only) array, so users cannot change it. This is specified in the type of the object as shown below:

```@repl abc
crps
tnzl
```
In order to parse these raw data, the `table` function is used:
```@repl abc
crpsdata = table(crps);
tnzldata = table(tnzl);
crpsdata
tnzldata
```
The resulting tables are of type `CorpusData` and `TanzilData`, respectively, and are encoded on top of [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl)'s `IndexedTable`, which can be accessed by simply calling the macro `@data` (for example, `@data crpsdata` or `crpsdata.data`).

## Manipulating the Table
As mentioned above, the table is based on [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl)'s  `DataFrame`. Therefore, any data manipulation is done through the [DataFrames.jl's APIs](https://dataframes.juliadata.org/stable/#API). To access the data, simply call the property with `.data` or using the macro `@data`:

```@repl abc
crpstbl = @data crpsdata; # or crpsdata.data
tnzltbl = @data tnzldata; # or tnzldata.data
crpstbl
tnzltbl
```
Note that, `crpsdata` and `crpstbl` have different types (as in the case of `tnzldata` and `tnzltbl`) as shown below:
```@repl abc
typeof(crpsdata)
typeof(crpstbl)
```
From here, any data manipulation is done using [DataFrames.jl's APIs](https://dataframes.juliadata.org/stable/#API). For example, the following will select the feature column of the `crpstbl`:

```@setup abc
using Pkg
Pkg.add("DataFrames")
```
```@repl abc
using DataFrames

crpstbl[!, :features]

# or equivalent to
crpsdata.data[!, :features]
```
!!! info "Note"
    You need to install [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) to successfully run the code. 
    ```julia
    using Pkg
    Pkg.add("DataFrames")
    ```
To filter tokens that are `Prefix`ed features, the Base.jl's `occursin` can be used:
```@repl abc
filter(t -> occursin(r"^PREFIX", t.features), crpstbl)

# or equivalent to
filter(t -> occursin(r"^PREFIX", t.features), crpsdata.data)
```
The main point here is that, any data manipulation on the `CorpusTable` and `TanzilData` is done through [DataFrames.jl's APIs](https://dataframes.juliadata.org/stable/#API).