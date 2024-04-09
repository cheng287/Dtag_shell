#!/bin/bash

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *



#/////////////////////////////////////////////////////////////////////////////////////

    #* * * * * * * * * * Read energy point information * * * * * * *begin

    #-----infor.txt          energy_points   luminostiy_points  run_number_low   run_number_high    center-of-mass_energy      run_number_low1   run_number_high2
    #-----decay_mode.txt     different_decay_mode

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - 

# infor=()
energy_points=()
luminostiy_points=()
runnu_low=()
runnu_high=()
CMS_energy=()
decay_mode_points=()

# unset infor
unset energy_points
unset luminostiy_points
unset runnu_low
unset runnu_high
unset CMS_energy
unset decay_mode_points

unset runnu_low_1
unset runnu_high_1




#- - - for infor.txt
while read -r col1 col2 col3 col4 col5   col6  col7
do
    energy_points+=("$col1")
    luminostiy_points+=("$col2")
    runnu_low+=("$col3")
    runnu_high+=("$col4")
    CMS_energy+=("$col5")
    runnu_low_1+=("$col6")
    runnu_high_1+=("$col7")   
done < ../decay_mode_and_infor/infor.txt


#- - - for decay_mode.txt
while read -r col1 
do
    decay_mode_points+=("$col1")  
done < ../decay_mode_and_infor/decay_mode.txt


echo -e "\n\n\n* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
echo "* * * * * * * * * * * * * Physics - - Summary * * * * * * * * * * * * * * * * * * * *"
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"

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
echo -e "\n run number low 1 ---: "
    echo ${runnu_low_1[*]}              #* * * * * run number low list         rl_i     count variable  
echo -e "\n run number high 1 ---: "   
    echo ${runnu_high_1[*]}             #* * * * * run number high list        rh_i     count variable 






echo -e "\n decay mode points : "
    echo ${decay_mode_points[*]}      #* * * * * decay mode list             dm_i     count variable  

echo -e "\n\n* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * "
echo "number of * * infor.txt * * sum - array elements      =   ${#infor[@]}"

echo "number of energy points       =   ${#energy_points[@]}"
echo "number of luminosity points   =   ${#luminostiy_points[@]}"
echo "number of run number low      =   ${#runnu_low[@]}"
echo "number of run number high     =   ${#runnu_high[@]}"
echo "number of CMS energy          =   ${#CMS_energy[@]}"
echo "number of run number low  1    =   ${#runnu_low_1[@]}"
echo "number of run number high 1    =   ${#runnu_high_1[@]}"


echo "number of decay mode points   =   ${#decay_mode_points[@]}"


#///////////////////////////////////////////////////////////////////////////////////////////////////

#///////////////////////////////////////////////////////////////////////////////////////////////////



##* * ep_i=0   #* * * energy point   
##* * dm_i=0   #* * * decay mode
##* * rl_i=0   #* * * run number low
##* * rh_i=0   #* * * run number high
##* * lp_i=0   #* * * luminosity

currentpath=$PWD
cd ../output
output_path=$PWD
cd $currentpath
DataParentPath1=$output_path

jobName=$1     #* * * jobName : the name of job will like "jobName_????.txt" 

if [ $# -ne 1 ]
then
    echo "* * * * * Be careful, only should one paramter * * * * *  "
    echo "./sub_make_hello_mode.sh jobname"
    exit
fi

dm_i=0   #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do        
    if [ -d "$DataParentPath1/mode_${decay_mode_points[$dm_i]}" ]
    then
        echo "$DataParentPath1/mode_${decay_mode_points[$dm_i]} is ok"
    else
        echo "* * * * * * * * * * * *  $DataParentPath1/mode_${decay_mode_points[$dm_i]} is not exit ! ! !"
        let dm_i++
        continue
    fi

    cd ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}
    ls ${jobName}*.cpp |sort > temp_cpp.txt
   
    unset file_number
    IFS=$'\n' file_number=($(cat temp_cpp.txt))
    for xy in $(seq ${#file_number[*]})
    do
        [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
        echo "/////////////////// ${file_number[$xy-1]}"
        #sed -e s/XXX/${file_number[$xy-1]}/ ${DataParentPath1}/make_sh.head > ./${file_number[$xy-1]}.sh
        sed -e "s/XXX/ /g" ${currentpath}/sub_sh.head > ./${file_number[$xy-1]}.sh
       
        echo "root -l -b -q ${PWD}/${file_number[$xy-1]}" >> ./${file_number[$xy-1]}.sh

        chmod +x ${file_number[$xy-1]}.sh
        #echo "hep_sub ${file_number[$xy-1]}.sh"
        hep_sub ${file_number[$xy-1]}.sh

    done

    let dm_i++
done
        
 
