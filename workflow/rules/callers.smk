#rules to call variants
container: "/proj/nobackup/sens2017106/wharf/kbilgrav/kbilgrav-sens2017106/findtroll/findtroll.sif" 

#run retroseq
rule retro_discover:
	input:
		#bam=lambda wildcards:config['PWD'][wildcards.PWD]+ config["samples"][wildcards.sample], 
		#bam = config['PWD'][wildcards.PWD] + config['sample'][wildcards.sample]
		bam = lambda wildcards: config["samples"][wildcards.sample],
		ref_ME_tab=expand("{ref_ME_tab}", ref_ME_tab=config["ref_ME_tab"]),
		ref_fasta=expand("{ref_fasta}", ref_fasta=config["ref_fasta"])
	output:
		discover="{PWD}results/{sample}_output.vcf", 
	container: 
		"findtroll.sif"
	shell: 
		" singularity exec findtroll.sif retroseq.pl -discover -bam {input.bam} -output {output.discover} -refTEs {input.ref_ME_tab} "

rule retro_call:
	input:
		discover="{PWD}results/{sample}_output.vcf",
		bam = "{PWD}{sample}.bam",
		#bam = lambda wildcards: config["samples"][wildcards.sample] ,
		ref_fasta=expand("{ref_fasta}", ref_fasta=config["ref_fasta"])
	output:
		call="{PWD}results/{sample}_final.vcf"
	container:
		"findtroll.sif"
	shell:
		" singularity exec findtroll.sif retroseq.pl  -call -bam {input.bam} -input {input.discover} -ref {input.ref_fasta} -output {output.call} "


#run jitterbug
#rule jitter: 
#	input:
#		bam = lambda wildcards: config["samples"][wildcards.sample],
#		#bam=lambda wildcards:config['PWD'][wildcards.PWD]+ config["samples"][wildcards.sample], 
#		#bam = expand("{PWD}/{sample}", PWD=config["PWD"], sample=config["sample"]),
#		ref_ME_gff3=expand("{ref_ME_gff3}", ref_ME_gff3=config["ref_ME_gff3"]),
#		libstats=expand("{libstats_jitter}", libstats_jitter=config["libstats_jitter"])
#	output:
#		jitter_gff="{PWD}results/{sample}_jitter.gff3"
#	params: 
#		prefix="{sample}_jitter"
#	container: 
#		"findtroll.sif"
#	shell:
#		"""
#		singularity exec findtroll.sif jitterbug.py {input.bam} {input.ref_ME_gff3} --output_prefix {params.prefix} --minMAPQ 10 --conf_lib_stats {input.libstats}
#		"""


#run delly
rule delly: 
	input:
		bam = lambda wildcards: config["samples"][wildcards.sample],
		#bam=lambda wildcards:config['PWD'][wildcards.PWD]+ config["samples"][wildcards.sample], 
		#bam = expand("{PWD}/{sample}", PWD=config["PWD"], sample=config["sample"]),
		ref_fasta=expand("{ref_fasta}", ref_fasta=config["ref_fasta"])
	output:
		"{PWD}results/{sample}_delly.bcf"
	container:
		"findtroll.sif"
	shell:
		"singularity exec findtroll.sif delly call -o {output} -g {input.ref_fasta} {input.bam}"
