#rules to call variants

#run retroseq
rule retro:
	input:
		bam=lambda wildcards: config["samples"][wildcards.sample], 
		ref_ME_tab=expand("{ref_ME_tab}", ref_ME_tab=config["ref_ME_tab"]),
		ref_fasta=expand("{ref_fasta}", ref_fasta=config["ref_fasta"])
	output:
		discover="results/{sample}.output.vcf", 
		call="results/{sample}.final.vcf"
	container: 
		"docker://kristinebilgrav/findtroll:latest"
	shell: 
		"perl RetroSeq/bin/retroseq.pl -discover -bam {input.bam} -output {output.discover} -refTEs {input.ref_ME_tab} | perl /bin/RetroSeq/bin/retroseq.pl  -call -bam {input.bam} -input {output.discover} -ref {input.ref_fasta} -output {output.call} "

#run jitterbug
rule jitter: #chmod 777 problem
	input:
		bam=lambda wildcards: config["samples"][wildcards.sample], 
		ref_ME_gff3=expand("{ref_ME_gff3}", ref_ME_gff3=config["ref_ME_gff3"]),
		libstats=expand("{libstats_jitter}", libstats_jitter=config["libstats_jitter"])
	output:
		"results/{sample}_jitter.gff3"
	params: 
		prefix=expand("{sample}", sample=config["samples"])
	container: 
		"docker://kristinebilgrav/findtroll:latest"
	resources:
		tmpdir="$TMPDIR" #not necessary, automatically uses system tmpdir
	shell:
		"chmod 777 . | jitterbug/jitterbug.py {input.bam} {input.ref_ME_gff3} --output_prefix {params.prefix} --minMAPQ 10 --conf_lib_stats {input.libstats}"

#run delly
rule delly: 
	input:
		bam=lambda wildcards: config["samples"][wildcards.sample],
		ref_fasta=expand("{ref_fasta}", ref_fasta=config["ref_fasta"])
	output:
		"results/{sample}_delly.bcf"
	container:
		"docker://kristinebilgrav/findtroll:latest"
	shell:
		"delly call -o {output} -g {input.ref_fasta} {input.bam}"

