# -*- coding: utf-8 -*-
import paramiko, time
HOST="192.168.0.20"; USER="user"
KEY=r"C:\Users\user\.ssh\id_ed25519"
c=paramiko.SSHClient(); c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(HOST, username=USER, key_filename=KEY, timeout=25)
def run(cmd, t=90):
    print("### $ "+cmd, flush=True)
    _,so,se=c.exec_command(cmd, timeout=t)
    o=so.read().decode("utf-8","replace").rstrip()
    if o.strip(): print(o, flush=True)
    e=se.read().decode("utf-8","replace")
    if e.strip(): print("[e] "+e.rstrip(), flush=True)
# 1) 可执行权限
run("sudo -n chmod +x /opt/orcaslicer/OrcaSlicer.AppImage && echo CHMOD_OK")
# 2) FUSE 依赖（systemd-run 脱离 SSH 装，防断开）
run("sudo -n systemd-run --collect --unit=orca-fuse apt-get -y install libfuse2t64 >/dev/null 2>&1; echo launched")
for _ in range(24):
    time.sleep(5)
    _,so,_=c.exec_command("systemctl is-active orca-fuse 2>/dev/null", timeout=15)
    st=so.read().decode().strip()
    if st != "active":
        print("fuse-install done, final-state="+st, flush=True); break
# 3) 写包装脚本（DISPLAY=:1 物理屏）
wrapper="""#!/bin/bash
export DISPLAY=:1
exec /opt/orcaslicer/OrcaSlicer.AppImage \"$@\"
"""
sftp=c.open_sftp()
with sftp.open("/tmp/orca_wrapper.sh","w") as f: f.write(wrapper)
sftp.close()
run("sudo -n cp /tmp/orca_wrapper.sh /usr/local/bin/orcaslicer && sudo -n chmod 755 /usr/local/bin/orcaslicer && echo WRAPPER_OK")
run("cat /usr/local/bin/orcaslicer")
# 4) 检查物理屏 :1 与 GPU
run("echo '===Xorg :1==='; ps -eo pid,cmd | grep -E '[X]org -core :1'; echo '===GPU renderer (llvmpipe? amdgpu?)==='; DISPLAY=:1 glxinfo 2>/dev/null | grep -iE 'OpenGL renderer|OpenGL vendor' | head -3 || echo 'glxinfo 未装，跳过'")
# 5) 实测：在 :1 上启动 OrcaSlicer，数秒后确认存活再关闭
run("DISPLAY=:1 nohup /opt/orcaslicer/OrcaSlicer.AppImage --appimage-extract-and-run >/tmp/orca_test.log 2>&1 & echo LAUNCHED; sleep 12; pgrep -f 'OrcaSlicer|orca' | head; echo '---log---'; tail -8 /tmp/orca_test.log 2>/dev/null")
c.close()
