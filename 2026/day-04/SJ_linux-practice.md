Process checks:-

  ps -aux|grep nginx  - give all process and its ids with name nginx
  pgrep -l nginx  - It is also used to get all pids with name nginx
  systemctl start nginx - To start nginx
  systemctl stop nginx - To stop
  systemctl status nginx - to get current status of nginx
  top :- give non-interactive system utilization (boring task manager)
  htop :- Colorfull interactive
  sytstemctl list-units -  gives list of all active units

  journalctl -u nginx - gives you logs of nginx

  
  how to download file from linux server to window local:
    scp -i privatekey user@public_dns:file/path/you_want_to_download c:/download
  
