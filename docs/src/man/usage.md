Usage
=====

```@meta
CurrentModule = QuranTree
DocTestSetup = quote
    using QuranTree
end
```

The dataset is included in the library already, both the Quranic Corpus and the Tanzil Data. To load the data, run the following
```@repl
using QuranTree

data = QuranData()
crps, tnzl = load(data);
```
The `load` function returns a tuple both for the Quranic Corpus and the Tanzil Data. The loaded data is encoded in a immutable (read-only) array, so users cannot change it. This is specified in the type of the object as shown below:
```@setup abc
using QuranTree

data = QuranData()
crps, tnzl = load(data)
```

```@repl abc
crps
```
This is a sample