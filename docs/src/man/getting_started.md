Getting Started
=====

```@meta
CurrentModule = QuranTree
DocTestSetup = quote
    using QuranTree
end
```

The dataset is included in the library already, both the Quranic Corpus and the Tanzil Data. To load the data, simply run the following
```@repl abc
using QuranTree

data = QuranData()
crps, tnzl = load(data);
```
The `QuranData()` is a `struct` containing the default filepath of the data. The `load` function returns a `tuple` for both the Quranic Corpus and the Tanzil Data. The loaded data is encoded in a immutable (read-only) array, so users cannot change it. This is specified in the type of the object as shown below:

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
The resulting tables, which are of type `CorpusData` and `TanzilData`, respectively, are based on [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl), which can be accessed by simply calling the macro `@data` (for example, `@data crpsdata` or `crpsdata.data`). One thing to note, however, is that JuliaDB.jl will only display the meta data of the columns if the width of the table is wider than the width of the output pane, for example in case of the `crpsdata` above which has more columns (and thus wider) compared to `tnzldata`. To display the data of any wide table, [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) can be used:

```@setup abc
using Pkg
Pkg.add("PrettyTables")
```
```@repl abc
using PrettyTables
@ptconf vcrop_mode=:middle tf=tf_compact
@pt crpsdata
```
## Manipulating the Table
As mentioned above, the table is based on JuliaDB.jl, which has a type `IndexedTable`. Therefore, any data manipulation is done through the [JuliaDB.jl's APIs](https://juliadb.juliadata.org/latest/api/). To access the data simply call the property with `.data` or the macro `@data`:

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
From here, any data manipulation is done using JuliaDB.jl's APIs. For example, to select the feature column of the `crpstbl` is done as follows:

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
Or filtering tokens that are Prefix features, is done as follows:
```@repl abc
filter(t -> occursin(r"^PREFIX", t.features), crpstbl)

# or equivalent to
filter(t -> occursin(r"^PREFIX", t.features), crpsdata.data)
```
Bottomline, any data manipulation on the `CorpusTable` and `TanzilData` is done through [JuliaDB.jl's APIs](https://juliadb.juliadata.org/latest/api/).