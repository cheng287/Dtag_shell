#!/bin/bash

#* * * * * * * * * * * * * ** * * * * * * * * * * * * ** * * * * * * * * * 
#* * * * * * * * * * * * * *auther   LIU Cheng * * * * * * * * * * * * * *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *



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

#///////////////////////////////////////////////////////////////////////////////////////////////////



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
#DataParentPath1=/besfs5/groups/tauqcd/songwm/Rc_study/Rc/4612to4700/outputroot      
DataParentPath1=/besfs5/groups/tauqcd/songwm/Rc_study/Rc_MC/D01/ana/root


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




dm_i=0       #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do
    ep_i=0   #* * * energy point    4260  
    rl_i=0   #* * * run number low
    rh_i=0   #* * * run number high
    lp_i=0   #* * *  luminosity
    Ce_i=0   #* * *  CMS energy  4.26
    
    
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