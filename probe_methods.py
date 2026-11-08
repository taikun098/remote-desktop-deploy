# -*- coding: utf-8 -*-
import paramiko
HOST="192.168.0.20"; USER="user"
t=paramiko.Transport((HOST,22))
try:
    t.connect()
    try:
        t.auth_none(USER)
    except paramiko.BadAuthenticationType as e:
        print("allowed types:", e.allowed_types)
    except Exception as e:
        print("auth_none:", type(e).__name__, e)
    t.close()
except Exception as e:
    print("transport error:", repr(e))
