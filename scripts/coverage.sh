#!/bin/bash

#samtools faidx ./coverage/all.reprentatives.fa
awk 'BEGIN {FS="\t"}; {print $1 FS "0" FS $2}' ./coverage/all.reprentatives.fa.fai  > ./coverage/all.reprentatives.bed

bwa index ./coverage/all.reprentatives.fa

for i in $(ls trimedfile/*_1*)
do
        echo ${i}
        s=$(echo ${i}|awk -F '_1' '{print $1,$2}' OFS='_2')
        j=$(echo ${i}|awk -F '_1' '{print $1}' )
        jj=$(echo ${j}|awk -F '/' '{print $NF}')
        echo ${s}
        echo ${j}
        echo ${jj}
        bwa mem -t 20 ./coverage/all.reprentatives.fa  ${i} ${s} |samtools sort > ./coverage/${jj}.representives.sorted.bam 
        samtools index ./coverage/${jj}.representives.sorted.bam
        bedtools coverage -a ./coverage/all.reprentatives.bed -b ./coverage/${jj}.representives.sorted.bam > ./coverage/${jj}.coveri
done
