ascp -QT -l 500m -P33001 -i /home/sebastian/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR195/008/SRR1956528/SRR1956528_1.fastq.gz 

ascp -QT -l 500m -P33001 -i /home/sebastian/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR195/007/SRR1956527/SRR1956527_2.fastq.gz .
ascp -QT -l 500m -P33001 -i /home/sebastian/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR195/008/SRR1956528/SRR1956528_2.fastq.gz .

ascp -QT -l 500m -P33001 -i /home/sebastian/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR195/009/SRR1956529/SRR1956529_1.fastq.gz .
ascp -QT -l 500m -P33001 -i /home/sebastian/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/SRR195/009/SRR1956529/SRR1956529_2.fastq.gz .

# bowtie2 
bowtie2 -x bowtie2/mm10_index --threads 8 -U original_data/SRR1956527_1.fastq.gz --reorder | samtools view -Shb - > SRR1956527_1.bam 2>SRR1956527_1.log &
bowtie2 -x bowtie2/mm10_index --threads 8 -U original_data/SRR1956527_2.fastq.gz --reorder | samtools view -Shb - > SRR1956527_2.bam 2>SRR1956527_2.log &
bowtie2 -x bowtie2/mm10_index --threads 8 -U original_data/SRR1956528_1.fastq.gz --reorder | samtools view -Shb - > SRR1956528_1.bam 2>SRR1956528_1.log &
bowtie2 -x bowtie2/mm10_index --threads 8 -U original_data/SRR1956528_2.fastq.gz --reorder | samtools view -Shb - > SRR1956528_2.bam 2>SRR1956528_2.log &
bowtie2 -x bowtie2/mm10_index --threads 8 -U original_data/SRR1956529_1.fastq.gz --reorder | samtools view -Shb - > SRR1956529_1.bam 2>SRR1956529_1.log &
bowtie2 -x bowtie2/mm10_index --threads 8 -U original_data/SRR1956529_2.fastq.gz --reorder | samtools view -Shb - > SRR1956529_2.bam 2>SRR1956529_2.log &

cd bowtie2
mkdir hicMatrix
hicBuildMatrix --samFiles SRR1956527_1.bam SRR1956527_2.bam --binSize 10000 --restrictionSequence GATC --outBam hicMatrix/SRR1956527_ref.bam --outFileName hicMatrix/SRR1956527_10kb.h5 --QCfolder hicMatrix/SRR1956527_10kb_QC --threads 8 --inputBufferSize 400000 &
hicBuildMatrix --samFiles SRR1956528_1.bam SRR1956528_2.bam --binSize 10000 --restrictionSequence GATC --outBam hicMatrix/SRR1956528_ref.bam --outFileName hicMatrix/SRR1956528_10kb.h5 --QCfolder hicMatrix/SRR1956528_10kb_QC --threads 8 --inputBufferSize 400000 &
hicBuildMatrix --samFiles SRR1956529_1.bam SRR1956529_2.bam --binSize 10000 --restrictionSequence GATC --outBam hicMatrix/SRR1956529_ref.bam --outFileName hicMatrix/SRR1956529_10kb.h5 --QCfolder hicMatrix/SRR1956529_10kb_QC --threads 8 --inputBufferSize 400000 &

hicSumMatrices --matrices hicMatrix/SRR1956527_10kb.h5 hicMatrix/SRR1956528_10kb.h5 hicMatrix/SRR1956529_10kb.h5 --outFileName hicMatrix/replicateMerged_10kb.h5
hicMergeMatrixBins --matrix hicMatrix/replicateMerged_10kb.h5 --numBins 100 --outFileName hicMatrix/replicateMerged.100bins.h5

# plot uncorrected matrix
mkdir plots
hicPlotMatrix \
--matrix hicMatrix/replicateMerged.100bins.h5 \
--log1p \
--dpi 300 \
--clearMaskedBins \
--chromosomeOrder chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chrX chrY \
--colorMap jet \
--title "Hi-C matrix for mESC" \
--outFileName plots/plot_1Mb_matrix.png

#bwa
parallel bwa mem -A 1 -B 4 -E 50 -L 0 -t 8 bwa/mm10_index {} | samtools view -Shb - ">" {}.bam ::: original_data/*.gz

cd bwa
mkdir hicMatrix
hicBuildMatrix --samFiles SRR1956527_1.bam SRR1956527_2.bam --binSize 10000 --restrictionSequence GATC --outBam hicMatrix/SRR1956527_ref.bam --outFileName hicMatrix/SRR1956527_10kb.h5 --QCfolder hicMatrix/SRR1956527_10kb_QC --threads 8 --inputBufferSize 400000 &
hicBuildMatrix --samFiles SRR1956528_1.bam SRR1956528_2.bam --binSize 10000 --restrictionSequence GATC --outBam hicMatrix/SRR1956528_ref.bam --outFileName hicMatrix/SRR1956528_10kb.h5 --QCfolder hicMatrix/SRR1956528_10kb_QC --threads 8 --inputBufferSize 400000 &
hicBuildMatrix --samFiles SRR1956529_1.bam SRR1956529_2.bam --binSize 10000 --restrictionSequence GATC --outBam hicMatrix/SRR1956529_ref.bam --outFileName hicMatrix/SRR1956529_10kb.h5 --QCfolder hicMatrix/SRR1956529_10kb_QC --threads 8 --inputBufferSize 400000 &
