# In MySql we can able to load the data using  "Import Data Wizard tool" 
## But if the file size is Big then it is very difficult to load the data into the MYSQl Work bench so for the Reason I am using a Load_infile method using a Sql Code.
## Using Load_infile method is most efficent way to load the data in few seconds and comparing to "Import Data Wizard tool", Load_infile Method way faster and efficent.
## Before using Load_infile Method we need to check weather Global Variable of Load_infile is on or off. 
## if not We need to turn on in both Client side and Server side 
## Setp-1 for server side: 
### check command = " show variables like 'local_infile'; "
### Switch Command = SET GLOBAL local_infile=1;
## Setp-2 For Client Side
### on home page of MySql right click on the local instace and click edit connections, --> Advanced ---> in others type 'OPT_LOCAL_INFILE=1'.
## Once we done this we can able to establish load_infile 

## And to load the data Follow my Notebook.
