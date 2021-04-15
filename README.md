# Basic Bulk RNA-seq Pipeline in Snakemake

<a name="toc"></a>
## Table of Contents
[Description](#Description)  
[Installation](#Installation)  
[Usage](#Usage)

## Description
This repository contains a demonstration of a basic bulk RNA-seq pipeline in two forms, `Snakemake` (in the `workflow/` directory) and as a `bash` script (in the `bash_workflow/` directory). 

The two workflows perform the same analysis, but the `Snakemake` pipeline is much more robust and recommended, though not perfect just yet. This `Snakemake` pipeline was created as part of a tutorial, and thus refrains from employing some of the full/more complex utilities of `Snakemake`. Still, it is a maked improvement over the `bash` workflow.

A couple of advantages of the `Snakemake` version.  
- Stops at an error, removes incomplete files automatically
- Can rerun/restart a pipeline after an error and only runs steps that were not completely finished
- Can run to a certain point within the pipeline without editing the pipeline
- Can add new samples and rerun the pipeline so that it only runs the steps necessary for processing of the new samples and integration of those new data with other sample data, if necessary
- Can generalize the analysis
- Do not have to pre-install all software
- Can have temporary files removed automatically
- With the use of a `config.yaml` file, need only to edit a single file to run a new analysis
- And more...

**Steps performed**
| Step                                         | Software/Tool                  |
|----------------------------------------------|--------------------------------|
| Initial read QC                              | `FastQC`                       |
| Filter, trim reads                           | `TrimGalore!`                  |
| Align reads                                  | `STAR`                         |
| Abundance quantification                     | `featureCounts` from `Subread` |
| _Pair-wise_ differential expression analysis | `DESeq2`                       |   

**The `Snakemake` workflow structure**
```
$ tree workflow
workflow
├── Snakefile
├── envs
│   ├── fastqc_env.yml
│   ├── star_env.yml
│   ├── subread_env.yml
│   └── trim_galore_env.yml
├── resources
│   ├── config.yaml
│   └── metadata.txt
└── scripts
    └── DESeq2.R
```

**A brief description of the files within the workflow**

| File Name         | Description                                                                                                                                                                                                                                                                                                  |
|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Snakefile`       | Main file of the workflow. Import modules, creates variables, describes commands in the form of `rules`.                                                                                                                                                                                                     |
| `*_env.yml` files | `.yaml` file that describes all software to be used by `conda`/`mamba` to create a computational environment, including the versions and all of the dependencies.                                                                                                                                            |
| `config.yaml`     | Configuration `.yaml` file holding values that we want to pass to the pipeline for anything we might want to change between runs of the pipeline, such as input file directories, parameter values, choices in trimming tools, etc.                                                                          |
| `metadata.txt`    | Tab-separated file containing `sample_id` and `expt` columns to be filled with the sample ids/names and their experimental group, respectively. The column names should remain unchanged. This file is used by `DESeq2` to perform a pair-wise differential expression analysis (single factor, two levels). |
| `DESeq2.R`        | R script that performs the differntial expression analysis.                                                                                                                                                                                                                                                  |  


**`config.yaml`** File Field Descriptions and Example

|Field|Description|Format|
|-----|-----------|------|
|`out_dir:`|Directory to output all results. Does not need to exist yet.|Full path to directory|
|(input_dir) `fastq:`|Directory containing input reads|Full path to directory|
|(input_dir) `genome_fasta:`|Directory containing `STAR` index files|Full path to directory|
|(input_dir) `genome_gtf:`|GTF file used to build the `STAR` index|Full path to file|
|(thread_info) `fastqc:`| Number of threads to use for each `FastQC` job |Integer |
|(thread_info) `align:` |Number of threads to use for each `STAR` job|Integer|
|(thread_info) `counts:` |Number of threads to use for each `featureCounts` job|Integer |
|(trim_info) `length:`|Shortest length a read can be after trimming, will toss read otherwise | Integer|
|(trim_info) `quality:`|Trim bases where quality is below this value | Integer|
|(count_info) `strand:`|Strandedness of library preparation (0=unstranded, 1=forward, 2=reverse)| Integer|
|(diffex_info) `prefix:`|String to use as a prefix for output in differential expression analysis file |Quoted string |
| (diffex_info) `metadata:`|File containing samples and group assignment for differential expression analysis |Full path to tab-separated `.txt` file|

Example `config.yaml`

    out_dir:
        '/Users/csifuentes/Documents/outDataSnakemakeOfficeHours'
    input_dir:
        fastq: '/Users/csifuentes/Documents/testData/simulated_reads/fastq'
        genome_fasta: '/Users/csifuentes/Documents/testData/index/'
        genome_gtf: '/Users/csifuentes/Documents/testData/index/Homo_sapiens.GRCh38.103.gtf'
    thread_info:
        fastqc: 4
        align: 4
        counts: 4
    trim_info:
        length: 20
        quality: 30
    count_info:
        strand: 0
    diffex_info:
        prefix: 'WT_vs_KO'
        metadata: '/Users/csifuentes/Documents/repo/snakemake-demo-rnaseq/workflow/resources/metadata.txt'



**Key Assumptions**
- Files end in `.fastq`, and are unzipped.
- Paired-end reads, with `_1.fastq` and `_2.fastq` as the suffix.
- Only 2 groups to compare (WT vs KO, or T0 vs T24, etc.)


[Table of Contents](#toc)

## Installation:
1. Install miniconda using the appropriate directions from here:
https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html

2. After closing and re-opening the terminal, the `conda` base environment should be enabled. To check this, make sure you see `(base)` to the left of your user name in the terminal prompt.
 ```
 (base) user: $
 ```
3. Install `mamba` using conda in your base environment.   
```
conda install -n base conda-forge mamba
```
4. Install `Snakemake` using `conda`/`mamba`. I install it into it's own environment, named `snakemake_env` here.   
```
conda activate base
mamba create -c conda-forge -c bioconda -n snakemake_env snakemake
```
5. Go to https://github.com/cjsifuen/Basic-Bulk-RNA-seq-Workflow. Click the green `Code` button on the top-right side of the page, and select `Download ZIP`, shown in the purple box below.  

![alt text](https://github.com/cjsifuen/Basic-Bulk-RNA-seq-Workflow/blob/main/DownloadZip.png?raw=true)

6. Move the downloaded file `Basic-Bulk-RNA-seq-Workflow-main.zip` to where you want to work, and unzip (right-click and extract or unzip, or double-clicking usually works).

7. If you have not installed R, install it from here: https://rstudio-education.github.io/hopr/starting.html#how-to-download-and-install-r. You can check for an R installation by opening the terminal and typing `R --version`, followed by the enter key. If R is installed the version number and other information will be shown.  

```
$ R --version
R version 4.0.3 (2020-10-10) -- "Bunny-Wunnies Freak Out"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-apple-darwin17.0 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
https://www.gnu.org/licenses/.
```

8. Install `DESeq2` in R in your `snakemake_env` by first activating the `snakemake_env`. Then follow the installation instructions here: https://bioconductor.org/packages/release/bioc/html/DESeq2.html.

```
# activate the environment
conda activate snakemake_env
``` 

```
# open R
R
```

```
# install DESeq2
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("DESeq2")
```
9. Exit `R`  by typing `q()`, followed by enter. Select `n` for no. Everything should be ready.

[Table of Contents](#toc)

## Usage:

1. Edit the `config.yaml` file, described above in [description](#Description). Note the key assumptions being made about these data/files.
2. Edit the `metadata.txt` file.
3. Open the terminal and activate the `snakemake_env`
```
conda activate snakemake_env
```
4. Change into the directory containing the unzipped repository. If I downloaded the repository to my `Downloads` directory and unzipped it there, I would type
```
cd /Users/csifuentes/Downloads/Basic-Bulk-RNA-seq-Workflow-main
```
5. Test the pipeline to make sure everything looks okay.  

```
snakemake -n
```
Should produce the following (as well as a larger block of text). This shows the number of jobs that will be run for each rule. So, for 6 samples, we have 12 `fastq` files (since they are paried). Thus, I should see 12 `fastqc` jobs that need to be performed. I should also see 6 `star` jobs for alignment. I see these below. Everything looks good so I can continue to run the analyis.
```
Job counts:
	count	jobs
	1	all
	1	clean_counts
	1	deseq2
	12	fastqc
	1	featureCounts
	6	star
	6	trim_galore
	28
This was a dry-run (flag -n). The order of jobs does not reflect the order of execution.
```
Check that the number of `fastqc` run

6. Run the pipeline. Some useful parameters are shown below.

| Flag / option             | Purpose                                                                 | Required? |
|---------------------------|-------------------------------------------------------------------------|-----------|
| `snakemake`               | Calls snakemake                                                         | Yes       |
| `--use-conda`             | Install the necessary software in temporary environments, using `conda` | Yes       |
| `--conda-frontend mamba`  | Use `mamba` to install the software, which will be faster               | No        |
| `--cores 8`               | Use up to 8 threads                                                     | No        |
| `-p`                      | Print the actual command to the screen                                  | No        |
| `-p 2>&1 \| tee log.file` | Test                                                                    | No        |
| `--until star`            | Stop the pipeline after the `star` jobs are all complete                | No        |





```
snakemake --use-conda --conda-frontend mamba --cores 8 -p 2>&1 | tee log.file
```

[Table of Contents](#toc)
