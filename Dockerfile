FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="6a5529025e18ea67988a485a2dde612ec3cf7c88374ac28ff63e869ef0f78826"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: workflow/envs/fastqc_env.yml
#   prefix: /conda-envs/f1904fb35c13402fde0c7862dcafb376
#   channels:
#     - bioconda
#     - defaults
#   dependencies:
#     - fastqc=0.11.9
#     - font-ttf-dejavu-sans-mono=2.37
#     - fontconfig=2.13.1
#     - freetype=2.10.4
#     - icu=58.2
#     - libcxx=10.0.0
#     - libiconv=1.16
#     - libpng=1.6.37
#     - libxml2=2.9.10
#     - openjdk=11.0.6
#     - perl=5.26.2
#     - xz=5.2.5
#     - zlib=1.2.11
RUN mkdir -p /conda-envs/f1904fb35c13402fde0c7862dcafb376
COPY workflow/envs/fastqc_env.yml /conda-envs/f1904fb35c13402fde0c7862dcafb376/environment.yaml

# Conda environment:
#   source: workflow/envs/star_env.yml
#   prefix: /conda-envs/756433216cfa292c6e45782097ec062f
#   channels:
#     - bioconda
#     - defaults
#   dependencies:
#     - star=2.7.8a
RUN mkdir -p /conda-envs/756433216cfa292c6e45782097ec062f
COPY workflow/envs/star_env.yml /conda-envs/756433216cfa292c6e45782097ec062f/environment.yaml

# Conda environment:
#   source: workflow/envs/subread_env.yml
#   prefix: /conda-envs/f9727df069b4e746d0a718d867b6e580
#   channels:
#     - bioconda
#     - defaults
#   dependencies:
#     - subread=2.0.1
#     - zlib=1.2.11
RUN mkdir -p /conda-envs/f9727df069b4e746d0a718d867b6e580
COPY workflow/envs/subread_env.yml /conda-envs/f9727df069b4e746d0a718d867b6e580/environment.yaml

# Conda environment:
#   source: workflow/envs/trim_galore_env.yml
#   prefix: /conda-envs/92f36c147b49714bfb42a1a6c8ea3c66
#   channels:
#     - bioconda
#     - defaults
#   dependencies:
#     - bz2file=0.98
#     - ca-certificates=2021.1.19
#     - certifi=2020.12.5
#     - cutadapt=1.18
#     - fastqc=0.11.9
#     - font-ttf-dejavu-sans-mono=2.37
#     - fontconfig=2.13.1
#     - freetype=2.10.4
#     - icu=58.2
#     - libcxx=10.0.0
#     - libffi=3.3
#     - libiconv=1.16
#     - libpng=1.6.37
#     - libxml2=2.9.10
#     - ncurses=6.2
#     - openjdk=11.0.6
#     - openssl=1.1.1k
#     - perl=5.26.2
#     - pigz=2.4
#     - pip=21.0.1
#     - python=3.7.10
#     - readline=8.1
#     - setuptools=52.0.0
#     - sqlite=3.35.3
#     - tk=8.6.10
#     - trim-galore=0.6.6
#     - wheel=0.36.2
#     - xopen=0.7.3
#     - xz=5.2.5
#     - zlib=1.2.11
RUN mkdir -p /conda-envs/92f36c147b49714bfb42a1a6c8ea3c66
COPY workflow/envs/trim_galore_env.yml /conda-envs/92f36c147b49714bfb42a1a6c8ea3c66/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/f1904fb35c13402fde0c7862dcafb376 --file /conda-envs/f1904fb35c13402fde0c7862dcafb376/environment.yaml && \
    mamba env create --prefix /conda-envs/756433216cfa292c6e45782097ec062f --file /conda-envs/756433216cfa292c6e45782097ec062f/environment.yaml && \
    mamba env create --prefix /conda-envs/f9727df069b4e746d0a718d867b6e580 --file /conda-envs/f9727df069b4e746d0a718d867b6e580/environment.yaml && \
    mamba env create --prefix /conda-envs/92f36c147b49714bfb42a1a6c8ea3c66 --file /conda-envs/92f36c147b49714bfb42a1a6c8ea3c66/environment.yaml && \
    mamba clean --all -y
