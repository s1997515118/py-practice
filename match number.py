n1=int(input(""))
n2=int(input(""))
n3=int(input(""))
d1=int(input(""))
d2=int(input(""))
d3=int(input(""))
a1=int(input(""))
a2=int(input(""))

outcome1=None
outcome2=None

if a1 == d1:
    outcome1=n1
elif a1==d2:
    outcome1=n2
elif a1==d3:
    outcome1=n3

if a2 == d1:
    outcome2=n1
elif a2==d2:
    outcome2=n2
elif a2==d3:
    outcome2=n3

if outcome1==None and outcome2==None:
    print(-1)
elif ontcome1==None:
    print(outcome2)
elif outcome1==None:
    print(outcome1)
elif outcome1==outcome2:
    print(outcome1)
else:
    print(outcome1,",",outcome2,sep="") 