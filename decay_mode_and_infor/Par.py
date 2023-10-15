#!/usr/bin/python

#for b in range(-10,10,1):
#   for a in range(0,250,10):
#      print a/100.0,(a+10)/100.0,b/10.0,(b+1)/10.0


write_file = open('Par.list','w')

for b in range(-10,10,1):
   for a in range(0,250,10):
      write_file.write(f"{a/100.0}     {(a+10)/100.0}    {b/10.0}    {(b+1)/10.0} \n")