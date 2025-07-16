FROM nextstrain/base:latest

# Install Miniforge (includes conda)
# FIXME: check permissions
RUN curl -L "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh" -o miniforge.sh && \
    bash miniforge.sh -b -p /nextstrain/miniforge && \
    rm miniforge.sh && \
    chmod -R 777 /nextstrain/miniforge

# Make conda available in PATH
ENV PATH="/nextstrain/miniforge/bin:$PATH"
