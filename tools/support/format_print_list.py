from sys import argv
from os import listdir

x = listdir(argv[1])
for i in x:
  print('  '+i)