FROM nextstrain/base:latest

RUN apt-get update

# Install binary deps that are packaged by Debian
RUN apt-get install --assume-yes --no-install-recommends \
    bcftools \
    # TODO file a bug about this not being a documented dep of
    # tb-profiler
    bedtools \
    # needed to build vt
    build-essential \
    bwa \
    # TODO file a bug about this not being a documented dep of
    # tb-profiler
    delly \
    freebayes \
    libbio-perl-perl \
    # next four needed to build vt
    libbz2-dev \
    libcurlpp-dev \
    liblzma-dev \
    libssl-dev \
    # TODO figure out a better source for this because it depends on
    # the entire damn universe
    libvcflib-tools \
    minimap2 \
    openjdk-17-jre-headless \
    parallel \
    samclip \
    samtools \
    snpeff \
    snp-sites \
    seqtk \
    sra-toolkit \
    trimmomatic \
    # needed to build vt
    zlib1g-dev

# Update `pip` and install Python dependencies
RUN pip install --upgrade pip
RUN pip install \
    docxtpl \
    filelock \
    pydantic \
    pysam \
    rich_argparse \
    tomli \
    tqdm

# Check out packages we want to build from source
RUN git clone https://github.com/atks/vt.git                      /opt/vt/
RUN git clone https://github.com/jodyphelan/itol-config           /opt/itol-config
RUN git clone https://github.com/jodyphelan/pathogen-profiler.git /opt/pathogen-profiler
RUN git clone https://github.com/jodyphelan/TBProfiler.git        /opt/TBProfiler
RUN git clone https://github.com/tseemann/snippy.git              /opt/snippy

# build vt
RUN cd /opt/vt && \
    git submodule update --init --recursive && \
    make -j10 && \
    cp vt /usr/bin/

# apply monkey patch to pathogen-profiler
COPY pathogen-profiler.patch /tmp/pathogen-profiler.patch
RUN pushd /opt/pathogen-profiler && \
    git apply /tmp/pathogen-profiler.patch && \
    rm /tmp/pathogen-profiler.patch && \
    popd

# don't let snippy use the embedded linux binaries by mistake
RUN chmod -x /opt/snippy/binaries/linux/*

# Build/install those things
RUN pushd /opt/itol-config       && pip install . && popd
RUN pushd /opt/pathogen-profiler && pip install . && popd
RUN pushd /opt/TBProfiler        && pip install . && popd

# Set up tb-profiler run area and the one file it won't bootstrap
RUN mkdir -p /usr/local/share/tbprofiler/snpeff && \
    touch /usr/local/share/tbprofiler/snpeff/snpEff.config && \
    chmod -R 777 /usr/local/share/tbprofiler

# inject the trimmomatic wrapper script that tb-profiler seems to be
# expecting, and symlink the JAR file to where that wrapper expects it
# to be…
COPY trimmomatic /usr/bin/trimmomatic
RUN chmod +x /usr/bin/trimmomatic && \
    ln -s /usr/share/java/trimmomatic.jar /usr/bin/

# Uncomment this if you need a persistent entrypoint so you can shell into the container
# CMD tail -f /dev/null
# USER root
