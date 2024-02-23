number_and_cost_chr=input()
price_chr=input()
demand_chr=input()

number_and_cost_list=number_and_cost_chr.split(",")
number=int(number_and_cost_list[0])
cost=int(number_and_cost_list[1])
price=[int(p) for p in price_chr.split(",")]
demand=[int(d) for d in demand_chr.split(",")]

bestprice=0
bestdemand=0
bestprofit=-10000000
for best in range(number):
    profit=(price[best]-cost)*demand[best]
    if profit>bestprofit:
        bestprice=price[best]
        bestdemand=demand[best]
        bestprofit=profit
    elif profit==bestprofit and demand[best]>bestdemand:
        bestprice=price[best]

print(bestprice,bestprofit,sep=",")