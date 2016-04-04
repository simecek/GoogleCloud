
## JAX pipeline

A typical pipeline analysis (e.g. for [192 kidney samples](https://github.com/simecek/GoogleCloud/blob/master/pipeline/sample_list.csv)) would be:


1.	ALIGN 
 *	Program: bowtie, samtools (C++, Python)
 *	Input:  [raw data](https://console.cloud.google.com/storage/browser/calico-jax/jax/fastq/do_kidney_korstanje/?project=calico-jax) (FASTQ)
 *	Output: [reads alligned to genome](https://console.cloud.google.com/storage/browser/calico-jax/jax/bams/do_kidney_korstanje/?project=calico-jax) (BAM)
 *	Docker image: [dockerimages:5000/bowtie](https://github.com/simecek/GoogleCloud/blob/master/docker/bowtie/Dockerfile)
 *  Scripts: [step1_align.sh](https://github.com/simecek/GoogleCloud/blob/master/pipeline/1_align/step1_align.sh), [gcloud_one_sample_align.sh](https://github.com/simecek/GoogleCloud/blob/master/pipeline/1_align/gcloud_one_sample_align.sh)
2.	QUANTIFY 
 *	Program: EMASE (C++, Python)
 *	Input: [reads alligned to genome](https://console.cloud.google.com/storage/browser/calico-jax/jax/bams/do_kidney_korstanje/?project=calico-jax) (BAM)
 *	Output: [gene/transcript counts](https://console.cloud.google.com/storage/browser/calico-jax/jax/emase/do_kidney_korstanje/?project=calico-jax) (TXT)
 *	Docker image: [dockerimages:5000/asesuite](https://github.com/churchill-lab/sysgen2015/blob/master/docker/asesuite/Dockerfile)
 *  Scripts: [step2_quantify.sh](https://github.com/simecek/GoogleCloud/blob/master/pipeline/2_quantify/step2_quantify.sh), [gcloud_one_sample_quantify.sh](https://github.com/simecek/GoogleCloud/blob/master/pipeline/2_quantify/gcloud_one_sample_quantify.sh)
3.	GENOME RECONSTUCTION 
 *	Program: GBRS (Python)
 *	Input: [gene/transcript counts](https://console.cloud.google.com/storage/browser/calico-jax/jax/emase/do_kidney_korstanje/?project=calico-jax) (TXT)
 *	Output: genotype probability (CSV)
 *  Docker image: [dockerimages:5000/gbrs](https://github.com/simecek/GoogleCloud/blob/master/docker/gbrs/Dockerfile)
 *  Scripts: [step3_gbrs.sh](https://github.com/simecek/GoogleCloud/blob/master/pipeline/3_gbrs/step3_gbrs.sh), [gcloud_one_sample_gbrs.sh](https://github.com/simecek/GoogleCloud/blob/master/pipeline/3_gbrs/gcloud_one_sample_gbrs.sh)
4.	QTL MAPPING 
 *	Program: R/qtl2scan (R, C)
 *	Input: [genotype probability](https://console.cloud.google.com/storage/browser/calico-jax/jax/gbrs/do_kidney_korstanje/?project=calico-jax) (CSV), [gene/transcript counts](https://console.cloud.google.com/storage/browser/calico-jax/jax/emase/do_kidney_korstanje/?project=calico-jax) (TXT)
 *	Output: QTL results
 *	Docker image: [dockerimages:5000/rocker](https://github.com/simecek/GoogleCloud/blob/master/docker/rocker/Dockerfile)
5.	QTL VIEWER 
 *	Program: QTL Viewer (Python, C extensions)
 *	Input: QTL results (currently HDF5)
 *	Output: HTML, Javascript
 *	Docker image: [dockerimages:5000/qtlviewer](https://github.com/simecek/GoogleCloud/blob/master/docker/qtlviewer/Dockerfile)
