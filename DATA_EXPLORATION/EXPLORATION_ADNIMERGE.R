library(ggplot2)

ADNIMERGE <- read.csv(file = "~/Google Drive/Joint_projects_DS_Massi/1_ADNI_MCI_to_AD/DATA_15_12_2017/Study_info/ADNIMERGE.csv")

for (j in 9:ncol(ADNIMERGE)) {
   
   # dataset_this <- ADNIMERGE[which(ADNIMERGE$DX_bl %in% c("EMCI","LMCI","SMC")),c(8,j)]
   dataset_this <- ADNIMERGE[,c(8,j)]
   dataset_this$DX_bl <- factor(as.character(dataset_this$DX_bl))
   # dataset_this$DX_bl <- ordered(as.character(dataset_this$DX_bl), levels = c("SMC","EMCI","LMCI"))
   
   levels(dataset_this$DX_bl)
   
   if (is.numeric(dataset_this[,2])) {
      
      png(filename = paste("/Users/massimilianograssi/Google Drive/Joint_projects_DS_Massi/1_ADNI_MCI_to_AD/DATA_15_12_2017/temp_r/R_screening/PLOTS/",names(dataset_this)[2],".png",sep = ""))
      names(dataset_this)[2] <- "VAR"
      plot <- ggplot(dataset_this, aes(x=DX_bl, y =VAR)) + 
         geom_boxplot() + 
         geom_jitter(height = 0, width = 0.1)
      print(plot)
      dev.off()
      
   } else {
      
      png(filename = paste("/Users/massimilianograssi/Google Drive/Joint_projects_DS_Massi/1_ADNI_MCI_to_AD/DATA_15_12_2017/temp_r/R_screening/PLOTS/",names(dataset_this)[2],".png",sep = ""))
      names(dataset_this)[2] <- "VAR"
      plot <- ggplot(dataset_this, aes(x=DX_bl, y= VAR, fill=VAR)) + 
         geom_bar(stat = "identity", position = "stack")
      print(plot)
      dev.off()
      
      
   }
}
