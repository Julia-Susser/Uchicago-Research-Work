

# ~~~~~~~~~~~~~~~~~~~~
## PRELIMINARY -------
# ~~~~~~~~~~~~~~~~~~~~

#_______________________________________
# Clear workspace
rm(list = ls())                               

#_______________________________________
# Packages
library(readr)
library(dplyr)
library(kernlab)
library(sparsepca)
setwd("~/Dropbox/thesis/5_APST/julia_pca/src") 

#_______________________________________
# Set options
normalPCA <- TRUE
sparsePCA <- TRUE
kernelPCA <- FALSE
pca_all <- data.frame()
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
  lf <- aggregate(lf[,-1:-2], list(lf$occ1990dd), mean)
  
  occ1990dd_list <- lf[,1]    # extract column of occupation num.
  lf <- lf[,-1]
  lf <- select(lf,-starts_with("occ1990dd")) # drop non-skill variables for PCA
  
  #_______________________________________
  # COMPUTE VAR(SKILL) ACROSS OCCS
  variances <- apply(lf, 2,var)                       # var of each column
  
  variances <- data.frame(skills=names(variances),    # Convert to dataframe
                          var_skill=variances, 
                          row.names=NULL) 
  stopifnot(sum(variances$var_skill == 0) == 0)       # Check cols have non-zero variance 
  
  for (num in c(3,4,7)){
    
    #_______________________________________
    # REGULAR PCA
    if (normalPCA==TRUE){
      #_______________________________________
      # Compute PCA, scale to Mean=0, SD=1
      # Rank = num princ. components. (slower but more accurate than computing for all)
      lf.pca <- prcomp(lf, scale = TRUE, center = TRUE, rank. = num)  
      
      k <- lf.pca$x                         # Extract matrix output (J x numPC)
      
      #_______________________________________
      # Append occupation codes and export
      k <- data.frame(k)
      k$occ1990dd <- occ1990dd_list
      
      
      filename <- paste("../output/pca/pca",toString(g),"/pca_",toString(g), 
                        "s_",toString(num), 
                      ".csv", sep="", collapse=NULL)
      write.csv(k,filename)
      k$year <- g
      if (num == 3){
        if (g == 1940){
           pca_all3 <- k
        }else{
          pca_all3 <- rbind(pca_all3, k)
        }
      }else if (num == 4){
        if (g == 1940){
          pca_all4 <- k
        }else{
          pca_all4 <- rbind(pca_all4, k)
        }
      }else{
        if (g == 1940){
          pca_all7 <- k
        }else{
          pca_all7 <- rbind(pca_all7, k)
        }
      }
      
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
      filename <- paste("../output/spca/spca",toString(g),"/spca_",toString(g), 
                        "s_",toString(num), 
                        ".csv", sep="", collapse=NULL)
      write.csv(k,filename)
      k$year <- g
      if (num == 3){
        if (g == 1940){
          spca_all3 <- k
        }else{
          spca_all3 <- rbind(spca_all3, k)
        }
      }else if (num == 4){
        if (g == 1940){
          spca_all4 <- k
        }else{
          spca_all4 <- rbind(spca_all4, k)
        }
      }else{
        if (g == 1940){
          spca_all7 <- k
        }else{
          spca_all7 <- rbind(spca_all7, k)
        }
      }
    }
    
    
  }
  
  #_______________________________________
  # UPDATE TO NEXT DECADE
  g <- yeary
}

filename <- "../output/pca/pca_by_decade/pca_by_decade_3"
write.csv(pca_all3, filename)
filename <- "../output/pca/pca_by_decade/pca_by_decade_4"
write.csv(pca_all4, filename)
filename <- "../output/pca/pca_by_decade/pca_by_decade_7"
write.csv(pca_all7, filename)
filename <- "../output/spca/spca_by_decade/spca_by_decade_3"
write.csv(spca_all3, filename)
filename <- "../output/spca/spca_by_decade/spca_by_decade_4"
write.csv(spca_all4, filename)
filename <- "../output/spca/spca_by_decade/spca_by_decade_7"
write.csv(spca_all7, filename)




## Explore SPCA ---
summary(lf.pca)     # first PC explains 28% of variance in 1990s
summary(lf.spca)    # note that first PC explains 43% of variance in 1990s



# ~~~~~~~~~~~~~~~~~~~~
## EVERYTHING  -------
# ~~~~~~~~~~~~~~~~~~~~

#_______________________________________
# Load APST skills data 
df <- read_csv("../input/occ_skill.csv")     # cleaned by Alex
df <- arrange(df, year, occ1990dd)           # sort by year and occupation


occ1990dd_list <- pull(df, occ1990dd) 
year_list <- pull(df, year) 

df <- select(df,-starts_with("occ1990dd")) # drop non-skill variables for PCA
  
#_______________________________________
# COMPUTE VAR(SKILL) ACROSS OCCS
  variances <- apply(df, 2,var)                       # var of each column
  
  variances <- data.frame(skills=names(variances),    # Convert to dataframe
                          var_skill=variances, 
                          row.names=NULL) 
  stopifnot(sum(variances$var_skill == 0) == 0)  # Check cols have non-zero variance 
  
  
for (num in c(3,4,7)){
  
  #_______________________________________
  # REGULAR PCA
  if (normalPCA==TRUE){
    #_______________________________________
    # Compute PCA, scale to Mean=0, SD=1
    # Rank = num princ. components. (slower but more accurate than computing for all)
    df.pca <- prcomp(df, scale = TRUE, center = TRUE, rank. = num)  
    
    k <- df.pca$x                        # Extract matrix output (J x numPC)
    
    filename <- paste("../output/pca/pca_everything/pca_",toString(num), 
                      ".csv", sep="", collapse=NULL)
    
    #_______________________________________
    # Append occupation codes and export
    k <- data.frame(k)
    k$occ1990dd <- occ1990dd_list
    k$year <- year_list
    write.csv(k,filename)
  }
  
  #_______________________________________
  # SPARSE PCA
  if (sparsePCA==TRUE){
    #_______________________________________
    # Compute Sparse PCA, scale to Mean=0, SD=1
    # k = num princ. components. (slow but more accurate than computing for all) 
    # Robspca is robust to outliers.
    df.spca <- robspca(df, scale = TRUE, center = TRUE, k = num)  
    
    k <- df.spca$scores                       # Extract matrix output (J x numPC)
    
    filename <- paste("../output/spca/spca_everything/pca_",toString(num), 
                      ".csv", sep="", collapse=NULL)
    
    #_______________________________________
    # Append occupation codes and export
    k <- data.frame(k)
    k$occ1990dd <- occ1990dd_list
    k$year <- year_list
    write.csv(k,filename)
  }
  
  
}









#________________________________________
#
  #5yr pca


  df <- read_csv("../input/occ_skill.csv")     # cleaned by Alex
  df <- arrange(df, year, occ1990dd)           # sort by year and occupation
  df <- select(df, !starts_with("technology")) # drop tech because has zero variance for many occs/decades
  
  # ~~~~~~~~~~~~~~~~~~~~
  ## PCA BY DECADE ---
  # ~~~~~~~~~~~~~~~~~~~~
  
  g     <- 1970                                # start year
  years <- c(1975,1980,1985,1990,1995,2001)   # divide into decades
  for (yeary in years){
    
    lf <- df %>% filter(year>=g, year < yeary) # extract decade 
    
    #_______________________________________
    # COLLAPSE TO {DECADE} X {OCCUPATION}
    lf <- aggregate(lf[,-1:-2], list(lf$occ1990dd), mean)
    
    occ1990dd_list <- lf[,1]    # extract column of occupation num.
    lf <- lf[,-1]
    lf <- select(lf,-starts_with("occ1990dd")) # drop non-skill variables for PCA
    
    #_______________________________________
    # COMPUTE VAR(SKILL) ACROSS OCCS
    variances <- apply(lf, 2,var)                       # var of each column
    
    variances <- data.frame(skills=names(variances),    # Convert to dataframe
                            var_skill=variances, 
                            row.names=NULL) 
    stopifnot(sum(variances$var_skill == 0) == 0)       # Check cols have non-zero variance 
    print(variances[variances$var_skill == 0])
    for (num in c(3,4,7)){

      #_______________________________________
      # REGULAR PCA
      if (normalPCA==TRUE){
        #_______________________________________
        # Compute PCA, scale to Mean=0, SD=1
        # Rank = num princ. components. (slower but more accurate than computing for all)
        lf.pca <- prcomp(lf, scale = TRUE, center = TRUE, rank. = num)

        k <- lf.pca$x                         # Extract matrix output (J x numPC)

        #_______________________________________
        # Append occupation codes and export
        k <- data.frame(k)
        k$occ1990dd <- occ1990dd_list


        filename <- paste("../output/pca/pca",toString(g),"/pca_",toString(g),
                          "s_",toString(num),
                          ".csv", sep="", collapse=NULL)
        #write.csv(k,filename)
        k$year <- g
        if (num == 3){
          if (g == 1970){
            print('hey')
            pca_all3 <- k
          }else{
            pca_all3 <- rbind(pca_all3, k)
          }
        }else if (num == 4){
          if (g == 1970){
            pca_all4 <- k
          }else{
            pca_all4 <- rbind(pca_all4, k)
          }
        }else{
          if (g == 1970){
            pca_all7 <- k
          }else{
            pca_all7 <- rbind(pca_all7, k)
          }
        }

      }

    #   #_______________________________________
    #   # SPARSE PCA
      if (sparsePCA==TRUE){
        #_______________________________________
        # Compute Sparse PCA, scale to Mean=0, SD=1
        # k = num princ. components. (slow but more accurate than computing for all)
        # Robspca is robust to outliers.
        lf.spca <- robspca(lf, scale = TRUE, center = TRUE, k = num)

        k <- lf.spca$scores                       # Extract matrix output (J x numPC)


        #_______________________________________
        # Append occupation codes and export
        k <- data.frame(k)
        k$occ1990dd <- occ1990dd_list
        filename <- paste("../output/spca/spca",toString(g),"/spca_",toString(g),
                          "s_",toString(num),
                          ".csv", sep="", collapse=NULL)
        #write.csv(k,filename)
        k$year <- g
        if (num == 3){
          if (g == 1970){
            spca_all3 <- k
          }else{
            spca_all3 <- rbind(spca_all3, k)
          }
        }else if (num == 4){
          if (g == 1970){
            spca_all4 <- k
          }else{
            spca_all4 <- rbind(spca_all4, k)
          }
        }else{
          if (g == 1970){
            spca_all7 <- k
          }else{
            spca_all7 <- rbind(spca_all7, k)
          }
        }
      }


    }
    
    #_______________________________________
    # UPDATE TO NEXT DECADE
    g <- yeary
  }
  
  filename <- "../output/pca/pca_by_5yr/pca_by_5yr_3"
  write.csv(pca_all3, filename)
  filename <- "../output/pca/pca_by_5yr/pca_by_5yr_4"
  write.csv(pca_all4, filename)
  filename <- "../output/pca/pca_by_5yr/pca_by_5yr_7"
  write.csv(pca_all7, filename)
  filename <- "../output/spca/spca_by_5yr/spca_by_5yr_3"
  write.csv(spca_all3, filename)
  filename <- "../output/spca/spca_by_5yr/spca_by_5yr_4"
  write.csv(spca_all4, filename)
  filename <- "../output/spca/spca_by_5yr/spca_by_5yr_7"
  write.csv(spca_all7, filename)
  
  
  
  
  ## Explore SPCA ---
  summary(lf.pca)     # first PC explains 28% of variance in 1990s
  summary(lf.spca)    # note that first PC explains 43% of variance in 1990s
  
  








