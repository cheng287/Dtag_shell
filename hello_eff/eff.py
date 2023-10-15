#!/usr/bin/python
import os
import sys
import string
import math


input_file = 'Nsig.txt'
infile = open(input_file,"r")
Nsig = infile.readlines()
infile.close()

Nsig = [float(x) for x in Nsig]
#print(Nsig)

n = len(Nsig)
eff = [0]*n
#print(eff)

weight = [0]*n

MC_number = 5000

j = 0 
for i in Nsig:
    eff[j] = i/MC_number
    weight[j] = MC_number/i
    j = j + 1
#print(eff)

#write_file = open('eff.txt',"a")
write_file = open('eff.txt',"w")
for i in eff:
    write_file.writelines(f"{i}")
    write_file.writelines("\n")

wgt_file = open('weight.txt',"w")
for i in weight:
    wgt_file.writelines(f"{i}")
    wgt_file.writelines("\n")

Nsig.clear()
eff.clear()
weight.clear()

