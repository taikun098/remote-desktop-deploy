# -*- coding: utf-8 -*-
import paramiko, sys
HOST="192.168.0.20"; USER="user"
pw = "1"
t=paramiko.Transport((HOST,22))
try:
    t.connect()
    # ask server which auth methods are allowed
    try:
        am = t.auth_none(USER)
        print("allowed auth methods:", am)
    except Exception as e:
        print("auth_none result:", type(e).__name__)
    # fresh-ish single password attempt (only 1 try, avoid lockout)
    try:
        t.auth_password(USER, pw)
        print("PASSWORD_OK")
    except paramiko.AuthenticationException:
        print("PASSWORD_FAILED")
    except Exception as e:
        print("OTHER:", type(e).__name__, e)
    t.close()
except Exception as e:
    print("transport error:", repr(e))
