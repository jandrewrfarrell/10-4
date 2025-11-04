#!/usr/bin/env Rscript
library(scales)
args = commandArgs(trailingOnly=TRUE)
options(width = 2000)
if (length(args)==0) {
                  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
                    print(args[1])
}

library(ggplot2)
subject <- read.table(args[1],header=FALSE)
cc = as.numeric(args[2])
mb = as.numeric(args[3])

subject<- subset(subject,  V5 > mb)

#subject$V7 <- (subject$V4/(cc/2)) - (control$V4/ (cm/2)) 
#subject$V9 <- subject$V4
#subject$V10 <- control$V4
#subset(subject, V6 >=1)

print(paste0(trimws(args[1]),".pdf"))
pdf(paste0(trimws(args[1]),".pdf"), width=8, height =4)

#chroms <- c(seq(1,22,1), "X", "Y")
chroms <- c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY")

for(ch in chroms) {
        print(  ggplot()+
                geom_point(aes(x=subset(subject , V1 == ch)$V2, y=subset(subject, V1 == ch)$V4/(cc/2)), color="chartreuse3", alpha = 0.1)+
                scale_y_continuous(limits=c(0,5), breaks=seq(0,10,1))+
                scale_x_continuous(limits=c(0,max(subset(subject , V1 == ch)$V2)), breaks=seq(0,max(subset(subject , V1 == ch)$V2), max(subset(subject , V1 == ch)$V2)/20), labels = label_number(suffix = " Mbp", scale = 1e-6)) +
                theme(axis.text.x=element_text(angle = -45, hjust = 0))+
                xlab(ch))
}


dev.off()
quit()

 #scale_x_continuous(limits=c(0,max(subset(subject , V1 == ch)$V2), breaks=seq(0,max(subset(subject , V1 == ch)$V2), max(subset(subject , V1 == ch)$V2)/20))) +

