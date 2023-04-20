script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>> Install Nginx server <<<<<<<<\e[0m"
yum install nginx -y
echo -e "\e[36m>>>>>>>>> Copy roboshop configuration file <<<<<<<<\e[0m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf
rm -rf /usr/share/nginx/html/*
echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/frontend.zip
echo -e "\e[36m>>>>>>>>> Start nginx Service <<<<<<<<\e[0m"
systemctl restart nginx
systemctl enable nginx