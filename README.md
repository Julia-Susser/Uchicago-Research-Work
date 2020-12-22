# Uchicago-Research-Work

My Work with Economic Researcher Alex Weinberg:
May-September, 35hrs per week
Languages: R (ggplot2), Python (Pandas, Numpy, Matplotlib)

Cleaned CPS government Employment Data according to HPV 2010 paper
  1.Merged in and cleaned occupational and educational codes from IPUMS CPS
  2.Dropped rows depending on different conditions; replaced values for codes
  3.Calculated wages using CPI and federal minimum wage data
  
Coded Kernel, Sparse and Regular PCA and then calculated dissimilarity/specialization within sectors.
  1.Principal Component Analysis determines whether occupations have become more similar to each other over time based on the skills required (data gathered through employment advertisements). PCA code uses multiple linear regressions and different variables to group items, in this case occupations.
  2.The PCA code gave us a matrix with PC values for each occupation. By computing the average distance of the PCs from the average PC in their sector, I was able to put a number on the similarity of jobs in a certain occupational sector. 

Found how routineness changed for each occupation over time based on advertisement data.
  1.Found how Routine Manual, Nonroutine Manual, Nonroutine Analytic, Nonroutine Interactive, Routine Cognitive skills changed for sectors by finding the weighted mean of each skill within a sector. 


