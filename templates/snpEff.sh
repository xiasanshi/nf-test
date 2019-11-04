#!/bin/bash
#===============================================================================
# TOOL    : snpEff 4.3T (2017-11-24)
# AUTHOR  : danny zhou
# UPDATED : 2019-10-08
#
# DESCRIPTION:
#
#
# INPUT:
# raw_vcf                    : Raw vcf file
# params.snpEff.dbpath       : Database path
# params.snpEff.genome       : Genome version
#
# OUTPUT:
# snpeff_out.txt             : Result after annotation
# 
#===============================================================================

java -jar /gcbi/snpEff/snpEff.jar \
     -dataDir $params.snpEff.dbpath \
     -geneId -noStats -lof -nodownload \
     -v "GRCh37.p13.RefSeq"  \
     $raw_vcf > snpeff_out.txt
