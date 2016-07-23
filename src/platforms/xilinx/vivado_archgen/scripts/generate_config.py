#!/usr/bin/python
from random import shuffle


#-----------------------------------------------------------------------------#
#                             Main program                                    #
#-----------------------------------------------------------------------------#
def main():

   slave_num = 0
   sep = "-------------"
   configurations = []
   for bs in range(2):
      for mul in range(3):
         for div in range(2):
            for fpu in range(3):
               for pattern in range(2):
                  #configurations.append("S" + str(slave_num) + ":" + str(bs) + sep + str(mul) + sep +str(div) + sep +str(fpu) + sep +str(pattern) + sep +"8192" + sep +"blank")
                  configurations.append(":" + str(bs) + sep + str(mul) + sep +str(div) + sep +str(fpu) + sep +str(pattern) + sep +"8192" + sep +"blank")

   # Shuffle configurations
   shuffle(configurations)
   for config in configurations:
      print ' {:>3}'.format('S' + str(slave_num)) + config
      slave_num+=1

if __name__ == "__main__":
   main()  
