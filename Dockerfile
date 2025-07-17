FROM nextstrain/base:latest

# Install Miniforge (includes conda)
RUN curl -L "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh" -o miniforge.sh && \
    bash miniforge.sh -b -p /nextstrain/miniforge && \
    rm miniforge.sh

# Make conda available in PATH
ENV PATH="/nextstrain/miniforge/bin:$PATH"

# Initialize conda for interactive shell use
RUN conda init bash

# Create conda environments
COPY envs/csvtk.yaml /tmp/
RUN conda env create --name csvtk --file /tmp/csvtk.yaml && rm /tmp/csvtk.yaml

COPY envs/nextstrain.yaml /tmp/
RUN conda env create --name nextstrain --file /tmp/nextstrain.yaml && rm /tmp/nextstrain.yaml

COPY envs/snippy.yaml /tmp/
RUN conda env create --name snippy --file /tmp/snippy.yaml && rm /tmp/snippy.yaml

COPY envs/tb-profiler.yaml /tmp/
RUN conda env create --name tb-profiler --file /tmp/tb-profiler.yaml && rm /tmp/tb-profiler.yaml

COPY envs/tsv-utils.yaml /tmp/
RUN conda env create --name tsv-utils --file /tmp/tsv-utils.yaml && rm /tmp/tsv-utils.yaml

# FIXME: check permissions
RUN chmod -R 777 /nextstrain/miniforge
