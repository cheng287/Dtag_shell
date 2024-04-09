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


# # 逐行读取文件，并将每一列数据存入相应的数组
while read -r col1 col2 col3 col4 col5  col6
do
    energy_points+=("$col1")
    luminostiy_points+=("$col2")
    runnu_low+=("$col3")
    runnu_high+=("$col4")
    CMS_energy+=("$col5")
    CMS_energy+=("$col6")
    
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



unset xxxenergy_points
unset xxx_font
unset c0_mode_0
unset c1_mode_0
unset c0_mode_200
unset c1_mode_200
unset c0_mode_401
unset c1_mode_401
while read -r col1 col2 col3 col4 col5  col6 col7 col8
do
    xxxenergy_points+=("$col1")
    xxx_font+=("$col2")
    c0_mode_0+=("$col3")
    c1_mode_0+=("$col4")
    c0_mode_200+=("$col5")
    c1_mode_200+=("$col6")
    c0_mode_401+=("$col7")
    c1_mode_401+=("$col8")
     
done < ../decay_mode_and_infor/c0_c1.txt

# #///////////////////////////////////////////////////////////////////////////////////////////////////

# #///////////////////////////////////////////////////////////////////////////////////////////////////



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

# DataParentPath1=../output/root    
DataParentPath1=/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/rscan/output/root                                                     
mypath=$PWD
jobDir=../output


CHARM_CHARM=1               #* * * charm = 1 or -1


#* * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * *
#* * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * *

cd ../output
# path_output=$PWD
path_output=/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/rscan/output
cd $mypath


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

        if [ -d "../output/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}" ]              
        then
            echo "../output/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]} is ok"
        else
            mkdir -p ../output/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}
        fi
    
        if [ -d "$DataParentPath1/mode_${decay_mode_points[$dm_i]}" ]
        then
            echo "$DataParentPath1/mode_${decay_mode_points[$dm_i]} is ok"
               
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
                    if [ -e ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp ] 
                    then 
                       echo "Just remind: ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp already exists, and it will be update!"
                    fi 
                
                    #* * * *  The mass of Ds and D0,D+- are different, so we should use different fitting scripts.
                    if [ ${decay_mode_points[$dm_i]} -lt 400 ]
                    then
                        # sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/fitjob.head > ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                        sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/fix_more_gaussian_fitjob.head > ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    else
                        # sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/Ds_fitjob.head > ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                        sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/fix_more_gaussian_fit_Ds_fitjob.head > ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    fi

                fi 

                if [[ `expr ${iline} % ${fileN}` -ne 0 && ${iline} -lt ${nline} ]] 
                then 

                    echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                fi 

                if [[ `expr ${iline} % ${fileN}` == 0 || ${iline} == ${nline} ]] 
                then 
                    echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    
                    #* * * *  The mass of Ds and D0,D+- are different, so we should use different fitting scripts.
                    if [ ${decay_mode_points[$dm_i]} -lt 400 ]
                    then       
                        # sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/fitjob.tail >> ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                        sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/more_gaussian_fitjob.tail >> ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    else
                        # sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/Ds_fitjob.tail >> ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                        sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}/ ${mypath}/more_gaussian_fit_Ds_fitjob.tail >> ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp
                    fi
                    
                    # sed -i "s#CUT_CUT#mmode== ${decay_mode_points[$dm_i]} \&\& mcharm == $CHARM_CHARM #g" `grep CUT_CUT  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    sed -i "s#CUT_CUT#Data.mmode== ${decay_mode_points[$dm_i]} \&\& Data.mcharm == $CHARM_CHARM #g" `grep CUT_CUT  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    sed -i "s#HHH#${energy_points[$ep_i]}#g" `grep HHH  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    sed -i "s#XXMODE#${decay_mode_points[$dm_i]}#g" `grep XXMODE  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    
                    
                    #- -- - - - i add

                    if [[ ${decay_mode_points[$dm_i]} -eq 0 ]]
                    then
                       sed -i "s#HHXX_C0#${c0_mode_0[$ep_i]}#g" `grep HHXX_C0  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                       sed -i "s#HHXX_C1#${c1_mode_0[$ep_i]}#g" `grep HHXX_C1  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    fi

                    if [[ ${decay_mode_points[$dm_i]} -eq 200 ]]
                    then
                       sed -i "s#HHXX_C0#${c0_mode_200[$ep_i]}#g" `grep HHXX_C0  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                       sed -i "s#HHXX_C1#${c1_mode_200[$ep_i]}#g" `grep HHXX_C1  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    fi

                    if [[ ${decay_mode_points[$dm_i]} -eq 401 ]]
                    then
                       sed -i "s#HHXX_C0#${c0_mode_401[$ep_i]}#g" `grep HHXX_C0  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                       sed -i "s#HHXX_C1#${c1_mode_401[$ep_i]}#g" `grep HHXX_C1  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    fi

                    







                    
                    
                    if [[ ${decay_mode_points[$dm_i]} -ge 200 && ${decay_mode_points[$dm_i]} -lt 400 ]]
                    then
                        sed -i "s#DDD#D^{+}#g" `grep DDD  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    fi

                    if [ ${decay_mode_points[$dm_i]} -lt 200 ]
                    then
                        sed -i "s#DDD#D^{0}#g" `grep DDD  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`
                    fi


                    #- - - - - - - - -  -
                    ls $path_output/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight*root |sort > weight_xx.txt
                    weight_file=$(cat weight_xx.txt)
                    
                    sed -i "s#WEIGHT_Tree_WEIGHT_Tree#$weight_file#g" `grep WEIGHT_Tree_WEIGHT_Tree  -rl ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp`

                    
                    
                    
                    echo ${jobDir}/more_gaussian_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_file_${ncount}.cpp is finished 
                  
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


