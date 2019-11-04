#!/bin/bash
# 
#===============================================================================
# TOOL    : gcasa model
# AUTHOR  : xialei
# UPDATED : 2019-10-17
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
# baseQualityTrimming == ${params.preproc.baseQualityTrimming}
# fileType == ${params.preproc.fileType}
# paired == true
# ampliconList = ${params.qc.ampliconList}
# targetList == ${params.qc.targetList}
# captureList == ${params.qc.captureList}
# maxCores == ${params.preproc.maxCores}
# umiFlag == ${params.umiFlag}
# logFile
# workdir
#
# OUTPUT:
# annovar_out*.txt           : Result after annotation
# preprocessDir           : preprocessDir
# 
#===============================================================================
# prepare
if [ ! -d ${params.outdir}/sample/qc ]; then mkdir -p -m 777 ${params.outdir}/sample/qc;fi

if [ ! -d /workspace/${tumorId}/qc ]; then mkdir -p -m 777 /workspace/${tumorId}/qc;fi

if [ ! -d /workspace/${normalId}/qc ]; then mkdir -p -m 777 /workspace/${normalId}/qc;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/qc ]; then mkdir -p -m 777 /workspace/${params.tag}/qc;fi

exec >/workspace/logs/${params.tag}-qc.log 2>&1


if [ ${params.qc.captureList} == true ]
then
    echo "captureList is ${params.qc.captureList}"
    echo "run somatic qc"
    echo " python3 -m task.qc_workflow run file:/workspace/${params.tag}/qc/1  --workDir=/workspace/${params.tag}/qc/ --maxCores ${params.preproc.maxCores} --message  {\"accession\":\"${tumorId}\",\"toolVendor\":\"${params.toolVendor}\",\"bedTarget\":\"file://${params.bedFile}\",\"targetList\":\"file://${params.qc.targetList}\",\"baitsList\":\"file://${params.qc.ampliconList}\",\"genomeVersion\":\"${params.genome}\",\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_somatic_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_somatic_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"qualityControl\",\"resultPath\":\"file:///workdir/${tumorId}/qc\"}"	


    PYTHONPATH="/gcbi/analyze/quality_control" python3 -m task.qc_workflow run file:/workspace/${params.tag}/qc/1  --workDir=/workspace/${params.tag}/qc/ --maxCores ${params.preproc.maxCores} --message "{\"accession\":\"${tumorId}\",\"toolVendor\":\"${params.toolVendor}\",\"bedTarget\":\"file://${params.bedFile}\",\"targetList\":\"file://${params.qc.targetList}\",\"baitsList\":\"file://${params.qc.ampliconList}\",\"genomeVersion\":\"${params.genome}\",\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_somatic_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_somatic_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"qualityControl\",\"resultPath\":\"file:///workdir/${tumorId}/qc\"}"
	
	echo "run germline qc"
	echo " python3 -m task.qc_workflow run file:/workspace/${params.tag}/qc/1  --workDir=/workspace/${params.tag}/qc/ --maxCores ${params.preproc.maxCores} --message  {\"accession\":\"${normalId}\",\"toolVendor\":\"${params.toolVendor}\",\"bedTarget\":\"file://${params.bedFile}\",\"targetList\":\"file://${params.qc.targetList}\",\"baitsList\":\"file://${params.qc.ampliconList}\",\"genomeVersion\":\"${params.genome}\",\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_germline_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_germline_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"qualityControl\",\"resultPath\":\"file:///workdir/${normalId}/qc\"}"	


    PYTHONPATH="/gcbi/analyze/quality_control" python3 -m task.qc_workflow run file:/workspace/${params.tag}/qc/1  --workDir=/workspace/${params.tag}/qc/ --maxCores ${params.preproc.maxCores} --message "{\"accession\":\"${normalId}\",\"toolVendor\":\"${params.toolVendor}\",\"bedTarget\":\"file://${params.bedFile}\",\"targetList\":\"file://${params.qc.targetList}\",\"baitsList\":\"file://${params.qc.ampliconList}\",\"genomeVersion\":\"${params.genome}\",\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_germline_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_germline_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"qualityControl\",\"resultPath\":\"file:///workdir/${normalId}/qc\"}"

else
    echo "captureList xx is ${params.qc.captureList}"
    echo "run somatic qc"
    echo " python3 -m task.qc_workflow run file:/workspace/${params.tag}/qc/1  --workDir=/workspace/${params.tag}/qc/ --maxCores ${params.preproc.maxCores} --message  {\"accession\":\"${tumorId}\",\"toolVendor\":\"${params.toolVendor}\",\"bedTarget\":\"file://${params.bedFile}\",\"targetList\":\"file://${params.qc.targetList}\",\"ampliconList\":\"file://${params.qc.ampliconList}\",\"genomeVersion\":\"${params.genome}\",\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_somatic_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_somatic_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"qualityControl\",\"resultPath\":\"file:///workdir/${tumorId}/qc\"}"	

    PYTHONPATH="/gcbi/analyze/quality_control" python3 -m task.qc_workflow run file:/workspace/${params.tag}/qc/1  --workDir=/workspace/${params.tag}/qc/ --maxCores ${params.preproc.maxCores} --message "{\"accession\":\"${tumorId}\",\"toolVendor\":\"${params.toolVendor}\",\"bedTarget\":\"file://${params.bedFile}\",\"targetList\":\"file://${params.qc.targetList}\",\"ampliconList\":\"file://${params.qc.ampliconList}\",\"genomeVersion\":\"${params.genome}\",\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_somatic_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_somatic_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"qualityControl\",\"resultPath\":\"file:///workdir/${tumorId}/qc\"}"
	
	echo "run germline qc"
	echo " python3 -m task.qc_workflow run file:/workspace/${params.tag}/qc/1  --workDir=/workspace/${params.tag}/qc/ --maxCores ${params.preproc.maxCores} --message  {\"accession\":\"${normalId}\",\"toolVendor\":\"${params.toolVendor}\",\"bedTarget\":\"file://${params.bedFile}\",\"targetList\":\"file://${params.qc.targetList}\",\"ampliconList\":\"file://${params.qc.ampliconList}\",\"genomeVersion\":\"${params.genome}\",\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_germline_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_germline_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"qualityControl\",\"resultPath\":\"file:///workdir/${normalId}/qc\"}"	


    PYTHONPATH="/gcbi/analyze/quality_control" python3 -m task.qc_workflow run file:/workspace/${params.tag}/qc/1  --workDir=/workspace/${params.tag}/qc/ --maxCores ${params.preproc.maxCores} --message "{\"accession\":\"${normalId}\",\"toolVendor\":\"${params.toolVendor}\",\"bedTarget\":\"file://${params.bedFile}\",\"targetList\":\"${params.qc.targetList}\",\"ampliconList\":\"${params.qc.ampliconList}\",\"genomeVersion\":\"${params.genome}\",\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_germline_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_germline_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"qualityControl\",\"resultPath\":\"file:///workdir/${normalId}/qc\"}"
	
fi

echo "qc handle result"
if [ ! -d ${params.outdir}/sample/qc/ ]; then mkdir -p -m 777 ${params.outdir}/sample/qc/;fi
python3 ${params.codePath}/qc_get.py   /workdir/${tumorId}/qc/ /workdir/${tumorId}/alignment/  ${tumorId}   /workdir/${tumorId}/qc/${tumorId}_tumor_report_qc.txt

cp /workdir/${tumorId}/qc/${tumorId}_tumor_report_qc.txt ${params.outdir}/sample/qc/

python3 ${params.codePath}/qc_get.py  /workdir/${normalId}/qc /workdir/${normalId}/alignment/  ${normalId}  /workdir/${normalId}/qc/${normalId}_normal_report_qc.txt

cp /workdir/${normalId}/qc/${normalId}_normal_report_qc.txt ${params.outdir}/sample/qc/

python3 ${params.codePath}/report_qc.py -t ${params.outdir}/sample/qc/${tumorId}_tumor_report_qc.txt -n ${params.outdir}/sample/qc/${normalId}_normal_report_qc.txt -o ${params.outdir}/sample/qc/seq_qc_report_qc.txt



