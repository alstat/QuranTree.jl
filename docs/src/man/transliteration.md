Transliteration
=====
For transliteration, we will use [Yunir.jl](https://github.com/alstat/Yunir.jl), a lightweight Arabic NLP toolkit. [Yunir.jl](https://github.com/alstat/Yunir.jl) uses Buckwalter as the default transliteration based on the Quranic Arabic Corpus [encoding](https://corpus.quran.com/java/buckwalter.jsp). The transliteration is done via the `encode` function, for example, the following will transliterate the first verse of Chapter 1:
```@setup
using Pkg
Pkg.add("Yunir")
```
```@repl abc
using QuranTree
using Yunir 

crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
vrs = verses(tnzldata[1][1])
encode(vrs[1])
```
!!! note "Note"
    You need to install [Yunir.jl](https://github.com/alstat/Yunir.jl) to run the above code. To install, run
    ```julia
    using Pkg
    Pkg.add("Yunir")
    ```
The `verses` function above is used to extract the corresponding verse from the Qur'an data of type `AbstractQuran`.
!!! tip "Tips"
    `verses` by default only returns the verse form of the table, but one can also extract the corresponding verse number instead of the form, example:
    ```julia
    verses(tnzldata, number=true, start_end=true)
    verses(tnzldata, number=true, start_end=false)
    ```
!!! tip "Tips"
    To extract the words of the corpus, use the function `words` instead.

The function `verses` always returns an Array, and hence encoding multiple verses is possible using Julia's `.` (dot) broadcasting operation. For example, the following will transliterate all verses of Chapter 114:
```@repl abc
vrs = verses(tnzldata[114])
encode.(vrs)
```
## Decoding
To decode the transliterated back to Arabic form, [Yunir.jl](https://github.com/alstat/Yunir.jl) has `arabic` function to do just that. For example, the following will decode to Arabic the transliterated verses of Chapter 114 above:
```@repl abc
arabic.(encode.(vrs))
```
Or using the `CorpusData`, 
```@repl abc
vrs = verses(crpsdata[114])
avrs = arabic.(vrs)
```
!!! tip "Tips"
    `.` (dot) broadcasting is only used for arrays. So, for `String` input (not arrays of `String`), `arabic(...)` (without dot) is used. Example,
    ```julia
    arabic(vrs[1])
    ```
## Custom Transliteration
Creating a custom transliteration requires only an input encoding in the form of a dictionary (`Dict`). For example, [Yunir.jl](https://github.com/alstat/Yunir.jl)'s Buckwalter's encoding is provided by the constant `BW_ENCODING` as shown below:

```@repl abc
BW_ENCODING
```
Suppose, we want to create a new transliteration by simply reversing the values of the dictionary. This is done as follows:
```@repl abc
old_keys = collect(keys(BW_ENCODING));
new_vals = reverse(collect(values(BW_ENCODING)));
my_encoder = Dict(old_keys .=> new_vals)
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
Another feature supported in QuranTree.jl is the [Simple Encoding](https://corpus.quran.com/java/simpleencoding.jsp). For example, the following will (Simple) encode the first verse of Chapter 1:
```@repl abc
vrs = verses(tnzldata[1][1:5])
parse(SimpleEncoding, vrs[1])
parse.(SimpleEncoding, vrs)
```