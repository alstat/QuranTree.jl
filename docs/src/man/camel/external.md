CAMeL Tools
=====
In this section, we will explore how to use [CAMeL Tools](https://github.com/CAMeL-Lab/camel_tools) of [New York University Abu Dhabi](https://nyuad.nyu.edu/en/research/faculty-labs-and-projects/computational-approaches-to-modeling-language-lab.html). CAMeL is a suite of tools for Arabic Natural Language Processing, and by far the most feature-rich library to date for universal Arabic NLP. To install the library, follow the instructions [here](https://camel-tools.readthedocs.io/en/latest/getting_started.html#installation). 

## Setting up
For macOS users, however, simply run the following in the terminal:
```bash
pip3 install camel-tools
```
Then, download the necessary data as follows:
```bash
camel_data light
```
For this tutorial, we are going to use only the light version of the CAMeL data which is around 19mb.
## Julia PyCall.jl
Julia can interoperate with Python through the library [PyCall.jl](https://github.com/JuliaPy/PyCall.jl). To install, run the following:
```@setup abc
using Pkg
Pkg.add("JuliaDB")
Pkg.add("PrettyTables")
```
```@repl abc
using Pkg
Pkg.add("PyCall")
```
```@setup abc
ENV["PYTHON"] = "/usr/bin/python3"
Pkg.build("PyCall")
```
## Character Dediacritization
At this point, Julia can now connect to Python, and CAMeL Tools can now be loaded via the macro `@pyimport`. For example, the following will load the `dediac` module of the said library:
```@repl abc
using PyCall
@pyimport camel_tools.utils.dediac as camel_dediac
@pyimport camel_tools.utils.normalize as camel_normalize
```
!!! warning "Important"
    In case Python is not found, then it is required to specify the path in the environment variables, and as to which version to use. Hence, after installation of [PyCall.jl](https://github.com/JuliaPy/PyCall.jl), specify the path, for example:
    ```julia
    ENV["PYTHON"] = "/usr/bin/python3"
    Pkg.build("PyCall")
    ```
    The last line will build the library and [PyCall.jl](https://github.com/JuliaPy/PyCall.jl) will remember the path.
!!! warning "Important"
    Make sure the Python version you setup is where the CAMeL Tools was installed.
    
Let's use this and compare the results with QuranTree.jl's built in `dediac` function.
```@repl abc
using QuranTree
crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
avrs1 = verses(tnzldata[1][1])[1]
dediac(avrs1)
```
Now using CAMeL tools, we get the following:
```@repl abc
camel_dediac.dediac_ar(avrs1)
```
The difference is on the Alif Khanjareeya, where at the moment QuranTree.jl tree does not consider it as part of the diacritics, but part of the characters to be normalized. 

Let's try this on `CorpusData` as well, to see how it handles Buckwalter dediacritization:
```@repl abc
vrs1 = verses(crpsdata[1][1])[1]
dediac(vrs1)
camel_dediac.dediac_bw(vrs1)
```

## Character Normalization
To normalize, QuranTree.jl uses argument for specifying the character to normalize. However for CAMeL tools, this is part of the name of the function:
```@repl abc
avrs2 = verses(tnzldata[2][3])[1]
normalize(avrs2, :ta_marbuta)
camel_normalize.normalize_teh_marbuta_ar(avrs2)
```
Another example, normalizing over the Buckwalter encoding:
```@repl abc
vrs2 = verses(crpsdata[2][3])[1]
normalize(vrs2, :ta_marbuta)
camel_normalize.normalize_teh_marbuta_bw(vrs2)
```

