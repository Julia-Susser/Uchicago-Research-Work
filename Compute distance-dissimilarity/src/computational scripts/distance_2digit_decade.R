library(readr)
library(dplyr)
setwd("~/Dropbox/thesis/5_APST/julia_compute_distance/src") 
rm(list = ls())   
#CREATE A NEW CURRENT VALUE DF THAT GROUPS BY 3DIGIT OCC AND DECADE WITH COUNT, 1DIGIT OCC AND 2DIGIT OCC
#----------------------------------------------------------
df <- read_csv("../input/current_values.csv")[,-1] 

#Calculate the decade of each row in the dataframe based on year
df$decade <- cut(df$Year,
                 breaks = c(1980,1990,2001), labels=c(1980,1990))
tf <- df %>% 
  group_by(`3digit occupation`, decade) %>%
  summarize(`number_employed`=n(), `1digit occ`=first(`1digit occupation`), `2digit occ`=first(`2digit occupation`))
#CREATE A LOOP FOR EACH TYPE OF PCA AND FOR EACH OF THE 3,4,7 PCS
types <- c("pca","spca")
for (x in types){
  for (num in c(3,4,7)){
    #READ THE PC
    #_____________________________________________________________
    filename <- paste("../input/", x, "_by_decade/", x, "_by_decade_", toString(num), sep="", collapse=NULL)
    print(filename)
    kf <- read_csv(filename)[,-1] 
    names(kf) <- sub("X1_1", "PC1", names(kf))   
    names(kf) <- sub("X", "PC", names(kf))
    
    #MERGES THE TWO DATAFRAMES
    #1. Merge N_jt = # of workers who work in occ j in decade t with PCA output.
    #ROW is {occ j} x {decade}
    #COL is {PCA 1} x {PCA 2} ..., N_jt
    #-------------------------------------------------
    
    kf$year <- as.character(kf$year)
    df <- inner_join(tf, kf, by = c("3digit occupation"="occ1990dd", "decade"="year"))
    
    
    #GET DISSIMILARITY
    #-------------------------------------------------------------
    
    if (num == 3){
      #get the weighted mean of the pcs by two digit occ and decade
      lf <- df %>% 
        group_by(`2digit occ`, decade)%>%
        summarize(`weighted_pc1`= weighted.mean(`PC1`, `number_employed`), `weighted_pc2`= weighted.mean(`PC2`, `number_employed`), `weighted_pc3`= weighted.mean(`PC3`, `number_employed`))
      #Merge the dataframe with the weighted mean pcs of each 2digit occ in each decade w the 3digit occs and pcs
      df <- inner_join(df, lf, by = c("2digit occ", "decade"))
      #calculate each 3digit occs pc distance from weighted mean pc for their 2 digit occ
      df$distance1 <- abs(df$PC1 - df$weighted_pc1)
      df$distance2 <- abs(df$PC2 - df$weighted_pc2)
      df$distance3 <- abs(df$PC3 - df$weighted_pc3)
      df$total_distance <- df$distance1 + df$distance2 + df$distance3
      #Get the weighted mean distance for each two digit occ each decade
      pf <- df %>%
        group_by(`2digit occ`, decade) %>%
        summarize(`1digit occ`=first(`1digit occ`), mean_distance = weighted.mean(total_distance, number_employed))
      
    }else if (num == 4){
      #get the weighted mean of the pcs by two digit occ and decade
      lf <- df %>% 
        group_by(`2digit occ`, decade)%>%
        summarize(`weighted_pc1`= weighted.mean(`PC1`, `number_employed`), `weighted_pc2`= weighted.mean(`PC2`, `number_employed`), `weighted_pc3`= weighted.mean(`PC3`, `number_employed`), `weighted_pc4`= weighted.mean(`PC4`, `number_employed`))
      #Merge the dataframe with the weighted mean pcs of each 2digit occ in each decade w the 3digit occs and pcs
      df <- inner_join(df, lf, by = c("2digit occ", "decade"))
      #calculate each 3digit occs pc distance from weighted mean pc for their 2 digit occ
      df$distance1 <- abs(df$PC1 - df$weighted_pc1)
      df$distance2 <- abs(df$PC2 - df$weighted_pc2)
      df$distance3 <- abs(df$PC3 - df$weighted_pc3)
      df$distance4 <- abs(df$PC4 - df$weighted_pc4)
      df$total_distance <- df$distance1 + df$distance2 + df$distance3 + df$distance4
      #Get the weighted mean distance for each two digit occ each decade
      pf <- df %>%
        group_by(`2digit occ`, decade) %>%
        summarize(`1digit occ`=first(`1digit occ`), mean_distance = weighted.mean(total_distance, number_employed))
    }else{
      #get the weighted mean of the pcs by two digit occ and decade
      lf <- df %>% 
        group_by(`2digit occ`, decade)%>%
        summarize(`weighted_pc1`= weighted.mean(`PC1`, `number_employed`), `weighted_pc2`= weighted.mean(`PC2`, `number_employed`), `weighted_pc3`= weighted.mean(`PC3`, `number_employed`), `weighted_pc4`= weighted.mean(`PC4`, `number_employed`), `weighted_pc5`= weighted.mean(`PC5`, `number_employed`), `weighted_pc6`= weighted.mean(`PC6`, `number_employed`), `weighted_pc7`= weighted.mean(`PC7`, `number_employed`))
      #Merge the dataframe with the weighted mean pcs of each 2digit occ in each decade w the 3digit occs and pcs
      df <- inner_join(df, lf, by = c("2digit occ", "decade"))
      #calculate each 3digit occs pc distance from weighted mean pc for their 2 digit occ
      df$distance1 <- abs(df$PC1 - df$weighted_pc1)
      df$distance2 <- abs(df$PC2 - df$weighted_pc2)
      df$distance3 <- abs(df$PC3 - df$weighted_pc3)
      df$distance4 <- abs(df$PC4 - df$weighted_pc4)
      df$distance5 <- abs(df$PC5 - df$weighted_pc5)
      df$distance6 <- abs(df$PC6 - df$weighted_pc6)
      df$distance7 <- abs(df$PC7 - df$weighted_pc7)
      df$total_distance <- df$distance1 + df$distance2 + df$distance3 + df$distance4  + df$distance5 + df$distance6 + df$distance7
      #Get the weighted mean distance for each two digit occ each decade
      pf <- df %>%
        group_by(`2digit occ`, decade) %>%
        summarize(`1digit occ`=first(`1digit occ`), mean_distance = weighted.mean(total_distance, number_employed))
      
      }
    
    
    #MERGE WITH TWO DIGIT OCCUPATIONAL CODES
    #-------------------------------------------------------------
    df <- read_csv("../input/2digit_occupations.csv")[,-1]
    df <- inner_join(pf, df, by = c("2digit occ"="codes"))
    
    
    df <- df %>%
      select(occupation, everything())
    #WRITE FILE
    #-------------------------------------------

    filename <- paste("../output/2digit_decade/", x, "_distance_", toString(num), ".csv", sep="", collapse=NULL)
    write.csv(df, filename)
}
}









