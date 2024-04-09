import PIL.Image as Image
import os

 

IMAGES_PATH = './'  # 图片集地址
IMAGES_FORMAT = ['.png']  # 图片格式
# IMAGE_SIZE = 1000  # 每张小图片的大小
IMAGE_SIZE_x = 1000   #每张图片x 方向大小  800
IMAGE_SIZE_y = 800   #每张图片y 方向大小   700


IMAGE_ROW = 2  # 图片间隔，也就是合并成一张图后，一共有几行
IMAGE_COLUMN = 2  # 图片间隔，也就是合并成一张图后，一共有几列
IMAGE_SAVE_PATH = './merge.png'  # 图片转换后的地址
 
# 获取图片集地址下的所有图片名称
image_names = [name for name in os.listdir(IMAGES_PATH) for item in IMAGES_FORMAT if
               os.path.splitext(name)[1] == item]

print(image_names)
print("* * afer sort* * * ")
image_names.sort()
print(image_names)

print("The length of IMAGES_FORMAT  = " ,len(image_names))

lost = IMAGE_COLUMN - (IMAGE_ROW*IMAGE_COLUMN  - len(image_names) )
print("The last column is   =  " ,lost)       # print("最后一行的图片列数为   =  " ,lost)
#简单的对于参数的设定和实际图片集的大小进行数量判断
if len(image_names) > IMAGE_ROW * IMAGE_COLUMN:
    raise ValueError("The quantity do not match ! ! !")
 
 # 定义图像拼接函数


# def image_compose():

#     to_image = Image.new('RGB', (IMAGE_COLUMN * IMAGE_SIZE, IMAGE_ROW * IMAGE_SIZE)) #创建一个新图


#     for y in range(1, IMAGE_ROW + 1):
#         if y < IMAGE_ROW:
#             for x in range(1, IMAGE_COLUMN + 1):       
#                 from_image = Image.open(IMAGES_PATH + image_names[IMAGE_COLUMN * (y - 1) + x - 1]).resize((IMAGE_SIZE, IMAGE_SIZE),Image.Resampling.LANCZOS)
#                 to_image.paste(from_image, ((x - 1) * IMAGE_SIZE, (y - 1) * IMAGE_SIZE))
#         else:
#             for z in range(1, lost + 1):       
#                 from_image = Image.open(IMAGES_PATH + image_names[IMAGE_COLUMN * (y - 1) + z - 1]).resize((IMAGE_SIZE, IMAGE_SIZE),Image.Resampling.LANCZOS)
#                 to_image.paste(from_image, ((z - 1) * IMAGE_SIZE, (y - 1) * IMAGE_SIZE))
              
    
#     return to_image.save(IMAGE_SAVE_PATH) # 保存新图

# image_compose() #调用函数


def image_compose():

    to_image = Image.new('RGB', (IMAGE_COLUMN * IMAGE_SIZE_x, IMAGE_ROW * IMAGE_SIZE_y)) #创建一个新图


    for y in range(1, IMAGE_ROW + 1):
        if y < IMAGE_ROW:
            for x in range(1, IMAGE_COLUMN + 1):       
                from_image = Image.open(IMAGES_PATH + image_names[IMAGE_COLUMN * (y - 1) + x - 1]).resize((IMAGE_SIZE_x, IMAGE_SIZE_y),Image.Resampling.LANCZOS)
                to_image.paste(from_image, ((x - 1) * IMAGE_SIZE_x, (y - 1) * IMAGE_SIZE_y))
        else:
            for z in range(1, lost + 1):       
                from_image = Image.open(IMAGES_PATH + image_names[IMAGE_COLUMN * (y - 1) + z - 1]).resize((IMAGE_SIZE_x, IMAGE_SIZE_y),Image.Resampling.LANCZOS)
                to_image.paste(from_image, ((z - 1) * IMAGE_SIZE_x, (y - 1) * IMAGE_SIZE_y))
              
    
    return to_image.save(IMAGE_SAVE_PATH) # 保存新图

image_compose() #调用函数
