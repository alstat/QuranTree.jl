# QuranTree.jl

```@meta
CurrentModule = QuranTree
DocTestSetup = quote
    using QuranTree
end
```

A Julia package for working with the Quran. The library is based on the Quranic corpus dataset 
from [The Quranic Arabic Corpus](https://corpus.quran.com/), and is inspired by the provided [JQuranTree](https://corpus.quran.com/java/overview.jsp) java package. The following are the features available:
 
 * Special Indexing for the Chapters, Verses, Words and Parts
 * Transliteration

    * Buckwalter as default
    * Function for creating custom transliterator
    * Automatically updates the transliteration in 1 line of code
 * Complete type for all Morphological Features and Part of Speech
 * Seemless transitioning between Arabic and Buckwalter
 * Arabic and Buckwalter character Normalizer
 * Arabic and Buckwalter character Dediacritization
 * Function for detailed description of the morphological feature.
 * Supports Tanzil Data
 * Immutable Array for raw datasets (Corpus and Tanzil)

Lastly, since this is built on Julia, it is therefore fast and robust (with strong type) as well.
## Installation
The library is not yet registered to Julia Packages since we are still working on the documentations and completing the unit tests, but it can be installed as follows:
```julia
julia> using Pkg
julia> Pkg.add("https://github.com/alstat/QuranTree.jl")
```
### Requirements
 * Julia >= 1.4
 * JuliaDB >= 0.13.0
 * PrettyTables >= 0.10.1

## Manual outline

```@contents
Pages = [
    "man/usage.md",
    "man/api.md
]
```