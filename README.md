# Automatic-Speaker-Recognition

By Deepak Muralidharan and Shubham Agarwal (UCLA, Electrical Engineering)

1) cd to the /sampleCode/ folder (make it as the working directory). The main file is final_2.m

2) give path_name and GENDER as arguments to final_2.m.

===========

For example:

path_name = '..\WavData\male\TEST\BABBLE_10dB\083A_S03_2.wav'

GENDER = ‘male’

predicted_label = final_2(path_name, GENDER)

===========

3) It is recommended to use a mac to run the code. 

NOTE: If you are using Windows to run the code, please remove lines 51 and 110 in the final_2.m code. Since mac uses right slash (‘/‘) and Windows uses left slash (‘\’), I have replaced (‘\’) with (‘/‘) in lines 51 and 110 as I ran my code on a Mac. 