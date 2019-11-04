#!/bin/bash
# 
#===============================================================================
# TOOL    : gcasa model
# AUTHOR  : xialei
# UPDATED : 2019-10-23
#
# DESCRIPTION:
#
#
# INPUT:
# seq_sorted_somatic_bam_file
# seq_somatic_bam_index_file
# seq_sorted_germline_bam_file
# seq_germline_bam_index_file
# sampleId == ${params.tag}          : processId
# genomeVersion == ${params.genome}          : processId
# hotspots == ${params.variant_calling.hotspots}
# includeDuplication == ${params.variant_calling.includeDuplication}
# variantCallingTool == ${params.variant_calling.variantCallingTool}
# paired == ${params.paired}
# callingToolArguFile == ${params.variant_calling.callingToolArguFile}
# baseRecalibration == ${params.variant_calling.baseRecalibration}
# maxCores == ${params.variant_calling.maxCores}
# umiFlag == ${params.umiFlag}
# logFile
# workdir
#
# OUTPUT:
# annovar_out*.txt           : Result after annotation
# preprocessDir           : preprocessDir
# 
#===============================================================================
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-somatic-tnb.log 2>&1

echo "-------------TNB_analysis--------------------"
#if [ ! -d  ${params.outdir}/somatic/tnb ]; then mkdir -p -m 777  ${params.outdir}/somatic/tnb/;fi

if [ ! -d ${params.outdir}/somatic/tnb ]; then mkdir -p -m 777 ${params.outdir}/somatic/tnb;fi


echo "`grep -Ev '^[[:space:]].*|^#' $variant_calling_somatic_filter_vcf | wc -l`"
echo "`awk 'END{print NR}' $hla_file`"

if [[ ! `grep -Ev '^[[:space:]].*|^#' $variant_calling_somatic_filter_vcf | wc -l` == 0 ]] && [[ ! `awk 'END{print NR}' $hla_file` == 1 ]]; then

	echo "/ve/bin/python3  ${params.codePath}/changehla.py  -i $hla_file -o ${params.outdir}/somatic/tnb/seq_hla_${normalId}_hlatypes.txt -s seq_snpindel_${tumorId}_${params.toolVendor}.raw.filtered"

	/ve/bin/python3  ${params.codePath}/changehla.py  -i $hla_file -o ${params.outdir}/somatic/tnb/seq_hla_${normalId}_hlatypes.txt -s seq_snpindel_${tumorId}_${params.toolVendor}.raw.filtered

	echo "python /opt/NeoPredPipe/NeoPredPipe.py -I ${params.outdir}/somatic/snpIndel -H ${params.outdir}/somatic/tnb/seq_hla_${normalId}_hlatypes.txt -o ${params.outdir}/somatic/tnb -n ${tumorId} -c 0 -E 8 9 10"
	python /opt/NeoPredPipe/NeoPredPipe.py -I ${params.outdir}/somatic/snpIndel -H ${params.outdir}/somatic/tnb/seq_hla_${normalId}_hlatypes.txt -o ${params.outdir}/somatic/tnb -n ${tumorId} -c 0 -E 8 9 10
	cat ${params.outdir}/somatic/tnb/${tumorId}.neoantigens.Indels.txt >>${params.outdir}/somatic/tnb/${tumorId}.neoantigens.txt

	if [ `awk 'END{print NR}' ${params.outdir}/somatic/tnb/${tumorId}.neoantigens.txt` == 0 ]
		then
			echo "${params.outdir}/somatic/tnb/${tumorId}.neoantigens.txt is null"
			cp /gcbi/bioxFlow_code/repo/seq_tnb.txt ${params.outdir}/somatic/tnb/seq_tnb_${tumorId}_NeoPredPipe_tnb.txt
		else
			sed "1iSample\tRegion\tLine\tchr\tallelepos\tref\tref\tGeneName:RefID\tpos\thla\tpeptide\tcore\tOf\tGp\tGl\tIp\tIl\tIcore\tIdentity\tScore\tBinding Affinity\tRank\tCandidate\tBindLevel" ${params.outdir}/somatic/tnb/${tumorId}.neoantigens.txt > ${params.outdir}/somatic/tnb/seq_tnb_${tumorId}_NeoPredPipe_tnb.txt
	fi

	mv ${params.outdir}/somatic/tnb/${tumorId}.neoantigens.Indels.summarytable.txt ${params.outdir}/somatic/tnb/seq_tnb_${tumorId}_NeoPredPipe_Indels_summarytable.txt
	mv ${params.outdir}/somatic/tnb/${tumorId}.neoantigens.summarytable.txt ${params.outdir}/somatic/tnb/seq_tnb_${tumorId}_NeoPredPipe_summarytable.txt


	rm ${params.outdir}/somatic/tnb/${tumorId}.neoantigens.Indels.txt

else

	echo "0 rows for that ${variant_calling_somatic_filter_vcf}. or hla is none" 
	cp /gcbi/bioxFlow_code/repo/seq_tnb_summarytable.txt  ${params.outdir}/somatic/tnbseq_tnb_${tumorId}_NeoPredPipe_Indels_summarytable.txt
	cp /gcbi/bioxFlow_code/repo/seq_tnb_summarytable.txt ${params.outdir}/somatic/tnb/seq_tnb_${tumorId}_NeoPredPipe_summarytable.txt
	cp /gcbi/bioxFlow_code/repo/seq_tnb.txt ${params.outdir}/somatic/tnb/seq_tnb_${tumorId}_NeoPredPipe_tnb.txt

fi

