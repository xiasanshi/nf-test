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
# prec_germline_mate1_file=prec_germline_mate1_file                    : paired-end sequencing R1
# prec_germline_mate2_file=prec_germline_mate2_file                    : paired-end sequencing R2
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
if [ ! -d /workspace/${normalId}/alignment ]; then mkdir -p -m 777 /workspace/${normalId}/alignment;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/alignment ]; then mkdir -p -m 777 /workspace/${params.tag}/alignment;fi

exec > /workspace/logs/${params.tag}-germline-alingment.log 2>&1


echo "#########align###########" 

echo "PYTHONPATH=\"/gcbi/analyze/alignment\" python3 -m task.run_workflow run file:/workspace/${params.tag}/alignment/germline  --workDir=/workspace/${params.tag}/alignment --maxCores ${params.alignment.maxCores} --message {\"accession\":\"${normalId}\",\"bedFile\":\"file://${params.bedFile}\",\"genomeVersion\":\"${params.genome}\",\"markDuplication\":${params.alignment.markDuplication},\"baseRecalibration\":${params.alignment.alin_baseRecalibration},\"inputFileList\":[{\"resultType\":\"seq_mate1_file\",\"storeId\":\"file://${prec_germline_mate1_file}\"},{\"resultType\":\"seq_mate2_file\",\"storeId\":\"file://${prec_germline_mate2_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"alignment\",\"realign\":${params.alignment.realign},\"resultPath\":\"file:///workspace/${normalId}/alignment\",\"toolVendor\":\"${params.toolVendor}\"}"

PYTHONPATH="/gcbi/analyze/alignment" python3 -m task.run_workflow run file:/workspace/${params.tag}/alignment/germline  --workDir=/workspace/${params.tag}/alignment --maxCores ${params.alignment.maxCores} --message "{\"accession\":\"${normalId}\",\"bedFile\":\"file://${params.bedFile}\",\"genomeVersion\":\"${params.genome}\",\"markDuplication\":${params.alignment.markDuplication},\"baseRecalibration\":${params.alignment.alin_baseRecalibration},\"inputFileList\":[{\"resultType\":\"seq_mate1_file\",\"storeId\":\"file://${prec_germline_mate1_file}\"},{\"resultType\":\"seq_mate2_file\",\"storeId\":\"file://${prec_germline_mate2_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"alignment\",\"realign\":${params.alignment.realign},\"resultPath\":\"file:///workspace/${normalId}/alignment\",\"toolVendor\":\"${params.toolVendor}\"}"

	
