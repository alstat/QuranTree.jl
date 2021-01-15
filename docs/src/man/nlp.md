Natural Language Processing
=====
In this section, we will demonstrate how to perform some Natural Language Processing task using QuranTree.jl with Julia's TextAnalysis.jl library. In particular, we will emphasize on how to come up with a feature matrix that can be used as input for any NLP tasks.

## Summarizing the Quran
The first task is to summarize the quran. The algorithm that we will be using is the TextRank which applies PageRank algorithm to text datasets.
```@setup abc
using Pkg
Pkg.add("JuliaDB")
Pkg.add("Languages")
Pkg.add("TextAnalysis")
```
```@repl abc
using JuliaDB
using Languages
using QuranTree
using TextAnalysis

crps, tnzl = QuranData() |> load;
crpsdata = table(crps)
```

### Data Preprocessing
To start with, we first clean the data by removing the Disconnected Letters such as الٓمٓ, الٓمٓصٓ, among others. This is done as follows:
```@repl abc
crpstbl = filter(t -> !isfeature(parse(Features, t.features), DisconnectedLetters), crpsdata.data)
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
crps = Corpus(StringDocument.(vrs))
```
We then update the lexicon and inverse index for efficient indexing of the corpus.
```@repl abc
update_lexicon!(crps)
update_inverse_index!(crps)
```
We then create a Document Term Matrix, which will have rows of verses and columns of words describing the verses.
```@repl abc
m = DocumentTermMatrix(crps)
```
### TF-IDF
Finally, we compute the corresponding TF-IDF, which will serve as the feature matrix.
```@repl abc
tfidf = tf_idf(m)
```
### Text Summarization
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
orig_vrs = verses(CorpusData(crpstbl))
```
Therefore, the Quranic Arabic corpus can be summarized by the following 10 verses using TextRank:
```@repl abc
arabic.(unique(orig_vrs[idx[1:10]]))
```