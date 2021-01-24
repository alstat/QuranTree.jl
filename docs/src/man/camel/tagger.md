Parts of Speech Tagger
==============
In this section, we are going to use CAMeL Tools for Parts of Speech tagging. To start with, load the data as follows:
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
```
For this task, we are going to use the second verse of Chapter 1.
```@repl abc
avrs1 = verses(tnzldata[1][2])[1]
```
The will load the model:
```@repl abc
using Pkg
Pkg.add("PyCall")
using PyCall
@pyimport camel_tools.disambig.mle as camel_disambig
@pyimport camel_tools.tagger.default as camel_tagger
mled = camel_disambig.MLEDisambiguator.pretrained()
```
## Tagging
From the model, we instantiate the `DefaultTagger` and finally call the `tag` method to tag the token:
```@repl abc
tagger = camel_tagger.DefaultTagger(mled, "pos")
tagger.tag(split(avrs1))
```