#!/bin/bash

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

#/////////////////////////////////////////////////////////////////////////////////////
#- - - for decay_mode.txt
while read -r col1 
do
    decay_mode_points+=("$col1")  
done < ../decay_mode_and_infor/decay_mode.txt

echo "number of decay mode points   =   ${#decay_mode_points[@]}"

#/////////////////////////////////////////////////////////////////////////////////////
#- - - for infor.txt

# 定义5个空数组
unset energy_points
unset luminostiy_points
unset runnu_low
unset runnu_high
unset CMS_energy 

energy_points=()      
luminostiy_point=()
runnu_low=()         
runnu_high=()      
CMS_energy=()    


# 逐行读取文件，并将每一列数据存入相应的数组
while read -r col1 col2 col3 col4 col5
do
    energy_points+=("$col1")
    luminostiy_points+=("$col2")
    runnu_low+=("$col3")
    runnu_high+=("$col4")
    CMS_energy+=("$col5")
    
done < ../decay_mode_and_infor/infor.txt

# # 打印每个数组的内容
echo -e "\n energy points : "
    echo ${energy_points[*]}          #* * * * * energy_points list          ep_i     count variable  
echo -e "\n luminosity points : "
    echo ${luminostiy_points[*]}      #* * * * * luminostiy list             lp_i     count variable             
echo -e "\n run number low : "
    echo ${runnu_low[*]}              #* * * * * run number low list         rl_i     count variable  
echo -e "\n run number high : "   
    echo ${runnu_high[*]}             #* * * * * run number high list        rh_i     count variable 
echo -e "\n CMS energy : "   
    echo ${CMS_energy[*]}             #* * * * * CMS energy list             Ce_i     count variable      

echo "number of energy points       =   ${#energy_points[@]}"
echo "number of luminosity points   =   ${#luminostiy_points[@]}"
echo "number of run number low      =   ${#runnu_low[@]}"
echo "number of run number high     =   ${#runnu_high[@]}"
echo "number of CMS energy          =   ${#CMS_energy[@]}"



#///////////////////////////////////////////////////////////////////////////////////////////////////

#///////////////////////////////////////////////////////////////////////////////////////////////////



##* * ep_i=0   #* * * energy point   
##* * dm_i=0   #* * * decay mode
##* * rl_i=0   #* * * run number low
##* * rh_i=0   #* * * run number high
##* * lp_i=0   #* * * luminosity

mypath=$PWD
DataParentPath1=../output  
jobName=$1     #* * * jobName : the name of job will like "jobName_????.txt" 

if [ $# -ne 1 ]
then
    echo "* * * * * Be careful, only should one paramter * * * * *  "
    echo "./sub_make_hello_mode.sh jobname"
    exit
fi

dm_i=0       #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do               
    ep_i=0   #* * * energy point 
    for cout_ii in ${energy_points[@]}
    do 
        
        if [ -d "$DataParentPath1/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}" ]
        then
            echo "$DataParentPath1/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]} is ok"
        else
            echo "* * * * * * * * * * * *  $DataParentPath1/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]} is not exit ! ! !"
            let ep_i++
            continue
        fi

        cd ${DataParentPath1}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}
        ls weight_${jobName}*.cpp |sort > temp_cpp.txt

     
        unset file_number
        IFS=$'\n' file_number=($(cat temp_cpp.txt))
        for xy in $(seq ${#file_number[*]})
        do
            [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
            
            sed -e "s/XXX/ /g" ${mypath}/sub_sh.head > ./${file_number[$xy-1]}.sh
            
            echo "root -b -q ${PWD}/${file_number[$xy-1]}" >> ./${file_number[$xy-1]}.sh
            chmod +x ${file_number[$xy-1]}.sh

            echo "hep_sub ${file_number[$xy-1]}"
            hep_sub ${file_number[$xy-1]}.sh
        done

        cd $mypath
        let ep_i++
    done

    let dm_i++
done

