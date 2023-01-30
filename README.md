# Gut Microbiome Study in NAFLD
#### The NAFLD study was performed on mice models to explore the critical role of gut microbiome in OCA treatment by shotgun metagenomics and targeted metabolomics. Thirty three six-week-old SPF male mice were adopted and randomly assigned to normal diet group (ND), high-fat diet group (HFD), and high-fat diet with following OCA treatment (HFD+OCA) group, each group consists of 11 mice. 
**Bioinformatic workflows of metagenomic analysis**
1.	Quality control for raw data
    conda create --name myenv FastQC=0.11.8 Trimmomatic=0.32
    fastqc sampleID.fastq -o quality/
    trimmomatic PE -phred33 -trimlog log.txt $INPUT_PATH/SampleID_1.fastq.gz $INPUT_PATH/SampleID_2.fastq.gz $OUTPUT_PATH/paired_SampleID_1.fq.gz    $OUTPUT_PATH/paired_SampleID_2.fq.gz $OUTPUT_PATH/paired_SampleID_1.fq.gz $OUTPUT_PATH/unpaired_SampleID_2.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:50
