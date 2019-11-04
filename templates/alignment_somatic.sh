#!/bin/bash
#===============================================================================
# TOOL    : gcasa model
# AUTHOR  : xialei
# UPDATED : 2019-10-21
#
# DESCRIPTION:
#
#
# INPUT:
# R1=R1T                    : paired-end sequencing R1
# R2=R2T                      : paired-end sequencing R2
# sampleId == ${params.tag}          : processId
# genomeVersion == ${params.genome}          : processId
# baseQualityTrimming == ${params.preproc.baseQualityTrimming}
# fileType == ${params.preproc.fileType}
# paired == ${params.paired}
# realign = ${params.alignment.realign}
# markDuplication == ${params.alignment.markDuplication}
# alin_baseRecalibration == ${params.alignment.alin_baseRecalibration}
# toolVendor == ${params.toolVendor}
# maxCores == ${params.alignment.maxCores}
# bedFile == ${params.bedFile}
# logFile
# workdir
#
# OUTPUT:
# annovar_out*.txt           : Result after annotation
# preprocessDir           : preprocessDir
# 
#===============================================================================

# prepare
if [ ! -d /workspace/${tumorId}/alignment ]; then mkdir -p -m 777 /workspace/${tumorId}/alignment;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/alignment ]; then mkdir -p -m 777 /workspace/${params.tag}/alignment;fi

exec > /workspace/logs/${params.tag}-somatic-alingment.log 2>&1


echo "#########align###########" 

echo "PYTHONPATH=\"/gcbi/analyze/alignment\" python3 -m task.run_workflow run file:/workspace/${params.tag}/alignment/somatic  --workDir=/workspace/${params.tag}/alignment --maxCores ${params.alignment.maxCores} --message {\"accession\":\"${tumorId}\",\"bedFile\":\"file://${params.bedFile}\",\"genomeVersion\":\"${params.genome}\",\"markDuplication\":${params.alignment.markDuplication},\"baseRecalibration\":${params.alignment.alin_baseRecalibration},\"inputFileList\":[{\"resultType\":\"seq_mate1_file\",\"storeId\":\"file://${prec_somatic_mate1_file}\"},{\"resultType\":\"seq_mate2_file\",\"storeId\":\"file://${prec_somatic_mate2_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"alignment\",\"realign\":${params.alignment.realign},\"resultPath\":\"file:///workspace/${tumorId}/alignment\",\"toolVendor\":\"${params.toolVendor}\"}"

PYTHONPATH="/gcbi/analyze/alignment" python3 -m task.run_workflow run file:/workspace/${params.tag}/alignment/somatic  --workDir=/workspace/${params.tag}/alignment --maxCores ${params.alignment.maxCores} --message "{\"accession\":\"${tumorId}\",\"bedFile\":\"file://${params.bedFile}\",\"genomeVersion\":\"${params.genome}\",\"markDuplication\":${params.alignment.markDuplication},\"baseRecalibration\":${params.alignment.alin_baseRecalibration},\"inputFileList\":[{\"resultType\":\"seq_mate1_file\",\"storeId\":\"file://${prec_somatic_mate1_file}\"},{\"resultType\":\"seq_mate2_file\",\"storeId\":\"file://${prec_somatic_mate2_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"alignment\",\"realign\":${params.alignment.realign},\"resultPath\":\"file:///workspace/${tumorId}/alignment\",\"toolVendor\":\"${params.toolVendor}\"}"

	
