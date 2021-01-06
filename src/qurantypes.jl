import JuliaDB: IndexedTable
import ReadOnlyArrays: ReadOnlyArray

struct FilePaths
    corpus::String
    tanzil::String
end
FilePaths() = FilePaths(
    joinpath(@__DIR__, "..", "data", "quranic-corpus-morphology-0.4.txt"),
    joinpath(@__DIR__, "..", "data", "quran-uthmani-final.txt")
)

struct SimpleEncoder
    encode::Dict{Symbol,Symbol}
end
SimpleEncoder() = SimpleEncoder(SIMPLE_ENCODING)

struct ChapterLabel
    english::Array{String,1}
    arabic::Array{String,1}
end
ChapterLabel() = ChapterLabel(EN_CHAPTER_LABELS, AR_CHAPTER_LABELS)

struct QuranData
   path::FilePaths 
end
QuranData() = QuranData(FilePaths())

struct CorpusRaw
    data::ReadOnlyArray{String,1,Array{String,1}}
end

struct TanzilRaw
    data::ReadOnlyArray{String,1,Array{String,1}}
end
   
mutable struct MetaData
    title::String
    author::String
    description::String
    website::String
    language::String
    year::String
    license::String
    version::String
end
MetaData(::Type{CorpusRaw}) = MetaData(
    "Quranic Arabic Corpus (morphology)",
    "Kais Dukes",
    "The Quranic Arabic Corpus includes syntactic and morphological\nannotation of the Quran, and builds on the verified Arabic text\ndistributed by the Tanzil project.",
    "http://corpus.quran.com/",
    "English",
    "2011",
    "GNU General Public License",
    "0.4"
)
MetaData(::Type{TanzilRaw}) = MetaData(
    "Tanzil Quran Text (Uthmani)",
    "Tanzil.net",
    "This copy of quran text is carefully produced, highly\nverified and continuously monitored by a group of specialists\nat Tanzil project.",
    "http://tanzil.net",
    "Arabic",
    "2008-2010",
    "Creative Commons Attribution 3.0",
    "1.0.2"
)

abstract type AbstractQuran end

struct CorpusData <: AbstractQuran
    data::IndexedTable
    meta::MetaData
end

struct TanzilData <: AbstractQuran
    data::IndexedTable
    meta::MetaData
end

struct Quran
    corpus::CorpusData
    tanzil::TanzilData
end

struct Chapter <: AbstractQuran
    data::IndexedTable
    numbers::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    verses::Array{Int64,1}
    istanzil::Bool
end
Chapter(data, number, verses) = Chapter(data, number, verses, false)

struct Verse <: AbstractQuran
    data::IndexedTable
    numbers::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    chapters::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    words::Union{Int64,Array{Int64,1},UnitRange{Int64},Missing}
    istanzil::Bool
end

struct Word <: AbstractQuran
    data::IndexedTable
    numbers::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    chapters::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    verses::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    parts::Union{Int64,Array{Int64,1},UnitRange{Int64}}
end

struct Part <: AbstractQuran
    data::IndexedTable
    numbers::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    chapters::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    verses::Union{Int64,Array{Int64,1},UnitRange{Int64}}
    words::Union{Int64,Array{Int64,1},UnitRange{Int64}}
end