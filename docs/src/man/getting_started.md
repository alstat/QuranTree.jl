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
The resulting tables are of type `CorpusData` and `TanzilData`, respectively, and are encoded on top of [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl)'s `IndexedTable`, which can be accessed by simply calling the macro `@data` (for example, `@data crpsdata` or `crpsdata.data`). One thing to note, however, is that [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl) will only display the meta data of the columns if the width of the table is wider than the width of the output pane, for example in case of the `crpsdata` above, the table contains more columns (and thus wider) compared to `tnzldata`. To display the data of any wide table, we recommend [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl):

```@setup abc
using Pkg
Pkg.add("PrettyTables")
```
```@repl abc
using PrettyTables
@ptconf vcrop_mode=:middle tf=tf_compact
@pt crpsdata
```
!!! info 'Note'
    You need to install [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) to successfully run the code. 
    ```julia
    using Pkg
    Pkg.add("PrettyTables")
    ```
## Manipulating the Table
As mentioned above, the table is based on [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl)'s  `IndexedTable`. Therefore, any data manipulation is done through the [JuliaDB.jl's APIs](https://juliadb.juliadata.org/latest/api/). To access the data, simply call the property with `.data` or using the macro `@data`:

```@repl abc
crpstbl = @data crpsdata; # or crpsdata.data
tnzltbl = @data tnzldata; # or tnzldata.data
crpstbl
tnzltbl
```
Note that, `crpsdata` and `crpstbl` have different type (as in the case of `tnzldata` and `tnzltbl`) as shown below:
```@repl abc
typeof(crpsdata)
typeof(crpstbl)
```
From here, any data manipulation is done using [JuliaDB.jl's APIs](https://juliadb.juliadata.org/latest/api/). For example, the following will select the feature column of the `crpstbl`:

```@setup abc
using Pkg
Pkg.add("JuliaDB")
```
```@repl abc
using JuliaDB

select(crpstbl, :features)

# or equivalent to
select(crpsdata.data, :features)
```
!!! info 'Note'
    You need to install [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl) to successfully run the code. 
    ```julia
    using Pkg
    Pkg.add("JuliaDB")
    ```
To filter tokens that are `Prefix`ed features, the Base.jl's `occursin` can be used:
```@repl abc
filter(t -> occursin(r"^PREFIX", t.features), crpstbl)

# or equivalent to
filter(t -> occursin(r"^PREFIX", t.features), crpsdata.data)
```
The main point here is that, any data manipulation on the `CorpusTable` and `TanzilData` is done through [JuliaDB.jl's APIs](https://juliadb.juliadata.org/latest/api/).