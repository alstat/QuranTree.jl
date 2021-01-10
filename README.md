# QuranTree.jl
[![Build status](https://github.com/alstat/QuranTree.jl/workflows/CI/badge.svg)](https://github.com/alstat/QuranTree.jl/actions)
[![Coverage](https://codecov.io/gh/alstat/QuranTree.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/alstat/QuranTree.jl)
[![](https://img.shields.io/badge/docs-dev-blue.svg)][docs-dev-url]

A Julia package for working with the Quran. QuranTree.jl is based on [The Quranic Arabic Corpus](https://corpus.quran.com/) by Kais Dukes, and is aimed at offerring a high-level API alternative to the Java package, [JQuranTree](https://corpus.quran.com/java/overview.jsp). 
## Features
The following are the features of the package:

 * Indexing
    * Intuitive indexing for Chapters, Verses, Words and Parts
 * Transliteration
    * Buckwalter as default
    * Create custom transliterator
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
 * Others
    * Supports Tanzil data
    * Read-only array for raw datasets (Corpus and Tanzil)

Since the library is purely written in Julia, it is therefore fast, type-safe and modular.

## Installation
The library will soon be added to the Julia Package Registry, still finishing up the documentation. For now, QuranTree.jl can be installed as follows:
```julia
julia> using Pkg
julia> Pkg.add("https://github.com/alstat/QuranTree.jl")
```
### Requirements
 * Julia >= 1.4
 * JuliaDB >= 0.13.0
 * PrettyTables >= 0.10.1
 
## Usage
See the [documentation](docs-dev-url).

[docs-dev-url]: https://alstat.github.io/QuranTree.jl/dev/