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



<img width="534" alt="Screen Shot 2020-12-22 at 12 02 02 PM" src="https://user-images.githubusercontent.com/57605923/102928491-a36e0880-444d-11eb-8671-0de1f52eb2ba.png">
Path: ~ /Uchicago Research Work/Routineness Ad Graphs/src/Routineness v Specialization/routine_vs_specialization.Rmd
Languages: R, ggplot2
First, I read in a dataframe with dissimilarity within each two digit occupation and the values of routineness. Then, I filtered for 1975 and I merged in 2digit and 1 digit occupation labels. Next, I scaled the routineness and dissimilarity values from 0-1 through this formula: (value - minimum value for that column)  / (maximum value - minimum value). Next, I graphed the dissimilarity/specialization values on the x axis and the routineness values on the y axis. For example, the graph above shows that Tech/Manage/Professional is the most specialized and the most Nonroutine Analytic in 1975. 


<img width="343" alt="Screen Shot 2020-12-22 at 12 00 02 PM" src="https://user-images.githubusercontent.com/57605923/102928500-a5d06280-444d-11eb-87b3-0731c2e9bb41.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src/Graphs/R graphs/mean_log_wage_by_occ graph_3digit.Rmd
Languages: R, ggplot2
First, I split the data into two data frames with years 1983 and 2001 (max and min years).  Next for both dataframes, I grouped the data by three digit occupation and calculated the weighted mean log wage from each three digit occupation. To find the difference of the mean log wage between 1983 and 2001 for each three digit occupation, I contacted the two aggregate data frames and subtracted the 1983 mean log wage from the 2001 mean log wage. Then, I merged in the one digit occupation labels with the data frame. Finally, I plotted the data. I plotted the three digit occupation on the x column but reordered by 1983 occupational mean log wage. On the y column, I plotted change in mean log hourly wage. Along with creating a smooth line that highlighted trends, I filled the data points based on the one digit occupation.


<img width="361" alt="Screen Shot 2020-12-22 at 12 00 09 PM" src="https://user-images.githubusercontent.com/57605923/102928501-a7018f80-444d-11eb-98d8-f507599744b0.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src//Graphs/annual hours
Languages: Python, Pandas, Matplotlib, Numpy
To create this graph, I made an array of arrays. First, I created an array by sex, then inside of it, I created an arrays by year. Next, I created a loop where I first grabbed the male array then the female array, and inside  of this loop, I calculated the weighted mean annuals by year of the inner array and plotted the line. 


<img width="548" alt="Screen Shot 2020-12-22 at 11 59 22 AM" src="https://user-images.githubusercontent.com/57605923/102928502-a79a2600-444d-11eb-9711-be76db53811d.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src/Graphs/R graphs/men-wage-school.Rmd
Languages: R, ggplot2
FIrst, I read in CPS wage data and filtered for Men who were older than 25 and younger than 54. Next, I read in a data frame with educational codes from school. Merged the CPS data with educational codes by year school column. Labeled the educational codes depending on the values (IPUMS CPS). Grouped the data by type and year and found mean real hourly wage. Graphed the year and real hourly wage for each type of education. Graph highlights how the difference in wage between degrees has become more significant, speaking to income inequality. One explanation for this could be the greater amount of people that are having higher education.



<img width="377" alt="Screen Shot 2020-12-22 at 12 00 23 PM" src="https://user-images.githubusercontent.com/57605923/102928503-a832bc80-444d-11eb-9816-fa874b5ca7a5.png">
Path: ~ /Dropbox/thesis/4_CPS/clean_HPV/src/Graphs/annual hours
Languages: Python, Pandas, Matplotlib, Numpy
Variance Graph: To create the variance graph, I created an array of arrays. First, I created an array by sex, then inside of it, I created arrays by year. Next, I created a loop where I first grabbed the male array then female, and inside of this loop, I went through each year and calculated the weighted variance of the log hourly wage. To do this I found the weighted average log hourly wage and then used average a to find the weighted log hourly wage variance manually. Plotted the line after there was a new sex.

Average Wage Graph: To create this graph, I made an array of arrays. First, I created an array by sex, then inside of it, I created an array by year. Next, I created a loop where I first grabbed the male array then the female array, and inside  of this loop, I calculated the weighted mean average wage by year of the inner array and plotted the line. 


<img width="367" alt="Screen Shot 2020-12-22 at 11 59 28 AM" src="https://user-images.githubusercontent.com/57605923/102928504-a832bc80-444d-11eb-8d67-889a2b17ea91.png">
Path: ~ /Uchicago Research Work/Compute distance-dissimilarity/src/plotting/1digit_plotting.Rmd
Languages: R, ggplot2
I read in the regular  PCA data with 3 PCs in 5 year bins. Then, I adjusted 1 digit occupational labels and graphed how dissimilarity within 1 digit occupations changed overtime. Indeed, Technology/Management has the greatest specialization compared to the other sectors. 


<img width="522" alt="Screen Shot 2020-12-22 at 12 00 33 PM" src="https://user-images.githubusercontent.com/57605923/102928505-a8cb5300-444d-11eb-9d84-3ac215c11538.png">

<img width="534" alt="Screen Shot 2020-12-22 at 11 59 44 AM" src="https://user-images.githubusercontent.com/57605923/102928507-a8cb5300-444d-11eb-973d-2c78f743a0f5.png">

<img width="302" alt="Screen Shot 2020-12-22 at 12 01 53 PM" src="https://user-images.githubusercontent.com/57605923/102928509-a963e980-444d-11eb-9521-14d401712634.png">

<img width="398" alt="Screen Shot 2020-12-22 at 11 59 51 AM" src="https://user-images.githubusercontent.com/57605923/102928510-a963e980-444d-11eb-857c-77c0f92e14ee.png">

<img width="557" alt="Screen Shot 2020-12-22 at 12 01 27 PM" src="https://user-images.githubusercontent.com/57605923/102928518-ae289d80-444d-11eb-9073-eba62b77f1b6.png">
<img width="708" alt="Screen Shot 2020-12-22 at 11 51 02 AM" src="https://user-images.githubusercontent.com/57605923/102928530-b1238e00-444d-11eb-9b1f-1d8bf1268ddf.png">
<img width="603" alt="Screen Shot 2020-12-22 at 11 59 09 AM" src="https://user-images.githubusercontent.com/57605923/102928531-b1bc2480-444d-11eb-9d15-84db1acc9e1b.png">
<img width="478" alt="Screen Shot 2020-12-22 at 11 59 17 AM" src="https://user-images.githubusercontent.com/57605923/102928533-b254bb00-444d-11eb-9b05-9d570f9eeb14.png">


