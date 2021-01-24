# QuranTree.jl Documentation

```@meta
CurrentModule = QuranTree
DocTestSetup = quote
    using QuranTree
end
```
A Julia package for working with the Qur'an (Islam's Holy Book), computationally. QuranTree.jl is based on [The Quranic Arabic Corpus](https://corpus.quran.com/) by Kais Dukes of University of Leeds, and is aimed at offerring a high-level API alternative to the Java package, [JQuranTree](https://corpus.quran.com/java/overview.jsp). 
## Features
The following are the features of the package:

 * Indexing
    * Intuitive indexing for Chapters, Verses, Words and Parts
 * Transliteration
    * Buckwalter as default
    * Functionality for creating custom transliterator
    * Update transliteration in 1 line of code
 * Complete type for all Morphological Features and Part of Speech
 * Seemless transition between Arabic and Buckwalter (or custom transliteration)
 * Simple Encoding (refer [here](https://corpus.quran.com/java/simpleencoding.jsp))
 * Character Normalization
    * For both Arabic and Buckwalter (or custom transliteration)
 * Character Dediacritization
    * For both Arabic and Buckwalter (or custom transliteration)
 * Utilities
    * Function for detailed description of the Morphological Features.
 * Modularity and Type-Safe
    * Can easily integrate with other Julia packages, thanks to Julia's Multiple Dispatch
    * Can easily integrate with Python (using PyCall.jl) and R (Using RCall.jl) for packages that are not yet in Julia
    * Like JQuranTree, QuranTree.jl is type-safe
 * Others
    * Supports Tanzil data
    * Read-only array for raw datasets (Corpus and Tanzil)

## Installation
QuranTree.jl is a Julia registered package, and can be installed as follows:
```julia
julia> using Pkg
julia> Pkg.add("QuranTree")
```
## Requirements
 * [Julia](https://julialang.org/) >= 1.0
 * [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl) >= 0.13.0
 * [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) >= 0.10.1