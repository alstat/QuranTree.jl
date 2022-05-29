using Documenter
using QuranTree

makedocs(
    sitename = "QuranTree.jl",
    format = Documenter.HTML(
        assets = ["assets/logo.ico"]
    ),
    modules = [QuranTree],
    authors = "Al-Ahmadgaid B. Asaad",
    pages = [
        "Home" => "index.md",
        "Getting Started" => "man/getting_started.md",
        "Indexing" => "man/indexing.md",
        "Transliteration" => "man/transliteration.md",
        "Morphological Features" => "man/morphological_features.md",
        "Data Processing" => "man/data_processing.md",
        "Natural Language Processing" => [
            "Introduction" => "man/nlp/nlp.md",
            "Text Summarization" => "man/nlp/text_summarization.md",
            "Topic Modeling" => "man/nlp/topic_modeling.md",
        ],
        # "CAMeL Tools" => [
        #     "Getting Started" => "man/camel/external.md",
        #     "Morphological Analysis" => "man/camel/analysis.md",
        #     "POS Tagging" => "man/camel/tagger.md",
        #     "Disambiguation" => "man/camel/disambig.md"
        # ],
        "API" => "man/api.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/alstat/QuranTree.jl.git"
)
