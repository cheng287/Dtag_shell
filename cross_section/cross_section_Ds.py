#!/usr/bin/python
import os
import sys
import string
import math


# open the file in read mode
with open('Nsig_mode401.txt', 'r') as file:
    # read the file and split each line into a list of strings
    lines = [line.strip().split() for line in file]

# use list comprehension to create 4 separate lists of values
energy_point = [float(line[0]) for line in lines]
nickname = [float(line[1]) for line in lines]
luminosity = [float(line[2]) for line in lines]
number_signal = [float(line[3]) for line in lines]
signal_error = [float(line[4]) for line in lines]


# print the lists to verify the data was read correctly
print(energy_point)
print(nickname)
print(luminosity)
print(number_signal)
print(signal_error)

#- - - - - - -  - - -
n = len(energy_point)
cross_section = [0]*n
cross_section_error = [0]*n

# branch_ratio = 0.03947     #- - - D0 -> k- pi+
# branch_ratio = 0.0938     #- - - D+ -> k- pi+ pi+    ( 9.38 ± 0.16 ) %
branch_ratio = 0.0538     #- - - Ds+ -> k- k+ pi+

write_file = open('obs_cross_section_mode401.txt',"w")
write_file.writelines("CMS_energy         cross_section         cross_section_error\n")

i = 0
while(i<n):
    cross_section[i] = number_signal[i]/luminosity[i]/branch_ratio
    cross_section_error[i] = signal_error[i]/luminosity[i]/branch_ratio
   
    write_file.writelines(f"{energy_point[i]}                ")
    write_file.writelines(f"{cross_section[i]}               ")
    write_file.writelines(f"{cross_section_error[i]}")
    write_file.writelines("\n")
    i= i+1


energy_point.clear()
nickname.clear()
luminosity.clear()
number_signal.clear()
cross_section.clear()
