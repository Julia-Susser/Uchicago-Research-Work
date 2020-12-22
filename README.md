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


<img width="343" alt="Screen Shot 2020-12-22 at 12 00 02 PM" src="https://user-images.githubusercontent.com/57605923/102928500-a5d06280-444d-11eb-87b3-0731c2e9bb41.png">


<img width="361" alt="Screen Shot 2020-12-22 at 12 00 09 PM" src="https://user-images.githubusercontent.com/57605923/102928501-a7018f80-444d-11eb-98d8-f507599744b0.png">
<img width="548" alt="Screen Shot 2020-12-22 at 11 59 22 AM" src="https://user-images.githubusercontent.com/57605923/102928502-a79a2600-444d-11eb-9711-be76db53811d.png">
<img width="377" alt="Screen Shot 2020-12-22 at 12 00 23 PM" src="https://user-images.githubusercontent.com/57605923/102928503-a832bc80-444d-11eb-9816-fa874b5ca7a5.png">
<img width="367" alt="Screen Shot 2020-12-22 at 11 59 28 AM" src="https://user-images.githubusercontent.com/57605923/102928504-a832bc80-444d-11eb-8d67-889a2b17ea91.png">
<img width="522" alt="Screen Shot 2020-12-22 at 12 00 33 PM" src="https://user-images.githubusercontent.com/57605923/102928505-a8cb5300-444d-11eb-9d84-3ac215c11538.png">
<img width="534" alt="Screen Shot 2020-12-22 at 11 59 44 AM" src="https://user-images.githubusercontent.com/57605923/102928507-a8cb5300-444d-11eb-973d-2c78f743a0f5.png">
<img width="302" alt="Screen Shot 2020-12-22 at 12 01 53 PM" src="https://user-images.githubusercontent.com/57605923/102928509-a963e980-444d-11eb-9521-14d401712634.png">
<img width="398" alt="Screen Shot 2020-12-22 at 11 59 51 AM" src="https://user-images.githubusercontent.com/57605923/102928510-a963e980-444d-11eb-857c-77c0f92e14ee.png">
<img width="557" alt="Screen Shot 2020-12-22 at 12 01 27 PM" src="https://user-images.githubusercontent.com/57605923/102928518-ae289d80-444d-11eb-9073-eba62b77f1b6.png">
<img width="708" alt="Screen Shot 2020-12-22 at 11 51 02 AM" src="https://user-images.githubusercontent.com/57605923/102928530-b1238e00-444d-11eb-9b1f-1d8bf1268ddf.png">
<img width="603" alt="Screen Shot 2020-12-22 at 11 59 09 AM" src="https://user-images.githubusercontent.com/57605923/102928531-b1bc2480-444d-11eb-9d15-84db1acc9e1b.png">
<img width="478" alt="Screen Shot 2020-12-22 at 11 59 17 AM" src="https://user-images.githubusercontent.com/57605923/102928533-b254bb00-444d-11eb-9b05-9d570f9eeb14.png">


