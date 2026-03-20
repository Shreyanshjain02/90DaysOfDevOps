# Day 03 – Linux Commands Practice

## Task
Today’s goal is to **build your Linux command confidence**.

You will create a cheat sheet of commands focused on:
- Process management
- File system
- Networking troubleshooting

This is the command toolkit you will reuse for years.

---

**Linux Command-cheatSheet**:(There are many types/categories of linux commands): keep updating as per learning and course

1. File & Directory Operations:-

   pwd -  path of working directory
     pwd (confused with aliases like -L and -P)

    ls -  list all files
     ls -l - list of all files with details: file permissions, owner, size, and modification date.
     ls -lt - list of all files with details: file permissions, owner, size, and modification date with order latest file first.
     ls -ltr - list of all files with details: file permissions, owner, size, and modification date with order oldest file first.

   Cd - Change directory
     cd / - Takes you to root
     cd .. - To go one folder back
     cd /home/ubuntu - Taked you to ubuntu directory/folder.

   Touch - create file
     touch - donottouch.txt - create file in existing directory

   mkdir - make directory
     mkdir private - create directory in existing directory

   Cp - copy -paste file or folder.
     cp donottouch.txt private/ - copy and paste file in private directory
     cp -r private public - copy recursively directory its content and paste into directory.

   mv - move file or folder
     mv donottouch.txt public/ - moving file to directory
     mv private/ public/ - move dir inside to dir
     rsync -a private/ public/ - this copy all files of private dir into public dir
     rsync -a private public/ - this move entire private dir into public dir

   rm - remove file or folder
     rm file.txt - remove file.txt in current dir
     rm -r private/ - remove whole directory and its files.
     rm *.txt -  remove all files with extension .txt in current dir.
     rm *.{doc,txt} - remove all files with extension .txt,.doc in current dir.

2. Process & Resource Management:-

   top - Real-time resource usage.

   htop- Real-time resource usage with good table and color format

   ps - process snapshot of current process.

   ps -aux -  process snapshot of all processes.

   kill -  kill any process with PID
     kill 9 - kill specific pid

   pkill - precision kill with name
     pkill nginx - kill all pids with name nginx

   nice - Every process has a nice value ranging from -20 (highest priority, least nice) to 19 (lowest priority, very nice). The default value is usually 0.
     nice -n 10 backup_script.sh - low priority task

   renice - renice to adjust a process that is already executing. It requires the PID.
     renice +10 -p 1234 - This will change priority of PID 1234 to +10

3. Networking & Connectivity
   ip: Replacing the old ifconfig for interface management.
      ip a - gives private ip address

   curl / wget: Transferring data over networks.
      curl ifconfig.me - give public ip address
      wget

   netstat / ss: Investigating socket connections.

   dig / nslookup: DNS troubleshooting
      dig google.com   - Domain Information Groper -

   ping: To check any server or service access or not.
      ping www.google.com

   Need to learn more complex Networking commands..
   
   
  
   
   
     
