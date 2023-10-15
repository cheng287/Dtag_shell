#!/bin/bash

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *



#/////////////////////////////////////////////////////////////////////////////////////

    #* * * * * * * * * * Read energy point information * * * * * * *begin

    #-----infor.txt          energy_points   luminostiy_points  run_number_low   run_number_high    center-of-mass_energy
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


#- - - for infor.txt
while read -r col1 col2 col3 col4 col5
do
    energy_points+=("$col1")
    luminostiy_points+=("$col2")
    runnu_low+=("$col3")
    runnu_high+=("$col4")
    CMS_energy+=("$col5")   
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
echo -e "\n decay mode points : "
    echo ${decay_mode_points[*]}      #* * * * * decay mode list             dm_i     count variable  

echo -e "\n\n* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * "
echo "number of * * infor.txt * * sum - array elements      =   ${#infor[@]}"

echo "number of energy points       =   ${#energy_points[@]}"
echo "number of luminosity points   =   ${#luminostiy_points[@]}"
echo "number of run number low      =   ${#runnu_low[@]}"
echo "number of run number high     =   ${#runnu_high[@]}"
echo "number of CMS energy          =   ${#CMS_energy[@]}"
echo "number of decay mode points   =   ${#decay_mode_points[@]}"



mypath=$PWD
echo "the current path is - - -  $mypath"

cd ../output
path_output=$PWD
cd $mypath

DataParentPath1=$path_output/fit       







dm_i=0   #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do
    #---ep_i=0   #* * *  energy    4260  
    #rl_i=0   #* * * run number low
    #rh_i=0   #* * * run number high
    #lp_i=0   #* * *  luminosity
    #Ce_i=0   #* * *  CMS energy  4.26
    
    #---for cout_ii in ${energy_points[@]}
    #---do



        if [ -d "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed" ]
        then
            #cd ./fit/mode_${decay_mode_points[$dm_i]}
            echo " "
            echo " "
            echo "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed is ok"




            cd ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed          #* * * * 进入 目录数组

            
            
            ls *cpp | sort > ${DataParentPath1}/refailed.txt
    
            unset file_number
            IFS=$'\n' file_number=($(cat ${DataParentPath1}/refailed.txt))  #* * * sh.out 单个目录下的文件数组列表

            for xy in  $(seq ${#file_number[*]})
            do
                [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
    			echo " "
                echo " "
    			echo "${file_number[$xy-1]} is ok " 


                grep -n "paramter_begin_paramter_begin" ${file_number[$xy-1]}  | awk -F ":" '{print $1}' > ${DataParentPath1}/para_begin.txt
                unset catxxx
                IFS=$'\n' catxxx=($(cat ${DataParentPath1}/para_begin.txt))            
                for n_catxxx in $(seq ${#catxxx[*]})
                do
                    [[ ${catxxx[$n_catxxx-1]} = $name ]] && echo "${catxxx[$n_catxxx]}"
                    echo "///line number/////"
                    echo ${catxxx[$n_catxxx-1]}   
                done
                nn_catxxx=${#catxxx[@]}  

                grep -n "paramter_end_paramter_end" ${file_number[$xy-1]}  | awk -F ":" '{print $1}' > ${DataParentPath1}/para_end.txt
                unset cathhh
                IFS=$'\n' cathhh=($(cat ${DataParentPath1}/para_end.txt))            
                for n_cathhh in $(seq ${#cathhh[*]})
                do
                    [[ ${cathhh[$n_cathhh-1]} = $name ]] && echo "${cathhh[$n_cathhh]}"
                    echo "///line number/////"
                    echo ${cathhh[$n_cathhh-1]}   
                done
                nn_cathhh=${#cathhh[@]}


                echo "paramter begin line is    $catxxx  * * * * * * * "
                echo "paramter end line is      $cathhh  * * * * * * * "
                sub_begin=`expr $catxxx + 1`
                sub_end=`expr $cathhh - 1`

                #sed `${catxxx},${cathhh}c `cat $mypath/re_fitjob.head`` ${file_number[$xy-1]}
                #sed -i "s/HHHRUN_HIGH/${runnu_high[$rh_i]}/g"     `grep HHHRUN_HIGH -rl ${jobDir}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`
                #sub_contents=`cat $mypath/re_fitjob.head`
                #echo "$sub_contents"

                if [ ${decay_mode_points[$dm_i]} -lt 400 ]
                then 
                    sed -i "${sub_begin},${sub_end}d"  ${file_number[$xy-1]}
                    sed -i "${catxxx}r $mypath/re_fitjob.head"  ${file_number[$xy-1]}
                else
                    sed -i "${sub_begin},${sub_end}d"  ${file_number[$xy-1]}
                    sed -i "${catxxx}r $mypath/re_Ds_fitjob.head"  ${file_number[$xy-1]}
                fi




            done    

        else            
            echo "* * * * * * Be careful, ./fit/mode_${decay_mode_points[$dm_i]}/failed is not exist ! ! ! ! "
        fi
   

    #---    let ep_i++
    #---    #let rl_i++
    #---    #let rh_i++
    #---done
    
    let dm_i++
done     


if [ -e ${DataParentPath1}/para_begin.txt ] 
then 
    rm ${DataParentPath1}/para_begin.txt 
fi

if [ -e ${DataParentPath1}/para_end.txt ] 
then 
    rm ${DataParentPath1}/para_end.txt 
fi

if [ -e ${DataParentPath1}/refailed.txt ] 
then 
    rm ${DataParentPath1}/refailed.txt
fi







echo "* * * * * * end * * * * * * * "



