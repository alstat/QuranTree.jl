CAMeL Tools
=====
In this section, we will explore the use of CAMeL tools from New York University Abu Dhabi. To install the library, run the following in the terminal:
```bash
pip3 install camel-tools
```
Then, download the necessary data as follows:
```bash
camel_tools light
```
For this, tutorial we are going to use only the light version of the CAMeL data which is about 19mb.
Install pycall
```@setup abc
using Pkg
Pkg.add("JuliaDB")
Pkg.add("PrettyTables")
```
```@repl abc
using Pkg
Pkg.add("PyCall")
```

```@repl abc
ENV["PYTHON"] = "/Library/Frameworks/Python.framework/Versions/3.8/bin/python3"
Pkg.build("PyCall")
```
## Character Dediacritization
```@repl abc
using PyCall
@pyimport camel_tools.utils.dediac as camel_dediac
@pyimport camel_tools.utils.normalize as camel_normalize
```

```@repl abc
using QuranTree
crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
avrs1 = verses(tnzldata[1][1])[1]
dediac(avrs1)
camel_dediac.dediac_ar(avrs1)
vrs1 = verses(crpsdata[1][1])[1]
dediac(vrs1)
camel_dediac.dediac_bw(vrs1)
```
## Character Normalization
```@repl abc
avrs2 = verses(tnzldata[2][3])[1]
normalize(avrs2, :ta_marbuta)
camel_normalize.normalize_teh_marbuta_ar(avrs2)
vrs2 = verses(crpsdata[2][3])[1]
normalize(vrs2, :ta_marbuta)
camel_normalize.normalize_teh_marbuta_bw(vrs2)
```

```@repl abc
using JuliaDB
using PyCall
using PrettyTables
@ptconf vcrop_mode=:middle tf=tf_compact
@pyimport camel_tools.morphology.database as camel_database
@pyimport camel_tools.morphology.analyzer as camel_analyzer

db = camel_database.MorphologyDB.builtin_db()
analyzer = camel_analyzer.Analyzer(db)
analyses = analyzer.analyze(split(avrs1)[1])
@pt table([(;Dict(Symbol.(keys(d)) .=> collect(values(d)))...) for d in analyses])
```
!!! note 'Note'
    You need to install [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl) to successfully run the code. 
    ```julia
    using Pkg
    Pkg.add("JuliaDB")
    ```