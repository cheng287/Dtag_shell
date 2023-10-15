#!/bin/bash
####!/bin/tcsh -f

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#//////  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 


#///////////////////////////////////////////////////////////////////////
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
    unset contents
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

#DataParentPath1=/besfs5/groups/psip/psipgroup/user/wangzy/root/psip2021/data  变量与"="之间不能有空格
#DataParentPath1=/besfs5/groups/tauqcd/songwm/Rc_study/Rc/4740to4960/outputroot     
#DataParentPath1=/workfs2/bes/liucheng/others/dtag_shell/version2/fit

#* * * * * * * * * * * * * * Must Change Here * * * * *   

#DataParentPath1=/workfs2/bes/liucheng/try/fit        #* * * * * * 路径，可根据需要改变 * * * 但必须是关于 fit 的,这里的fit 目录是通过 hello_fit.sh 生成的目录
DataParentPath1=$PWD/fit                            #* * * * * * 默认当前路径，不需要改变


#* * * * * * * * * * * * * * * * * * * * * * * * * * * *







##* * ep_i=0   #* * * 能量   
##* * dm_i=0   #* * * decay mode
##* * rl_i=0   #* * * run number low
##* * rh_i=0   #* * * run number high
##* * lp_i=0   #* * *  luminosity





dm_i=0   #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do
    ep_i=0   #* * * 能量    4260  
    rl_i=0   #* * * run number low
    rh_i=0   #* * * run number high
    lp_i=0   #* * *  luminosity
    Ce_i=0   #* * *  CMS energy  4.26
    
    
    if [ -d "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed" ]
    then
        #cd ./fit/mode_${decay_mode_points[$dm_i]}
        echo " "
        echo " "
        echo "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed is ok"

        #* *  if [ -d "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed" ]                #* * * *  放拟合失败的文件
        #* *  then
        #* *      echo "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed is ok"
        #* *  else
        #* *      mkdir -p ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed
        #* *  fi



        #echo " CMS_energy   energy_point   luminosity          c0              c1                 mean              nbkg              nsig            sigma    " > ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
        echo " CMS_energy   energy_point   luminosity          path                                        c0              c1                 mean              nbkg              nsig            sigma    " > ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt

        cd ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed          #* * * * 进入 目录数组
        
        ls *sh.out* | sort > ${DataParentPath1}/temp_fit.txt
		
        unset file_number
        IFS=$'\n' file_number=($(cat ${DataParentPath1}/temp_fit.txt))  #* * * sh.out 单个目录下的文件数组列表

        for xy in  $(seq ${#file_number[*]})
        do
            [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
			#echo "////////"
			echo "${file_number[$xy-1]} is ok " 


            ls ${file_number[$xy-1]} | awk -F ".sh.out" '{print $1}' > ${DataParentPath1}/failed.txt              #* * .cpp list
            unset fff
            IFS=$'\n' fff=($(cat ${DataParentPath1}/failed.txt))            
            for n_fff in $(seq ${#fff[*]})
            do
                [[ ${fff[$n_fff-1]} = $name ]] && echo "${fff[$n_fff]}"
                echo "///cpp file list/////"
                echo ${fff[$n_fff-1]}   
            done

            ls ${file_number[$xy-1]} | awk -F ".cpp.sh.out" '{print $1}' > ${DataParentPath1}/faild_png.txt    # .png list
            unset ffpng
            IFS=$'\n' ffpng=($(cat ${DataParentPath1}/faild_png.txt))            
            for n_ffpng in $(seq ${#ffpng[*]})
            do
                [[ ${ffpng[$n_ffpng-1]} = $name ]] && echo "${ffpng[$n_ffpng]}"
                echo "///cpp file list/////"
                echo ${ffpng[$n_ffpng-1]}   
            done


            #* if [ -f "${DataParentPath1}/check.temp" ]
			#* then
			#* 	rm ${DataParentPath1}/check.temp
			#* fi

           
            grep -n "COVARIANCE MATRIX CALCULATED SUCCESSFULLY" ${file_number[$xy-1]}  | awk -F ":" '{print $1}' > ${DataParentPath1}/success.txt
            unset catxxx
            IFS=$'\n' catxxx=($(cat ${DataParentPath1}/success.txt))            
            for n_catxxx in $(seq ${#catxxx[*]})
            do
                [[ ${catxxx[$n_catxxx-1]} = $name ]] && echo "${catxxx[$n_catxxx]}"
                echo "///cut line number/////"
                echo ${catxxx[$n_catxxx-1]}   
            done
            nn_catxxx=${#catxxx[@]}  

            grep -n "hahahahahaha" ${file_number[$xy-1]}  | awk -F ":" '{print $1}' > ${DataParentPath1}/hhh.txt
            unset cathhh
            IFS=$'\n' cathhh=($(cat ${DataParentPath1}/hhh.txt))            
            for n_cathhh in $(seq ${#cathhh[*]})
            do
                [[ ${cathhh[$n_cathhh-1]} = $name ]] && echo "${cathhh[$n_cathhh]}"
                echo "///line number/////"
                echo ${cathhh[$n_cathhh-1]}   
            done
            nn_cathhh=${#cathhh[@]}
            n_range=`expr ${cathhh[$nn_cathhh-1]} - ${catxxx[$nn_catxxx-1]}`
            echo "select range is $n_range * * * * * * //////////////////////"





            #if [ ${glogc} -eq 1 ]  #* * *  我注释， 因为 glogc可以 >=1
            if [ $nn_catxxx -ge 1 ]       #* * *  i change there
            then
               
                #tail -n +${catxxx[$nn_catxxx-1]} ${file_number[$xy-1]} > ${DataParentPath1}/catcontent.txt
                cat ${file_number[$xy-1]} | tail -n +${catxxx[$nn_catxxx-1]} | head -n +$n_range  > ${DataParentPath1}/catcontent.txt


                #* * * * * * * * * * * * * * 判断是否拟合成功 * * * * * * * * * * * *

                log1=$(grep  "STATUS=OK" ${DataParentPath1}/catcontent.txt | wc -l)
                log2=$(grep  "STATUS=CONVERGED" ${DataParentPath1}/catcontent.txt | wc -l)
                #log3=$(grep  "STATUS=NOT POSDEF" ${DataParentPath1}/catcontent.txt | wc -l)

                log4=$(grep  "MATRIX ACCURATE" ${DataParentPath1}/catcontent.txt | wc -l)
                #log5=$(grep  "MATRIX NOT POS-DEF" ${DataParentPath1}/catcontent.txt | wc -l)

                log6=$(grep  "fixed" ${DataParentPath1}/catcontent.txt | wc -l)
                log7=$(grep  "WARNING" ${DataParentPath1}/catcontent.txt | wc -l)                    
                #log8=$(grep  "MATRIX UNCERTAINTY" ${DataParentPath1}/catcontent.txt | wc -l)
                
                if [[ ${log1} -eq 1 || ${log2} -eq 1 ]]
                then
                    echo "* * *  STATUS=OK or STATUS=CONVERGED * * *"
                else
                    echo "* * *  STATUS error ! ! ! * * *"
                    #echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}        ${file_number[$xy-1]}             *                *                  *                  *                 *                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                    echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}        ${file_number[$xy-1]}             *              STATUS              ERROR               *                 *                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                    
                    #* * cp $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}    #* *  将拟合失败的文件移动到 ./failed 
                    #* * cp ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]} 

                    if [ ${#energy_points[@]} -gt 1 ]           #* * 如果只有一个能量点，则数组长度小于 循环递增数目，从而导致 无法记录能量点信息， 故需要判断
                    then    
                        let ep_i++                                            #* * 这里有内容
                    fi
                    continue
                fi
                
                if [ ${log4} -eq 1 ]
                then
                    echo " * * *  MATRIX ACCURATE * * * * "
                else
                    echo "! ! !  MATRIX not ACCURATE ! ! !"                    
                    #echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}              *                *                  *                  *                 *                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                    #echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}        ${file_number[$xy-1]}             *                *                  *                  *                 *                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                    echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}        ${file_number[$xy-1]}             *              MATRIX               NOT             ACCURATE           ERROR              *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt

                    #* * cp $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed/    #* *  将拟合失败的文件移动到 ./failed 
                    #* * cp ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed/ 

                    if [ ${#energy_points[@]} -gt 1 ] 
                    then    
                        let ep_i++                                            #* * 这里有内容
                    fi
                    #let ep_i++
                    continue
                fi

                
                #if [[ ${log6} -eq 1 || ${log7} -eq 1 ]]
                if [[ ${log6} -ge 1 || ${log7} -ge 1 ]]   #*   * 因为 logi 可以 >=1
                then
                    echo "! ! ! parameter error ! ! ! "
                    #echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}              *                *                  *                  *                 *                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                    #echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}        ${file_number[$xy-1]}             *                *                  *                  *                 *                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                    echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}        ${file_number[$xy-1]}             *             PARAMETER            ERROR               *                 *                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt

                    #* * cp $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed/    #* *  将拟合失败的文件移动到 ./failed 
                    #* * cp ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed/ 

                    if [ ${#energy_points[@]} -gt 1 ] 
                    then    
                        let ep_i++                                     
                    fi
                    #let ep_i++
                    continue
                fi


                #* * * * * * * *  结束判断是否拟合成功  * * * * * * * * * * * * * *
                unset ycontents
                IFS=$'\n' ycontents=($(cat ${DataParentPath1}/catcontent.txt))   #* * * 开始对重定向后的内容挑选               
                for ycontents_i in  $(seq ${#ycontents[*]})
                do
                    #echo "\\\\\\\\\\\\\\\\\\\\\\\\\********${ycontents[$ycontents_i-1]}"     #* ** * * * *检查代码 ，可以注释
                    echo ${ycontents[$ycontents_i-1]} > ${DataParentPath1}/yycontents.txt
                    glogbc=$(grep  "hiiiiiiiiiii" ${DataParentPath1}/yycontents.txt | wc -l)                   
                    if [ ${glogbc} -eq 1 ]
                    then
                        tail -n +$ycontents_i ${DataParentPath1}/catcontent.txt > ${DataParentPath1}/finial_0.txt   #* * * *  拟合结果内容
                        echo "\\\\\\\\\\\\\\\\\\\\\\\\\\ ****************** $ycontents_i"
                        break
                                                          
                    fi

                done


                #* * * * * * * * * * * 最后挑选开始* * * * * * * * * * * * * * * * *
                #* * if [ -f "${DataParentPath1}/finial_1.txt" ]     #* * * * 拟合结果存储
				#* * then
				#* * 	rm ${DataParentPath1}/finial_1.txt
				#* * fi
                #* * touch ${DataParentPath1}/finial_1.txt
                
                #echo "CMS_energy    energy_point   luminosity  path  c0   c1  mean  nbkg   nsig  sigma    " > rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                echo ${CMS_energy[$ep_i]} > ${DataParentPath1}/finial_1.txt         #* * *  都用ep_i 了，因为它们的值都一样
                echo ${energy_points[$ep_i]} >> ${DataParentPath1}/finial_1.txt
                echo ${luminostiy_points[$ep_i]} >> ${DataParentPath1}/finial_1.txt
                echo ${file_number[$xy-1]} >> ${DataParentPath1}/finial_1.txt   
               
                unset fcontents
                IFS=$'\n' fcontents=($(cat ${DataParentPath1}/finial_0.txt))   #* * * 开始对重定向后的内容挑选               
                for fcontents_i in  $(seq ${#fcontents[*]})
                do
                    echo ${fcontents[$fcontents_i-1]} > ${DataParentPath1}/ffcontents.txt
                    yog1=$(grep  "c0" ${DataParentPath1}/ffcontents.txt | wc -l)
                    yog2=$(grep  "c1" ${DataParentPath1}/ffcontents.txt | wc -l)
                    yog3=$(grep  "mean" ${DataParentPath1}/ffcontents.txt | wc -l)
                    yog4=$(grep  "nbkg" ${DataParentPath1}/ffcontents.txt | wc -l)
                    yog5=$(grep  "nsig" ${DataParentPath1}/ffcontents.txt | wc -l)
                    yog6=$(grep  "sigma" ${DataParentPath1}/ffcontents.txt | wc -l)
                    
                    
                    if [ ${yog1} -eq 1 ]
                    then
                        cat ${DataParentPath1}/ffcontents.txt | grep -o "c0 .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                        echo ${fcontents[$fcontents_i-1]}

                    fi

                    if [ ${yog2} -eq 1 ]
                    then
                        cat ${DataParentPath1}/ffcontents.txt | grep -o "c1 .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt 
                        echo ${fcontents[$fcontents_i-1]}

                    fi

                    if [ ${yog3} -eq 1 ]
                    then
                        cat ${DataParentPath1}/ffcontents.txt | grep -o "mean .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt 
                        echo ${fcontents[$fcontents_i-1]}

                    fi

                    if [ ${yog4} -eq 1 ]
                    then
                        cat ${DataParentPath1}/ffcontents.txt | grep -o "nbkg .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                        echo ${fcontents[$fcontents_i-1]}

                    fi

                    if [ ${yog5} -eq 1 ]
                    then
                        cat ${DataParentPath1}/ffcontents.txt | grep -o "nsig .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                        echo ${fcontents[$fcontents_i-1]}

                    fi

                    if [ ${yog6} -eq 1 ]
                    then
                        cat ${DataParentPath1}/ffcontents.txt | grep -o "sigma .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                        echo ${fcontents[$fcontents_i-1]}

                    fi
                    

                done
                
                


                #* * * * * * * * * *  * 最后了，往 rerun_result_mode_${decay_mode_points[$dm_i]}.txt 填写内容
                unset finial_2_points
                IFS=$'\n' finial_2_points=($(cat ${DataParentPath1}/finial_1.txt))             
                for ixy in $(seq ${#finial_2_points[*]})
                do
                    [[ ${finial_2_points[$ixy-1]} = $name ]] && echo "${finial_2_points[$ixy]}"
                    echo "////////"
                    echo ${finial_2_points[$ixy-1]} 
                    echo -n "        ${finial_2_points[$ixy-1]}" >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                done

                echo "" >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt

                mv $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}    #* *  将从新拟合成功的移动到上一目录
                mv ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}
                mv ${ffpng}.png  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}

            
                
                
        
            else
                echo " not found ! ! ! "
                #echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}        ${file_number[$xy-1]}             *                not                  found                  !                 !                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt
                echo "        ${CMS_energy[$ep_i]}        ${energy_points[$ep_i]}        ${luminostiy_points[$ep_i]}        ${file_number[$xy-1]}             *               NOT                FOUND              ERROR              *                *    " >> ${DataParentPath1}/rerun_result_mode_${decay_mode_points[$dm_i]}.txt

                #* *  cp $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed/    #* *  将拟合失败的文件移动到 ./failed 
                #* *  cp ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/failed/ 
            fi

            if [ ${#energy_points[@]} -gt 1 ] 
            then    
                let ep_i++                                       
            fi
            #let ep_i++
        done    

        
        
        
    else            
        echo "* * * * * * Be careful, ./fit/mode_${decay_mode_points[$dm_i]} is not exist ! ! ! ! "
    fi
    let dm_i++
        
done     


echo "* * * * * * end * * * * * * * "
        
        
        
        
        
