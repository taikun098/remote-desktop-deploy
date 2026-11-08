# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
def run(script, timeout=300):
    c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
    sftp=c.open_sftp(); sftp.put(r"C:\Users\user\Doubao\chats\2026-11-01\new-chat-2\\"+script,"/tmp/"+script); sftp.close()
    c.get_transport().set_keepalive(15)
    _,so,se=c.exec_command("bash /tmp/"+script, timeout=timeout)
    out=so.read().decode("utf-8","replace")
    print(out.replace("\x00",""))
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e)
    c.close()
run("fcsteam_inst.sh")
print("\n########## 轮询安装结果 ##########\n")
run("fcsteam_poll.sh")
