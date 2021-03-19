#!/bin/bash
#

supervisord() {
    #/usr/bin/sudo /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
}

sshkeygen() {
    # 重新生成ssh服务的机器key
    echo "[+] ssh-keygen ..."
    #/usr/bin/sudo /usr/bin/ssh-keygen -A -v
    /usr/bin/ssh-keygen -A -v
    #md5sum /etc/ssh/*.pub
    echo "[+] done"
}

# # NOTE: 改用 supervisord 管理
# sshd() {
#     # 最后启动 ssh 服务，用前台方式启动，不退出的...
#     echo "[+] sshd ..."
#     #/usr/bin/sudo /usr/sbin/sshd -D -o ListenAddress=0.0.0.0
#     /usr/bin/sudo /usr/sbin/sshd -o ListenAddress=0.0.0.0
# }

user_auto() {
    # 普通用户自定义启动运行脚本，
    # NOTE: 运行用户的ubuntu而不是root哦。。。
    if [[ -x /home/ubuntu/.local/auto.sh ]]; then
        echo "[+] /home/ubuntu/.local/auto.sh ..."
        sudo -u ubuntu /home/ubuntu/.local/auto.sh
    fi
}

# # NOTE: 改用 supervisord 管理
# crond() {
#     /usr/bin/sudo /usr/sbin/crond
# }

main() {
    sshkeygen
    supervisord
    user_auto
    sleep infinity
}
main