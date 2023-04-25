script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
#rabbitmq_appuser_password=$1
echo -e "\e[36m>>>>>>>>> Install Python <<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y
echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"
useradd ${app_user}
mkdir /app
echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/payment.zip
cd /app
pip3.6 install -r requirements.txt
echo -e "\e[36m>>>>>>>>> Copy payment SystemD file <<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|/" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service
echo -e "\e[36m>>>>>>>>> Start Payment Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment