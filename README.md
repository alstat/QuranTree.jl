# QuranTree.jl <img src="docs/src/assets/logo.png" align="right" width="100"/>
[![Build status](https://github.com/alstat/QuranTree.jl/workflows/CI/badge.svg)](https://github.com/alstat/QuranTree.jl/actions)
[![Coverage](https://codecov.io/gh/alstat/QuranTree.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/alstat/QuranTree.jl)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://alstat.github.io/QuranTree.jl/dev/)
[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/alstat/QuranTree.jl/blob/master/LICENSE)

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

## Installation
To install the package, run the following:
```julia
julia> using Pkg
julia> Pkg.add("QuranTree")
```

## Citation
```
@inproceedings{asaad-2021-qurantree,
    title = "{Q}uran{T}ree.jl: A Julia Package for Quranic {A}rabic Corpus",
    author = "Asaad, Al-Ahmadgaid",
    booktitle = "Proceedings of the Sixth Arabic Natural Language Processing Workshop",
    month = apr,
    year = "2021",
    address = "Kyiv, Ukraine (Virtual)",
    publisher = "Association for Computational Linguistics",
    url = "https://www.aclweb.org/anthology/2021.wanlp-1.22",
    pages = "208--212",
}
```

## Requirements
 * [Julia](https://julialang.org/) >= 1.0
 * [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl) >= 0.13.0
 * [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) >= 0.10.1

## Usage
See the [documentation](https://alstat.github.io/QuranTree.jl/dev/).