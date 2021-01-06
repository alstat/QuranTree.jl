# QuranTree.jl

[![Build Status](https://travis-ci.com/alstat/QuranTree.jl.svg?branch=master)](https://travis-ci.com/alstat/QuranTree.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/alstat/QuranTree.jl?svg=true)](https://ci.appveyor.com/project/alstat/QuranTree-jl)
<!-- [![Coverage](https://codecov.io/gh/alstat/QuranTree.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/alstat/QuranTree.jl) -->

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

## Documentation
The dataset is included in the library already, both the Quranic Corpus and the Tanzil Data. To load the data, run the following
```julia
using QuranTree

data = QuranData()
crps, tnzl = load(data);
```
The `load` function returns a tuple both for the Quranic Corpus and the Tanzil Data. The loaded data is encoded in a immutable (read-only) array, so users cannot change it. This is specified in the type of the object as shown below:
```julia
crps
#> (CorpusRaw) 128276-element ReadOnlyArray{String,1,Array{String,1}}:
#>  "# PLEASE DO NOT REMOVE OR CHANGE THIS COPYRIGHT BLOCK"
#>  "#===================================================================="
#>  "#"
#>  "#  Quranic Arabic Corpus (morphology, version 0.4)"
#>  "#  Copyright (C) 2011 Kais Dukes"
#>  "#  License: GNU General Public License"
#>  ⋮
#>  "(114:6:1:1)\tmina\tP\tSTEM|POS:P|LEM:min"
#>  "(114:6:2:1)\t{lo\tDET\tPREFIX|Al+"
#>  "(114:6:2:2)\tjin~api\tN\tSTEM|POS:N|LEM:jin~ap|ROOT:jnn|F|GEN"
#>  "(114:6:3:1)\twa\tCONJ\tPREFIX|w:CONJ+"
#>  "(114:6:3:2)\t{l\tDET\tPREFIX|Al+"
#>  "(114:6:3:3)\tn~aAsi\tN\tSTEM|POS:N|LEM:n~aAs|ROOT:nws|MP|GEN"
```
