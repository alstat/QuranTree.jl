Natural Language Processing
=====
In this section, we will demonstrate how to perform some Natural Language Processing task using QuranTree.jl with Julia's TextAnalysis.jl library. In particular, we will emphasize on how to come up with a feature matrix that can be used as input for any NLP tasks.

## Text Summarization
The first task is to summarize the quran. The algorithm that we will be using is the TextRank which applies PageRank algorithm to text datasets.
```@setup abc
using Pkg
Pkg.add("JuliaDB")
Pkg.add("TextAnalysis")
```
```@repl abc
using JuliaDB
using QuranTree
using TextAnalysis

crps, tnzl = QuranData() |> load;
crpsdata = table(crps)
```

### Data Preprocessing
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

crpstbl = filter(t -> preprocess(t.features), crpsdata.data)
```
Next, we need to create a copy of the above data so we have the original state, and use the copy to do further data processing.
```@repl abc
crpsnew = deepcopy(crpstbl)
feats = select(crpsnew, :features)
feats = parse.(Features, feats)
```
### Lemmatization
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
### Tokenization
We want to summarize the document, in this case the Qur'an, using its verses. In doing so, the token would be the verses of the corpus. From these verses, we further clean it by dediacritization and normalization of the characters:
```@repl abc
lem_vrs = verses(crpsnew)
vrs = QuranTree.normalize.(dediac.(lem_vrs))
```
### Creating a TextAnalysis Corpus
To make use of the TextAnalysis.jl's api, we need to encode the processed Quranic Corpus to TextAnalysis.jl's Corpus. In this case, we will create a String document of the verses.
```@repl abc
crps1 = Corpus(StringDocument.(vrs))
```
We then update the lexicon and inverse index for efficient indexing of the corpus.
```@repl abc
update_lexicon!(crps1)
update_inverse_index!(crps1)
```
We then create a Document Term Matrix, which will have rows of verses and columns of words describing the verses.
```@repl abc
m1 = DocumentTermMatrix(crps1)
```
### TF-IDF
Finally, we compute the corresponding TF-IDF, which will serve as the feature matrix.
```@repl abc
tfidf = tf_idf(m1)
```
### Summarizing the Quran
Using the TF-IDF, we compute the product of it with its transpose to come up with a square matrix, where the elements describes the linkage between the verses, or the similarity between the verses.
```@repl abc
sim_mat = tfidf * tfidf'
```
At this point, we can now write the code for PageRank algorithm:
```@repl abc
using LinearAlgebra
function pagerank( A; Niter=20, damping=.15)
    Nmax = size(A, 1)
    r = rand(1,Nmax);              # Generate a random starting rank.
    r = r ./ norm(r,1);            # Normalize
    a = (1-damping) ./ Nmax;       # Create damping vector

    for i=1:Niter
        s = r * A
        rmul!(s, damping)
        r = s .+ (a * sum(r, dims=2));   # Compute PageRank.
    end

    r = r./norm(r,1);

    return r
end
```
Using this function, we apply it to the above similarity matrix (`sim_mat`) and extract the PageRank scores for all verses. This score will serve as the weights, and so the higher the score the higher the change that this verse have a lot of connections to other verses in the corpus, which means it represents per se the corpus.
```@repl abc
p = pagerank(sim_mat)
```
Now we sort these scores in descending order and use it to rearrange the original verses:
```@repl abc
idx = sortperm(vec(p), rev=true)[1:10]
```
Therefore, the Quranic Arabic corpus can be summarized by the following 10 verses using TextRank:
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

table((
    chapter=chapter[idx], 
    verse=verse[idx], 
    verse_text=arabic.(verse_out[idx])
))
```
The following are the translations of the above verses:
```@raw html
<table>
    <thead><td>Chapter</td><td>Verse</td><td>Enlish Translation</td></thead>
    <tbody>
    <tr><td>101</td><td>10</td><td>And what will make you realize what that is?</td></tr>
    <tr><td>37</td><td>13</td><td>When they are reminded, they are never mindful.</td></tr>
    <tr><td>109</td><td>2</td><td>I do not worship what you worship,</td></tr>
    <tr><td>83</td><td>17</td><td>and then be told, “This is what you used to deny.”</td></tr>
    <tr><td>16</td><td>24</td><td>And when it is said to them, “What has your Lord revealed?” They say, “Ancient fables!”</td></tr>
    <tr><td>96</td><td>10</td><td>a servant ˹of Ours˺ from praying?</td></tr>
    <tr><td>37</td><td>85</td><td>and said to his father and his people, “What are you worshipping?</td></tr>
    <tr><td>83</td><td>32</td><td>And when they saw the faithful, they would say, “These ˹people˺ are truly astray,”</td></tr>
    <tr><td>26</td><td>117</td><td>Noah prayed, “My Lord! My people have truly rejected me.</td></tr>
    <tr><td>99</td><td>3</td><td>and humanity cries, “What is wrong with it?”—</td></tr>
    </tbody>
</table>
```
## Topic Modeling
In this section, we are going to extract the topics for Chapters 2 to Chapters 12. To do this, Latent Dirichlet Allocation (LDA) is used to model the topics. Let's start with fresh data:
```@repl def
using QuranTree
using TextAnalysis
crps, tnzl = QuranData() |> load;
crpsdata = table(crps)
```
### Data Preprocessing
We clean the data by removing the following:

 1. Disconnected Letters
 2. 

This is done as follows:
```@repl abc

function preprocess(s::String)
    feat = parse(Features, s)
    disletters = isfeature(feat, AbstractDisLetters)
    prepositions = isfeature(feat, Stem) && isfeature(feat, Preposition)
    conjunctions = isfeature(feat, AbstractConjunction)
    pronouns = isfeature(feat, AbstractPronoun)

    return !disletters && !prepositions && !conjunctions && !pronouns
end

crpstbl = filter(t -> !isfeature(parse(Features, t.features), DisconnectedLetters), crpsdata.data)
```
Next, we need to create a copy of the above data so we have the original state, and use the copy to do further data processing.
```@repl abc
crpsnew = deepcopy(crpstbl)
feats = select(crpsnew, :features)
feats = parse.(Features, feats)

crps2 = Corpus(NGramDocument.(ngrams.(StringDocument.(vrs), 2)))
update_lexicon!(crps2)
update_inverse_index!(crps2)
m2 = DocumentTermMatrix(crps2)
k = 10      # number of topics
iter = 1000 # number of gibbs sampling iterations
alpha = 0.1 # hyperparameter
beta = 0.1  # hyperparameter
ϕ, θ = lda(m2, k, iter, alpha, beta)
```
Extract the topic for first cluster:
```@repl abc
ntopics = 10
cluster_topics = Matrix(undef, ntopics, k)
for i = 1:k
    topics_idcs = sortperm(ϕ[i, :], rev=true)
    cluster_topics[:, i] = arabic.(m2.terms[topics_idcs][1:ntopics])
end
```