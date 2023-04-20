script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>> Install maven <<<<<<<<\e[0m"
yum install maven -y
echo -e "\e[36m>>>>>>>>> Add application user  <<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/shipping.zip
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m>>>>>>>>> Copy shipping SystemD file <<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service
echo -e "\e[36m>>>>>>>>> Start shipping services<<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable shipping
systemctl start shipping

yum install mysql -y
mysql -h mysql.panda4u.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl restart shipping