Data Processing
=====
Special utilities for Arabic Natural Language Processing (ANLP) for data preprocessing are provided by [Yunir.jl](https://github.com/alstat/Yunir.jl), for example on tasks like *character dediacritization* and *character normalization*.

## Character Dediacritization
`dediac` works for both Arabic, Buckwalter and custom transliterations.
```@setup abc
using Pkg
Pkg.add("Yunir")
```

```@repl abc
using QuranTree
using Yunir

crps, tnzl = load(QuranData());
crpsdata = table(crps);
tnzldata = table(tnzl);
avrs = verses(tnzldata[1][1])[1]
dediac(avrs)
bvrs = verses(crpsdata[1][1])[1]
dediac(bvrs)
dediac(avrs) === arabic(dediac(bvrs))
```
Custom transliteration is also dediacritizable as shown below,
```@repl abc
old_keys = collect(keys(BW_ENCODING));
new_vals = reverse(collect(values(BW_ENCODING)));
my_encoder = Dict(old_keys .=> new_vals);

@transliterator my_encoder "MyEncoder"
encode(avrs)
arabic(encode(avrs))
dediac(encode(avrs))
arabic(dediac(encode(avrs)))
```
To reset the transliteration,
```@repl abc
@transliterator :default
encode(avrs)
dediac(encode(avrs))
```
## Character Normalization
Normalization is done using the `normalize` function. It works for Arabic, Buckwalter and other custom transliterations. For example, the following normalizes the `avrs` above:
```@repl abc
normalize(avrs)
normalize(dediac(avrs))
dediac(normalize(avrs))
# using pipe notation
avrs |> dediac |> normalize |> encode
```
Specific character can be normalized:
```@repl abc
avrs1 = verses(tnzldata[2][4])[1]
normalize(avrs1, :alif_maddah)
normalize(avrs1, :alif_hamza_above)
normalize(avrs, [:alif_khanjareeya, :hamzat_wasl])
```
Or using the `CorpusData` instead of the `TanzilData`,
```@repl abc
avrs2 = arabic(verses(crpsdata[2][15])[1])
normalize(avrs2, :ya_hamza_above)
```
