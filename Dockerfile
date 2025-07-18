FROM nextstrain/base:latest

# Install micromamba
RUN curl -L "https://github.com/mamba-org/micromamba-releases/releases/latest/download/micromamba-linux-64" -o /usr/local/bin/micromamba \
 && chmod +x /usr/local/bin/micromamba

# Run the final setup as our target user for permissions reasons.
USER nextstrain:nextstrain


# Create conda environments
# Add global write bits, similar to what's done for /nextstrain¹, but
# recursively on the conda environment directory. This allows `tb-profiler
# update_tbdb` to write to the directory at run time under a different UID.
# ¹ <https://github.com/nextstrain/docker-base/blob/9270fb321251b298b332b648f2744308bb2d89ff/Dockerfile#L430-L431>

RUN micromamba create -y --name snippy \
      -c conda-forge -c bioconda \
      sra-tools=3.2.1 \
      snippy=4.6.0 \
 && micromamba clean -afy \
 && rm -rf ~/.cache \
 && chmod -R a+rwXt ~/.mamba/envs/snippy

RUN micromamba create -y --name tb-profiler \
      -c conda-forge -c bioconda \
      sra-tools=3.2.1 \
      tb-profiler=6.6.3-0 \
 && micromamba clean -afy \
 && rm -rf ~/.cache \
 && chmod -R a+rwXt ~/.mamba/envs/tb-profiler

# Switch back to root.  The entrypoint will drop to nextstrain:nextstrain as
# necessary when a container starts.
USER root
