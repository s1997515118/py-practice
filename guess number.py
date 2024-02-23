x=int(input(""))
y=int(input(""))

x_list=[x//100,(x%100)//10,x%10]
y_list=[y//100,(y%100)//10,y%10]

A=0
B=0

for A_test in range(3):
    if x_list[A_test]==y_list[A_test]:
        A+=1

for B_test in range(3):
    for B_test2 in range(3):
        if x_list[B_test]==y_list[B_test2]:
            B+=1

print(A,"A",B-A,"B",sep="")