ALL.extend([expand('{directory}{sample}{extension}',
                  directory = TRIM_DIR,
                  sample = FILES,
                  extension = '.trimmed.fastq'),])
                    
rule fastp_trim:
    input:
        r1 = INPUT_DIR + '{sample}_1.fastq.gz',
        r2 = INPUT_DIR + '{sample}_2.fastq.gz'
    output:
        r1 = TRIM_DIR + '{sample}_1.trimmed.fastq',
        r2 = TRIM_DIR + '{sample}_2.trimmed.fastq'
    params:
        trimq = config['trim']['trimq'],
        minlen = config['trim']['minlen'],
    conda:
        '../envs/fastp_env.yml'
    threads:
        config['thread_info']['trim']
    shell:
        """
        fastp \
        -i {input.r1} \
        -I {input.r2} \
        -o {output.r1} \
        -O {output.r2} \
        -w {threads} \
        -G \
        -l {params.minlen} \
        -q {params.trimq}
        """
