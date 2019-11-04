#!/bin/bash
#===============================================================================
# TOOL    : AnnotSV v1.1.1
# AUTHOR  : danny zhou
# UPDATED : 2019-10-08
#
# DESCRIPTION:
#
#
# INPUT:
# raw_vcf                    : Raw vcf file
# params.annotsv.dbpath      : Database path
# params.snnotsv.genome      : Genome version
#
# OUTPUT:
# annotsv_out.txt            : Result after annotation
# 
#===============================================================================

#annotsv: (ENV ANNOTSV=$DIR_INSTALL/annoxFlow/AnnotSV_1.1.1)

tclsh /gcbi/AnnoTSV/bin/AnnotSV \
    -genomeBuild GRCh37 \
    -dbPath $params.annotsv.dbpath
    -SVinputFile {inputfile} \
    -outputFile {outfile} \
