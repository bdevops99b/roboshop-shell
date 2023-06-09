script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1
#samp
if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input roboshop user password missing
 exit
fi

func_print_head " Download App Content - setup erland repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_stat_check $?
func_print_head " Install erlang "
yum install erlang -y &>>$log_file
func_stat_check $?
func_print_head " Download App Content - setup rabbitmq repos "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_stat_check $?
func_print_head "  Install rabbitmq  "
yum install rabbitmq-server -y &>>$log_file
func_stat_check $?
func_print_head " Start rabbitmq Service "
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
func_stat_check $?
func_print_head "Add application user  "
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_stat_check $?