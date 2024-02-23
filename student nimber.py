n1=int(input(""))
n2=int(input(""))
n3=int(input(""))
d1=int(input(""))
d2=int(input(""))
d3=int(input(""))
a1=int(input(""))
a2=int(input(""))


n_set=[n1,n2,n3]
d_set=[d1,d2,d3]
a_set=[a1,a2]


outcome=[]

if a1==a2:
    for d in range(len(d_set)):
        if a1==d_set[d]:
            outcome.append(n_set[d])
else:
    for a in range(len(a_set)):
        for d in range(len(d_set)):
            if a_set[a]==d_set[d]:
                outcome.append(n_set[d])


if outcome==[]:
    print(-1)
else:
    if all(element==outcome[0] for element in outcome):
        print(outcome[0])
    else :
        print(",".join(map(str,outcome)))