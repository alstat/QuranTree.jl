using Documenter
using QuranTree

makedocs(
    sitename = "QuranTree.jl",
    format = Documenter.HTML(),
    modules = [QuranTree],
    authors = "Al-Ahmadgaid B. Asaad",
    pages = [
        "Home" => "index.md",
        "Usage" => "man/usage.md",
        "API" => "man/api.md"
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/alstat/QuranTree.jl.git"
)
