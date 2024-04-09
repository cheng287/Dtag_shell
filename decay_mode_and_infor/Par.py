#!/usr/bin/python

#for b in range(-10,10,1):
#   for a in range(5,150,10):
#      print a/100.0,(a+10)/100.0,b/10.0,(b+1)/10.0



#- - -  - - -2023/5/8
# write_file = open('Par.list','w')

# for b in range(-10,10,1):
#    for a in range(0,250,10):
#       write_file.write(f"{a/100.0}     {(a+10)/100.0}    {b/10.0}    {(b+1)/10.0} \n")



write_file = open('costheta.list','w')

for b in range(-10,10,1):
   write_file.write(f"{b/10.0}    {(b+1)/10.0} \n")
