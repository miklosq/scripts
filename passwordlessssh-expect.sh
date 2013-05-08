#!/usr/bin/expect

spawn ssh orwell
expect "miklos@orwell's password: " {
  sleep 1
  send "\r"
} timeout {
  send_user "Error connecting"
}
