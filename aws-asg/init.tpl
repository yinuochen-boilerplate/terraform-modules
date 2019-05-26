#cloud-config
repo_update: true
repo_upgrade: all

packages:
- nginx

runcmd:
- service nginx start
- mv /usr/share/nginx/html/index2.html /usr/share/nginx/html/index.html

write_files:
- path: /usr/share/nginx/html/index2.html
  permissions: '0755'
  owner: root:root
  content: |
    Hello World
