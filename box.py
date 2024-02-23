#輸入變數，並把字串轉為list
number_and_weight=input("")
number_and_weight_list=number_and_weight.split(",")
item_number=int(number_and_weight_list[0])
max_weight=int(number_and_weight_list[1])

item_string=input("")

item_string_list=item_string.split(",")
item_list=list(map(int, item_string_list))

#將物品重量由大排到小
for arrange in range(item_number):
    for change in range (item_number-arrange-1):
        if item_list[change] < item_list[change+1]:
            temporary=item_list[change]
            item_list[change]=item_list[change+1]
            item_list[change+1]=temporary

box_weight=[max_weight]

for number in range(item_number):
    add_new_box=True

    for put in range(len(box_weight)):
        if item_list[number]<=box_weight[put]:
            box_weight[put]=box_weight[put]-item_list[number]
            add_new_box=False
            break
    if add_new_box==True:
        box_weight.append(max_weight-item_list[number])

print(len(box_weight))