FROM nextstrain/base:latest

RUN echo MACHINE: $(uname -m)

# Install Miniforge (includes conda)
RUN curl -L "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh" -o miniforge.sh && \
    bash miniforge.sh -b -p /nextstrain/miniforge && \
    rm miniforge.sh

# Make conda available in PATH
ENV PATH="/nextstrain/miniforge/bin:$PATH"

# Initialize conda for interactive shell use
RUN conda init bash

# Install snippy into a conda environment
RUN conda create -y --name snippy  -c conda-forge -c bioconda sra-tools=3.2.1 snippy=4.6.0 awscli && conda clean -afy

# Install tb-profiler into a conda environment
RUN conda create -y --name tb-profiler -c conda-forge -c bioconda sra-tools=3.2.1 tb-profiler=6.6.3-0 awscli && conda clean -afy

# FIXME: check permissions
RUN chmod -R 777 /nextstrain/miniforge
