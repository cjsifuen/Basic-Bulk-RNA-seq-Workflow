#! /bin/bash

#set variables and values
IN_DIR='/Users/csifuentes/Documents/testData/simulated_reads/fastq'
GENOME_FASTA='/Users/csifuentes/Documents/testData/index/'
GENOME_GTF='/Users/csifuentes/Documents/testData/index/Homo_sapiens.GRCh38.103.gtf'
OUT_DIR='/Users/csifuentes/Documents/outDataOfficeHours/'
QC_DIR='/Users/csifuentes/Documents/outDataOfficeHours/QC'
TRIM_DIR='/Users/csifuentes/Documents/outDataOfficeHours/TRIMMED'
TRIM_LENGTH='20'
TRIM_QUALITY='30'
ALN_DIR='/Users/csifuentes/Documents/outDataOfficeHours/ALIGN/'
STRAND='0'
COUNTS_DIR='/Users/csifuentes/Documents/outDataOfficeHours/COUNTS/'
ANNOT_TMP='/Users/csifuentes/Documents/outDataOfficeHours/COUNTS/counts.tmp'
ANNOT_OUT='/Users/csifuentes/Documents/outDataOfficeHours/COUNTS/counts.txt'
COUNTS_FIXED='/Users/csifuentes/Documents/outDataOfficeHours/COUNTS/counts_fixed.txt'
SCRIPT='/Users/csifuentes/Documents/repo/snakemake-demo-rnaseq/bash_workflow/DESeq2.R'
METADATA='/Users/csifuentes/Documents/repo/snakemake-demo-rnaseq/bash_workflow/metadata.txt'
OUTPREFIX='WT_vs_KO'
DIFFEX_DIR='/Users/csifuentes/Documents/outDataOfficeHours/DIFFEX/'

# ###
# #fastqc
# ###

# #activate conda env
# conda init bash
# source ~/.bash_profile
# conda activate fastqc_env

# #make output directory
# mkdir -p ${QC_DIR}

# #fastqc on each file
# for i in ${IN_DIR}/*.fastq;
# do BASE=$(basename ${i} '.fastq');
#     echo ${BASE};
#     fastqc \
#     -o ${QC_DIR} \
#     --noextract \
#     -f fastq \
#     -t 4 \
#     ${i};
# done

# #deactivate environment
# conda deactivate


# ###
# #trimgalore!
# ###

# #activate conda env
# source ~/.bash_profile
# conda activate trim_galore_env

# #trimgalore! on each file
# for i in ${IN_DIR}/*_1.fastq;
# do BASE=$(basename ${i} '_1.fastq');
#     echo ${BASE};
#     trim_galore \
#     -q ${TRIM_QUALITY} \
#     --length ${TRIM_LENGTH} \
#     --basename ${BASE} \
#     -o ${TRIM_DIR} \
#     --paired ${IN_DIR}/${BASE}_1.fastq ${IN_DIR}/${BASE}_2.fastq;
# done

# # deactivate environment
# conda deactivate

###
#star
###

#activate conda env
source ~/.bash_profile
conda activate star_env

#star alignment on each file
for i in ${TRIM_DIR}/*_val_1.fq;
do BASE=$(basename ${i} '_val_1.fq');
    echo ${BASE};
    STAR \
    --genomeDir ${GENOME_FASTA} \
    --readFilesIn ${TRIM_DIR}/${BASE}_val_1.fq ${TRIM_DIR}/${BASE}_val_2.fq \
    --sjdbGTFfile ${GENOME_GTF} \
    --outFileNamePrefix ${ALN_DIR}${BASE} \
    --runThreadN 4 \
    --outSAMattributes Standard \
    --outSAMtype BAM SortedByCoordinate \
    --outFilterMismatchNmax 999 \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --outFilterMismatchNoverReadLmax 0.04 \
    --alignIntronMin 20 \
    --alignIntronMax 1000000 \
    --alignMatesGapMax 1000000 \
    --sjdbScore 1;
done

# deactivate env
conda deactivate

###
#featureCounts
###

#activate env
source ~/.bash_profile
conda activate subread_env

#make output directory
mkdir -p ${COUNTS_DIR}

#featureCounts on all files together
featureCounts \
    -O \
    -p \
    -B \
    -C \
    -T 4 \
    -s ${STRAND} \
    -a ${GENOME_GTF} \
    -o ${ANNOT_TMP} \
    ${ALN_DIR}*Aligned.sortedByCoord.out.bam

#clean file
sed '/^#/d' ${ANNOT_TMP} | cut -f 1,7- > ${ANNOT_OUT}

#clean sample names
printf '%sGeneid' > ${COUNTS_FIXED}

for i in ${ALN_DIR}*Aligned.sorted*;
    do B=$(basename $i Aligned.sortedByCoord.out.bam);
    printf '\t%s' ${B} >> ${COUNTS_FIXED};
done

echo >> ${COUNTS_FIXED}

#printf '%s\n' >> ${COUNTS_FIXED}
tail -n+2 ${ANNOT_OUT} >> ${COUNTS_FIXED}


# ###
# #DESeq2
# ###

# # make directory
# mkdir -p ${DIFFEX_DIR}

# # run deseq2 script
# Rscript ${SCRIPT} ${METADATA} ${COUNTS_FIXED} ${DIFFEX_DIR}${OUTPREFIX}
