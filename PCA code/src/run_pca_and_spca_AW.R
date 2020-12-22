# ~~~~~~~~~~~~~~~~~~~~
## PRELIMINARY -------
# ~~~~~~~~~~~~~~~~~~~~

#_______________________________________
# Clear workspace
rm(list = ls())                               

#_______________________________________
# Packages
library(tidyverse)
library(mixkernel)
library(sparsepca)
library(BKPC)
setwd("~/Dropbox/thesis/5_APST/julia_pca/src") 

#_______________________________________
# Set options
normalPCA <- TRUE
sparsePCA <- TRUE
kernelPCA <- FALSE

#_______________________________________
# Load APST skills data 
df <- read_csv("../input/occ_skill.csv")     # cleaned by Alex
df <- arrange(df, year, occ1990dd)           # sort by year and occupation
df <- select(df, !starts_with("technology")) # drop tech because has zero variance for many occs/decades

# ~~~~~~~~~~~~~~~~~~~~
## PCA BY DECADE ---
# ~~~~~~~~~~~~~~~~~~~~

g     <- 1940                                # start year
years <- c(1950,1960,1970,1980,1990,2001)   # divide into decades
for (yeary in years){

  lf <- df %>% filter(year>=g, year < yeary) # extract decade 

  #_______________________________________
  # COLLAPSE TO {DECADE} X {OCCUPATION}
  lf <- lf %>% 
    group_by(occ1990dd) %>%
    summarize_all(mean, na.rm=T) %>%         # compute mean within-occ across-year
    select(-year) %>%                        # drop cols
    arrange(occ1990dd) %>%                   # sort
    ungroup()

  occ1990dd_list <- pull(lf, occ1990dd)      # extract column of occupation num.
  
  lf <- select(lf,-starts_with("occ1990dd")) # drop non-skill variables for PCA
  
  #_______________________________________
  # COMPUTE VAR(SKILL) ACROSS OCCS
  variances <- apply(lf, 2,var)                       # var of each column

  variances <- data.frame(skills=names(variances),    # Convert to dataframe
                          var_skill=variances, 
                          row.names=NULL) 
  stopifnot(sum(variances$var_skill == 0) == 0)          # Check cols have non-zero variance 

  for (num in c(3,4,7)){
    
    #_______________________________________
    # REGULAR PCA
    if (normalPCA==TRUE){
      #_______________________________________
      # Compute PCA, scale to Mean=0, SD=1
      # Rank = num princ. components. (slower but more accurate than computing for all)
      lf.pca <- prcomp(lf, scale = TRUE, center = TRUE, rank. = num)  
      
      k <- lf.pca$x                         # Extract matrix output (J x numPC)
      
      filename <- paste("../output/pca/pca",toString(g),"/pca_",toString(g), 
                        "s_",toString(num), 
                        ".csv", sep="", collapse=NULL)
      
      #_______________________________________
      # Append occupation codes and export
      k <- data.frame(k)
      k$occ1990dd <- occ1990dd_list
      write.csv(k,filename)
    }
    
    #_______________________________________
    # SPARSE PCA
    if (sparsePCA==TRUE){
      #_______________________________________
      # Compute Sparse PCA, scale to Mean=0, SD=1
      # k = num princ. components. (slow but more accurate than computing for all)
      # Robspca is robust to outliers.
      lf.spca <- robspca(lf, scale = TRUE, center = TRUE, k = num)  
      
      k <- lf.spca$scores                       # Extract matrix output (J x numPC)
      
      filename <- paste("../output/spca/spca",toString(g),"/spca_",toString(g), 
                        "s_",toString(num), 
                        ".csv", sep="", collapse=NULL)
      
      #_______________________________________
      # Append occupation codes and export
      k <- data.frame(k)
      k$occ1990dd <- occ1990dd_list
      write.csv(k,filename)
    }
    
    
  }

  #_______________________________________
  # UPDATE TO NEXT DECADE
  g <- yeary
  
}

## Explore SPCA ---
summary(lf.pca)     # first PC explains 28% of variance in 1990s
summary(lf.spca)    # note that first PC explains 43% of variance in 1990s



# ~~~~~~~~~~~~~~~~~~~~
## EVERYTHING  -------
# ~~~~~~~~~~~~~~~~~~~~

df <- read_csv("../input/occ_skill.csv")
# df <- df[
#   with(df, order(occ1990dd, year)),
# ]
# #saves original data frame
# h <- df
# #takes out the year and occ1990_3_digit
# df <- df[,-1:-2]
# #takes out the occ1990 1 and 2 digit
# df <- df[,-207:-208]
# #runs pca - none of them have a zero variance
# df.pca <- prcomp(df, scale = TRUE, center = TRUE)
# for (num in c(3,4,7)){
#   #puts pca into data frame bc it is a matrix
#   k <- df.pca$x[,1:num]
#   h <- h %>%
#     select(occ1990dd, year)
#   #combines year, and occ with pca
#   k <- cbind(h,k)
#   filename <- paste("../output/pca/pca_everything/pca_", toString(num), ".csv", sep="", collapse=NULL)
#   write.csv(k, filename)
# }
# 
# 
# 
# 
# 
# 
# 
# df <- read_csv("../input/occ_skill.csv")
# df <- df[
#   with(df, order(occ1990dd, year)),
# ]
# years <- c(1950,1960,1970,1980,1990,2001)
# g <-1940
# #goes through it by 10 years
# for (yeary in years){
#   variances <- c()
#   #filters through it by 10 years
#   lf <- df %>% 
#     filter(year >= g & year <= yeary-1)
#   
#   h <- lf
#   lf <- aggregate(lf[,-1:-2], list(lf$occ1990dd), mean)
#   lf <- lf[,-1]
#   #runs pca
#   lf.pca <- prcomp(lf, scale = TRUE, center = TRUE)
#   for (num in c(3,4,7)){
#     k <- lf.pca$x[,1:num]
#     filename <- paste("../output/pca/pca",toString(g),"/pca_",toString(g), "s_",toString(num), ".csv", sep="", collapse=NULL)
#     
#     #puts pca into data frame bc it is a matrix
#     k <- data.frame(k)
#     h <- h %>%
#       select(occ1990dd, year)
#     
#     #combines year, and occ with pca
#     k <- cbind(h,k)
#    
#   }
#   g <- yeary
#   
# }
# 
# 
# 
# 
# l <- 0
# lf <- lf %>% group_split(occ1990dd)
# for (x in lf){
#   t <- summarize(x, first(occ1990dd))
#   j <- colMeans(x)
#   print(t)
#   if (l == 0)
#     l <- data.frame(j)
#   else{
#     l <- cbind(l, data.frame(j))
#   }
# }
# lf <- data.frame(t(l))
# 
# 
# lf <- t
# 
# 
# variances <- c()
# for(i in 1:208){
#   variances <- c(variances, var(lf[,i]))
# }
# skills <- names(lf)
# #merges the variances with the skills
# skills_variances <- data.frame(skills,variances)
# #finds how many variances are not zero, so that I can select the ones that aren't
# f <- skills_variances %>% 
#   filter(variances == 0)
# 
# #orders it by the variance
# skills_variances <- skills_variances[
#   with(skills_variances, order(variances)),
# ]
# print(206-length(row.names(f)))
# #selects all of the skills that aren't zero by grabbing the last n rows
# #gets the row names for them which are the original order of the skills
# i <- strtoi(row.names(tail(skills_variances,length(row.names(f)))))
# #selects all of the rows where the variance isn't zero by using the rownames which are the order of the skills
# lf <- lf[,i]
# length(names(lf))
# 
# lf <- df %>% 
#   filter(year >= 1940 & year <= 1950-1)
# lf$technology_foxpro
# 
# 
# 
# 
# 
# 
# 
