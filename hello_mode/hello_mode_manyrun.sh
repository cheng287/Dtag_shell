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


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - 


echo -e "\n\n* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * "
echo -e "\n\n* * * * * *  Begin to generate different decay mode job ! ! ! * * * * * *"

#///////////////////////// generate job - - - - begin///////////////////////////////////////////////

##* * ep_i=0   #* * * energy point   
##* * dm_i=0   #* * * decay mode
##* * rl_i=0   #* * * run number low
##* * rh_i=0   #* * * run number high
##* * lp_i=0   #* * *  luminosity


#if [[ $# -ne 1 && $# -ne 2 && $# -ne 3 && $# -ne 4 ]]
if [[ $# -ne 1 && $# -ne 2 && $# -ne 3 ]]
then
    echo " "
    echo "purpose:[for real data] you can get jobOptions with certain number rec file in each job automatically. "
    echo "        Also, you can summit the jobs automatically. "
    echo "useage : ./hello_mode.sh jobName [jobN] [fileN] "
    echo "jobName: is the name of jobOption you wish"
    echo "         this argument SHOULD NOT be omitted. "
    echo "jobN   : is the largest number of jobs"
    echo "         by default, it will be 20 "
    echo "fileN  : is the smallest of rec file in each jobOption"
    echo "         by default, it will be 200  "
    echo "  "
    echo "SQUESTION: step one  : please check/modify the 'infor_mode.head' "
    echo "           step two  : please check/modify the 'infor_mode.tail' "
    echo "           step three: please check 'DataParentPath1' in 'hello_mode.sh' correct or not"
    exit
fi

#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
#---- get all rec file from all child path of the DataParentPath
#---- ! ! ! no space between '=' and your path

# DataParentPath1=/besfs5/groups/tauqcd/songwm/Rc_study/Rc/4612to4700/outputroot
# DataParentPath1=/besfs5/groups/tauqcd/songwm/Rc_study/Rc/4740to4960/mini/mode0       
# DataParentPath1=/besfs5/groups/psip/psipgroup/user/liucheng/Rc_data/703_3810to4600/outputroot

# DataParentPath1=/besfs5/groups/psip/psipgroup/user/liucheng/Rc_data/inclusive_MC/incluMC_4946/signal/outputroot

# DataParentPath1=/besfs5/groups/psip/psipgroup/user/liucheng/Rc_data/inclusive_MC/incluMC_4946/match/outputroot

# DataParentPath1=/besfs5/groups/psip/psipgroup/user/liucheng/Rc_data/inclusive_MC/incluMC_4946/tag_all/outputroot

# DataParentPath1=/scratchfs/bes/liucheng21/inclu_4946/tag_all/outputroot

# DataParentPath1=/scratchfs/bes/liucheng21/inclu_4946/save_all/outputroot



DataParentPath1=/besfs5/groups/psip/psipgroup/user/liucheng/Rc_data/new_run/*/outputroot




#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
echo " DataParentPath1 : ${DataParentPath1}"


if [ -d "../output" ]
then
    echo "output is ok"
else
    mkdir ../output
fi

#-----jobName : the name of job will like "jobName_????.txt" 
jobName=$1             #* * *  jobName=data, mc and so on.
echo "jobName : ${jobName}"

#----jobN : the largest number of jobs
if [ $# -ge 2 ]  
then
    jobN=$2
else
    jobN=20
fi
echo "The largest number of jobs : ${jobN}"

#----fileN : the smallest number of rec file in each jobOption" 
fileN_number=1      
if [ $# -ge 3 ] 
then
    fileN=$3
    if [ $3 -eq 1 ]
    then
        fileN_number=0
    fi
else
    fileN=2
fi
echo "The smallest number of rec file in each job : ${fileN}"


jobDir=../output

dst_list=temp.txt

if [ -e temp.txt ] 
then 
   rm temp.txt 
fi 

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - -
if [ ! -e temp.txt ]   
then 
    find  ${DataParentPath1}/ -name "*.root" |sort >$dst_list
else
    find  ${DataParentPath1}/ -name "*.root" |sort >>$dst_list
fi 

# if [ ! -e temp.txt ]   
# then 
#     # /besfs5/groups/psip/psipgroup/user/liucheng/Rc_data/703_3810to4600/outputroot/data_3810to4600_0.root
#     # /besfs5/groups/psip/psipgroup/user/liucheng/Rc_data/703_3810to4600/outputroot/data_3810to4600_2.root
#     # /besfs5/groups/psip/psipgroup/user/liucheng/Rc_data/703_3810to4600/outputroot/data_3810to4600_100.root
#     # find  ${DataParentPath1}/ -name "*.root" | sort -t_ -k5n  >$dst_list   #- - -这里是按第4个分隔符"_"后面的数字排序， 具体数字需要自行改变
#      find  ${DataParentPath1}/ -name "*.root" |sort -t'_' -k$(echo 'split' | tr -d '\n' | wc -c) -n  >$dst_list
# else
#     # find  ${DataParentPath1}/ -name "*.root" | sort -t_ -k5n >>$dst_list
#     find  ${DataParentPath1}/ -name "*.root" |sort -t'_' -k$(echo 'split' | tr -d '\n' | wc -c) -n >>$dst_list
# fi


#---------- - - - - ---------------------------------------------------------
#- - - 不知道咋出错了 ? ?   * * * * 正常用这里
#  if [ ! -e temp.txt ]   
#  then 
#       find  ${DataParentPath1}/ -name "*.root" |sort -t'_' -k$(echo 'split' | tr -d '\n' | wc -c) -n  >$dst_list   #- - -按分隔符"_"最后的一个数字大小排序
#  else
#      find  ${DataParentPath1}/ -name "*.root" |sort -t'_' -k$(echo 'split' | tr -d '\n' | wc -c) -n >>$dst_list
#  fi


#---------- - - - - ---------------------------------------------------------


# if [ ! -e temp.txt ]   
# then 
#      find  ${DataParentPath1}/ -name "*.root" |sort -t'_' -k6 -n  >$dst_list   #- - -按分隔符"_"最后的一个数字大小排序
# else
#     find  ${DataParentPath1}/ -name "*.root" |sort -t'_' -k6 -n >>$dst_list
# fi


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - -


# input the number of total lines of temp.txt 
nline=`wc -l temp.txt | cut -f 1 -d " "`
echo "There are ${nline} rec file totally"

# calculate how much jobs and how much rec file in each job 
let Ntemp=`expr ${fileN} \* ${jobN}`
if [ ${nline} -gt ${Ntemp} ] 
then 
    fileN=`expr ${nline} / ${jobN} + 1 `
    echo "To make sure there are at most ${jobN} jobs, there will be ${fileN} rec files in each job"
else 
    jobN=`expr ${nline} / ${fileN} + 1`
    echo "To make sure there are at least ${fileN} rec files in each job, there will be ${jobN} jobs"
fi




dm_i=0       #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do
    ep_i=0   #* * * energy point    4260  
    rl_i=0   #* * * run number low
    rh_i=0   #* * * run number high
    # lp_i=0   #* * *  luminosity
    # Ce_i=0   #* * *  CMS energy  4.26
    
    
    for cout_ii in ${energy_points[@]}
    do
        if [ -d "../output/mode_${decay_mode_points[$dm_i]}" ]
        then
            echo "../output/mode_${decay_mode_points[$dm_i]} is ok"
        else
            mkdir ../output/mode_${decay_mode_points[$dm_i]}
        fi

        if [ -d "../output/root/mode_${decay_mode_points[$dm_i]}" ]
        then
            echo "../output/root/mode_${decay_mode_points[$dm_i]} is ok"
        else
            mkdir -p ../output/root/mode_${decay_mode_points[$dm_i]}
        fi


        


        # make jobOptions with certain rec files in each job
        let iline=1
        let i=1
        ijob=${i}

        unset file_number
        IFS=$'\n' file_number=($(cat temp.txt)) 
        for xy in $(seq ${#file_number[*]})
        do
            [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"

            #* * * * * * add * * * * begin   * * * * Change the number of outputs as needed, for example 03d --- 001,002 . 05d----00001, 00002
             ncount=`printf "%03d"  $ijob`
            #* * * * * * add * * * * end

            #* * * * * * * * * * * ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! * * * * * * * * * * *
            #if [ `expr ${iline} % ${fileN}` == 1 ] 
            #if [ `expr ${iline} % ${fileN}` == 0 ]  #* * In order to make each job contains only one root file, change `1` here to `0`. i add this line ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
            if [ `expr ${iline} % ${fileN}` == $fileN_number ]    #* * *  = 0 or 1
            then 
                if [ -e ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp ] 
                then 
                    echo "Just remind: ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.txt already exists, and it will be update!"
                fi 
                
                sed -e s/XXX/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}/ ./infor_mode.head > ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp

            fi 

            if [[ `expr ${iline} % ${fileN}` -ne 0 && ${iline} -lt ${nline} ]] 
            then 
                echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp
            fi 

            if [[ `expr ${iline} % ${fileN}` == 0 || ${iline} == ${nline} ]] 
            then 
                echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp
                sed -e s/XXX/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}/ ./infor_mode.tail >> ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp

                sed -i "s/HHH_MODE/${decay_mode_points[$dm_i]}/g" `grep HHH_MODE  -rl ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`
                sed -i "s/HHHRUN_LOW/${runnu_low[$rl_i]}/g"       `grep HHHRUN_LOW -rl ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`
                sed -i "s/HHHRUN_HIGH/${runnu_high[$rh_i]}/g"     `grep HHHRUN_HIGH -rl ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`

                sed -i "s/HHHRUN_xxLOW1/${runnu_low_1[$rl_i]}/g"       `grep HHHRUN_xxLOW1 -rl ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`
                sed -i "s/HHHRUN_xxHIGH1/${runnu_high_1[$rh_i]}/g"     `grep HHHRUN_xxHIGH1 -rl ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`

                echo ${jobDir}/mode_${decay_mode_points[$dm_i]}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp is finished 

                let i++
                if [ ${i} -lt 10 ] 
                then 
                    ijob=${i}
                else
                    ijob=${i}
                fi 
            fi 

            let iline++
        done

        let ep_i++
        let rl_i++
        let rh_i++
    done

    let dm_i++

done

#///////////////////////// generate job - - - - end///////////////////////////////////////////////
