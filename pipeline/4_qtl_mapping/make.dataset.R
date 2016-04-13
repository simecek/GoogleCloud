sample.file <- "/home/docker/sample_list.csv"
emase.dir <- "/data_in/emase"
gbrs.dir <- "/data_in/gbrs"
output.dir <- "/data_out"
suffix <- ".emase.genes.effective_read_counts"
grid.file <- "/data_in/marker_grid_64K.txt"
ensembl.file <-"/data_in/mouse_genes.txt"

pheno <- read.csv(sample.file, as.is=TRUE, header=FALSE, colClasses = c("character"))
names(pheno)[1:3] <- c("mouse", "sex", "generation")
rownames(pheno) <- pheno$mouse
Nsamples <- nrow(pheno)

# snps
snps <- read.csv(grid.file, sep="\t", as.is=TRUE)
snps$pos <- snps$bp
snps$bp <- snps$bp/10^6
rownames(snps) <- snps$marker

# annotation
file.name <- paste0(emase.dir, "/", pheno$mouse[1], suffix)
gene.id <- read.csv(file.name, as.is=TRUE, sep="\t")$locus
Ngenes <- length(gene.id)

genes <- read.csv(ensembl.file, sep="\t", as.is=TRUE)
stopifnot(all(gene.id %in% genes$ensembl_id))
genes <- genes[match(gene.id, genes$ensembl_id),]

annot.mrna <- data.frame(id = genes$ensembl_id,
                         symbol = genes$symbol,
                         chr = genes$region,
                         start = genes$start,
                         end = genes$end,
                         strand = genes$strand,
                         middle_point = NA,
                         nearest_snp =NA,
                         biotype = genes$biotype,
                         stringsAsFactors = FALSE)
annot.mrna$middle_point <- round((annot.mrna$start + annot.mrna$end)/2)

library(foreach)

idx <- foreach(i=1:nrow(annot.mrna), .combine='c') %do% {
  dist.to <- abs(snps$pos - annot.mrna$middle_point[i])
  min.dist <- min(dist.to[snps$chr == annot.mrna$chr[i]])
  which(snps$chr == annot.mrna$chr[i] & dist.to==min.dist)[1]
}
annot.mrna$nearest_snp <- idx


# expression
raw.mrna <- matrix(0, Nsamples, Ngenes)
colnames(raw.mrna) <- gene.id
rownames(raw.mrna) <- pheno$mouse

for (i in 1:Nsamples) {
#  print(i)
  file.name <- paste0(emase.dir, "/", pheno$mouse[i], suffix)
  tmp <- read.csv(file.name, as.is=TRUE, sep="\t")
  stopifnot(tmp$locus == gene.id)
  raw.mrna[i,] <- tmp$total
}

# probs
file.name <- paste0(gbrs.dir, "/", pheno$mouse[1], ".gbrs.csv")
tmp <- read.csv(file.name, as.is=TRUE, header=FALSE)
Nmarkers <- nrow(tmp)
stopifnot(Nmarkers == nrow(snps))

probs <- array(0.0, dim=c(Nsamples, 8, Nmarkers))

for (i in 1:Nsamples) {
#  print(i)
  file.name <-  paste0(gbrs.dir, "/", pheno$mouse[i], ".gbrs.csv")
  tmp <- read.csv(file.name, as.is=TRUE, header=FALSE)
  probs[i,,] <- t(tmp)
}

dimnames(probs)[[1]] <- pheno$mouse
dimnames(probs)[[2]] <- LETTERS[1:8]
dimnames(probs)[[3]] <- snps$marker

# filtering, normalization and rankZ-transform
zeroes <- apply(raw.mrna == 0, 2, sum)
filter.keep <- which(zeroes <= Nsamples/2)
annot.mrna  <- annot.mrna[filter.keep,]
raw.mrna   <- raw.mrna[,filter.keep]
stopifnot(nrow(annot.mrna) == ncol(raw.mrna))
quantile75 <- apply(raw.mrna, 1, quantile, probs=0.75)
expr.mrna <- raw.mrna / quantile75

# rankZ transform
rankZ <- function(x) {
  y <- rank(x)
  y[is.na(x)] <- NA
  qnorm(y / (sum(!is.na(x))+1))
}

# rankZ each gene
for (i in 1:ncol(expr.mrna)) expr.mrna[,i] <- rankZ(expr.mrna[,i])

# some file specific things
save(annot.mrna, expr.mrna, pheno, probs, raw.mrna, snps,
     file = paste(output.dir, "dataset_before_additional_data.RData", sep="/"))

# DO kidney specific
names(pheno) <- c("Mouse.ID", "Sex", "Generation", "Age")
pheno$Sample.Number <- as.numeric(sub("DO-", "", pheno$Mouse.ID))
pheno$Generation
covar.mrna <- covar.protein <- model.matrix(~Sex*Age+Generation, data=pheno)

# load all additional files
additional.files <- dir("/data_in/additional_data/", full.names=TRUE)
for (f in additional.files) load(f)

# save final version
save(annot.mrna, expr.mrna, pheno, probs, raw.mrna, snps,
     file = paste(output.dir, "dataset.RData", sep="/"))

