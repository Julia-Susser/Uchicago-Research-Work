#this file takes the values in occ1990 and organizes them based off 1, 2 and 3 digits
import re
k = open("original_occ1990.txt")
jobs = list()
c = list()
subtitles = []
titles = []
listy = k.readlines()
for x in listy:
    y = x.replace("\n","").strip(" · · X X X X · X X · · X X X X X").strip(" X").strip("· ").strip("\n")
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




#print(jobs)
p = 1
jobs2 = []
for x in jobs:
    if type(x) is str:
        jobs2.append(x.strip(": "))
    elif x[0] == 'allocated (1990':
        pass
    else:
        j = " ".join(x)
        jobs2.append(j)


jobs2 = jobs2[1:]
three_digits = {}
two_digits = {}
types = []
nums = []
j = 3
headers = []
header_nums = []
k = 0
for x in jobs2:
    try:
        j = int(x.split()[0])
        three_digits[" ".join(x.split()[1:])] = j
        if k == 1:
            nums.append(j)
            k = 0
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
            header_nums.append(j)
        else:
            types.append(x)
            k = 1

nums.append(890)

types = types[1:]
nums = nums[1:]
two_digits_helper = dict()
for x in range(len(types)):
    two_digits[str(nums[x])+"/"+str(nums[x+1])] = types[x]
for x in range(len(types)):
    two_digits_helper[str(nums[x])] = types[x]

one_digits = {}
header_nums.append(999)
for x in range(len(headers)):
    one_digits[str(header_nums[x])+"/"+str(header_nums[x+1])] = headers[x]

file3 = open("../Desktop/two_digits.txt","w")
file3.write("two_digits = ")
file3.write("{")
n = 0
for x, y in two_digits.items():
    n += 1
    if len(two_digits) == n:
        file3.write("'" + x + "' : '" + y+"'")
    else:
        file3.write("'" + x + "' : '" + y+"', ")
file3.write("}")

n = 0
file6 = open("../Desktop/two_digits_dict.py", "w")
file6.write("#This will get you the occupation for two digit codes. \n")
file6.write("two_digits = ")
file6.write("{")
n = 0
for x, y in two_digits_helper.items():
    n += 1
    if len(two_digits_helper) == n:
        file6.write("'" + x + "' : '" + y+"'")
    else:
        file6.write("'" + x + "' : '" + y+"', ")
file6.write("}")

n = 0

file4 = open("../Desktop/three_digits.txt","w")
file4.write("three_digits = ")
file4.write("{")
for x, y in three_digits.items():
    n += 1
    if len(three_digits) == n:
        file4.write('"'+ x.lower() + '" : "' + str(y)+'"')
    else:
        file4.write('"' + x.lower() + '" : "' + str(y) +'", ')
file4.write("}")

n = 0
file5 = open("../Desktop/one_digits.txt","w")
file5.write("one_digits = ")
file5.write("{")
for x, y in one_digits.items():
    n += 1
    if len(one_digits) == n:
        file5.write("'" + str(x) + "' : '" + y+"'")
    else:
        file5.write("'" + str(x) + "' : '" + y+"', ")
file5.write("}")
