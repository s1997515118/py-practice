bestprice = []
bestprofit = []
profit = []
price = 0

number=int(input(""))
for package in range(number):
    basic_demand=int(input(""))
    sensitiveness=int(input(""))
    cost=int(input(""))

    current_price=0
    max_price=0
    max_profit=0
    while True:
        if len(profit)>=3:
            if profit[len(profit)-2]>=profit[len(profit)-1] and profit[len(profit)-2]>=profit[len(profit)-3]:
                if profit[len(profit)-2]<=0:
                    price=1000
                    profit=[0]
                break
        price+=1
    if profit[len(profit)-2]<=0:
        bestprice.append(price)
    else:
        bestprice.append(price-1)
    bestprofit.append(max(profit))
print(bestprofit.index(max(bestprofit))+1,bestprice[bestprofit.index(max(bestprofit))],max(bestprofit),sep=",")
