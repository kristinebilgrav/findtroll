#rules to call variants
container: "findtroll.sif"

#run retroseq
rule retro:
	input:
		bam=lambda wildcards:config['PWD'][wildcards.PWD]+ config["samples"][wildcards.sample], 
		#bam = expand("{PWD}/{sample}", PWD=config["PWD"], sample=config["sample"]),
		ref_ME_tab=expand("{ref_ME_tab}", ref_ME_tab=config["ref_ME_tab"]),
		ref_fasta=expand("{ref_fasta}", ref_fasta=config["ref_fasta"])
	output:
		discover="{PWD}results/{sample}_output.vcf", 
		call="{PWD}results/{sample}_final.vcf"
	container: 
		"findtroll.sif"
	shell: 
		"perl RetroSeq/bin/retroseq.pl -discover -bam {input.bam} -output {output.discover} -refTEs {input.ref_ME_tab} "
		"perl /bin/RetroSeq/bin/retroseq.pl  -call -bam {input.bam} -input {output.discover} -ref {input.ref_fasta} -output {output.call} "

#run jitterbug
rule jitter: 
	input:
		bam=lambda wildcards:config['PWD'][wildcards.PWD]+ config["samples"][wildcards.sample], 
		#bam = expand("{PWD}/{sample}", PWD=config["PWD"], sample=config["sample"]),
		ref_ME_gff3=expand("{ref_ME_gff3}", ref_ME_gff3=config["ref_ME_gff3"]),
		libstats=expand("{libstats_jitter}", libstats_jitter=config["libstats_jitter"])
	output:
		"{PWD}results/{sample}_jitter.gff3"
	params: 
		prefix="{PWD}results/{sample}_jitter"
	container: 
		"findtroll.sif"
	resources:
		tmpdir="$TMPDIR" #not necessary, automatically uses system tmpdir
	shell:
		"""
		mkdir workhere &&
		chmod 777 workhere &&
		cd workhere &&
		jitterbug/jitterbug.py {input.bam} {input.ref_ME_gff3} --output_prefix {params.prefix} --minMAPQ 10 --conf_lib_stats {input.libstats} &&
		mv {params.prefix} {output}
		"""

#run delly
rule delly: 
	input:
		bam=lambda wildcards:config['PWD'][wildcards.PWD]+ config["samples"][wildcards.sample], 
		#bam = expand("{PWD}/{sample}", PWD=config["PWD"], sample=config["sample"]),
		ref_fasta=expand("{ref_fasta}", ref_fasta=config["ref_fasta"])
	output:
		"{PWD}results/{sample}_delly.bcf"
	container:
		"findtroll.sif"
	shell:
		"delly call -o {output} -g {input.ref_fasta} {input.bam}"
