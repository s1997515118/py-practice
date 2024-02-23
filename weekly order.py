standard = int(input(""))
weekly_standard = int(input(""))
unit_price = int(input(""))
extra_price = int(input(""))
bonus = int(input(""))
order=[]  #每日完成訂單數
revenue=0
for day in range(7):            #建立每日訂單數列表
    order.append(int(input("")))

for day in range(len(order)):
    if order[day] <= standard:              #若訂單完成數沒有超過當日標準
        revenue += order[day] * unit_price
    else:                                   #若訂單完成數超過當日標準
        revenue += standard * unit_price + (order[day]-standard) * extra_price
    print(revenue)

if sum(order)>=weekly_standard: #週訂單累計是否達到週標準
    revenue+=bonus
print(revenue)