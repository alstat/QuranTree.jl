Arabic Disambiguation
=========
In this section, we are going to apply a model, estimated from Maximum Likelihood Estimation (MLE), for disambiguating Arabic texts with no diacritics.
As always, load the data as follows:
```@setup abc
using Pkg
Pkg.add("DataFrames")
```
```@repl abc
using QuranTree
crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
```
For this task, we are going to use the last verse of Chapter 1.
```@repl abc
avrs1 = verses(tnzldata[1][7])[1]
```
Of course, the input needs to have no diacritics and so:
```@repl abc
avrs1 = avrs1 |> dediac
```
## Inferring
To infer the diacritics then, run the following:
```@repl abc
using Pkg
Pkg.add("PyCall")
using PyCall
@pyimport camel_tools.disambig.mle as camel_disambig
mled = camel_disambig.MLEDisambiguator.pretrained()
disambig = mled.disambiguate(split(avrs1))
```
## Extracting Diacritized Output
Finally, tying up all diacritized output:
```@repl abc
join([d[2][1][2]["diac"] for d in disambig], " ")
```