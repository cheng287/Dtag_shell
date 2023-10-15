#!/bin/bash
####!/bin/tcsh -f

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#//////  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 




#* * * * * * Read energy point information * * * * * * *begin
#infor.txt  * *顺序   energy_points   luminostiy_points  runnu_low   runnu_high    CMS_energy
#decay_mode.txt     different_decay_mode

unset energy_point
IFS=$'\n' energy_point=($(cat infor.txt))             
for i in $(seq ${#energy_point[*]})
do
    [[ ${energy_point[$i-1]} = $name ]] && echo "${energy_point[$i]}"
    #echo ${energy_point[$i-1]}
done

            #* * #echo ${energy_point[*]}
            #* * 
            #* * #* * * * * output array * * * method 1
            #* * #for point in ${energy_point[@]}     
            #* * #do    
            #* * #    echo $point
            #* * #    echo '***'
            #* * #done

#* * * * * output array * * * method 2
i_cout=0
while [ $i_cout -lt ${#energy_point[@]} ]
do
    echo ${energy_point[$i_cout]}
    echo "* * * "
    let i_cout++
done

echo "* * * * * * * * * * * * * 二维数组信息输出 * * * end"
#* * * * * * Read energy point information * * * * * * *end

#/////////////////////////////////////////////////////////////////////////////////////

#* * * * * * * * * 清空数组 * * * remember change there ! ! !
unset infor
unset energy_points
unset luminostiy_points
unset runnu_low
unset runnu_high
unset  CMS_energy

unset decay_mode_points




#* * * * * * * * * * * * * 二维数组转换为一维输出 * * * begin

j=0
for arrat_1d in ${energy_point[@]}
do
    unset contents     #* * 我后面添加 ，好像之前没添加也没出错  ！! ! !  * * ** *  2022/10/22
    IFS=' ' read -r -a contents <<< "$arrat_1d"
    for var in "${contents[@]}"
    do
    infor[j]=$var
    ((j++))
    echo $var
    
    done
done

number_1=0
while [ $number_1 -lt ${#infor[@]} ]
do
    echo "+ + +  "
    echo ${infor[$number_1]}  
    let number_1++
done

echo "* * * * * * * * * * * * * 二维数组转换为一维数组输出 * * * end"
#* * * * * * * * * * * * * * 二维数组转换为一维输出 * * * end



#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 赋值 * * * begin
#* * * * very important here
number=5          #* * * * * 改变这儿，有几列数据就写几,这里已经固定 * * * remember change there ! ! !
#* * * *
number_2=0        #* * * * while 循环计数

energy_count=1
luminostiy_count=1
runnu_low_count=1
runnu_high_count=1
CMS_energy_count=1          

#* * * * 相关物理量定义，根据需要增加或减少这儿的变量个数 * * * begin * * * remember change there ! ! !
energy_i=0
luminostiy_i=0
runnu_low_i=0
runnu_high_i=0
CMS_energy_i=0
#* * * * 相关物理量定义 * * * end
while [ $number_2 -lt ${#infor[@]} ]
do
    #echo "! ! ! ! !  "    
    #* * * * * * * * * * * * * * * * * 根据需要改变这儿 * * * * begin
    if [ $number_2 -lt $number ]
    then
         echo "* * * "
         #echo $number_2
        if [ $number_2 -eq 0 ]
        then
           energy_points[$energy_i]=${infor[$number_2]}
           #energy_points[${#energy_points[@]}]=${infor[$number_2]}
           echo ${energy_points[$energy_i]}
           let energy_i++ 
        fi

        if [ $number_2 -eq 1 ]
        then
            luminostiy_points[$luminostiy_i]=${infor[$number_2]}
            #luminostiy_points[${#luminostiy_points[@]}]=${infor[$number_2]}
            echo ${luminostiy_points[$luminostiy_i]}
            let luminostiy_i++
        fi

       if [ $number_2 -eq 2 ]
       then
           runnu_low[$runnu_low_i]=${infor[$number_2]}
           #runnu_low[${#runnu_low[@]}]=${infor[$number_2]}
           echo ${runnu_low[$runnu_low_i]}
           let runnu_low_i++
       fi

       if [ $number_2 -eq 3 ]
       then
           runnu_high[$runnu_high_i]=${infor[$number_2]}
           #runnu_high[${#runnu_high[@]}]=${infor[$number_2]}
           echo ${runnu_high[$runnu_high_i]}
           let runnu_high_i++
       fi

       if [ $number_2 -eq 4 ]
       then
           CMS_energy[$CMS_energy_i]=${infor[$number_2]}
           #CMS_energy[${#CMS_energy[@]}]=${infor[$number_2]}
           echo ${CMS_energy[$CMS_energy_i]}
           let CMS_energy_i++
       fi
        
        
    fi
    #* * * * * * * * * * * * * * * * * 根据需要改变这儿 * * * * end
    
   
    
    
    if [ $number_2 -ge $number ]
    then
        #* * * * * *  根据需要增加或减少这儿的变量个数 * * * remember change there ! ! !
        x=`expr $number \* $energy_count`
        y=`expr 1 + $number \* $luminostiy_count`
        z=`expr 2 + $number \* $runnu_low_count`
        w=`expr 3 + $number \* $runnu_high_count`
        v=`expr 4 + $number \* $CMS_energy_count`

        #echo $x
        echo "* * * "
        if [ $number_2 -eq $x ]
        then 
            energy_points[$energy_i]=${infor[$number_2]}
            #echo "xxxxxxxxx"
            echo ${energy_points[$energy_i]}
            let energy_i++
            let energy_count++
        fi

        if [ $number_2 -eq $y ]
        then 
            luminostiy_points[$luminostiy_i]=${infor[$number_2]}
            #luminostiy_points[${#luminostiy_points[@]}]=${infor[$number_2]}    这行代码错误
            #echo "yyyyyyyyy"
            echo ${luminostiy_points[$luminostiy_i]}
            let luminostiy_i++
            let luminostiy_count++
        fi
      
        if [ $number_2 -eq $z ]
        then 
            runnu_low[$runnu_low_i]=${infor[$number_2]}
            #runnu_low[${#runnu_low[@]}]=${infor[$number_2]}        这行代码错误
            echo ${runnu_low[$runnu_low_i]}
            let runnu_low_i++
            let runnu_low_count++
        fi

        if [ $number_2 -eq $w ]
        then 
            runnu_high[$runnu_high_i]=${infor[$number_2]}
            #runnu_high[${#runnu_high[@]}]=${infor[$number_2]}        这行代码错误
            echo ${runnu_high[$runnu_high_i]}
            let runnu_high_i++
            let runnu_high_count++
        fi

        if [ $number_2 -eq $v ]
        then 
            CMS_energy[$CMS_energy_i]=${infor[$number_2]}
            #CMS_energy[${#CMS_energy[@]}]=${infor[$number_2]}        这行代码错误
            echo ${CMS_energy[$CMS_energy_i]}
            let CMS_energy_i++
            let CMS_energy_count++
        fi

   
    fi

    echo $number_2
    let number_2++
done


echo "* * * * decay mode list * * * "
IFS=$'\n' decay_mode_points=($(cat decay_mode.txt))             
for i in $(seq ${#decay_mode_points[*]})
do
    [[ ${decay_mode_points[$i-1]} = $name ]] && echo "${decay_mode_points[$i]}"
    echo "////////"
    echo ${decay_mode_points[$i-1]}   
done

echo "* * * * * * * * * * * * * 将一维数组分割成若干物理量数组输出,例如能量点,亮度等 * * * end"

#///////////////////////////////////////////////////////////////////////////////////////////////////


#* * * * * * * * * * * * * * 赋值 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  end
echo -e "\n\n\n* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
echo "* * * * * * * * * * * * * 物理量数组 summary * * * * * * * * * * * * * * * * * * * * *"
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"

echo -e "\n energy points : "
    echo ${energy_points[*]}          #* * * * * 能量点列表             ep_i   计数变量   
echo -e "\n luminosity points : "
    echo ${luminostiy_points[*]}      #* * * * *  亮度列表              lp_i     计数变量              
echo -e "\n run number low : "
    echo ${runnu_low[*]}              #* * * * * run number low         rl_i      计数变量   
echo -e "\n run number high : "   
    echo ${runnu_high[*]}             #* * * * * run number high        rh_i     计数变量  
echo -e "\n CMS energy : "   
    echo ${CMS_energy[*]}             #* * * * * CMS energy             Ce_i     计数变量       
echo -e "\n decay mode points : "
    echo ${decay_mode_points[*]}      #* * * * *  decay mode            dm_i     计数变量   

echo -e "\n\n* * * * * * * * * * * * * 最后相关物理量数组输出 * * * * * * * * * * * * * * * * * * * end"
echo "number of * * infor.txt * * array elements      =   ${#infor[@]}"
echo "number of energy points       =   ${#energy_points[@]}"
echo "number of luminosity points   =   ${#luminostiy_points[@]}"
echo "number of run number low      =   ${#runnu_low[@]}"
echo "number of run number high     =   ${#runnu_high[@]}"
echo "number of CMS energy          =   ${#CMS_energy[@]}"
echo "number of decay mode points   =   ${#decay_mode_points[@]}"


#///////////////////////////////////////////////////////////////////////////////////////////////////

#echo "hello${energy_points[2]}.txt"

#! ! ! ! ! ! ! ! ! ! ! ! 这里的decay_mode 和 能量点，run号可能不一致，因为一个能量点下有不同的decay_mode
#! ! ! ! ! ! ! ! ! ! ! !
#/////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////* * * 大循环 * * * begin///////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////
#* * * * * * * 计数变量



##* * ep_i=0   #* * * 能量   
##* * dm_i=0   #* * * decay mode
##* * rl_i=0   #* * * run number low
##* * rh_i=0   #* * * run number high
##* * lp_i=0   #* * *  luminosity

dm_i=0       #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do
    ep_i=0   #* * * 能量    4260  
    rl_i=0   #* * * run number low
    rh_i=0   #* * * run number high
    lp_i=0   #* * *  luminosity
    Ce_i=0   #* * *  CMS energy  4.26
    
    
    for cout_ii in ${energy_points[@]}
    do

        if [ -d "mode_${decay_mode_points[$dm_i]}" ]
        then
            echo "mode_${decay_mode_points[$dm_i]} is ok"
        else
            mkdir mode_${decay_mode_points[$dm_i]}
        fi

        if [ -d "./root/mode_${decay_mode_points[$dm_i]}" ]
        then
            echo "root/mode_${decay_mode_points[$dm_i]} is ok"
        else
            mkdir -p ./root/mode_${decay_mode_points[$dm_i]}
        fi




        #/////////////////////////////////////////////////////////////////////////////////////////////////////
        if [[ $# -ne 1 && $# -ne 2 && $# -ne 3 && $# -ne 4 ]]
        then
          echo " "
          echo "purpose:[for real data] you can get jobOptions with certain number rec file in each job automatically. "
          echo "        Also, you can summit the jobs automatically. "
          echo "useage : ./hello_mode.sh jobName [jobN] [fileN] [jobDir]"
          echo "jobName: is the name of jobOption you wish"
          echo "         this argument SHOULD NOT be omitted. "
          echo "jobN   : is the largest number of jobs"
          echo "         by default, it will be 20 "
          echo "fileN  : is the smallest of rec file in each jobOption"
          echo "         by default, it will be 200  "
          echo "jobDir : is the directory where you want the jobOption is"
          echo "         by default, it will be PWD  "
          echo "  "
          echo "SQUESTION: step one  : please check/modify the 'infor.head' "
          echo "           step two  : please check/modify the 'infor.tail' "
          echo "           step three: please check 'DataParentPath1' in 'hello_mode.sh' correct or not"
          exit
        fi

        #  DataParentPath: where is the real data
        #* * * * * * * * * 路径必须改变* * * * * * * * * * * * * * * * *
        #DataParentPath1=/besfs5/groups/psip/psipgroup/user/wangzy/root/psip2021/data  变量与"="之间不能有空格
        DataParentPath1=/besfs5/groups/tauqcd/songwm/Rc_study/Rc_MC/D0bar1/ana/root      
        #DataParentPath1=/besfs5/groups/tauqcd/songwm/Rc_study/Rc/4740to4960/mini/mode0        #* * * * * * 路径，必须改变 ! ! ! ! ! ! ! ! ! ! ! !








        #  jobName : the name of job will like "jobName_????.txt" 

        #jobName=${decay_mode_points[jjj]}     # * * * jjj 记录物理量数组的编号，第几个decay_mode 等等
        jobName=$1                                      #* * *  jobName=data, mc  等等
        echo "jobName : ${jobName}"

        #  jobN    : the largest number of jobs" 
        if [ $# -ge 2 ]  
        then
            jobN=$2
        else
            jobN=20
        fi
        echo "The largest number of jobs : ${jobN}"

        #  fileN   : the smallest number of rec file in each jobOption" 
        if [ $# -ge 3 ] 
        then
            fileN=$3
        else
           fileN=2
        fi
        echo "The smallest number of rec file in each job : ${fileN}"

        # input the path as DataParentPath of data
        if [ $# -ge 4 ] 
        then
             jobDir=$4
        else
             jobDir=$PWD
        fi
        echo "jobDir  : ${jobDir}"

        # get all rec file from all child path of the DataParentPath
        echo "okok "
        echo " DataParentPath1 : ${DataParentPath1}"

         dst_list=temp.txt

        if [ -e ${jobDir}/temp.txt ] 
        then 
           rm ${jobDir}/temp.txt 
        fi 

        if [ ! -e temp.txt ]   
        then 
            find  ${DataParentPath1}/ -name "*.root" |sort >$dst_list
        else
            find  ${DataParentPath1}/ -name "*.root" |sort >>$dst_list
        fi 

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


        # make jobOptions with certain rec files in each job
        let iline=1
        let i=1
        ijob=${i}

        unset file_number
        IFS=$'\n' file_number=($(cat temp.txt)) 
        for xy in $(seq ${#file_number[*]})
        do
                [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"

                #* * * * * * add * * * * begin   * * * * 根据需要改变输出位数
                 ncount=`printf "%03d"  $ijob`
                #* * * * * * add * * * * end

                #if [ `expr ${iline} % ${fileN}` == 1 ] 
                if [ `expr ${iline} % ${fileN}` == 0 ]  #* * 为了使每个job 里面只含有一个root file, 将这里的 `1` 改为 `0` ,i add this line
                then 
                    if [ -e ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp ] 
                    then 
                       echo "Just remind: ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.txt already exists, and it will be update!"
                    fi 
                    sed -e s/XXX/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}/ ${jobDir}/infor.head >> ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp

                    # sed -i "s/HHH_MODE/${decay_mode_points[$dm_i]}/g" `grep HHH_MODE -rl  ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`
                    # sed -i "s/HHHRUN_LOW/${runnu_low[$rl_i]}/g"       `grep HHHRUN_LOW -rl ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`
                    # sed -i "s/HHHRUN_HIGH/${runnu_high[$rh_i]}/g"     `grep HHHRUN_HIGH -rl ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`

                fi 

                if [[ `expr ${iline} % ${fileN}` -ne 0 && ${iline} -lt ${nline} ]] 
                then 

                    echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp
                fi 

                if [[ `expr ${iline} % ${fileN}` == 0 || ${iline} == ${nline} ]] 
                then 
                    echo  "    chaindata->Add("\"${file_number[$xy-1]}\" ") ;" >>  ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp
                    sed -e s/XXX/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}/ ${jobDir}/infor.tail >> ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp

                    sed -i "s/HHH_MODE/${decay_mode_points[$dm_i]}/g" `grep HHH_MODE  -rl ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`
                    sed -i "s/HHHRUN_LOW/${runnu_low[$rl_i]}/g"       `grep HHHRUN_LOW -rl ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`
                    sed -i "s/HHHRUN_HIGH/${runnu_high[$rh_i]}/g"     `grep HHHRUN_HIGH -rl ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp`


                    echo ${jobDir}/mode_${decay_mode_points[$dm_i]}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp is finished 
                    #boss -q ${jobName}_${ncount}.txt
                    #boss.condor ${jobName}_${ncount}.txt
                    mv ${jobDir}/${jobName}_${energy_points[$ep_i]}_mode${decay_mode_points[$dm_i]}_${ncount}.cpp ./mode_${decay_mode_points[$dm_i]}
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

#/////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////* * * 大循环 * * * end //////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////
#/////////////////////////////////////////////////////////////////////////////////////////////////////
