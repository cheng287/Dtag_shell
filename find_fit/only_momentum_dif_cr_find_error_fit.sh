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


#///////////////////////////////////////////////////////////////////////////////////////////////////

#///////////////////////////////////////////////////////////////////////////////////////////////////

#* * * * * * * * * * * * * * Must Change Here * * * * *   

#DataParentPath1=/workfs2/bes/liucheng/try/only_momentum_differential_fit        #* * * * * * 路径，可根据需要改变 * * * 但必须是关于 fit 的,这里的fit 目录是通过 hello_fit.sh 生成的目录
                          #* * * * * * 默认当前路径，不需要改变


mypath=$PWD
cd ../output/only_momentum_differential_fit
DataParentPath1=$PWD
cd $mypath

#* * * * * * * * * * * * * * * * * * * * * * * * * * * *


##* * ep_i=0   #* * * energy points  
##* * dm_i=0   #* * * decay mode
##* * rl_i=0   #* * * run number low
##* * rh_i=0   #* * * run number high
##* * lp_i=0   #* * *  luminosity


#/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/${energy_points[@]}


dm_i=0   #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do
    ep_i=0   #* * * energy point    4260      
    for cout_ii in ${energy_points[@]}
    do 
    
        if [ -d "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}" ]
        then
            #cd ./only_momentum_differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}
            echo " "
            echo " "
            echo "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]} is ok"

            if [ -d "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed" ]                #* * * *  Put the file that failed to fit
            then
                echo "${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed is ok"
            else
                mkdir -p ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed
            fi



            #echo " CMS_energy   energy_point   luminosity          c0              c1                 mean              nbkg              nsig            sigma    " > ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
            # echo "          path                                                            c0              c1                 mean              nbkg              nsig            sigma    " > ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt

            echo "          path                                                              c0                 c1              fsig                 mean1             mean2              nbkg              nsig            sigma1            sigma2    " > ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
            cd ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}          #* * * * 进入 目录数组



            ls *cpp.sh.out* | sort > ${DataParentPath1}/temp_fit.txt

            unset file_number
            IFS=$'\n' file_number=($(cat ${DataParentPath1}/temp_fit.txt))  #* * * sh.out 单个目录下的文件数组列表

            for xy in  $(seq ${#file_number[*]})
            do
                [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
        		#echo "////////"
        		echo "${file_number[$xy-1]} is ok " 


                ls ${file_number[$xy-1]} | awk -F ".sh.out" '{print $1}' > ${DataParentPath1}/failed.txt
                unset fff
                IFS=$'\n' fff=($(cat ${DataParentPath1}/failed.txt))            
                for n_fff in $(seq ${#fff[*]})
                do
                    [[ ${fff[$n_fff-1]} = $name ]] && echo "${fff[$n_fff]}"
                    echo "///cpp file list/////"
                    echo ${fff[$n_fff-1]}   
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

                #grep -n "hahahahahaha" ${file_number[$xy-1]}  | awk -F ":" '{print $1}' > ${DataParentPath1}/hhh.txt
                grep -n "output_end_output_end" ${file_number[$xy-1]}  | awk -F ":" '{print $1}' > ${DataParentPath1}/hhh.txt
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
                        #echo "                ${file_number[$xy-1]}             *                *                  *                  *                 *                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
                        echo "        ${file_number[$xy-1]}             *              STATUS              ERROR               *                 *                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt

                        cp $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed    #* *  将拟合失败的文件移动到 ./failed 
                        cp ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed 

                        #----if [ ${#energy_points[@]} -gt 1 ]           #* * 如果只有一个能量点，则数组长度小于 循环递增数目，从而导致 无法记录能量点信息， 故需要判断
                        #----then    
                        #----    let ep_i++                                            #* * 这里有内容
                        #----fi
                        continue
                    fi

                    if [ ${log4} -eq 1 ]
                    then
                        echo " * * *  MATRIX ACCURATE * * * * "
                    else
                        echo "! ! !  MATRIX not ACCURATE ! ! !"                    
                        #echo "                      *                *                  *                  *                 *                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
                        #echo "                ${file_number[$xy-1]}             *                *                  *                  *                 *                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
                        echo "        ${file_number[$xy-1]}             *              MATRIX               NOT             ACCURATE           ERROR              *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt

                        cp $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed    #* *  将拟合失败的文件移动到 ./failed 
                        cp ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed 

                        #---if [ ${#energy_points[@]} -gt 1 ] 
                        #---then    
                        #---    let ep_i++                                            #* * 这里有内容
                        #---fi
                        #---#let ep_i++
                        continue
                    fi


                    #if [[ ${log6} -eq 1 || ${log7} -eq 1 ]]
                    if [[ ${log6} -ge 1 || ${log7} -ge 1 ]]   #*   * 因为 logi 可以 >=1
                    then
                        echo "! ! ! parameter error ! ! ! "
                        #echo "                      *                *                  *                  *                 *                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
                        #echo "                ${file_number[$xy-1]}             *                *                  *                  *                 *                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
                        echo "        ${file_number[$xy-1]}             *             PARAMETER            ERROR               *                 *                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt

                        cp $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed    #* *  将拟合失败的文件移动到 ./failed 
                        cp ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed 

                        #---if [ ${#energy_points[@]} -gt 1 ] 
                        #---then    
                        #---    let ep_i++                                     
                        #---fi
                        #---#let ep_i++
                        continue
                    fi


                    #* * * * * * * *  结束判断是否拟合成功  * * * * * * * * * * * * * *
                    unset ycontents
                    IFS=$'\n' ycontents=($(cat ${DataParentPath1}/catcontent.txt))   #* * * 开始对重定向后的内容挑选               
                    for ycontents_i in  $(seq ${#ycontents[*]})
                    do
                        #echo "\\\\\\\\\\\\\\\\\\\\\\\\\********${ycontents[$ycontents_i-1]}"     #* ** * * * *检查代码 ，可以注释
                        echo ${ycontents[$ycontents_i-1]} > ${DataParentPath1}/yycontents.txt
                        #glogbc=$(grep  "hiiiiiiiiiii" ${DataParentPath1}/yycontents.txt | wc -l)
                        glogbc=$(grep  "output_begin_output_begin" ${DataParentPath1}/yycontents.txt | wc -l)                    
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

                    #echo "CMS_energy    energy_point   luminosity  path  c0   c1  mean  nbkg   nsig  sigma    " > result_${energy_points[$ep_i]}_mode_${decay_mode_points[$dm_i]}.txt
                    #--echo ${CMS_energy[$ep_i]} > ${DataParentPath1}/finial_1.txt         #* * *  都用ep_i 了，因为它们的值都一样
                    #--echo ${energy_points[$ep_i]} >> ${DataParentPath1}/finial_1.txt
                    #--echo ${luminostiy_points[$ep_i]} >> ${DataParentPath1}/finial_1.txt
                    echo ${file_number[$xy-1]} > ${DataParentPath1}/finial_1.txt   

                    unset fcontents
                    IFS=$'\n' fcontents=($(cat ${DataParentPath1}/finial_0.txt))   #* * * 开始对重定向后的内容挑选               
                    for fcontents_i in  $(seq ${#fcontents[*]})
                    do
                        echo ${fcontents[$fcontents_i-1]} > ${DataParentPath1}/ffcontents.txt
                        # yog1=$(grep  "c0" ${DataParentPath1}/ffcontents.txt | wc -l)
                        # yog2=$(grep  "c1" ${DataParentPath1}/ffcontents.txt | wc -l)
                        # yog3=$(grep  "mean" ${DataParentPath1}/ffcontents.txt | wc -l)
                        # yog4=$(grep  "nbkg" ${DataParentPath1}/ffcontents.txt | wc -l)
                        # yog5=$(grep  "nsig" ${DataParentPath1}/ffcontents.txt | wc -l)
                        # yog6=$(grep  "sigma" ${DataParentPath1}/ffcontents.txt | wc -l)
                        yog1=$(grep  "c0" ${DataParentPath1}/ffcontents.txt | wc -l)
                        yog2=$(grep  "c1" ${DataParentPath1}/ffcontents.txt | wc -l)
                        yog3=$(grep  "fsig" ${DataParentPath1}/ffcontents.txt | wc -l)
                        yog4=$(grep  "mean1" ${DataParentPath1}/ffcontents.txt | wc -l)
                        yog5=$(grep  "mean2" ${DataParentPath1}/ffcontents.txt | wc -l)
                        yog6=$(grep  "nbkg" ${DataParentPath1}/ffcontents.txt | wc -l)
                        yog7=$(grep  "nsig" ${DataParentPath1}/ffcontents.txt | wc -l)
                        yog8=$(grep  "sigma1" ${DataParentPath1}/ffcontents.txt | wc -l)                   
                        yog9=$(grep  "sigma2" ${DataParentPath1}/ffcontents.txt | wc -l)


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
                            cat ${DataParentPath1}/ffcontents.txt | grep -o "fsig .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt 
                            echo ${fcontents[$fcontents_i-1]}

                        fi

                        if [ ${yog4} -eq 1 ]
                        then
                            cat ${DataParentPath1}/ffcontents.txt | grep -o "mean1 .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                            echo ${fcontents[$fcontents_i-1]}

                        fi

                        if [ ${yog5} -eq 1 ]
                        then
                            cat ${DataParentPath1}/ffcontents.txt | grep -o "mean2 .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                            echo ${fcontents[$fcontents_i-1]}

                        fi

                        if [ ${yog6} -eq 1 ]
                        then
                            cat ${DataParentPath1}/ffcontents.txt | grep -o "nbkg .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                            echo ${fcontents[$fcontents_i-1]}

                        fi

                        if [ ${yog7} -eq 1 ]
                        then
                            cat ${DataParentPath1}/ffcontents.txt | grep -o "nsig .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                            echo ${fcontents[$fcontents_i-1]}

                        fi

                        if [ ${yog8} -eq 1 ]
                        then
                            cat ${DataParentPath1}/ffcontents.txt | grep -o "sigma1 .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                            echo ${fcontents[$fcontents_i-1]}

                        fi

                        if [ ${yog9} -eq 1 ]
                        then
                            cat ${DataParentPath1}/ffcontents.txt | grep -o "sigma2 .* +/-" | awk -F " " '{print $2}' >> ${DataParentPath1}/finial_1.txt
                            echo ${fcontents[$fcontents_i-1]}

                        fi


                    done




                    #* * * * * * * * * *  * 最后了，往 result_${energy_points[$ep_i]}_mode_${decay_mode_points[$dm_i]}.txt 填写内容
                    unset finial_2_points
                    IFS=$'\n' finial_2_points=($(cat ${DataParentPath1}/finial_1.txt))             
                    for ixy in $(seq ${#finial_2_points[*]})
                    do
                        [[ ${finial_2_points[$ixy-1]} = $name ]] && echo "${finial_2_points[$ixy]}"
                        echo "////////"
                        echo ${finial_2_points[$ixy-1]} 
                        echo -n "        ${finial_2_points[$ixy-1]}" >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
                    done

                    echo "" >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt





                else
                    echo " not found ! ! ! "
                    #echo "                ${file_number[$xy-1]}             *                not                  found                  !                 !                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt
                    echo "        ${file_number[$xy-1]}             *               NOT                FOUND              ERROR              *                *    " >> ${DataParentPath1}/result_mode_${decay_mode_points[$dm_i]}.txt

                    cp $fff ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed    #* *  将拟合失败的文件移动到 ./failed 
                    cp ${file_number[$xy-1]}  ${DataParentPath1}/mode_${decay_mode_points[$dm_i]}/${energy_points[@]}/failed 
                fi

                #---if [ ${#energy_points[@]} -gt 1 ] 
                #---then    
                #---    let ep_i++                                       
                #---fi
                #---#let ep_i++
            done    


        else            
            echo "* * * * * * Be careful, ./only_momentum_differential_fit/mode_${decay_mode_points[$dm_i]}/${energy_points[@]} is not exist ! ! ! ! "
            #---if [ ${#energy_points[@]} -gt 1 ] 
            #---then    
            #---    let ep_i++                       
            #---fi

        fi

        let ep_i++
    done
    
    let dm_i++
        
done     

if [ -e ${DataParentPath1}/temp_fit.txt ] 
then 
    rm ${DataParentPath1}/temp_fit.txt 
fi

if [ -e ${DataParentPath1}/failed.txt ] 
then 
    rm ${DataParentPath1}/failed.txt
fi

if [ -e ${DataParentPath1}/success.txt ] 
then 
    rm ${DataParentPath1}/success.txt 
fi

if [ -e ${DataParentPath1}/hhh.txt ] 
then 
    rm ${DataParentPath1}/hhh.txt 
fi

if [ -e ${DataParentPath1}/catcontent.txt ] 
then 
    rm ${DataParentPath1}/catcontent.txt 
fi

if [ -e ${DataParentPath1}/yycontents.txt ] 
then 
    rm ${DataParentPath1}/yycontents.txt 
fi

if [ -e ${DataParentPath1}/finial_0.txt ] 
then 
    rm ${DataParentPath1}/finial_0.txt 
fi

if [ -e  ${DataParentPath1}/finial_1.txt ] 
then 
    rm  ${DataParentPath1}/finial_1.txt 
fi

if [ -e ${DataParentPath1}/ffcontents.txt ] 
then 
    rm ${DataParentPath1}/ffcontents.txt 
fi





echo "* * * * * * end * * * * * * * "
        
        
        
        
        
