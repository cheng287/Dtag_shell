#!/bin/bash

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# object file 必须多空一行， 即如果有5行数据，第6行必须换行
# 定义5个空数组
unset p_min
unset p_max
unset costheta_min
unset costheta_max
unset cosp_mode     #* * * costheta_p 的标号
p_min=()
p_max=()
costheta_min=()
costheta_max=()
cosp_mode=()


# 逐行读取文件，并将每一列数据存入相应的数组
while read -r col1 col2 col3 col4 col5
do
    p_min+=("$col1")
    p_max+=("$col2")
    costheta_min+=("$col3")
    costheta_max+=("$col4")
    cosp_mode+=("$col5")
    
done < ../decay_mode_and_infor/Par.list

# # 打印每个数组的内容
# echo "p_min: ${p_min[@]}"
# echo "p_max: ${p_max[@]}"
# echo "costheta_min: ${costheta_min[@]}"
# echo "costheta_max: ${costheta_max[@]}"
# echo "cosp_mode: ${cosp_mode[@]}"



echo "number of p_min              =   ${#p_min[@]}"
echo "number of p_max              =   ${#p_max[@]}"
echo "number of costheta_min       =   ${#costheta_min[@]}"
echo "number of costheta_max       =   ${#costheta_max[@]}"
echo "number of cosp_mode          =   ${#cosp_mode[@]}"


#///////////////////////////////////////////////////////////////////////////////////////////////////
#- - - - -  - -costheta_list
unset xx_costheta_MIN
unset xx_costheta_MAX
unset xx_cos_mode
xx_costheta_MIN=()
xx_costheta_MAX=()
xx_cos_mode=()

while read -r colx1 colx2 colx3
do
    xx_costheta_MIN+=("$colx1")
    xx_costheta_MAX+=("$colx2")
    xx_cos_mode+=("$colx3")
    
done < ../decay_mode_and_infor/costheta.list

# 打印每个数组的内容
echo "costheta_min: ${xx_costheta_MIN[*]}"
echo "costheta_max: ${xx_costheta_MAX[*]}"
echo "cosp_mode:    ${xx_cos_mode[*]}"

echo "number of xx_costheta_min       =   ${#xx_costheta_MIN[@]}"
echo "number of xx_costheta_max       =   ${#xx_costheta_MAX[@]}"
echo "number of xx_cos_mode           =   ${#xx_cos_mode[@]}"


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

unset runnu_low_1
unset runnu_high_1

#- - - for infor_more_runno.txt
while read -r col1 col2 col3 col4 col5   col6  col7
do
    energy_points+=("$col1")
    luminostiy_points+=("$col2")
    runnu_low+=("$col3")
    runnu_high+=("$col4")
    CMS_energy+=("$col5")
    runnu_low_1+=("$col6")
    runnu_high_1+=("$col7")   
done < ../decay_mode_and_infor/infor_more_runno.txt


# # 逐行读取文件，并将每一列数据存入相应的数组
# while read -r col1 col2 col3 col4 col5
# do
#     energy_points+=("$col1")
#     luminostiy_points+=("$col2")
#     runnu_low+=("$col3")
#     runnu_high+=("$col4")
#     CMS_energy+=("$col5")
    
# done < ../decay_mode_and_infor/infor.txt

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
##* * lp_i=0   #* * *  luminosity

DataParentPath1=../output   
mypath=$PWD

if [ $# -ne 1 ]
then
    echo "* * * * * Be careful, only should one paramter * * * * *  "
    echo "./run_mode.sh jobname"
    exit
fi  
jobName=$1   #* * * jobName : the name of job will like "jobName_????.txt" 

# dm_i=0       #* * * decay mode
# for cout_i in ${decay_mode_points[@]}
# do               
#     #--ep_i=0   #* * * energy point 
#     #--for cout_ii in ${energy_points[@]}
#     #--do 
        
#         if [ -d "$DataParentPath1/fit/mode_${decay_mode_points[$dm_i]}" ]
#         then
#             echo "$DataParentPath1/fit/mode_${decay_mode_points[$dm_i]} is ok"
#         else
#             echo "* * * * * * * * * * * *  $DataParentPath1/fit/mode_${decay_mode_points[$dm_i]} is not exit ! ! !"
#             let ep_i++
#             continue
#         fi

#         cd ${DataParentPath1}/fit/mode_${decay_mode_points[$dm_i]}
#         ls mass_fit_${jobName}*.cpp |sort > temp_cpp.txt

     

#         unset file_number
#         IFS=$'\n' file_number=($(cat temp_cpp.txt))
#         for xy in $(seq ${#file_number[*]})
#         do
#             [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
            
#             #echo "root -b -q ${file_number[$xy-1]}"
#             root -l -b -q ${file_number[$xy-1]}
#         done

#         cd $mypath
#     #--    let ep_i++
#     #--done

#     let dm_i++
# done
        

#-----------------------------------------------------------------------------------------


dm_i=0       #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do               
    ep_i=0   #* * * energy point 
    for cout_ii in ${energy_points[@]}
    do 
        
        if [ -d "$DataParentPath1/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}" ]
        then
            echo "$DataParentPath1/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]} is ok"
        else
            echo "* * * * * * * * * * * *  $DataParentPath1/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]} is not exit ! ! !"
            let ep_i++
            continue
        fi

        cd ${DataParentPath1}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}
        # ls mass_fit_${jobName}*.cpp |sort > temp_cpp.txt
        ls mass_fit_*.cpp |sort > temp_cpp.txt

     

        unset file_number
        IFS=$'\n' file_number=($(cat temp_cpp.txt))
        for xy in $(seq ${#file_number[*]})
        do
            [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
            
            # echo "root -b -q ${file_number[$xy-1]}"
            root -l -b -q ${file_number[$xy-1]}
        done

        cd $mypath
        let ep_i++
    done

    let dm_i++
done