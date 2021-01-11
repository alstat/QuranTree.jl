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
avrs = arabic.(vrs)
```
Note that `.` (dot) broadcasting is only used for arrays. So for pure string input (not arrays of string), `arabic(...)` (without dot) is used. Example,
```@repl abc
vrs[1]
arabic(vrs[1]);
```
## Custom Transliteration
Creating a custom transliteration requires only an input encoding in the form of dictionary. For example, QuranTree.jl's Buckwalter's encoding is provided by the constant `BW_ENCODING` as shown below:

```@repl abc
BW_ENCODING
```
Suppose, we want to create a new transliteration by simply reversing the values of the dictionary. This is done as follows:
```@repl abc
old_keys = collect(keys(BW_ENCODING));
new_keys = reverse(collect(values(BW_ENCODING)));
my_encoder = Dict(old_keys .=> new_keys)
@transliterator my_encoder "MyEncoder"
```
The macro `@transliterator` is used for updating the transliteration, and it takes two inputs: the dictionary (`my_encoder`) and the name of the encoding (`"MyEncoder"`). Using this new encoding, the `avrs` above will have a new transliteration:
```@repl abc
new_vrs = encode.(avrs);
new_vrs
```
To confirm this new transliteration, decoding it back to arabic should generate the proper results:
```@repl abc
arabic.(new_vrs)
```
To reset the transliteration, simply run the following:
```@repl abc
@transliterator :default
```
This will fallback to the Buckwalter transliteration, as shown below:
```@repl abc
bw_vrs = encode.(avrs);
bw_vrs
arabic.(bw_vrs)
```
## Simple Encoding
Another feature supported in QuranTree.jl is the [Simple Encoding](https://corpus.quran.com/java/simpleencoding.jsp). For example, the following will (Simple) encode first verse of chapter 1:
```@repl abc
vrs = verses(tnzldata[1][1])
encode(SimpleEncoder, vrs[1])
```
Or, for verses 1 to 4 of chapter 114:
```@repl abc
vrs = verses(tnzldata[114][1:4])
encode.(SimpleEncoder, vrs)
```