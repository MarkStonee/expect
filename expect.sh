#��¼
set timeout -1
spawn ssh ubuntu@10.12.5.223
set password [lindex $argv 0]
expect { 
"yes/no" { send "yes\n";  exp_continue } 
"*password:*" {
	send "$password\n"
	expect @
	}
}
#��ɵ�¼

#����Ȩ��
send "su\n"
expect {
"Password: "
}
send "$password\n"
expect #
#�������Ȩ��

#�����������ļ���
send "cd /home/\n"
expect #

send "cd panshi\n"
expect {
	"*No such file or directory*" {
		send "mkdir panshi\n"
		send "cd panshi\n"
		expect "#" {}
	}
	"#" {}
}

send "cd local\n"
expect {
	"*No such file or directory*" {
	send "mkdir local\n"
	send "cd local\n"
	}
	"#" {}
}

send "cd ..\n"
expect "#"

send "sudo chmod -R 777 local\n"
expect {
	"assword" {
		send "$password\n"
		expect "#" {}
	}
	"#" {}
}
interact
#��ɹ����������ļ���

#�˻ص�����
send "exit\n"
expect "ubuntu@tegra-ubuntu"
send "exit\n"
expect "ubuntu@tegra-ubuntu"
#����˻ص�����

#�����ļ���Զ��
send "scp -r /home/panshi/mnt/reference/myexpect/bin/linux/arm_64/node_proc ubuntu@10.12.5.223:/home/panshi/local\n"
expect { 
	"yes/no" {send "yes\n"; exp_continue}
	"password:" {
		send "$password\n"
		expect {
			"denied" {}
			"#"
		}
	}
	"#" {}
}
interact
#��ɿ����ļ���Զ��

#������Ĳ�������һ�飬�ҵ��������ļ���ִ��
