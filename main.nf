#!/usr/bin/env nextflow

params.help = null
if (params.help)
{
    log.info "---------------------------------------------------------------------"
    log.info "  USAGE                                                 "
    log.info "---------------------------------------------------------------------"
    log.info ""
    log.info "nextflow run 'http://192.168.2.79:3000/gittest/longzhao_paried.git' -name shrivelled-wozniak -resume last -latest true -process.tag test-somatic003 --tag test-somatic003 [OPTIONS]"
    log.info ""
    log.info "Mandatory arguments:"
    log.info "--tag                    process id"
	log.info "-process.tag             the same as --tag"
    log.info "--R1T                    tumor R1 file"
    log.info "--R2T                    tumor R2 file"
    log.info "--R1N                    normal R1 file"
    log.info "--R2N                    normal R2 file"
    exit 1
}

log.info """\

=======================================
SOMATIC PARIED - NF               v1.0
=======================================
Tag   : $params.tag
R1T : $params.R1T
R2T : $params.R2T
R1N : $params.R1N
R2N : $params.R2N
indic : 
Genome: $params.genome
Outdir: $params.outdir
=======================================
"""

// Parse the input parameters
R1T=params.R1T
R2T=params.R2T
R1N=params.R1N
R2N=params.R2N

// 获取样本名
def get_sample_id(sample_path){
    file_name=sample_path.substring(sample_path.lastIndexOf("/")+1)
    file_name = file_name.indexOf('.') != -1 ? file_name.substring(0,file_name.lastIndexOf(".")) : file_name  //删除文件扩展名
    return file_name.replace("_R1","").replace("_R2","").replace(".fastq","")
}

tumorId = get_sample_id("${params.R1T}")
normalId = get_sample_id("{$params.R1N}")

/******
 * PART 1: SOMATIC prepare process.
 *
 * Process 1A: 
 */


/******
 * LAST PART: Collect and publish result.
 */
process collect_result {
    publishDir "${params.outdir}", mode: 'copy', overwrite: true

    input:
    val R1T from R1T

    """
    touch a.txt
    """
}

