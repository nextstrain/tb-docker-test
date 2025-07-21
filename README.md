# genehack-tb-runtime

## Goal

Create a Docker-based image, based on [docker-base][], that includes
all the tools necessary to run [this TB `ingest/Snakefile`][].

### Required binaries

- `curl` (included in base Nextstrain image)
- `augur` (included in base Nextstrain image)
- `aws` (included in base Nextstrain image)
- `fasterq-dump` (part of [`sra-tools`][])
- [`tb-profiler`][]
- [`snippy`][]
- `csvtk` (included in base Nextstrain image)
- `tsv-filter` (included in base Nextstrain image)
- `snippy-core`
- `snippy-clean_full_aln`

## High-level outline of approach

1. Make Dockerfile based on `nextstrain/base`
2. Add root shell entry point
3. Install sra-tools with apt-get
4. Install `snippy` and dependencies manually and/or with apt-get
5. Install `tb-profiler` and dependencies manually and/or with apt-get

### Notes

- copied `sra-toolkit` install from [prior example][]
- b/c Kim wanted most recent versions, will build `snippy` and `tb-profiler` from source checkouts
- snippy needed Bio::Perl installed
  - …and a java (let's try the headless jdk that's available)
  - …and sam-tools and bcftools and bwa
- and now `/opt/snippy/bin/snippy --check` passes
- tb-profiler installs with pip, so let's update that first
  - pip install --upgrade pip
  - fucking python deps are a fucking tragedy every fucking time
- it's fully installed but gives cryptic shitty error messages. here are the deps:
  - ~trimmomatic (>=v0.38)~
  - ~bwa (>=v0.7.17)~
  - ~minimap2 (>=v2.16)~
  - ~samtools (>=v1.12)~
  - ~bcftools (>=v1.12)~
  - ~freebayes (>=v1.3.5)~
  - ~tqdm (>=v4.32.2) ?~
  - ~parallel (>=v20190522)~
  - ~samclip (>=v0.4.0)~
  - ~snpEff (>=v5.0.0)~
- shitty cryptic error:
  ```
  [21:59:22] DEBUG    Running command: tb-profiler create_db --db_dir /usr/local/share/tbprofiler --prefix tbdb --csv         utils.py:546
                    mutations.csv --watchlist watchlist.csv  --load
           ERROR    Traceback (most recent call last):                                                                      utils.py:551
  ```
`
- `touch /usr/local/share/tbprofile/snpeff/snpeff.config`

[docker-base]: https://github.com/nextstrain/docker-base/
[this TB `ingest/Snakefile`]: https://github.com/nextstrain/tb/blob/automate_with_checkpoints/ingest/Snakefile
[`sra-tools`]: https://github.com/ncbi/sra-tools/
[`tb-profiler`]: https://github.com/jodyphelan/TBProfiler
[`snippy`]: https://github.com/tseemann/snippy
[prior example]: https://github.com/victorlin/nextstrain-tb-docker-2/blob/main/Dockerfile
