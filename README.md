# Gut Microbiome Study in NAFLD
#### The NAFLD study was performed on mice models to explore the critical role of gut microbiome in OCA treatment by shotgun metagenomics and targeted metabolomics. Thirty three six-week-old SPF male mice were adopted and randomly assigned to normal diet group (ND), high-fat diet group (HFD), and high-fat diet with following OCA treatment (HFD+OCA) group, each group consists of 11 mice. 
##### Bioinformatic workflows of metagenomic analysis
**1.Quality control for raw data**  
    conda create --name myenv FastQC=0.11.8 Trimmomatic=0.32  
    fastqc sampleID.fastq -o quality/  
    trimmomatic PE -phred33 -trimlog log.txt $INPUT_PATH/SampleID_1.fastq.gz $INPUT_PATH/SampleID_2.fastq.gz $OUTPUT_PATH/paired_SampleID_1.fq.gz $OUTPUT_PATH/paired_SampleID_2.fq.gz $OUTPUT_PATH/paired_SampleID_1.fq.gz $OUTPUT_PATH/unpaired_SampleID_2.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:50  
**2.Host genomic contaminant removal**  
    conda install --name myenv -c bioconda bowtie2  
    wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz -O genomic.fa  
    bowtie2-build genomic.fa genome_index bowtie2 -x genome_index -1 $INPUT_PATH/trimmed_SampleID_1.fq.gz -2 $INPUT_PATH/trimmed_SampleID_2.fq.gz --un-conc-gz $OUTPUT_PATH/SampleID.hostfree.fq.gz -p 60 -S $OUTPUT_PATH/SampleID.sam 1>$OUTPUT_PATH/SampleID.o 2>$OUTPUT_PATH/SampleID.e  

**3.Paired-end reads assembly**  
    conda install --name myenv -c bioconda spades  
    spades.py --meta -t 20 -m 500 -1 $INPUT_PATH/SampleID.hostfree_1.fq.gz -2 $INPUT_PATH/SampleID.hostfree_2.fq.gz -o $OUTPUT_PATH/SampleID_assembly 1>$OUTPUT_PATH/SampleID.o 2>$OUTPUT_PATH/SampleID.e  

**4.Open reading frames (ORFs) prediction and non-redundant gene catalog construction**  
    For ORFs prediction, runing on linux sever  
    Download MetaGeneMark from http://topaz.gatech.edu/genemark/license_download.cgi  
    tar –xvzf MetaGeneMark_linux_64.tar.gz –C $PATH/MetaGeneMark_linux_64  
    $PATH/MetaGeneMark_linux_64/mgm/gmhmmp -a -d -f 3 -m $PATH/MetaGeneMark_linux_64/mgm/MetaGeneMark_v1.mod $INPUT_PATH/contigs.fa -A $OUTPUT_PATH/protein.fasta -D $OUTPUT_PATH/nuleotide.fasta  

**5.Constrcuct non-redundant gene catalog**  
    wget https://github.com/weizhongli/cdhit/releases/cd-hit-v4.8.1-2019-0228.tar.gz 
    tar –xvzf cd-hit-v4.8.1-2019-0228.tar.gz –C $PATH/cd-hit-v4.8.1  
    $PATH/cd-hit-v4.8.1/cd-hit -i $INPUT_PATH/protein.fasta -o nr95_protein.fa -n 5 -g 1 -c 0.95 -G 0 -M 0 -d 0 -aS 0.9  
    
**6.Gene abundance calculation**  
    conda install --name myenv -c bioconda salmon  
    salmon index -p 20 -t $INPUT_PATH/nr95_gene.fa -i $OUTPUT_PATH/nr95_gene_index  
    salmon quant -i $PATH/nr95_gene_index --libType IU -1 $INPUT_PATH/SampleID.hostfree_1.fastq.gz -2 $INPUT_PATH/SampleID.hostfree_2.fastq.gz -o $OUTPUT_PATH/SampleID.quant --meta -p 30  
    
**7.Taxonomic and functional analysis**  
    **Taxonmic analysis**  
    conda install –name myenv -c conda-forge -c bioconda metaphlan  
    metaphlan2.py SampleID.fasta --input_type fasta > SampleID_profile.txt  
    **Functional annotation**  
    conda install --name myenv -c bioconda eggnog-mapper  
    emapper.py -i nr95_protein.fa -o eggNOG_annotation --cpu 0 --evalue 1e-5
