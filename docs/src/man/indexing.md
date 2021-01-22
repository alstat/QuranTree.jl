Indexing the Corpus
=====
QuranTree.jl offers a intuitive indexing for both [Quranic Arabic Corpus](https://corpus.quran.com/) and the [Tanzil Data](http://tanzil.net/download), specifically it follows the following usage:
```julia
# for Quranic Arabic Corpus
crpsdata[<chapters>][<verses>][<words>][<parts>]

# for Tanzil Data
tnzldata[<chapters>][<verses>]
```
The following are the options supported for each index:
 * Chapters:
    * Int64 - `crpsdata[1]` (extracts chapter 1)
    * UnitRange - `crpsdata[15:24]` (extracts chapters 15 to 24)
    * Array{Int64,1} - `crpsdata[[3,9,10]]` (extracts chapters 3, 9 and 10)
    * end (special) - `crpsdata[end-3:end]` (extracts chapters 111 to 114).
 * Verses:
    * Int64 - `crpsdata[1][1]` (extracts verse 1 of chapter 1)
    * UnitRange - `crpsdata[2][15:24]` (extracts verses 15 to 24 of chapter 2)
    * Array{Int64,1} - `crpsdata[10][[3,9,10]]` (extracts verses 3, 9 and 10 of chapter 10)
 * Words: (not applicable for `TanzilData`, only `CorpusData`)
    * Int64 - `crpsdata[1][1][1]` (extracts word 1 of verse 1 of chapter 1)
    * UnitRange - `crpsdata[2][8][1:3]` (extracts words 1 to 3 of verse 8 of chapter 2)
    * Array{Int64,1} - `crpsdata[2][8][[1,3]]` (extracts words 1 and 3 of verse 8 of chapter 2)
* Parts: (not applicable for `TanzilData`, only `CorpusData`)
    * Int64 - `crpsdata[1][1][1][1]` (extracts part 1 of word 1 of verse 1 of chapter 1)
    * UnitRange - `crpsdata[2][9][1][1:2]` (extracts part 1 to part 2 of word 1 of verse 9 of chapter 2)
    * Array{Int64,1} - `crpsdata[2][9][1][[1,2]]` (extracts part 1 and part 2 of word 1 of verse 9 of chapter 2)

As an example, the following will extract verse 9 of chapter 2 in both `TanzilData` and `CorpusData`:
```@repl abc
using QuranTree

data = QuranData();
crps, tnzl = load(data);
crpsdata = table(crps);
tnzldata = table(tnzl);
crpsdata[2][9]
tnzldata[2][9]
```
As shown above, the output of the indexing contains label for the chapter name, both in Arabic and in English. Again, the output of the `crpsdata[2][9]` is not shown, since the width of the output is wider than the width of the output pane. So, [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) is used to view the table:
```@setup abc
using Pkg
Pkg.add("PrettyTables")
```
```@repl abc
using PrettyTables
@ptconf vcrop_mode=:middle tf=tf_compact
@pt crpsdata[2][9]
```
## Combinations of Indices
Combinations of these indices are also supported. For example, the following will extract chapters 111 to 114, each with verses 1 and 3:
```@repl abc
@pt crpsdata[111:114][[1,3]]
@pt tnzldata[111:114][[1,3]] 
```
!!! info "Info"
    Node that special index like `end` is applicable, for example `crpsdata[111:114][[1,3]]` is the same as `crpsdata[end-3:end][[1,3]]`, and `tnzldata[111:114][[1,3]]` is equivalent to `tnzldata[end-3:end][[1,3]]`.

Another example, the following will extract part 1 of words 1 to 3 of the above `CorpusData` output:
```@repl abc
@pt crpsdata[111:114][[1,3]][1:3][1] 
```
