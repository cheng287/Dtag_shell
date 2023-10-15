#!/bin/bash

if [ -e Nsig.txt ] 
then 
    rm Nsig.txt 
fi

unset number
j=0
IFS=$'\n' number=($(cat ../output/fit/result_mode_*.txt))             
for i in $(seq ${#number[*]})
do
    [[ ${number[$i-1]} = $name ]] && echo "${number[$i]}"
    #echo "${number[$i-1]}" |awk -F ' ' '{print $3,$4}'
    if [ $i -ne 1 ]
    then
        echo ${number[$i-1]} |awk -F ' ' '{print $8}' >> Nsig.txt
        let j++
    fi
done




















# #!/bin/bash

# if [ -e Nsig.txt ] 
# then 
#     rm Nsig.txt 
# fi

# # ls ../output/fit/result_mode*.cpp |sort > ./temp_res.txt
# # unset file_number
# # unset number


# # IFS=$'\n' file_number=($(cat ./temp_res.txt))          
# # for i in $(seq ${#file_number[*]})
# # do
# #     [[ ${file_number[$i-1]} = $name ]] && echo "${file_number[$i]}"
# #     #echo "${number[$i-1]}" |awk -F ' ' '{print $3,$4}'

# #     j=0 
# #     IFS=$'\n' number=($(cat ../output/fit/${file_number[$i-1]}))          
# #     for n in $(seq ${#number[*]})
# #     do
# #         [[ ${number[$n-1]} = $name ]] && echo "${number[$n]}"
# #         #echo "${number[$n-1]}" |awk -F ' ' '{print $3,$4}'
# #         if [ $n -ne 1 ]
# #         then
# #             echo ${number[$n-1]} |awk -F ' ' '{print $9}' >> Nsig.txt
# #             let j++
# #         fi
# #     done
    
# # done








# #- - - - - - -  - - - - -
# unset number
# j=0
# # IFS=$'\n' number=($(cat ./fit/mode_0/result_3770_mode_0_charm_p1.txt))    
# IFS=$'\n' number=($(cat ../output/fit/result_mode*.txt))          
# for i in $(seq ${#number[*]})
# do
#     [[ ${number[$i-1]} = $name ]] && echo "${number[$i]}"
#     #echo "${number[$i-1]}" |awk -F ' ' '{print $3,$4}'
#     if [ $i -ne 1 ]
#     then
#         echo ${number[$i-1]} |awk -F ' ' '{print $9}' >> Nsig.txt
#         let j++
#     fi
# done


# # if [ -e temp_res.txt ] 
# # then 
# #     rm temp_res.txt 
# # fi