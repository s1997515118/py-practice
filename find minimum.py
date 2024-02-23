n=int(input(""))
x_string=input("")

x_string_list=x_string.split(",")
x_list=list(map(int, x_string_list))

y_list=[]
for i in range(n-1):
    y_list.append(max(x_list[i]-x_list[i+1],0))

print(min(y_list))