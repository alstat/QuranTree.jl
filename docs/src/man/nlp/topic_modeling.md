Topic Modeling
============
Another application of Natural Language Processing is Topic Modeling, and in this section, we are going to extract the topics for Chapter 18 (The Cave). To do this, again [TextAnalysis.jl](https://juliahub.com/docs/TextAnalysis/5Mwet/0.7.2/) (Julia's leading NLP library) is used. The model for this task will be Latent Dirichlet Allocation (LDA), but Latent Semantic Analysis (LSA) is also available in [TextAnalysis.jl](https://juliahub.com/docs/TextAnalysis/5Mwet/0.7.2/). To start with, load the data as follows:
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
@ptconf vcrop_mode=:middle tf=tf_compact

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
## Latent Dirichlet Allocation
Finally, run LDA as follows:
```@repl abc
k = 3          # number of topics
iter = 1000    # number of gibbs sampling iterations
alpha = 0.1    # hyperparameter
beta = 0.1     # hyperparameter
ϕ, θ = lda(m1, k, iter, alpha, beta)
```
Extract the topic for first cluster:
```@repl abc
ntopics = 10
cluster_topics = Matrix(undef, ntopics, k);
for i = 1:k
    topics_idcs = sortperm(ϕ[i, :], rev=true)
    cluster_topics[:, i] = arabic.(m1.terms[topics_idcs][1:ntopics])
end
@pt cluster_topics
```
Tabulating this propery would give us the following
```@example abc
Pkg.add("DataFrames")
Pkg.add("Latexify")
using DataFrames: DataFrame
using Latexify

mdtable(convert(DataFrame, cluster_topics), latex=false)
```
As you may have noticed, the result is not good and this is mainly due to data processing. Readers are encourage to improve this for their own use. This section, however, demonstrated how [TextAnalysis.jl](https://juliahub.com/docs/TextAnalysis/5Mwet/0.7.2/)'s LDA can be used for Topic Modeling the QuranTree.jl's corpus.

Finally, the following will extract the topic for each verse:
```@repl abc
vrs_topics = []
for i = 1:dtm(m1).m
    push!(vrs_topics, sortperm(θ[:, i], rev=true)[1])
end
@pt vrs_topics
```