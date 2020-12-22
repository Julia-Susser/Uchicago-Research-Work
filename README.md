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

<br/>
<br/>



<img width="534" alt="Screen Shot 2020-12-22 at 12 02 02 PM" src="https://user-images.githubusercontent.com/57605923/102928491-a36e0880-444d-11eb-8671-0de1f52eb2ba.png">
Path: ~ /Uchicago Research Work/Routineness Ad Graphs/src/Routineness v Specialization/routine_vs_specialization.Rmd
<br/>
Languages: R, ggplot2
<br/>
First, I read in a dataframe with dissimilarity within each two digit occupation and the values of routineness. Then, I filtered for 1975 and I merged in 2digit and 1 digit occupation labels. Next, I scaled the routineness and dissimilarity values from 0-1 through this formula: (value - minimum value for that column)  / (maximum value - minimum value). Next, I graphed the dissimilarity/specialization values on the x axis and the routineness values on the y axis. For example, the graph above shows that Tech/Manage/Professional is the most specialized and the most Nonroutine Analytic in 1975. 


<br/>
<br/>

<img width="343" alt="Screen Shot 2020-12-22 at 12 00 02 PM" src="https://user-images.githubusercontent.com/57605923/102928500-a5d06280-444d-11eb-87b3-0731c2e9bb41.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src/Graphs/R graphs/mean_log_wage_by_occ graph_3digit.Rmd
<br/>
Languages: R, ggplot2
<br/>
First, I split the data into two data frames with years 1983 and 2001 (max and min years).  Next for both dataframes, I grouped the data by three digit occupation and calculated the weighted mean log wage from each three digit occupation. To find the difference of the mean log wage between 1983 and 2001 for each three digit occupation, I contacted the two aggregate data frames and subtracted the 1983 mean log wage from the 2001 mean log wage. Then, I merged in the one digit occupation labels with the data frame. Finally, I plotted the data. I plotted the three digit occupation on the x column but reordered by 1983 occupational mean log wage. On the y column, I plotted change in mean log hourly wage. Along with creating a smooth line that highlighted trends, I filled the data points based on the one digit occupation.

<br/>
<br/>



<img width="361" alt="Screen Shot 2020-12-22 at 12 00 09 PM" src="https://user-images.githubusercontent.com/57605923/102928501-a7018f80-444d-11eb-98d8-f507599744b0.png">
Path: ~ /Uchicago Research Work/Compute distance-dissimilarity/src/plotting/2digit_plotting.Rmd
<br/>
Languages: R, ggplot2
<br/>
I read in the PCA data for SPCA with 7 PCs. Then I split the dataframe by the decade, so I had a dataframes with the 2digit weighted dissimilarity for 1980s and 1990s. Next, I merged the data frames by 2digit occupation, and for each 2digit occupation, I subtracted the weighted dissimilarity 1980s from the weighted dissimilarity 1990s. Before graphing, I merged in 1 digit occupational labels. On the y axis, I graphed the change dissimilarity/specialization for each two digit occupation. Indeed, this shows that Production and Operators had the greatest change in dissimilarity/specialization.



<br/>
<br/>


<img width="548" alt="Screen Shot 2020-12-22 at 11 59 22 AM" src="https://user-images.githubusercontent.com/57605923/102928502-a79a2600-444d-11eb-9711-be76db53811d.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src//Graphs/annual hours
<br/>
Languages: Python, Pandas, Matplotlib, Numpy
<br/>
To create this graph, I made an array of arrays. First, I created an array by sex, then inside of it, I created an arrays by year. Next, I created a loop where I first grabbed the male array then the female array, and inside  of this loop, I calculated the weighted mean annuals by year of the inner array and plotted the line. 


<br/>
<br/>


<img width="377" alt="Screen Shot 2020-12-22 at 12 00 23 PM" src="https://user-images.githubusercontent.com/57605923/102928503-a832bc80-444d-11eb-9816-fa874b5ca7a5.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src/Graphs/R graphs/men-wage-school.Rmd
<br/>
Languages: R, ggplot2
<br/>
FIrst, I read in CPS wage data and filtered for Men who were older than 25 and younger than 54. Next, I read in a data frame with educational codes from school. Merged the CPS data with educational codes by year school column. Labeled the educational codes depending on the values (IPUMS CPS). Grouped the data by type and year and found mean real hourly wage. Graphed the year and real hourly wage for each type of education. Graph highlights how the difference in wage between degrees has become more significant, speaking to income inequality. One explanation for this could be the greater amount of people that are having higher education.


<br/>
<br/>


<img width="367" alt="Screen Shot 2020-12-22 at 11 59 28 AM" src="https://user-images.githubusercontent.com/57605923/102928504-a832bc80-444d-11eb-8d67-889a2b17ea91.png">
Path: ~ /Dropbox/thesis/4_CPS/clean_HPV/src/Graphs/annual hours
<br/>
Languages: Python, Pandas, Matplotlib, Numpy
<br/>
Variance Graph: To create the variance graph, I created an array of arrays. First, I created an array by sex, then inside of it, I created arrays by year. Next, I created a loop where I first grabbed the male array then female, and inside of this loop, I went through each year and calculated the weighted variance of the log hourly wage. To do this I found the weighted average log hourly wage and then used average a to find the weighted log hourly wage variance manually. Plotted the line after there was a new sex.
<br/>
Average Wage Graph: To create this graph, I made an array of arrays. First, I created an array by sex, then inside of it, I created an array by year. Next, I created a loop where I first grabbed the male array then the female array, and inside  of this loop, I calculated the weighted mean average wage by year of the inner array and plotted the line. 


<br/>
<br/>


<img width="522" alt="Screen Shot 2020-12-22 at 12 00 33 PM" src="https://user-images.githubusercontent.com/57605923/102928505-a8cb5300-444d-11eb-9d84-3ac215c11538.png">
Path: ~ /Uchicago Research Work/Compute distance-dissimilarity/src/plotting/1digit_plotting.Rmd
<br/>
Languages: R, ggplot2
<br/>
I read in the regular  PCA data with 3 PCs in 5 year bins. Then, I adjusted 1 digit occupational labels and graphed how dissimilarity within 1 digit occupations changed overtime. Indeed, Technology/Management has the greatest specialization compared to the other sectors. 


<br/>
<br/>

<img width="534" alt="Screen Shot 2020-12-22 at 11 59 44 AM" src="https://user-images.githubusercontent.com/57605923/102928507-a8cb5300-444d-11eb-973d-2c78f743a0f5.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src/Graphs/R graphs/years_school v wage graph.Rmd
<br/>
Language: R, ggplot2
<br/>
First, I split the dataframe by the year's school constraints and added the labels (CLG, GTC or ect.). Next, I concatted the split dataframes, which now had years of school labels. Then I grouped the new dataframe by sex, label and year to find the aggregate mean log wage.  Next, I filtered through the aggregate dataframe, which had a new mean log wage for every sex, label and year, and plotted the lines. 


<br/>
<br/>



<img width="302" alt="Screen Shot 2020-12-22 at 12 01 53 PM" src="https://user-images.githubusercontent.com/57605923/102928509-a963e980-444d-11eb-9521-14d401712634.png">
Path: ~ /Uchicago Research Work/Routineness Ad Graphs/src/Dissimilarity sorted/dissimilarity-sorted-routineness.Rmd
<br/>
Languages: R, ggplot2
<br/>
I read in the regular PCA data with 3 PCs. Then I split the dataframe by the decade, so I had a dataframes with the 2digit weighted dissimilarity for 1980s and 1990s. Next, I merged the data frames by 2digit occupation, and for each 2digit occupation, I subtracted the weighted dissimilarity 1980s from the weighted dissimilarity 1990s. Then, I merged in 1 digit occupational codes to get the labels. Next, I read in dta file of routineness and grouped by 2 digit occupation in 1983 to find weighted routines for each 2digit occupation. Finally, I merged the weighted routineness in 1983 data with the PCA code. Next, I sorted the 2digit occupations by routineness and put number id on each occupation by routines. On the y axis, I graphed the change dissimilarity/specialization. On the x-axis, I graphed the ids of each occupation and added their names as labels. Because I used number ids on the x-axis, I could add a smooth line to fit the data. The graph highlights how jobs that require more routine manual skill (based on ads) have become more similar to each other, as the average total distances from the mean of PCs of the jobs within those sectors has become smaller.

<br/>
<br/>


<img width="398" alt="Screen Shot 2020-12-22 at 11 59 51 AM" src="https://user-images.githubusercontent.com/57605923/102928510-a963e980-444d-11eb-857c-77c0f92e14ee.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src/Graphs/R graphs/mean_log_wage_2digit.Rmd
<br/>
Languages: R, ggplot2
<br/>
First, I split the data into two data frames with years 1983 and 2001 (max and min years).  Next, for both dataframes, I grouped the data by two digit occupation and calculated the weighted mean log wage from each two digit occupation. To find the difference of the mean log wage between 1983 and 2001 for each two digit occupation, I contacted the two aggregate data frames and subtracted the 1983 mean log wage from the 2001 mean log wage. Then, I merged in the two digit occupations labels and one digit occupation labels with the dataframe. Finally, I plotted the data in  a bar chart. I plotted the two digit occupation on the x column but reordered the occupations by 1983 occupational mean log wage. On the y column, I plotted change in mean log hourly wage. I also filled the bar chart based on one digit occupation.
<br/>
Analysis: This graph highlights how medium wage jobs have decreased in wage due to automation. Between 1980-2000, production was automated and therefore there was less need for people in the Production/Operators field. The Production/Operators field used to be unpleasant jobs in a factory, so they were medium wage. However, now that there is no need for factory workers, there are Production/Operating jobs because almost all the work has been replaced by machines. Therefore, more people have been diverted to Service jobs or in some cases, higher expertised jobs.


<br/>
<br/>


<img width="557" alt="Screen Shot 2020-12-22 at 12 01 27 PM" src="https://user-images.githubusercontent.com/57605923/102928518-ae289d80-444d-11eb-9073-eba62b77f1b6.png">
Path: ~ /Uchicago Research Work/Routineness Ad Graphs/src/routineness occ graphs/keyword-1digit.Rmd
<br/>
First, I read in the occupational advertisement dataset from a dta file. Then, I grouped by one digit occupation and year to find the weighted mean of each of these skills. The weights were the number of ads about each 3digit occupation occupation. Next, I merged in 1digit occupation labels and graphed the weighted mean mentions of each skill per ad on the y axis over time. This graph mirrors a published research paper to confirm that our data was correct.

<br/>
<br/>


<img width="603" alt="Screen Shot 2020-12-22 at 11 59 09 AM" src="https://user-images.githubusercontent.com/57605923/102928531-b1bc2480-444d-11eb-9d15-84db1acc9e1b.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src/Graphs/percent one-digit-occ
<br/>
Languages: Python, Pandas, Matplotlib
<br/>
First, I grouped the data by sex and year; then I made an aggregate dataframe with the weighted number of rows.  Next, I made another dataframe that grouped the data by sex, year and one digit occupation and also made an aggregate of the weighted number of rows. Then, I merged the dataframes by sex and year and calculated the percent of workers in each occupation by year. Next I went through the aggregate dataframe and plotted a new line each time there was a new 1digit occupation.


<br/>
<br/>

<img width="478" alt="Screen Shot 2020-12-22 at 11 59 17 AM" src="https://user-images.githubusercontent.com/57605923/102928533-b254bb00-444d-11eb-9b05-9d570f9eeb14.png">
Path: ~ /Uchicago Research Work/CPS Cleaning and Graphs/src/Graphs/average age
<br/>
Languages: Python, Pandas, Matplotlib, Numpy
<br/>
To create this graph, I made an array of arrays. First, I created an array by sex, then inside of it, I created an arrays by year. Next, I created a loop where I first grabbed the male array then the female array, and inside  of this loop, I calculated the weighted mean average age by year of the inner array and plotted the line. 

<br /><br /><br /><br />


PCA Code: 
<br />
Principal Component Analysis determines whether occupations have become more similar to each other over time based on the skills required (data gathered through employment advertisements). PCA code uses multiple linear regressions and different variables to group items, in this case occupations. First, I created a matrix with each occupation and skill. Then, I ran this matrix through the PCA code, which created another matrix with each occupation and its PC values. PC values are determined by where the occupation is on each regression line. The regression lines are the best fit line for all of the occupations based on the skills required. Indeed, each regression line (PC) has a different value for each occupation.  However, since PC2 finds a regression line that is perpendicular to PC1, and PC3 finds a regression line that is perpendicular to PC1 and PC2, etc. PC1 accounts for the most variance between occupations. In short, PCA code takes the skills for each occupation and is able to put a value on each occupation based on where it falls on the regression line of skills for each occupation. These PC values demonstrate how similar and different each occupation is. 
<br />
First, I read in a dataframe with the occupations versus skills. Next I sorted the dataframe by year and three digit occupations. To compute the PCA by decade, I created a for loop that filtered through the data from each decade. In this loop, I found the aggregate mean skill of each occupation in the decade. Next, I had to check that all columns had a variance in skills because otherwise I would not be able to scale the PCA code as there would be a zero division error. To do this I first applied a variance to each column (skill). If the number of skills with a variance of zero did not equal zero then the function would stop. This code returns a dataframe with the PCs for each occupation. I wrote the PCA code by decade, 5year bins and all years into different csv files. 
<br />
I ran the PCA using this function:
 prcomp(lf, scale = TRUE, center = TRUE, rank. = num)  
I ran the Sparce PCA using this function:
lf.spca <- robspca(lf, scale = TRUE, center = TRUE, k = num)  
I ran the kernel PCA using this function: 
kpc <- kpca(~.,data=df,kernel="rbfdot", kpar=list(sigma=0.2),features=7)
*It is slower if you calculate the PCA with the number of PCs that you want but it is also more accurate. I used 3,4 and 7 PCs, so I ran this function three times per decade. 
<br />
<br />

Calculating Dissimilarity/Specialization: 
<br />
The PCA code gave us a matrix with PC values for each occupation. By computing the average variation of the PCs for each occupation within a sector, we are able to put a number on the similarity of jobs in a certain occupational sector. The number is the dissimilarity within an occupation also known as the specialization.
<br />
<br />
I read in the CPS and PCA data. I grouped the CPS data by 3 digit occupations and decade to find the weighted number of people in each occupation. Next I grouped the PCA data by 2 digit occupation and decade to find the weighted average PCs for each 2digit occupation. By finding the distance of each 3digit PC from the weighted mean PC of their 2digit occupation, I was able to calculate the distance from the mean of each PC. To find the total distance from the 2digit occupation PC mean, I added up all the distances (PC1 + PC2 + ect.) . To find the dissimilarity within each two digit occupation, I found the weighted mean of each 3digit occupation's total distance. I completed this process with 3,4,and 7 PCs, between 5 year bins and for the dissimilarity within 1 digit occupations. 




