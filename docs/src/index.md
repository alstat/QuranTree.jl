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
 * Complete type for all Morphological Features and Part of Speech
 * Others
    * Supports Tanzil data
    * Read-only array for raw datasets (Corpus and Tanzil)

## Yunir.jl support
[Yunir.jl](https://github.com/alstat/Yunir.jl) is a lightweight Arabic NLP toolkit that well supports QuranTree.jl for the following functionalities:

 * Transliteration
    * Buckwalter as default
    * Functionality for creating custom transliterator
    * Update transliteration in 1 line of code
 * Seemless transition between Arabic and Buckwalter (or custom transliteration)
 * Simple Encoding (refer [here](https://corpus.quran.com/java/simpleencoding.jsp))
 * Character Normalization
    * For both Arabic and Buckwalter (or custom transliteration)
 * Character Dediacritization
    * For both Arabic and Buckwalter (or custom transliteration)
 * Orthographical Analysis
 
Please refer to [Yunir.jl](https://github.com/alstat/Yunir.jl) for examples.

## Installation
To install the package, run the following:
```julia
julia> using Pkg
julia> Pkg.add("QuranTree")
```