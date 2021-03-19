ALL.extend([expand('{directory}{sample}{extension}',
                  directory = TRIM_QC_DIR,
                  sample = SAMPLE_NAMES,
                  extension = '.trimmed_fastqc.zip')])

rule fastqc_trim:
    input:
        fastq = TRIM_DIR + '{sample}.trimmed.fastq',
    output:
        fastq = TRIM_QC_DIR + '{sample}.trimmed_fastqc.zip',
    params:
        qc_dir = TRIM_QC_DIR,
        format = 'fastq',
    conda:
        '../envs/fastqc_env.yml'
    threads:
        config['thread_info']['fastqc']
    shell:
        """
        mkdir -p {params.qc_dir}
        fastqc \
        --noextract \
        -f {params.format} \
        -o {params.qc_dir} \
        -t {threads} \
        {input}
        """
