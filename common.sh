app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
# start
func_print_head() {
  echo -e "\e[35m>>>>>>> $1 <<<<<<<\e[0m"
}
func_stat_check(){
   if [ $1 -eq 0 ]; then
        echo -e "\e[32mSuccess\e[0m"
      else
        echo -e "\e[31mFailure\e[0m"
        exit 1
      fi
}
func_schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
  print_head " Copy MongoDB repo "
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
  func_stat_check $?
  print_head " Install MongoDB Client "
  yum install mongodb-org-shell -y
  func_stat_check $?
  print_head "Load Schema "
  mongo --host mongod.panda4u.online </app/schema/${component}.js
  func_stat_check $?
fi

  if [ "$scheme_setup" == "mysql" ]; then
   func_print_head " Install Mysql client "
   yum install mysql -y
   func_stat_check $?
   func_print_head " Load schema "
   mysql -h mysql.panda4u.online -uroot -p${mysql_root_password}< /app/schema/${component}.sql
   func_stat_check $?
fi
}
func_app_prereq(){
    func_print_head " Create Application User "
    useradd ${app_user}
    func_stat_check $?
    func_print_head " Create Application Directory "
    mkdir /app
    func_stat_check $?
    func_print_head " Download App Content "
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    func_stat_check $?
    func_print_head " Extract Application Content "
    cd /app
    unzip /tmp/${component}.zip
    func_stat_check $?
}

func_systemd_setup(){
  func_print_head " Setup SystemD service "
  func_print_head " Copy ${component} SystemD file "
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  func_print_head " Start ${component} services "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}
  func_stat_check $?
}
func_nodejs(){
  func_print_head " Configuring NodeJS repos "
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_stat_check $?

  func_print_head " Installing NodeJS "
  yum install nodejs -y
  func_stat_check $?

  func_app_prereq

  func_print_head " Install NodeJS Dependencies "
  npm install
  func_stat_check $?

  func_schema_setup
  func_systemd_setup
}

func_java(){

  func_print_head " Install maven "
  yum install maven -y >/tmp/roboshop.log
  func_stat_check $?
  func_app_prereq
  func_print_head " Download Maven Dependencies  "
  mvn clean package
 func_stat_check $?
  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup
  func_systemd_setup

  }
