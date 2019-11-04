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

echo "########### variant calling ########" 

if [ ! -d /workspace/${tumorId}/hla/ ]; then mkdir -p -m 777 /workspace/${tumorId}/hla/;fi
if [ ! -d  ${params.outdir}/germline/hla/ ]; then mkdir -p -m 777  ${params.outdir}/germline/hla/;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/hla/germline ]; then mkdir -p -m 777 /workspace/${params.tag}/hla/germline ;fi

exec >/workspace/logs/${params.tag}-variant_hla.log 2>&1
echo "########### hla ########" 

echo  "PYTHONPATH=\"/gcbi/analyze/hla_subtyping\" python3 -m task.hla_workflow run file:/workspace/${params.tag}/hla/germline --retryCount 0 --maxCores $params.hla.maxCores --message {\"processId\":\"${params.tag}\",\"processType\":\"hlaSubtyping\",\"tumorAccession\":\"${tumorId}\",\"controlAccession\":\"${normalId}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"genomeVersion\":\"${params.genome}\",\"resultPath\":\"file:///workspace/${tumorId}/hla/\",\"removeDuplication\":${params.hla.removeDuplication}}"


PYTHONPATH="/gcbi/analyze/hla_subtyping" python3 -m task.hla_workflow run file:/workspace/${params.tag}/hla/germline/1 --retryCount 0 --maxCores $params.hla.maxCores --message "{\"processId\":\"${params.tag}\",\"processType\":\"hlaSubtyping\",\"tumorAccession\":\"${tumorId}\",\"controlAccession\":\"${normalId}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"genomeVersion\":\"${params.genome}\",\"resultPath\":\"file:///workspace/${tumorId}/hla/\",\"removeDuplication\":${params.hla.removeDuplication}}"

cp /workspace/${tumorId}/hla/*.result ${params.outdir}/germline/hla/seq_hla_kourami-${normalId}_kourami.result
cp /workspace/${tumorId}/hla/*.log ${params.outdir}/germline/hla/

sed "1iAllele\tBasesMatched\tIdentity\tLength of the assembled allele\tLength of the matched allele from IMGT/HLA DB\tCombined bottleneck weights\tWeight of the bottleneck edge in path 1\tWeight of the bottleneck edge in path 2" ${params.outdir}/germline/hla/seq_hla_kourami-${normalId}_kourami.result>${params.outdir}/germline/hla/seq_hla_${normalId}_kourami.txt
