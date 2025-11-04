#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
                  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
                    print(args[1])
}

library(ggplot2)
child <- read.table(args[1],header=FALSE)
mother <-read.table(args[2],header=FALSE)
father <-read.table(args[3], header=FALSE)
cc = as.numeric(args[4])
cm = as.numeric(args[5])
cf = as.numeric(args[6])
mb = as.numeric(args[7])
#ch = args[8]
#start = as.numeric(args[9])
#end = as.numeric(args[10])

child<- subset(child,  V5 > mb)
mother<-subset(mother,  V5 > mb)
father<-subset(father,  V5 > mb)
#child<- subset(child,  V2 >= start & V2 <= end)
#mother<-subset(mother,   V2 >= start & V2 <= end)
#father<-subset(father,   V2 >= start & V2 <= end)

child$V6[(child$V4/(cc/2)) - (mother$V4/ (cm/2) )  >  0.75 &  (child$V4/(cc/2)) - (father$V4/ (cf/2)) >  0.75  ] <- 1
child$V6[(child$V4/(cc/2)) - (mother$V4/ (cm/2) )  < -0.75 &  (child$V4/(cc/2)) - (father$V4/ (cf/2)) < -0.75  ] <- 2
child$V7 <- (child$V4/(cc/2)) - (mother$V4/ (cm/2)) 
child$V8 <- (child$V4/(cc/2)) - (father$V4/ (cf/2))
child$V9 <- child$V4
child$V10 <- mother$V4
child$V11 <- father$V4
subset(child, V6 >=1)

print(paste0(trimws(args[1]),".scatter.pdf"))
pdf(paste0(trimws(args[1]),".scatter.pdf"), width=8, height =8)

#chroms <- c(seq(1,22,1), "X", "Y")
chroms <- c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22", "chrX", "chrY")

for(ch in chroms) {
print(  ggplot()+
                geom_point(aes(x=subset(child , V1 == ch)$V4/(cc/2), y=subset(father, V1 == ch)$V4/(cf/2)), color = "blue", alpha =0.1)+
                geom_point(aes(x=subset(child , V1 == ch)$V4/(cc/2), y=subset(mother,  V1 == ch)$V4/(cm/2)), color="green", alpha =0.1)+
                scale_y_continuous(limits=c(0,5), breaks=seq(0,10,1))+
                scale_x_continuous(limits=c(0,5), breaks=seq(0,10,1)) +
                geom_abline(intercept=0, slope=1, color = "black")+
                geom_abline(intercept=0, slope=2, color = "grey")+
                geom_abline(intercept=0, slope=0.5, color = "grey")+
                geom_abline(intercept=1, slope=1, color = "green")+
                geom_abline(intercept=-1, slope=1, color = "green")+
                geom_abline(intercept=2, slope=1, color = "orange")+
                geom_abline(intercept=-2, slope=1, color = "orange")+
                geom_abline(intercept=3, slope=1, color = "red")+
                geom_abline(intercept=-3, slope=1, color = "red")+
                xlab(ch))
}


dev.off()
quit()


