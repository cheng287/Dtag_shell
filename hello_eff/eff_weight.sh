#!/bin/bash

#* * *  generate the Nsig.txt from the  'result_3770_mode_0_charm_p1.txt'
./read.sh

#* * *  generate the 'eff.txt' and 'weight.txt'
python3.6 eff.py