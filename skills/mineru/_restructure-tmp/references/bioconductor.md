# Bioconductor Reference

Official site: https://www.bioconductor.org/

## Installation

```r
# Install BiocManager
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

# Install Bioconductor (specify version)
BiocManager::install(version = "3.22")

# Install packages
BiocManager::install("GenomicRanges")
BiocManager::install(c("DESeq2", "edgeR", "limma"))
```

## Package Management

```r
# List available packages
BiocManager::available()
BiocManager::available("^org")  # Annotation packages

# Check for updates
BiocManager::install()  # Updates all

# Validate installation
BiocManager::valid()

# Version info
BiocManager::version()
```

## Core Data Structures

### GenomicRanges
```r
library(GenomicRanges)

# Create GRanges
gr <- GRanges(
  seqnames = c("chr1", "chr1", "chr2"),
  ranges = IRanges(start = c(100, 200, 150), width = 50),
  strand = c("+", "-", "+"),
  score = c(1.5, 2.0, 3.0)
)

# Operations
start(gr)
end(gr)
width(gr)
strand(gr)
mcols(gr)  # Metadata columns

# Overlap operations
findOverlaps(gr1, gr2)
subsetByOverlaps(gr1, gr2)
```

### SummarizedExperiment
```r
library(SummarizedExperiment)

# Create
se <- SummarizedExperiment(
  assays = list(counts = count_matrix),
  colData = sample_info,
  rowData = gene_info
)

# Access
assay(se, "counts")
colData(se)
rowData(se)
```

### Biostrings
```r
library(Biostrings)

# DNA sequences
dna <- DNAStringSet(c("ATCG", "GCTA"))
reverseComplement(dna)
translate(dna)

# Pattern matching
matchPattern("ATG", dna[[1]])
vmatchPattern("ATG", dna)
```

## Common Workflows

### RNA-seq (DESeq2)
```r
library(DESeq2)

# Create DESeq object
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = sample_info,
  design = ~ condition
)

# Run analysis
dds <- DESeq(dds)
res <- results(dds, contrast = c("condition", "treated", "control"))

# Filter significant
sig <- res[which(res$padj < 0.05), ]
```

### Annotation
```r
# Organism annotation
library(org.Hs.eg.db)

# Map gene IDs
mapIds(org.Hs.eg.db,
       keys = gene_ids,
       column = "SYMBOL",
       keytype = "ENSEMBL")

# Gene ontology
library(GO.db)
select(GO.db, keys = "GO:0008150", columns = c("TERM", "DEFINITION"))
```

### Visualization
```r
library(ComplexHeatmap)

# Heatmap
Heatmap(matrix,
        name = "Expression",
        row_split = clusters,
        column_split = conditions)

# Volcano plot (EnhancedVolcano)
library(EnhancedVolcano)
EnhancedVolcano(res,
                lab = rownames(res),
                x = 'log2FoldChange',
                y = 'pvalue')
```

## Key Packages by Domain

| Domain | Packages |
|--------|----------|
| RNA-seq | DESeq2, edgeR, limma |
| Single-cell | Seurat, SingleCellExperiment, scater |
| ChIP-seq | ChIPseeker, DiffBind |
| Methylation | minfi, methylKit |
| Variant calling | VariantAnnotation |
| Pathway analysis | clusterProfiler, fgsea |
| Visualization | ComplexHeatmap, EnhancedVolcano |
| Annotation | AnnotationHub, biomaRt |

## Getting Help

```r
# Package vignettes
browseVignettes("DESeq2")

# Function help
?DESeq

# Bioconductor support
# https://support.bioconductor.org/
```
