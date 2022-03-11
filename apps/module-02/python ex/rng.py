from random import randint

min_nbr = int(input('Please enter the min number: '))
max_nbr = int(input('Please enter the max number: '))

if(max_nbr < min_nbr):
    print('Invalid input - shutting down')
else:
    rnd_nbr = randint(min_nbr, max_nbr)
    print(rnd_nbr)