Transliteration
=====
QuranTree.jl uses Buckwalter as the default transliteration, which is based on the Quranic Arabic Corpus [encoding](https://corpus.quran.com/java/buckwalter.jsp). The transliteration is invoke using the `encode` function. However, to extract the form/verses of the `CorpusData`/`TanzilData`, the function `verses` can be used. For example, the following will transliterate the first verse of chapter 1:
```@setup abc
using QuranTree

crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
```

```@repl
using QuranTree

crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
vrs = verses(tnzldata[1][1])
encode(vrs[1])
```
The function `verses` always returns an Array, and hence encoding multiple verses is possible using Julia's `.` (dot) broadcasting. For example, the following will transliterate all verses of chapter 114:
```@repl abc
vrs = verses(tnzldata[114])
encode.(vrs)
```
## Decoding
To decode the transliterated back to arabic is done using the function `arabic`. For example, the following will decode to arabic the transliterated verses above of chapter 114:
```@repl abc
arabic.(encode.(vrs))
```
Or using the `CorpusData`, 
```@repl abc
vrs = verses(crpsdata[114])
arabic.(vrs)
```