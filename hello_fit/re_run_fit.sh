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



##* * ep_i=0   #* * * energy point   
##* * dm_i=0   #* * * decay mode
##* * rl_i=0   #* * * run number low
##* * rh_i=0   #* * * run number high
##* * lp_i=0   #* * *  luminosity


mypath=$PWD

mypath=$PWD
echo "the current path is - - -  $mypath"

cd ../output
DataParentPath1=$PWD
cd $mypath

 




if [ $# -ne 1 ]
then
    echo "* * * * * Be careful, only should one paramter * * * * *  "
    echo "./run_mode.sh jobname"
    exit
fi  
jobName=$1   #* * * jobName : the name of job will like "jobName_????.txt" 

dm_i=0       #* * * decay mode
for cout_i in ${decay_mode_points[@]}
do               
    ep_i=0   #* * * energy point 
    for cout_ii in ${energy_points[@]}
    do 
        
        if [ -d "$DataParentPath1/fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/failed" ]
        then
            echo "$DataParentPath1/fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/failed is ok"
        else
            echo "* * * * * * * * * * * *  $DataParentPath1/fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/failed is not exit ! ! !"
            let ep_i++
            continue
        fi

        cd ${DataParentPath1}/fit/mode_${decay_mode_points[$dm_i]}/${energy_points[$ep_i]}/failed
        ls mass_fit_${jobName}*.cpp |sort > temp_cpp.txt

     

        unset file_number
        IFS=$'\n' file_number=($(cat temp_cpp.txt))
        for xy in $(seq ${#file_number[*]})
        do
            [[ ${file_number[$xy-1]} = $name ]] && echo "${file_number[$xy]}"
            
            #echo "root -b -q ${file_number[$xy-1]}"
            root -b -q ${file_number[$xy-1]}
        done

        cd $mypath
        let ep_i++
    done

    let dm_i++
done
        
