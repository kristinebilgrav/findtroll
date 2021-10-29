
#organize and prep vcf for merging

#jitter gff to vcf
rule gff_to_vcf:
	input:
		"{PWD}results/{sample}_jitter.gff3"
	output:
		"{PWD}results/{sample}_jitter.vcf"
	shell:
		"script/fixgff.py {input} {output}"


#delly bcf to vcf
rule bcf_to_vcf:
	input:
		"{PWD}results/{sample}_delly.bcf"
	output:
		"{PWD}results/{sample}_delly.vcf"
	container:
		"findtroll.sif"
	shell:
		"bcftools view {input} > {output}"

#remove problemcausing things
rule fix_vcf:
	input:
		"{PWD}results/{sample}_delly.vcf"
	output:
		"{PWD}results/{sample}_delly_fix.vcf"
	script:
		"scripts/filter.py {input} {output}"

#annotate delly wil retro
rule mobileann_retro:
	input:
		delly="{PWD}results/{sample}_delly.vcf", 
		retro="{PWD}results/{sample}_final.vcf",
		ref_ME_bed=expand("{ref_ME_bed}", ref_ME_bed=config["ref_ME_bed"])
	output:
		"{PWD}results/{sample}_delly_retro.vcf"
	container: 
		"findtroll.sif"
	script:
		"MobileAnn/MobileAnn.py --sv_annotate --sv {input.delly} --db {input.retro} --rm {input.ref_ME_bed} -d 300 > {output}"


#annotate delly with jitterfile
rule mobileann_jitter:
	input:
		delly="{PWD}results/{sample}_delly.vcf", 
		jitter="{PWD}results/{sample}_jitter.vcf",
		ref_ME_bed=expand("{ref_ME_bed}", ref_ME_bed=config["ref_ME_bed"]) 
	output:
		"{PWD}results/{sample}_delly_jitter.vcf"
	container: 
		"findtroll.sif"
	script:
		"MobileAnn/MobileAnn.py --sv_annotate --sv {input.delly} --db {input.jitter} --rm {input.ref_ME_bed} -d 300 > {output}"

