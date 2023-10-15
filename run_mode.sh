#!/bin/bash
####!/bin/tcsh -f

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#//////  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

#* * * * * * Read energy point information * * * * * * *begin
#infor.txt  * *顺序   energy_points   luminostiy_points  runnu_low   runnu_high    CMS_energy
#decay_mode.txt     different decay mode

unset energy_point
IFS=$'\n' energy_point=($(cat infor.txt))             
for i in $(seq ${#energy_point[*]})
do
    [[ ${energy_point[$i-1]} = $name ]] && echo "${energy_point[$i]}"
    #echo ${energy_point[$i-1]}
done

#echo ${energy_point[*]}

#* * * * * output array * * * method 1
#for point in ${energy_point[@]}     
#do    
#    echo $point
#    echo '***'
#done

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
number=5          #* * * * * 改变这儿，有几列数据就写几 * * * remember change there ! ! !
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
            #energy_points[${#energy_points[@]}]=${infor[$number_2]}   这行代码错误
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

DataParentPath1=$PWD   
   


dm_i=0   #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do
        #/////////////////////////////////////////////////////////////////////////////////////////////////////
        if [ $# -ne 1 ]
        then
            echo "* * * * * Be careful, only should one paramter * * * * *  "
            echo "./sub_make.sh jobname"
            exit
        fi


        #  DataParentPath: where is the real data

        #DataParentPath1=/besfs5/groups/psip/psipgroup/user/wangzy/root/psip2021/data  变量与"="之间不能有空格
  
        jobName=$1



        #  jobName : the name of job will like "jobName_????.txt" 
        if [ -d "$DataParentPath1/mode_${decay_mode_points[$dm_i]}" ]
        then
            echo "$DataParentPath1/mode_${decay_mode_points[$dm_i]} is ok"
        else
            echo "* * * * * * * * * * * *  $DataParentPath1/mode_${decay_mode_points[$dm_i]} is not exit ! ! !"
            let dm_i++
            continue
        fi


        cd ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}
        
        #dst_list=temp_cpp.txt
        #ls "${jobName}*.cpp" |sort >$dst_list
        ls ${jobName}*.cpp |sort > temp_cpp.txt
        #find $PWD -name "${jobName}*.cpp" |sort > temp_cpp.txt


        unset file_number
        IFS=$'\n' file_number=($(cat temp_cpp.txt))
        for xy in $(seq ${#file_number[*]})
        do
            [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
            
           #* *   #* * * * * * add * * * * begin   * * * * 根据需要改变输出位数
           #* *   #ncount=`printf "%03d"  $ijob`
           #* *    #* * * * * * add * * * * end
           #* *   echo "/////////////////// ${file_number[$xy-1]}"
           #* *   #sed -e s/XXX/${file_number[$xy-1]}/ ${DataParentPath1}/make_sh.head > ./${file_number[$xy-1]}.sh
           #* *   sed -e "s/XXX/ /g" ${DataParentPath1}/sub_sh.head > ./${file_number[$xy-1]}.sh
           #* *   #echo "-----------------"
           #* *   echo "${PWD}/${file_number[$xy-1]}" >> ./${file_number[$xy-1]}.sh
           #* *   
           #* *   chmod +x ${file_number[$xy-1]}.sh
           #* *   #hep_sub ${file_number[$xy-1]}.sh

            root -l -b -q ${file_number[$xy-1]}
        done

    let dm_i++
done
        
 
