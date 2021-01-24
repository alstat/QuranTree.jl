Text Summarization
=====
This section will demonstrate how to use [TextAnalysis.jl](https://juliahub.com/docs/TextAnalysis/5Mwet/0.7.2/) (Julia's leading NLP library) for QuranTree.jl. In particular, in summarizing the Qur'an, specifically Chapter 18 (The Cave) which most Muslims are aware of the story, since it is the chapter recommended to be read every Friday. The algorithm used for summarization is called TextRank, an application of PageRank algorithm to text datasets.
```@setup abc
using Pkg
Pkg.add("JuliaDB")
Pkg.add("PrettyTables")
Pkg.add("TextAnalysis")
```
```@repl abc
using JuliaDB
using PrettyTables
using QuranTree
using TextAnalysis
@ptconf tf=tf_compact vcrop_mode=:backend

crps, tnzl = QuranData() |> load;
crpsdata = table(crps)
```
!!! info "Note"
    You need to install [JuliaDB.jl](https://github.com/JuliaData/JuliaDB.jl) and [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) to successfully run the code. 
    ```julia
    using Pkg
    Pkg.add("JuliaDB")
    Pkg.add("PrettyTables")
    ```
## Data Preprocessing
The first data processing will be the removal of all Disconnected Letters like الٓمٓ ,الٓمٓصٓ, among others. This is done as follows:
```@repl abc
function preprocess(s::String)
    feat = parse(Features, s)
    disletters = isfeature(feat, AbstractDisLetters)
    prepositions = isfeature(feat, AbstractPreposition)
    particles = isfeature(feat, AbstractParticle)
    conjunctions = isfeature(feat, AbstractConjunction)
    pronouns = isfeature(feat, AbstractPronoun)
    adverbs = isfeature(feat, AbstractAdverb)

    return !disletters && !prepositions && !particles && !conjunctions && !pronouns && !adverbs
end

crpstbl = filter(t -> preprocess(t.features), crpsdata[18].data)
```
Next, we create a copy of the above data so we have the original state, and use the copy to do further data processing.
```@repl abc
crpsnew = deepcopy(crpstbl)
feats = select(crpsnew, :features)
feats = parse.(Features, feats)
```
## Lemmatization
Using the above parsed features, we then convert the `form` of the tokens into its lemma. This is useful for addressing minimal variations due to inflection.
```@repl abc
lemmas = lemma.(feats)
forms1 = select(crpsnew, :form)
forms1[.!ismissing.(lemmas)] = lemmas[.!ismissing.(lemmas)]
```
!!! tip "Tips"
    We can also use the `Root` features instead, which is done by simply replacing `lemma.(feats)` with `root.(feats)`. 

We now put back the new form to the corpus:
```@repl abc
crpsnew = transform(crpsnew, :form => forms1)
crpsnew = CorpusData(crpsnew)
```
## Tokenization
We want to summarize the Qur'an at the verse level. Thus, the token would be the verses of the corpus. From these verses, we further clean it by dediacritization and normalization of the characters:
```@repl abc
lem_vrs = verses(crpsnew)
vrs = QuranTree.normalize.(dediac.(lem_vrs))
```
## Creating a TextAnalysis Corpus
To make use of the [TextAnalysis.jl's APIs](https://juliahub.com/docs/TextAnalysis/5Mwet/0.7.2/APIReference/), we need to encode the processed Quranic Corpus to [TextAnalysis.jl](https://juliahub.com/docs/TextAnalysis/5Mwet/0.7.2/)'s Corpus. In this case, we will create a `StringDocument` of the verses.
```@repl abc
crps1 = Corpus(StringDocument.(vrs))
```
We then update the lexicon and inverse index for efficient indexing of the corpus.
```@repl abc
update_lexicon!(crps1)
update_inverse_index!(crps1)
```
Next, we create a Document Term Matrix, which will have rows of verses and columns of words describing the verses.
```@repl abc
m1 = DocumentTermMatrix(crps1)
```
## TF-IDF
Finally, we compute the corresponding TF-IDF, which will serve as the feature matrix.
```@repl abc
tfidf = tf_idf(m1)
```
## Summarizing the Qur'an
Using the TF-IDF, we compute the product of it with its transpose to come up with a square matrix, where the elements describes the linkage between the verses, or the similarity between the verses.
```@repl abc
sim_mat = tfidf * tfidf'
```
At this point, we can now write the code for the PageRank algorithm:
```@repl abc
using LinearAlgebra
function pagerank(A; Niter=20, damping=.15)
    Nmax = size(A, 1)
    r = rand(1, Nmax);              # Generate a random starting rank.
    r = r ./ norm(r, 1);            # Normalize
    a = (1 - damping) ./ Nmax;      # Create damping vector

    for i=1:Niter
        s = r * A
        rmul!(s, damping)
        r = s .+ (a * sum(r, dims=2));   # Compute PageRank.
    end

    r = r ./ norm(r, 1);

    return r
end
```
Using this function, we apply it to the above similarity matrix (`sim_mat`) and extract the PageRank scores for all verses. This score will serve as the weights, and so higher scores suggest that the verse has a lot of connections to other verses in the corpus, which means it represents *per se* the corpus.
```@repl abc
p = pagerank(sim_mat)
```
Now we sort these scores in descending order and use it to rearrange the original verses:
```@repl abc
idx = sortperm(vec(p), rev=true)[1:10]
```
Finally, the following 10 verses best summarizes the corpus (Chapter 18) using TextRank:
```@repl abc
verse_nos = verses(CorpusData(crpstbl), number=true, start_end=false)

verse_out = String[];
chapter = Int64[];
verse = Int64[];
for v in verse_nos
    verse_out = vcat(verse_out, verses(crpsdata[v[1]][v[2]]))
    chapter = vcat(chapter, repeat(v[1], inner=length(v[2])))
    verse = vcat(verse, v[2])
end

tbl = table((
    chapter=chapter[idx], 
    verse=verse[idx], 
    verse_text=arabic.(verse_out[idx])
));

@pt tbl
```
The following is the table of the above output properly formatted in HTML.
```@example abc
Pkg.add("DataFrames")
Pkg.add("IterableTables")
Pkg.add("Latexify")
using DataFrames: DataFrame
using IterableTables
using Latexify

mdtable(DataFrame(tbl), latex=false)
```
The following are the translations of the above verses:
```@raw html
<table>
    <thead><td>Chapter</td><td>Verse</td><td>English Translation</td></thead>
    <tbody>
    <tr><td>18</td><td>85</td><td>So he travelled a course,</td></tr>
    <tr><td>18</td><td>89</td><td>Then he travelled a ˹different˺ course</td></tr>
    <tr><td>18</td><td>92</td><td>Then he travelled a ˹third˺ course</td></tr>
    <tr><td>18</td><td>66</td><td>Moses said to him, “May I follow you, provided that you teach me some of the right guidance you have been taught?”</td></tr>
    <tr><td>18</td><td>70</td><td>He responded, “Then if you follow me, do not question me about anything until I ˹myself˺ clarify it for you.”</td></tr>
    <tr><td>18</td><td>8</td><td>And We will certainly reduce whatever is on it to barren ground.</td></tr>
    <tr><td>18</td><td>28</td><td>And patiently stick with those who call upon their Lord morning and evening, seeking His pleasure.1 Do not let your eyes look beyond them, desiring the luxuries of this worldly life. And do not obey those whose hearts We have made heedless of Our remembrance, who follow ˹only˺ their desires and whose state is ˹total˺ loss.</td></tr>
    <tr><td>18</td><td>108</td><td>where they will be forever, never desiring anywhere else.</td></tr>
    <tr><td>18</td><td>91</td><td>So it was. And We truly had full knowledge of him.</td></tr>
    <tr><td>18</td><td>68</td><td>And how can you be patient with what is beyond your ˹realm of˺ knowledge?”</td></tr>
    </tbody>
</table>
```