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

**Steps performed:**
| Step                                         | Software/Tool                  |
|----------------------------------------------|--------------------------------|
| Initial read QC                              | `FastQC`                       |
| Filter, trim reads                           | `TrimGalore!`                  |
| Align reads                                  | `STAR`                         |
| Abundance quantification                     | `featureCounts` from `Subread` |
| _Pair-wise_ differential expression analysis | `DESeq2`                       |   

The `Snakemake` workflow structure
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

A brief description of the files within the workflow

| File Name         | Description                                                                                                                                                                                                                                                                                                  |
|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Snakefile`       | Main file of the workflow. Import modules, creates variables, describes commands in the form of `rules`.                                                                                                                                                                                                     |
| `*_env.yml` files | `.yaml` file that describes all software to be used by `conda`/`mamba` to create a computational environment, including the versions and all of the dependencies.                                                                                                                                            |
| `config.yaml`     | Configuration `.yaml` file holding values that we want to pass to the pipeline for anything we might want to change between runs of the pipeline, such as input file directories, parameter values, choices in trimming tools, etc.                                                                          |
| `metadata.txt`    | Tab-separated file containing `sample_id` and `expt` columns to be filled with the sample ids/names and their experimental group, respectively. The column names should remain unchanged. This file is used by `DESeq2` to perform a pair-wise differential expression analysis (single factor, two levels). |
| `DESeq2.R`        | R script that performs the differntial expression analysis.                                                                                                                                                                                                                                                  |

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

