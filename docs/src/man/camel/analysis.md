Morphological Analysis
==============
Among the features of CAMeL Tools, is the availability of a token analyzer. In the following example, we will analyze the first word of the basmalah from `avrs1` above. Load the data as follows:
```@setup abc
using Pkg
Pkg.add("JuliaDB")
Pkg.add("PrettyTables")
```
```@repl abc
using QuranTree
crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
avrs1 = verses(tnzldata[1][1])[1]
dediac(avrs1)
```
To analyze the Morphological feature of the basmalah, run the following:
```@repl abc
using Pkg
Pkg.add("PyCall")
using PyCall
using JuliaDB
using PrettyTables
@ptconf vcrop_mode=:middle tf=tf_compact
@pyimport camel_tools.morphology.database as camel_database
@pyimport camel_tools.morphology.analyzer as camel_analyzer

db = camel_database.MorphologyDB.builtin_db()
analyzer = camel_analyzer.Analyzer(db)
analyses = analyzer.analyze(split(avrs1)[1])
tbl = table([(;Dict(Symbol.(keys(d)) .=> collect(values(d)))...) for d in analyses])
@pt tbl
```
The following is the table of the above output properly formatted in HTML.
```@example abc
Pkg.add("DataFrames")
Pkg.add("IterableTables")
Pkg.add("Latexify")
using DataFrames: DataFrame
using IterableTables
using Latexify

mdtable(DataFrame(tbl), latex=false)
```
\
\
!!! info "Note"
    You need to install [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl) and [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) to successfully run the code. 
    ```julia
    using Pkg
    Pkg.add("JuliaDB")
    Pkg.add("PrettyTables")
    ```
