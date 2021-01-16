# Topic Modeling
In this section, we are going to extract the topics for Chapters 2 to Chapters 12. To do this, Latent Dirichlet Allocation (LDA) is used to model the topics. Let's start with fresh data:
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

## Data Preprocessing
To start with, we first clean the data by removing the Disconnected Letters such as الٓمٓ ,الٓمٓصٓ, among others. This is done as follows:
```@repl abc
function preprocess(s::String)
    feat = parse(Features, s)
    disletters = isfeature(feat, AbstractDisLetters)
    prepositions = isfeature(feat, Stem) && isfeature(feat, Preposition)
    conjunctions = isfeature(feat, AbstractConjunction)
    pronouns = isfeature(feat, AbstractPronoun)

    return !disletters && !prepositions && !conjunctions && !pronouns
end

crpstbl = filter(t -> preprocess(t.features), crpsdata[2].data)
```
Next, we need to create a copy of the above data so we have the original state, and use the copy to do further data processing.
```@repl abc
crpsnew = deepcopy(crpstbl)
feats = select(crpsnew, :features)
feats = parse.(Features, feats)
```
## Lemmatization
Using the above parsed features, we then convert the `form` of the tokens to its lemma. This is useful for addressing minimal variations due to inflection.
```@repl abc
lemmas = lemma.(feats)
forms1 = select(crpsnew, :form)
forms1[.!ismissing.(lemmas)] = lemmas[.!ismissing.(lemmas)]
```
We can also use the Root features instead, which is done by simply replacing `lemma.(feats)` with `root.(feats)`. We now put back the new form to the corpus:
```@repl abc
crpsnew = transform(crpsnew, :form => forms1)
crpsnew = CorpusData(crpsnew)
```
## Tokenization
We want to summarize the document, in this case the Qur'an, using its verses. In doing so, the token would be the verses of the corpus. From these verses, we further clean it by dediacritization and normalization of the characters:
```@repl abc
lem_vrs = verses(crpsnew)
vrs = QuranTree.normalize.(dediac.(lem_vrs))
```
## Creating a TextAnalysis Corpus
To make use of the TextAnalysis.jl's api, we need to encode the processed Quranic Corpus to TextAnalysis.jl's Corpus. In this case, we will create a String document of the verses.
```@repl abc
crps1 = Corpus(NGramDocument.(ngrams.(StringDocument.(vrs), 3)))
```
We then update the lexicon and inverse index for efficient indexing of the corpus.
```@repl abc
update_lexicon!(crps1)
update_inverse_index!(crps1)
```
We then create a Document Term Matrix, which will have rows of verses and columns of words describing the verses.
```@repl abc
m1 = DocumentTermMatrix(crps1)
k = 3       # number of topics
iter = 1000 # number of gibbs sampling iterations
alpha = 0.1 # hyperparameter
beta = 0.1  # hyperparameter
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
Extract the topic for each verse
```@repl abc
vrs_topics = []
for i = 1:dtm(m1).m
    push!(vrs_topics, sortperm(θ[:, i], rev=true)[1])
end
@pt vrs_topics
```
