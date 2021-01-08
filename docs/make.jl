using Documenter
using QuranTree

makedocs(
    sitename = "QuranTree",
    format = Documenter.HTML(),
    modules = [QuranTree]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/alstat/QuranTree.jl.git"
)
