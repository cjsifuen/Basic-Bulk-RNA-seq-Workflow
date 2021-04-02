#!/bin/env Rscript
args = commandArgs(trailingOnly=T)
if(length(args)<3){
    stop("Usage: Rscript DESeq2.R metadata_file featureCount_output output_prefix", call.=FALSE)
}
library('DESeq2')
metadata = read.table(args[1],header=T,sep="\t",row.names=1)
data = read.table(args[2],header=T,sep="\t",row.names=1)
rownames(metadata) = colnames(data)
outprefix = args[3]
dds = DESeqDataSetFromMatrix(countData=data, colData=metadata, design=~expt)
dds$expt = relevel(dds$expt,ref="WT")
dds = DESeq(dds)
norm = counts(dds, normalized=T)
file = paste0(outprefix,"_normCounts.txt")
write.table(norm,file,sep="\t",quote=F,row.names=T,col.names=T)
vsd = varianceStabilizingTransformation(dds)
vstcounts = assay(vsd)
file = paste0(outprefix,"_vstCounts.txt")
write.table(vstcounts,file,sep="\t",quote=F,row.names=T,col.names=T)
res = results(dds)
file = paste0(outprefix,"_results.txt")
write.table(res,file,sep="\t",quote=F,row.names=T,col.names=T)
sig = res[! is.na(res$padj) & res$padj < 0.05,]
file = paste0(outprefix,"_sigdiff.txt")
write.table(sig,file,sep="\t",quote=F,row.names=T,col.names=T)