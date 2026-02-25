#!/bin/bash
#SBATCH --job-name=EGAPx_QC
#SBATCH --partition=ceres
#SBATCH --time=00-01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --account=beenome100
#SBATCH --mail-type=END
#SBATCH --mail-user=kim.vertacnik@usda.gov
#SBATCH -e %j.%x.err     # %x applies the job name.  %j applies the job number
#SBATCH -o %j.%x.out

module load miniconda

source activate
conda activate egapx_qc_env

cwltool QC.cwl QC_params.yml
