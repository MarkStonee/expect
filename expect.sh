#��¼
set timeout -1
set password [lindex $argv 0]
for {set i 220} {$i<=230} {incr i} {
	puts $i
	set var 10.12.5.	
	append var $i
	
	spawn ssh ubuntu@$var
	
	expect { 
	" No route to host" { continue }
	"yes/no" { send "yes\n";exp_continue} 
	"*password:*" {
		send "$password\n"
			expect { 
			"*password: " { send "$password\n"; exp_continue} 
			"(publickey,password)" { continue }
			"gssapi-with-mic,password)" { continue }
			"tegra-ubuntu" {}
			}			
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
		"panshi#" {}
	}

	send "cd local\n"
	expect {
		"*No such file or directory*/home#" {
		send "mkdir local\n"
		except "/home/panshi#"
		send "cd local\n"
		except "/home/panshi/local#"
		}
		"/home/panshi/local#" {}
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
	#��ɹ����������ļ���
}

expect "arm_64$"
spawn exit

for {set i 220} {$i<=230} {incr i} {
	puts $i
	set var 10.12.5.	
	append var $i
	#�����ļ���Զ��
	spawn scp -r /home/panshi/node_proc ubuntu@$var:/home/panshi/local
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
}
#��ɿ����ļ���Զ��
	
#������Ĳ�������һ�飬�ҵ��������ļ���ִ��
