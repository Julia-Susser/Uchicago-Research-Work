#this file takes the values in occ1990 and organizes them based off 1, 2 and 3 digits
import re
k = open("original_ind1990..txt")
jobs = list()
c = list()
subtitles = []
titles = []
listy = k.readlines()
for x in listy:
    y = x.replace("\n","").strip(" · · X X X X · X X · · X X X X X").strip(" X").strip("· ").strip("\n")
    y = y.strip("\t")
    nums = re.findall("[0-9][0-9][0-9]", y)

    if y.isupper():
        jobs.append(c)
        jobs.append(y)
        titles.append(y)

    elif nums != []:
        if c not in jobs:
            jobs.append(c)
        c = list()
        c.append(y)

    elif (":" in y):
         subtitles.append(y)
         jobs.append(c)
         jobs.append(y)

    else:
        c.append(y)

jobs.append(c)



#print(jobs)
p = 1
jobs2 = []
for x in jobs:
    if type(x) is str:
        jobs2.append(x.strip(": "))
    else:
        j = " ".join(x)
        jobs2.append(j)


jobs2 = jobs2[1:]
three_digits = {}
two_digits = {}
types = []
nums = []
j = 0
headers = []
header_nums = []
k = 0
p = 0
for x in jobs2:
    try:
        j = int(x.split()[0])
        three_digits[" ".join(x.split()[1:])] = j
        if p == 1:
            header_nums.append(j)
            p = 0

    except IndexError:
        if x.isupper():
            headers.append(x)
            header_nums.append(j)
        else:
            types.append(x)
            nums.append(j)
    except ValueError:
        if x.isupper():
            headers.append(x)
            p = 1
        else:
            types.append(x)
            k = 1
header_nums.insert(0,0)
header_nums.append(998)
types = types[2:]

two_digits_helper = dict()

one_digits = {}
header_nums.append(999)
for x in range(len(headers)):
    one_digits[str(header_nums[x])+"/"+str(header_nums[x+1])] = headers[x]


n = 0

file4 = open("../Desktop/ind_three_digits.txt","w")
file4.write("ind_three_digits = ")
file4.write("{")
for x, y in three_digits.items():
    n += 1
    if len(three_digits) == n:
        file4.write('"'+ x.lower() + '" : "' + str(y)+'"')
    else:
        file4.write('"' + x.lower() + '" : "' + str(y) +'", ')
file4.write("}")

n = 0
file5 = open("../Desktop/ind_one_digits.txt","w")
file5.write("ind_one_digits = ")
file5.write("{")
for x, y in one_digits.items():
    n += 1
    if len(one_digits) == n:
        file5.write("'" + str(x) + "' : '" + y+"'")
    else:
        file5.write("'" + str(x) + "' : '" + y+"', ")
file5.write("}")
