import math
# ^.*remove.*\n

def read_file(file_path):
    column1 = []  # 存储第一列数据的列表
    column2 = []  # 存储第二列数据的列表
    column3 = []  # 存储第三列数据的列表

    with open(file_path, 'r') as file:
        lines = file.readlines()[1:]  # 跳过第一行

        for line in lines:
            # 分割每行的数据并转换为浮点数
            values = line.split()
            col1_value, col2_value, col3_value = map(float, values)

            # 将每列的数据添加到相应的列表
            column1.append(col1_value)
            column2.append(col2_value)
            column3.append(col3_value)

    return column1, column2, column3





file_D0 = './obs_cross_section_mode0.txt'  
file_Dp = './obs_cross_section_mode200.txt'  
file_Ds = './obs_cross_section_mode401.txt'  

output_file_path = 'add_obs_cross_section.txt'

energy_D0, cross_section_D0, cross_section_error_D0 = read_file(file_D0)
energy_Dp, cross_section_Dp, cross_section_error_Dp = read_file(file_Dp)
energy_Ds, cross_section_Ds, cross_section_error_Ds = read_file(file_Ds)


# print(" energy_D0  ", energy_D0)
# print("cross_section_D0  "  ,cross_section_D0)
# print("cross_section_error_D0"  ,cross_section_error_D0)

# print(" energy_Dp  ", energy_Dp)
# print("cross_section_Dp  "  ,cross_section_Dp)
# print("cross_section_error_Dp"  ,cross_section_error_Dp)

# print(" energy_Ds  ", energy_Ds)
# print("cross_section_Ds  "  ,cross_section_Ds)
# print("cross_section_error_Ds"  ,cross_section_error_Ds)



add_cross_section = []
add_cross_section_error = []

add_cross_section.clear()
add_cross_section_error.clear()

i = 0
while(i < len(energy_D0)):
    value = cross_section_D0[i] + cross_section_Dp[i] + cross_section_Ds[i]
    error = math.sqrt(cross_section_error_D0[i]**2 + cross_section_error_Dp[i]**2 +cross_section_error_Ds[i]**2 )
    add_cross_section.append(value)
    add_cross_section_error.append(error)
    i = i + 1

i = 0
with open(output_file_path, 'w') as output_file:
    output_file.write("energy          cross_section          cross_section_error \n")   
    while(i < len(energy_D0)):
        output_file.write(f"{energy_D0[i]}           {add_cross_section[i]}          {add_cross_section_error[i]} \n")
        i = i + 1

