alias colored='ack --flush --passthru --color --color-match=blue "DEBUG" | ack --flush --passthru --color --color-match=yellow "WARN(ING)?" |  ack --flush --passthru --color --color-match=red "ERROR" | ack --flush --passthru --color --color-match=red "^.*FAILURE.*" | ack --flush --passthru --color --color-match=green "BUILD SUCCESSFUL" | ack --flush --passthru --color --color-match=green "^Tests run: .*" | ack --flush --passthru --color --color-match=blue "\-\-\-*"'

tail() {
  /usr/bin/tail $@ | colored
}

tabname() {
  printf "\e]1;$1\a"
}

flushdns() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    echo "DNS Cache Flushed"
}

flushping() {
    flushdns
    ping $1
}

hostsset() {
    sudo ln -sf $1 /etc/hosts
    flushdns
}
