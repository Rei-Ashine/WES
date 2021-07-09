# WES Data Analysis

Scripts for
1. Identifying SNVs(: Somatic single-Nucleotide Variants)
2. Identifying INDELs(: Somatic Insertions/Deletions)
3. Identifying MS(: MicroSatellite) INDELs
4. Clustering MSI-High and MSI-Low
5. Evaluating Somatic Mutation Spectrum
6. Identifying SCNAs(: Somatic Copy Number Alterations)

\* MSI: Microsatellite Instability

## Installing Dependencies
All dependencies can be installed with conda.<br>
An environment screenshot is provided :
```bash
conda env create -f environment.yml
```
Once the environment is created,<br>
it can be used at any time (without having to download everything again) :
```bash
conda activate wes
```
Exit the running virtual environment :
```bash
conda deactivate
```
Delete the virtual environment :
```bash
conda remove -n wes --all
```
