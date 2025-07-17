FROM nextstrain/base:latest

# Run the final setup as our target user for permissions reasons.
USER nextstrain:nextstrain

# Install Miniforge (includes conda)
RUN curl -L "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh" -o miniforge.sh && \
    bash miniforge.sh -b -p /nextstrain/miniforge && \
    rm miniforge.sh

# Make conda available in PATH
ENV PATH="/nextstrain/miniforge/bin:$PATH"

# Initialize conda for interactive shell use
RUN conda init bash


# Create conda environments

RUN conda create -y --name snippy \
      -c conda-forge -c bioconda \
      sra-tools=3.2.1 \
      snippy=4.6.0 \
 && conda clean -afy

# chmod allows `tb-profiler update_tbdb` to write to
# /nextstrain/miniforge/envs/tb-profiler/share/tbprofiler/
RUN conda create -y --name tb-profiler \
      -c conda-forge -c bioconda \
      sra-tools=3.2.1 \
      tb-profiler=6.6.3-0 \
 && conda clean -afy \
 && chmod -R u+w /nextstrain/miniforge/envs/tb-profiler/share/


# Switch back to root.  The entrypoint will drop to nextstrain:nextstrain as
# necessary when a container starts.
USER root
