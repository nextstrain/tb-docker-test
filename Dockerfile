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
COPY --chown=nextstrain:nextstrain envs/snippy.yaml /tmp/
RUN conda env create --name snippy --file /tmp/snippy.yaml && rm /tmp/snippy.yaml

COPY --chown=nextstrain:nextstrain envs/tb-profiler.yaml /tmp/
RUN conda env create --name tb-profiler --file /tmp/tb-profiler.yaml && rm /tmp/tb-profiler.yaml

# Switch back to root.  The entrypoint will drop to nextstrain:nextstrain as
# necessary when a container starts.
USER root
