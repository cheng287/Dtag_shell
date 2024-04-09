#!/bin/bash

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

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
#/////////////////////////////////////////////////////////////////////////////////////

    #* * * * * * * * * * Read energy point information * * * * * * *begin

    #-----infor.txt          energy_points   luminostiy_points  run_number_low   run_number_high    center-of-mass_energy
    #-----decay_mode.txt     different_decay_mode

unset energy_point
IFS=$'\n' energy_point=($(cat ../decay_mode_and_infor/infor.txt))            #---read information from ../decay_mode_and_infor/infor.txt
for i in $(seq ${#energy_point[*]})
do
    [[ ${energy_point[$i-1]} = $name ]] && echo "${energy_point[$i]}"
done


    #* * * * * output infor.txt, but it is a two-dimensional arry now ! ! ! * * * 
echo "* * * * * * * * * * * * * Two-dimensional array information output * * * begin"

i_cout=0
while [ $i_cout -lt ${#energy_point[@]} ]
do
    echo ${energy_point[$i_cout]}
    echo "* * * "
    let i_cout++
done

echo "* * * * * * * * * * * * * Two-dimensional array information output * * * end "
    #* * * * * * Read energy point information * * * * * * *end

#/////////////////////////////////////////////////////////////////////////////////////



#/////////////////////////////////////////////////////////////////////////////////////

echo "* * * * * ** * * * Convert two-dimensional array to one-dimensional* * * begin"

unset infor
unset energy_points
unset luminostiy_points
unset runnu_low
unset runnu_high
unset CMS_energy
unset decay_mode_points

j=0
for arrat_1d in ${energy_point[@]}
do
    unset contents     
    IFS=' ' read -r -a contents <<< "$arrat_1d"
    for var in "${contents[@]}"
    do
        infor[j]=$var
        ((j++))
        echo $var    
    done
done

j=0
while [ $j -lt ${#infor[@]} ]
do
    echo "+ + +  "
    echo ${infor[$j]}  
    let j++
done

echo "* * * * * ** * * * Convert two-dimensional array to one-dimensional* * * end"

#/////////////////////////////////////////////////////////////////////////////////////


#/////////////////////////////////////////////////////////////////////////////////////
echo "* * * * * * * * * * * * * Divide an array into 5 arrays * * * * * * begin"

number=5          #* * * * * Because we have 5 variables.   energy_points   luminostiy_points  run_number_low   run_number_high    center-of-mass_energy

number_2=0        #* * * * 'while' loop count
energy_count=1
luminostiy_count=1
runnu_low_count=1
runnu_high_count=1
CMS_energy_count=1          

energy_i=0
luminostiy_i=0
runnu_low_i=0
runnu_high_i=0
CMS_energy_i=0


while [ $number_2 -lt ${#infor[@]} ]
do
    if [ $number_2 -lt $number ]
    then
        echo "* * * "
        if [ $number_2 -eq 0 ]
        then
           energy_points[$energy_i]=${infor[$number_2]}
           echo ${energy_points[$energy_i]}
           let energy_i++ 
        fi

        if [ $number_2 -eq 1 ]
        then
            luminostiy_points[$luminostiy_i]=${infor[$number_2]}
            echo ${luminostiy_points[$luminostiy_i]}
            let luminostiy_i++
        fi

       if [ $number_2 -eq 2 ]
       then
           runnu_low[$runnu_low_i]=${infor[$number_2]}
           echo ${runnu_low[$runnu_low_i]}
           let runnu_low_i++
       fi

       if [ $number_2 -eq 3 ]
       then
           runnu_high[$runnu_high_i]=${infor[$number_2]}
           echo ${runnu_high[$runnu_high_i]}
           let runnu_high_i++
       fi

       if [ $number_2 -eq 4 ]
       then
           CMS_energy[$CMS_energy_i]=${infor[$number_2]}
           echo ${CMS_energy[$CMS_energy_i]}
           let CMS_energy_i++
       fi       
        
    fi
    
      
    
    if [ $number_2 -ge $number ]
    then
        x=`expr $number \* $energy_count`
        y=`expr 1 + $number \* $luminostiy_count`
        z=`expr 2 + $number \* $runnu_low_count`
        w=`expr 3 + $number \* $runnu_high_count`
        v=`expr 4 + $number \* $CMS_energy_count`

        echo "---- "
        if [ $number_2 -eq $x ]
        then 
            energy_points[$energy_i]=${infor[$number_2]}
            echo ${energy_points[$energy_i]}
            let energy_i++
            let energy_count++
        fi

        if [ $number_2 -eq $y ]
        then 
            luminostiy_points[$luminostiy_i]=${infor[$number_2]}
            echo ${luminostiy_points[$luminostiy_i]}
            let luminostiy_i++
            let luminostiy_count++
        fi
      
        if [ $number_2 -eq $z ]
        then 
            runnu_low[$runnu_low_i]=${infor[$number_2]}
            echo ${runnu_low[$runnu_low_i]}
            let runnu_low_i++
            let runnu_low_count++
        fi

        if [ $number_2 -eq $w ]
        then 
            runnu_high[$runnu_high_i]=${infor[$number_2]}
            echo ${runnu_high[$runnu_high_i]}
            let runnu_high_i++
            let runnu_high_count++
        fi

        if [ $number_2 -eq $v ]
        then 
            CMS_energy[$CMS_energy_i]=${infor[$number_2]}
            echo ${CMS_energy[$CMS_energy_i]}
            let CMS_energy_i++
            let CMS_energy_count++
        fi
  
    fi

    echo $number_2
    let number_2++
done


echo "* * * * * * * * * * * * * Divide an array into 5 arrays * * * * * * end"
#/////////////////////////////////////////////////////////////////////////////////////

#/////////////////////////////////////////////////////////////////////////////////////



echo "* * * * * * * * * * *  decay mode list * * * * * * * * * * * * begin "
IFS=$'\n' decay_mode_points=($(cat ../decay_mode_and_infor/decay_mode.txt))             
for i in $(seq ${#decay_mode_points[*]})
do
    [[ ${decay_mode_points[$i-1]} = $name ]] && echo "${decay_mode_points[$i]}"
    echo ${decay_mode_points[$i-1]}   
done

echo "* * * * * * * * * * *  decay mode list * * * * * * * * * * * * end "

#/////////////////////////////////////////////////////////////////////////////////////

#/////////////////////////////////summary output//////////////////////////////////////


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

#///////////////////////////////////////////////////////////////////////////////////////////////////

#//////////////////////../decay_mode_and_infor/Par.list/////////////////////////////////////////////

#这段代码嵌入到其他脚本中，可能会出现与其他代码冲突的问题。其中一个可能的原因是，其他代码可能会改变IFS环境变量的值，导致read命令无法正确地将每行数据分隔成多个字段。为了避免这种情况，您可以在读取文件之前将IFS环境变量设置为默认值：
# # 定义5个空数组
# unset p_min
# unset p_max
# unset costheta_min
# unset costheta_max
# unset cosp_mode     #* * * costheta_p 的标号
# p_min=()
# p_max=()
# costheta_min=()
# costheta_max=()
# cosp_mode=()


# # 逐行读取文件，并将每一列数据存入相应的数组
# while read -r col1 col2 col3 col4 col5
# do
#     p_min+=("$col1")
#     p_max+=("$col2")
#     costheta_min+=("$col3")
#     costheta_max+=("$col4")
#     cosp_mode+=("$col5")
    
# done < ../decay_mode_and_infor/Par.list

# # # 打印每个数组的内容
# # echo "p_min: ${p_min[@]}"
# # echo "p_max: ${p_max[@]}"
# # echo "costheta_min: ${costheta_min[@]}"
# # echo "costheta_max: ${costheta_max[@]}"
# # echo "cosp_mode: ${cosp_mode[@]}"



# echo "number of p_min              =   ${#p_min[@]}"
# echo "number of p_max              =   ${#p_max[@]}"
# echo "number of costheta_min       =   ${#costheta_min[@]}"
# echo "number of costheta_max       =   ${#costheta_max[@]}"
# echo "number of cosp_mode          =   ${#cosp_mode[@]}"


# #///////////////////////////////////////////////////////////////////////////////////////////////////
# #- - - - -  - -costheta_list
# unset xx_costheta_MIN
# unset xx_costheta_MAX
# unset xx_cos_mode
# xx_costheta_MIN=()
# xx_costheta_MAX=()
# xx_cos_mode=()

# while read -r colx1 colx2 colx3
# do
#     xx_costheta_MIN+=("$colx1")
#     xx_costheta_MAX+=("$colx2")
#     xx_cos_mode+=("$colx3")
    
# done < ../decay_mode_and_infor/costheta.list

# # 打印每个数组的内容
# echo "costheta_min: ${xx_costheta_MIN[*]}"
# echo "costheta_max: ${xx_costheta_MAX[*]}"
# echo "cosp_mode:    ${xx_cos_mode[*]}"

# echo "number of xx_costheta_min       =   ${#xx_costheta_MIN[@]}"
# echo "number of xx_costheta_max       =   ${#xx_costheta_MAX[@]}"
# echo "number of xx_cos_mode           =   ${#xx_cos_mode[@]}"




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

DataParentPath1=../output/root                                                        
mypath=$PWD
jobDir=../output


CHARM_CHARM=1               #* * * charm = 1 or -1


#* * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * *
#* * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * * * * - - - - - - - - - - * * * * * * * * * * * * * * * * *

cd ../output
path_output=$PWD
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

        if [ -d "../output/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}" ]              
        then
            echo "../output/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]} is ok"
        else
            mkdir -p ../output/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}
        fi
    
        if [ -d "../output/root/mode_${decay_mode_points[$dm_i]}" ]
        then
            echo "../output/root/mode_${decay_mode_points[$dm_i]} is ok"
               
            if [ -e temp.txt ] 
            then 
               rm temp.txt 
            fi 

            #dst_list=temp.txt



            #- - - - -  - -add there
            cos_cout=0
            for cout_iii in ${xx_costheta_MIN[@]}
            do


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
                        if [ -e ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp ] 
                        then 
                           echo "Just remind: ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp already exists, and it will be update!"
                        fi 

                        #* * * *  The mass of Ds and D0,D+- are different, so we should use different fitting scripts.
                        if [ ${decay_mode_points[$dm_i]} -lt 400 ]
                        then
                            sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}/ ${mypath}/fitjob.head > ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp
                        else
                            sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}/ ${mypath}/Ds_fitjob.head > ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp
                        fi

                    fi 

                    if [[ `expr ${iline} % ${fileN}` -ne 0 && ${iline} -lt ${nline} ]] 
                    then 

                        echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp
                    fi 

                    if [[ `expr ${iline} % ${fileN}` == 0 || ${iline} == ${nline} ]] 
                    then 
                        echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp

                        #* * * *  The mass of Ds and D0,D+- are different, so we should use different fitting scripts.
                        if [ ${decay_mode_points[$dm_i]} -lt 400 ]
                        then       
                            sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}/ ${mypath}/dif_fitjob.tail >> ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp
                        else
                            sed -e s/XXX/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}/ ${mypath}/dif_Ds_fitjob.tail >> ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp
                        fi

                        sed -i "s#CUT_CUT#mmode== ${decay_mode_points[$dm_i]} \&\& mcharm == $CHARM_CHARM #g" `grep CUT_CUT  -rl ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp`
                        sed -i "s#HHH#${energy_points[$ep_i]}--${xx_cos_mode[$cos_cout]}#g" `grep HHH  -rl ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp`
                        sed -i "s#COSTHETA_Min#${xx_costheta_MIN[$cos_cout]}#g" `grep COSTHETA_Min  -rl ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp`
                        sed -i "s#COSTHETA_Max#${xx_costheta_MAX[$cos_cout]}#g" `grep COSTHETA_Max  -rl ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp`
                        
                        
                        
                        
                        
                        
                        if [[ ${decay_mode_points[$dm_i]} -ge 200 && ${decay_mode_points[$dm_i]} -lt 400 ]]
                        then
                            sed -i "s#DDD#D^{+}#g" `grep DDD  -rl ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp`
                        fi

                        if [ ${decay_mode_points[$dm_i]} -lt 200 ]
                        then
                            sed -i "s#DDD#D^{0}#g" `grep DDD  -rl ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp`
                        fi


                        #- - - - - - - - -  -
                        ls $path_output/weight/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/weight*root |sort > weight_xx.txt
                        weight_file=$(cat weight_xx.txt)

                        sed -i "s#WEIGHT_Tree_WEIGHT_Tree#$weight_file#g" `grep WEIGHT_Tree_WEIGHT_Tree  -rl ${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp`
                       #- - 这里功能可以改进



                        echo "${jobDir}/differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/mass_fit_${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_costheta${xx_cos_mode[$cos_cout]}_file_${ncount}.cpp is finished "

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

                let cos_cout++
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


