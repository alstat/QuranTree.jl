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
To start working with the raw data, the `CorpusRaw` and `TanzilRaw` objects must be tabularized.
```julia
crpsdata = table(crps);
tnzldata = table(tnzl);
crpsdata
#> Quranic Arabic Corpus (morphology)
#> (C) 2011 Kais Dukes
#> 
#> Table with 128219 rows, 7 columns:
#> Columns:
#> #  colname   type
#> ─────────────────────
#> 1  chapter   Int64
#> 2  verse     Int64
#> 3  word      Int64
#> 4  part      Int64
#> 5  form      String
#> 6  tag       String
#> 7  features  Features
```
### Indexing
The indexing works as follows: For `CorpusData`, 
```julia
crpsdata[<chapter>][<verse>][<word>][<part>]
```
and for `TanzilData`,
```julia
tnzldata[<chapter>][<verse>]
```
For example, to access Chapter 1, Verse 7 is accessed as follows:
```julia
crpsdata[1][7]
#> Chapter 1 ٱلْفَاتِحَة (The Opening)
#> Verse 7
#> 
#> Table with 15 rows, 5 columns:
#> Columns:
#> #  colname   type
#> ─────────────────────
#> 1  word      Int64
#> 2  part      Int64
#> 3  form      String
#> 4  tag       String
#> 5  features  Features

tnzldata[1][7]
#> Chapter 1 ٱلْفَاتِحَة (The Opening)
#> Verse 7
#> 
#> Table with 1 rows, 1 columns:
#> form
#> ─────────────────────────────────────────────────────
#> "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ"
```
QuranTree.jl uses [IndexedTable.jl](https://github.com/JuliaData/IndexedTables.jl) for tabulating the raw data, and unique to IndexedTable.jl is that it will only view part the summary of the table if the width of the table is wider that output pane, as seen in `crpsdata[1][7]` above. To view the table, [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) can be used:
```julia
using PrettyTables
@pt crpsdata[1][7]
#> ────────────────────────────────────────────────────────────────────────────────
#>    word    part          form      tag                                         ⋯
#>   Int64   Int64        String   String                                         ⋯
#> ────────────────────────────────────────────────────────────────────────────────
#>       1       1       Sira`Ta        N               Features("STEM|POS:N|LEM: ⋯
#>       2       1     {l~a*iyna      REL                        Features("STEM|P ⋯
#>       3       1      >anoEamo        V     Features("STEM|POS:V|PERF|(IV)|LEM: ⋯
#>       3       2            ta     PRON                                    Feat ⋯
#>       4       1        Ealayo        P                              Features(" ⋯
#>       4       2          himo     PRON                                    Feat ⋯
#>       5       1        gayori        N                Features("STEM|POS:N|LEM ⋯
#>       6       1           {lo      DET                                         ⋯
#>       6       2     magoDuwbi        N   Features("STEM|POS:N|PASS|PCPL|LEM:ma ⋯
#>       7       1        Ealayo        P                              Features(" ⋯
#>       7       2          himo     PRON                                    Feat ⋯
#>       8       1            wa     CONJ                                     Fea ⋯
#>       8       2           laA      NEG                               Features( ⋯
#>       9       1            {l      DET                                         ⋯
#>       9       2   D~aA^l~iyna        N     Features("STEM|POS:N|ACT|PCPL|LEM:D ⋯
#> ────────────────────────────────────────────────────────────────────────────────
#>                                                                 1 column omitted
```