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



if [[ $# -ne 1 && $# -ne 2 && $# -ne 3 ]]
then
    echo " "
    echo "purpose:[for real data] you can get jobOptions with certain number rec file in each job automatically. "
    echo "        Also, you can summit the jobs automatically. "
    echo "useage : ./hello_fit.sh jobName [jobN] [fileN]"
    echo "jobName: is the name of jobOption you wish"
    echo "         this argument SHOULD NOT be omitted. "
    echo "jobN   : is the largest number of jobs"
    echo "         by default, it will be 20 "
    echo "fileN  : is the smallest of rec file in each jobOption"
    echo "         by default, it will be 200  "
    echo "SQUESTION: step one  : please check/modify the 'fitjob.head' or 'Ds_fitjob.head'"
    echo "           step two  : please check/modify the 'fitjob.tail' or 'Ds_fitjob.tail' "
    exit
fi



# get all object file from all child path of the DataParentPath


# cd ../output/root



DataParentPath1=../output/root                                                        
mypath=$PWD
jobDir=../output




#charm_p1=1                  #* * * 选择拟合 charm =1,   这里非常重要 开关
#charm_m1=0
CHARM_CHARM=1               #* * * charm = 1 or -1
#charm_p1=0                 #* * * 选择拟合 charm = -1,   这里非常重要 
#charm_m1=1

#* * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * *

#* * * jobName : the name of job will like "jobName_????.txt"         
jobName=$1
echo "jobName : ${jobName}"          #* * * * * jobName=data, mc and so on . Must be consistent with the name entered in 'hello_mode.sh' ! ! ! ! ! !

#* * *jobN : the largest number of jobs" 
if [ $# -ge 2 ]  
then
    jobN=$2
else
    jobN=20
fi
echo "The largest number of jobs : ${jobN}"

#* * * fileN   : the smallest number of rec file in each jobOption" 
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


##* * ep_i=0   #* * * energy point  
##* * dm_i=0   #* * * decay mode
##* * rl_i=0   #* * * run number low
##* * rh_i=0   #* * * run number high
##* * lp_i=0   #* * *  luminosity

dm_i=0   #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do
    ep_i=0              #* * * energy    4260  
    #rl_i=0              #* * * run number low
    #rh_i=0              #* * * run number high
    #lp_i=0              #* * *  luminosity
    #Ce_i=0              #* * *  CMS energy  4.26
    
         
    for cout_ii in ${energy_points[@]}
    do

        if [ -d "../output/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}" ]              
        then
            echo "../output/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]} is ok"
        else
            mkdir -p ../output/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}
        fi
    
        if [ -d "../output/root/mode_${decay_mode_points[$dm_i]}" ]
        then
            echo "../output/root/mode_${decay_mode_points[$dm_i]} is ok"
               
            if [ -e temp.txt ] 
            then 
               rm temp.txt 
            fi 

            #dst_list=temp.txt

            cd  ${DataParentPath1}
            
            if [ ! -e temp.txt ]   
            then 
                #find  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/ -name "${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}*.root" |sort >$dst_list
                find  ${PWD}/mode_${decay_mode_points[$dm_i]}/ -name "${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}*.root" |sort > $mypath/temp.txt
            else
                #find  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/ -name "${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}*.root" |sort >>$dst_list
                find  ${PWD}/mode_${decay_mode_points[$dm_i]}/ -name "${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}*.root" |sort >> $mypath/temp.txt
            fi 

            cd $mypath

            # input the number of total lines of temp.txt 
            nline=`wc -l temp.txt | cut -f 1 -d " "`
            echo "There are ${nline}  file totally"

            #- - calculate how much jobs and how much rec file in each job 
            let Ntemp=`expr ${fileN} \* ${jobN}`
            if [ ${nline} -gt ${Ntemp} ] 
            then 
                fileN=`expr ${nline} / ${jobN} + 1 `
                echo "To make sure there are at most ${jobN} jobs, there will be ${fileN} rec files in each job"
            else 
                jobN=`expr ${nline} / ${fileN} + 1`
                echo "To make sure there are at least ${fileN} rec files in each job, there will be ${jobN} jobs"
            fi


            # make jobOptions with certain files in each job
            let iline=1
            let i=1
            ijob=${i}

            unset file_number
            IFS=$'\n' file_number=($(cat temp.txt)) 
            for xy in $(seq ${#file_number[*]})
            do
                [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"

                #* * * * * *  * * * * begin   * * * * Change the number of outputs as needed, for example 03d --- 001,002 . 05d----00001, 00002
                 ncount=`printf "%03d"  $ijob`
                #* * * * * * add * * * * end

                #if [ `expr ${iline} % ${fileN}` == 0 ]   #* * In order to make each job contains only one root file, change `1` here to `0`.  ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
                #if [ `expr ${iline} % ${fileN}` == 1 ]  
                if [ `expr ${iline} % ${fileN}` == $fileN_number ]    #* * *  = 0 or 1
                then 
                    if [ -e ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp ] 
                    then 
                       echo "Just remind: ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp already exists, and it will be update!"
                    fi 
                
                    #* * * *  The mass of Ds and D0,D+- are different, so we should use different fitting scripts.
                    if [ ${decay_mode_points[$dm_i]} -lt 400 ]
                    then
                        sed -e s/XXX/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/wgt.head > ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    else
                        sed -e s/XXX/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/wgt.head > ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    fi

                fi 

                if [[ `expr ${iline} % ${fileN}` -ne 0 && ${iline} -lt ${nline} ]] 
                then 

                    echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                fi 

                if [[ `expr ${iline} % ${fileN}` == 0 || ${iline} == ${nline} ]] 
                then 
                    echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    
                    #* * * *  The mass of Ds and D0,D+- are different, so we should use different fitting scripts.
                    if [ ${decay_mode_points[$dm_i]} -lt 400 ]
                    then       
                        sed -e s/XXX/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/wgt.tail >> ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    else
                        sed -e s/XXX/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/wgt.tail >> ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    fi
                    
                    #sed -i "s#PAR_WEIGHT_PAR_WEIGHT#mmode== ${decay_mode_points[$dm_i]} \&\& mcharm == $CHARM_CHARM #g" `grep PAR_WEIGHT_PAR_WEIGHT  -rl ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    sed -i "s#PAR_WEIGHT_PAR_WEIGHT#$mypath#g" `grep PAR_WEIGHT_PAR_WEIGHT  -rl ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`

                    sed -i "s#MODE_MODE#mode${decay_mode_points[$dm_i]}#g" `grep MODE_MODE  -rl ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`


                    echo ${jobDir}/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp is finished 
                  
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
        else
            echo "../output/root/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]} is not exist ! ! ! ! ! * "
        fi


        let ep_i++
        #let rl_i++
        #let rh_i++
    done

    let dm_i++
done


