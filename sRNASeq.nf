process p1 {
	publishDir "bowtie"
	input: path(fna)
	output: path ebwt

	script:
	ebwt = "*.ebwt"
	specie = "ecoli"

	"""
	bowtie-build ${fna} ${specie}
	"""
}
process p2 {
	publishDir "bam"
	input: path(archivo)
	output: path bam

	script:
	bam = "${archivo.baseName}-sorted.bam"
	
	"""
	bowtie -a -v 3 -p 4 -m 1 -S /Users/cpareja/RNASeq_NextFlow/ecoli --strata --best -l 14 ${archivo} | samtools view -b -S | samtools sort -o ${archivo.baseName}-sorted.bam
	"""
}
process p3 {
	publishDir "mmannot"
	input: path bam
	output: path txt

	script:
	txt = "output-${bam.baseName}.txt"

	"""
		/Users/cpareja/mmannot/mmannot -a /Users/cpareja/RNASeq_NextFlow/GCF_000017765.1_ASM1776v1_genomic.gtf -r ${bam} -c /Users/cpareja/RNASeq_NextFlow/configA.txt -M output-${bam.baseName}.txt
	"""
}
workflow {
	Channel.fromPath("/Users/cpareja/RNASeq_NextFlow/GCF_000017765.1_ASM1776v1_genomic.fna")|p1
	Channel.fromPath("*fastq")|p2
	Channel.fromPath("/Users/cpareja/RNASeq_NextFlow/bam/*bam")|p3
}
