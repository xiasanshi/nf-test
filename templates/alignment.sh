#! /bin/bash
# author : Zhang Limei; at 2019-03-10
# 
R1T=$1
R2T=$2
sampleIdT=$3
R1N=$4
R2N=$5
sampleIdN=$6

resultPath=$7
indic=$8
phy=$9
logFile=/data/bioxFlow/logs/wes.log

echo "tumor $R1T ; $R2T; $sampleIdT; "
echo "normal $R1N ; $R2N; $sampleIdN;  "
echo "indic $indic" 
echo "phy $phy" 

starttime=`date +'%Y-%m-%d %H:%M'`




source ./bioxFlow.config
source ./somatic_paired.config

if [ ! -d ${resultPath} ]; then mkdir -p -m 777 ${resultPath};fi



for sampleId in $sampleIdT $sampleIdN;do
if [ $sampleId == $sampleIdT ];then
	R1=$R1T
	R2=$R2T
	echo "Tumor sample: ${R1}  ${R2}"
else
	R1=$R1N
	R2=$R2N
	echo "Normal sample: ${R1}  ${R2}"
fi


samlpe_Dir=${resultPath}/$sampleId
if [ ! -d ${samlpe_Dir} ]; then mkdir -p -m 777 ${samlpe_Dir};fi

preproc_Dir=${resultPath}/$sampleId/preproc
processId=$sampleId




#-------------step1:alignment module
echo "step1:alignment module"
align_Dir=${resultPath}/$sampleId/align
if [ ! -d ${align_Dir} ]; then mkdir -p -m 777 ${align_Dir};fi

if [ ${add_umi} == false ];then

/bin/bash ${codePath}/align.sh ${align_Dir} \
	$sampleId \
	$genome \
	$bedTarget \
	$paired \
	$realign \
	$toolVendor \
	${seq_mate1_file} \
	${seq_mate2_file} \
	$markDuplication \
	$alin_baseRecalibration \
	$maxCores \
	$logFile 
	
	qc_sh="qc.sh"
fi
	
if [ ${add_umi} == true ];then

/bin/bash 	${codePath}/umi_align.sh \
	$align_Dir \
	$sampleId \
	$genome \
	$bedTarget \
	$paired \
	$umiFlag \
	$seq_mate1_file \
	$seq_mate2_file  \
	$maxCores \
	$logFile 
qc_sh="qc_bat.sh"
fi
seq_sorted_bam_file=`ls ${align_Dir}/seq_sorted_bam_file-*.bam`
seq_bam_index_file=`ls ${align_Dir}/seq_bam_index_file-*`


