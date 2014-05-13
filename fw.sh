#!/bin/bash
#
#  File: fw.sh
#  Desc: FW firewall rules 
#
#  Improved by qmi <qmi@eworldcom.hu> 
#  Based on the work of:
#  $Id: fw.sh 19 2005-06-08 13:02:11Z lirul $
#

MYNAME="`basename "$0"`"

### configurable settings
LOCAL_ROUTER="192.168.0.1"
#LOCAL_ROUTER="192.168.1.1"
#LOCAL_ROUTER="192.168.43.1"
#LOCAL_ROUTER="172.16.240.1"
#DHCP_SERVER="172.16.240.2"
DHCP_SERVER=$LOCAL_ROUTER
OUT_DNS1="192.168.0.1"
#OUT_DNS1="194.168.4.100"
OUT_DNS2="8.8.4.4"
#OUT_DNS2="194.168.8.100"

# local network settings
LOCAL_DEV="wlan0"
IBMLAPTOP=""

# trusted host
TRUSTED_SSH_IP="$MACBOOK \
		$IBMLAPTOP "

# binaries path
FW="/sbin/iptables"

flush_everything() {
    ### setting up default policies (temporarily)
    $FW -P INPUT ACCEPT
    $FW -P FORWARD ACCEPT
    $FW -P OUTPUT ACCEPT

    ### flush, delete and zero counter all chains 
    $FW -F
    $FW -X
    $FW -Z
}

sysctl_tuning() {

    ### Sysctl tuning (got from firestarter)
    # Turn off IP forwarding by default
    echo 0 > /proc/sys/net/ipv4/ip_forward
    # Log 'odd' IP addresses (excludes 0.0.0.0 & 255.255.255.255)
    echo 1 > /proc/sys/net/ipv4/conf/all/log_martians
    # Don't accept IP redirects
    echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
    # Redirects turn off
    echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
    # Turn off TCP Timestamping in kernel
    #echo 0 > /proc/sys/net/ipv4/tcp_timestamps
    # Set TCP Re-Ordering value in kernel to '5'
    #echo 5 > /proc/sys/net/ipv4/tcp_reordering
    # Turn off TCP ACK in kernel
    #echo 0 > /proc/sys/net/ipv4/tcp_sack
    # Turn off TCP Window Scaling in kernel
    #echo 0 > /proc/sys/net/ipv4/tcp_window_scaling
    # Turn off Extended Cognest Notification
    #echo 0 > /proc/sys/net/ipv4/tcp_ecn
    # Set SYN ACK retry attempts to '3'
    #echo 3 > /proc/sys/net/ipv4/tcp_synack_retries
    # ICMP Dead Error Messages protection
    echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
    # ICMP Broadcasting protection
    echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
    # Set Keepalive timeout to 30 seconds
    #echo 1800 > /proc/sys/net/ipv4/tcp_keepalive_time
    # Set to 1280 syn backlog
    #echo 1280 > /proc/sys/net/ipv4/tcp_max_syn_backlog
}

do_everything() {

    ### create own chains
    $FW -N noise
    $FW -N in_synprot_all
    #$FW -N in_ssh_pub
    $FW -N in_tcp_pub
    $FW -N in_udp_pub
    $FW -N in_icmp_pub
    $FW -N ping_tracert
    
    #echo 1...   
    ### ugly traffic on public interface
    $FW -A noise -s 10.0.0.0/8 -j DROP
    $FW -A noise -s 172.16.0.0/12 -j DROP
    #$FW -A noise -s 192.168.0.0/16 -j DROP
    #$FW -A noise -s 224.0.0.0/8 -j DROP
    $FW -A noise -m addrtype --dst-type BROADCAST -j DROP
    $FW -A noise -p TCP ! --syn -m state --state NEW -j DROP
    #$FW -A noise -m limit --limit 10/s --limit-burst 20 -j LOG --log-prefix "Unauth NOISE: "
    $FW -A noise -f -j DROP
    
    #echo 1a..   
    ### TCP SYN flood protection
    $FW -A in_synprot_all -m limit --limit 5/s --limit-burst 10 -j RETURN
    #$FW -A in_synprot_all -j DROP
    
    ### allowed incoming ssh connections
    #for ip in $TRUSTED_SSH_IP; do
    #    $FW -A in_ssh_pub -s $ip -j ACCEPT
    #done
    
    #$FW -A in_ssh_pub -m limit --limit 30/m --limit-burst 10 -j LOG --log-prefix "Unauth SSH: "
    #$FW -A in_ssh_pub -j DROP
    
    #echo 1b..   
    ### allowed ping and udp tracert packages
    $FW -A ping_tracert -i $LOCAL_DEV -s $LOCAL_ROUTER -j ACCEPT
    $FW -A ping_tracert -i $LOCAL_DEV -d $LOCAL_ROUTER -j ACCEPT
    $FW -A ping_tracert -i $LOCAL_DEV -m limit --limit 30/m -j LOG --log-prefix "Unauth ICMP: "
    $FW -A ping_tracert -j DROP
    
    #echo 2...   
    ### allowed incoming icmp types
    $FW -A in_icmp_pub -i $LOCAL_DEV -p ICMP --icmp-type destination-unreachable -j ACCEPT
    $FW -A in_icmp_pub -i $LOCAL_DEV -p ICMP --icmp-type source-quench -m limit --limit 3/s -j ACCEPT
    $FW -A in_icmp_pub -i $LOCAL_DEV -p ICMP --icmp-type time-exceeded -j ACCEPT
    $FW -A in_icmp_pub -i $LOCAL_DEV -p ICMP --icmp-type parameter-problem -j ACCEPT
    $FW -A in_icmp_pub -i $LOCAL_DEV -p ICMP --icmp-type echo-reply -m limit --limit 2/s --limit-burst 15 -j ping_tracert
    $FW -A in_icmp_pub -i $LOCAL_DEV -p ICMP --icmp-type echo-request -m limit --limit 2/s --limit-burst 15 -j ping_tracert
    $FW -A in_icmp_pub -m limit --limit 30/m -j LOG --log-prefix "Unauth ICMP: "
    $FW -A in_icmp_pub -j DROP
    
    ######################################################################
    ### INCOMING packets
    ######################################################################

    ### all incoming TCP packets
    # SSH
    #$FW -A in_tcp_pub -p TCP --dport 22 -j in_ssh_pub
    #$FW -A in_tcp_pub -p TCP --dport 22 -j ACCEPT
    # Skype
    $FW -A in_tcp_pub -p TCP --dport 32804 -j ACCEPT
    #$FW -A in_tcp_pub -p TCP --dport 113 -j REJECT --reject-with tcp-reset
    $FW -A in_tcp_pub -m limit --limit 30/m -j LOG --log-prefix "Unauth TCP: "
    $FW -A in_tcp_pub -j DROP
    
    ### all incoming UDP packets
    #$FW -A in_udp_pub -p UDP --dport 68 -j ACCEPT
    $FW -A in_udp_pub -p UDP --sport 32769:65535 --dport 33434:33523 -j ping_tracert
    $FW -A in_udp_pub -j DROP
    
    #echo 3...   
    ### the main INPUT chain
    $FW -A INPUT -i $LOCAL_DEV -j noise
    $FW -A INPUT -i $LOCAL_DEV -p TCP --syn -j in_synprot_all
    $FW -A INPUT -i $LOCAL_DEV -p ALL -m state --state ESTABLISHED,RELATED -j ACCEPT
    $FW -A INPUT -i lo -p ALL -j ACCEPT
    $FW -A INPUT -p ICMP -j in_icmp_pub
    $FW -A INPUT -p TCP -i $LOCAL_DEV -j in_tcp_pub
    $FW -A INPUT -p UDP -i $LOCAL_DEV -j in_udp_pub

    # final policy 
    $FW -A INPUT -j DROP
    
    #echo 3a...   
    ######################################################################
    ### OUTGOING packets
    ######################################################################
    
    ### the main OUTPUT chain
    $FW -A OUTPUT -p TCP ! --syn -m state --state NEW -j DROP
    # $FW -A OUTPUT -s $LOCAL_IP -o $LOCAL_DEV -p ALL -m unclean -j DROP
    $FW -A OUTPUT -p ALL -o lo -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -m state --state ESTABLISHED,RELATED -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -p ICMP -j ACCEPT
    ### allowed outgoing DHCP packets
    #echo 3b...   
    $FW -A OUTPUT -o $LOCAL_DEV -p UDP --dport 67 -d $DHCP_SERVER -j ACCEPT
    ### allowed outgoing DNS packets to name servers
    $FW -A OUTPUT -o $LOCAL_DEV -p UDP --dport 53 -d $OUT_DNS1 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -p UDP --dport 53 -d $OUT_DNS2 -j ACCEPT
    ### enable multicasting on the same network segment (mDNS, etc.)
    $FW -A OUTPUT -o $LOCAL_DEV -p UDP --dport 5353 -d 224.0.0.251 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -p all -m addrtype --dst-type MULTICAST -j ACCEPT
    #echo 3c...   

    #echo 4...   
    ### gmail smtp servers
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.108 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.109 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.108 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.109 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.16 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.16 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.16 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.16 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.108 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.108 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.109 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.109 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.16 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.16 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.108 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.108 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.109 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.109 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.16 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.16 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.108 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.108 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.109 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.109 -p TCP --dport 587 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.136.108 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.136.109 -p TCP --dport 465 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.136.16 -p TCP --dport 465 -j ACCEPT
    # gmail imap
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.108 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.109 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.108 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.108 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.69.108 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.16 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.16 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.16 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.69.16 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.109 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.109 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.16 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.108 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.109 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 209.85.229.108 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 209.85.229.109 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.79.108 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.79.109 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.136.108 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.136.109 -p TCP --dport 993 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.136.16 -p TCP --dport 993 -j ACCEPT
    # google talk chat and GCM (Google Cloud Messaging)
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.65.125 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.125 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.70.125 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.125 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 209.85.147.125 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 74.125.132.125 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.66.188 -p TCP --dport 5228 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.67.188 -p TCP --dport 5228 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.194.78.188 -p TCP --dport 5228 -j ACCEPT
    # facebook chat
    #echo 5...   
    $FW -A OUTPUT -o $LOCAL_DEV -d 69.171.241.10 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 69.171.246.7 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.252.106.17 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.252.107.17 -p TCP --dport 5222 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 173.252.75.17 -p TCP --dport 5222 -j ACCEPT
    # gnome3 desktop dictionary 
    $FW -A OUTPUT -o $LOCAL_DEV -d dict.org -p TCP --dport 2628 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 0.debian.pool.ntp.org -p UDP --dport 123 -j ACCEPT
    # whois to whois.arin.net, whois.ripe.net
    $FW -A OUTPUT -o $LOCAL_DEV -d 199.71.0.46 -p TCP --dport 43 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 199.71.0.47 -p TCP --dport 43 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 199.71.0.48 -p TCP --dport 43 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 199.212.0.46 -p TCP --dport 43 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 199.212.0.47 -p TCP --dport 43 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 199.212.0.48 -p TCP --dport 43 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 193.0.6.135 -p TCP --dport 43 -j ACCEPT
    # debian irc server
    #echo 5a...   
    $FW -A OUTPUT -o $LOCAL_DEV -d 87.117.201.130 -p TCP --dport 6667 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 82.195.75.116 -p TCP --dport 6667 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 109.74.200.93 -p TCP --dport 6667 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 130.239.18.160 -p TCP --dport 6667 -j ACCEPT
    # my amazon aws cloud
    #$FW -A OUTPUT -o $LOCAL_DEV -d 54.229.26.150 -p TCP --dport 22 -j ACCEPT
    #$FW -A OUTPUT -o $LOCAL_DEV -d 54.229.75.238 -p TCP --dport 22 -j ACCEPT
    # my google cloud engine
    #$FW -A OUTPUT -o $LOCAL_DEV -d 192.158.30.63 -p TCP --dport 22 -j ACCEPT
    # outgoing ftp to uk debian mirror
    #$FW -A OUTPUT -o $LOCAL_DEV -d 212.219.56.184 -p TCP --dport 21 -j ACCEPT
    #$FW -A OUTPUT -o $LOCAL_DEV -d 212.219.56.184 -p TCP --dport 1024:65535 -j ACCEPT
    #echo 5b...   

    ### allowed http and https everywhere
    $FW -A OUTPUT -o $LOCAL_DEV -p TCP -m multiport --dports 80,443 -j ACCEPT

    # allow outgoing non-privileged UDP port ranges for ping/traceroute
    $FW -A OUTPUT -o $LOCAL_DEV -p UDP --sport 32769:65535 --dport 33434:33523 -j ping_tracert
 
    # allow port 1935 to cloudfront (spotify)
    $FW -A OUTPUT -o $LOCAL_DEV -d 54.239.165.0/24 -p UDP --dport 1935 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 54.240.167.0/24 -p UDP --dport 1935 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 54.239.165.0/24 -p TCP --dport 1935 -j ACCEPT
    $FW -A OUTPUT -o $LOCAL_DEV -d 54.240.167.0/24 -p TCP --dport 1935 -j ACCEPT

    #echo 5c...   
    # allow outgoing icmp
    $FW -A OUTPUT -p ICMP --icmp-type echo-request -m limit --limit 2/s --limit-burst 15 -j ping_tracert
    $FW -A OUTPUT -p ICMP --icmp-type echo-reply -m limit --limit 2/s --limit-burst 15 -j ping_tracert
    $FW -A OUTPUT -m limit --limit 30/m -j LOG --log-prefix "Unauth OUT: "
    $FW -A OUTPUT -j DROP
    
    ### setting up final default policies
    $FW -P OUTPUT DROP
    
    ######################################################################
    ### FORWARDING packets
    ######################################################################

    ### the main FORWARD chain
    $FW -P FORWARD DROP

    #echo 6...   
}

testrun() {
    echo -n "120 seconds: ["
    for i in `seq 120`; do
        echo -n "."
        sleep 1
    done
    echo "] OK."
    flush_everything
}

### parameters' handle
case "$1" in
    start)
         sysctl_tuning
         do_everything
         ;;
    stop)
         flush_everything
         ;;
    restart|reload)
         flush_everything
         sleep 1
         $0 start
         ;;
    testrun)
         $0 start
         testrun
         ;;
    *)
         echo "Usage: $MYNAME (start|stop|restart|reload|testrun)"
         ;;
esac

exit 0
