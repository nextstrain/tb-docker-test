# Stage 1: Create conda environment
FROM mambaorg/micromamba:2.0.8 AS conda-builder

COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
RUN micromamba create -y -n env -f /tmp/env.yaml && \
    micromamba clean --all --yes

# Stage 2: Build final image extending nextstrain/base
FROM nextstrain/base:latest

# Copy the conda environment from the previous stage
COPY --from=conda-builder /opt/conda/envs/env /opt/conda/envs/env

# Add environment bin to PATH
# Notes:
# 1. This makes the conda-installed tools available but isn't equivalent to
#    activating the environment since micromamba itself is not part of the final
#    image.
# 2. nextstrain/base puts programs in /usr/local/bin, and those should take
#    precedence.
ENV PATH="/usr/local/bin:/opt/conda/envs/env/bin:$PATH"
