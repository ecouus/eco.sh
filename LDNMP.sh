#!/bin/bash
  while true; do
    clear
    echo -e "\033[33m▶ LDNMP建站 二次开发版 \033[0m"
    echo  "原地址https://github.com/kejilion/sh"
    echo  "------------------------"
    echo  "1. 安装LDNMP环境"
    echo  "------------------------"
    echo  "2. 安装WordPress"
    echo  "3. 安装Discuz论坛"
    echo  "4. 安装可道云桌面"
    echo  "5. 安装苹果CMS网站"
    echo  "6. 安装独角数发卡网"
    echo  "7. 安装flarum论坛网站"
    echo  "8. 安装typecho轻量博客网站"
    echo  "------------------------"
    echo  "21. 仅安装nginx"
    echo  "22. 站点重定向"
    echo  "23. 站点反向代理"
    echo  "24. 自定义静态站点"
    echo  "25. 安装Bitwarden密码管理平台"
    echo  "26. 安装Halo博客网站"
    echo  "------------------------"
    echo  "31. 站点数据管理"
    echo  "32. 备份全站数据"
    echo  "33. 定时远程备份"
    echo  "34. 还原全站数据"
    echo  "------------------------"
    echo  "35. 站点防御程序"
    echo  "------------------------"
    echo  "36. 优化LDNMP环境"
    echo  "37. 更新LDNMP环境"
    echo  "38. 卸载LDNMP环境"
    echo  "------------------------"
    echo  "0. 返回主菜单"
    echo  "------------------------"
    read -p "请输入你的选择: " sub_choice


    case $sub_choice in
      1)
      check_port
      install_dependency
      install_docker
      install_certbot

      # 创建必要的目录和文件
      cd /home && mkdir -p web/html web/mysql web/certs web/conf.d web/redis web/log/nginx && touch web/docker-compose.yml

      wget -O /home/web/nginx.conf https://raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf
      wget -O /home/web/conf.d/default.conf https://raw.githubusercontent.com/kejilion/nginx/main/default10.conf
      default_server_ssl

      # 下载 docker-compose.yml 文件并进行替换
      wget -O /home/web/docker-compose.yml https://raw.githubusercontent.com/kejilion/docker/main/LNMP-docker-compose-10.yml

      dbrootpasswd=$(openssl rand -base64 16) && dbuse=$(openssl rand -hex 4) && dbusepasswd=$(openssl rand -base64 8)

      # 在 docker-compose.yml 文件中进行替换
      sed -i "s#webroot#$dbrootpasswd#g" /home/web/docker-compose.yml
      sed -i "s#kejilionYYDS#$dbusepasswd#g" /home/web/docker-compose.yml
      sed -i "s#kejilion#$dbuse#g" /home/web/docker-compose.yml
      
      install_ldnmp

        ;;
      2)
      clear
      # wordpress
      webname="WordPress"
      ldnmp_install_status
      add_yuming
      install_ssltls
      add_db

      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/wordpress.com.conf
      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

      cd /home/web/html
      mkdir $yuming
      cd $yuming
      wget -O latest.zip https://cn.wordpress.org/latest-zh_CN.zip
      unzip latest.zip
      rm latest.zip

      echo "define('FS_METHOD', 'direct'); define('WP_REDIS_HOST', 'redis'); define('WP_REDIS_PORT', '6379');" >> /home/web/html/$yuming/wordpress/wp-config-sample.php

      restart_ldnmp

      ldnmp_web_on
      echo "数据库名: $dbname"
      echo "用户名: $dbuse"
      echo "密码: $dbusepasswd"
      echo "数据库地址: mysql"
      echo "表前缀: wp_"
      nginx_status
        ;;

      3)
      clear
      # Discuz论坛
      webname="Discuz论坛"
      ldnmp_install_status
      add_yuming
      install_ssltls
      add_db

      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/discuz.com.conf

      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

      cd /home/web/html
      mkdir $yuming
      cd $yuming
      wget https://github.com/kejilion/Website_source_code/raw/main/Discuz_X3.5_SC_UTF8_20230520.zip
      unzip -o Discuz_X3.5_SC_UTF8_20230520.zip
      rm Discuz_X3.5_SC_UTF8_20230520.zip

      restart_ldnmp


      ldnmp_web_on
      echo "数据库地址: mysql"
      echo "数据库名: $dbname"
      echo "用户名: $dbuse"
      echo "密码: $dbusepasswd"
      echo "表前缀: discuz_"
      nginx_status

        ;;

      4)
      clear
      # 可道云桌面
      webname="可道云桌面"
      ldnmp_install_status
      add_yuming
      install_ssltls
      add_db

      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/kdy.com.conf
      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

      cd /home/web/html
      mkdir $yuming
      cd $yuming
      wget https://github.com/kalcaddle/kodbox/archive/refs/tags/1.42.04.zip
      unzip -o 1.42.04.zip
      rm 1.42.04.zip

      restart_ldnmp


      ldnmp_web_on
      echo "数据库地址: mysql"
      echo "用户名: $dbuse"
      echo "密码: $dbusepasswd"
      echo "数据库名: $dbname"
      echo "redis主机: redis"
      nginx_status
        ;;

      5)
      clear
      # 苹果CMS
      webname="苹果CMS"
      ldnmp_install_status
      add_yuming
      install_ssltls
      add_db

      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/maccms.com.conf

      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

      cd /home/web/html
      mkdir $yuming
      cd $yuming
      # wget https://github.com/magicblack/maccms_down/raw/master/maccms10.zip && unzip maccms10.zip && rm maccms10.zip
      wget https://github.com/magicblack/maccms_down/raw/master/maccms10.zip && unzip maccms10.zip && mv maccms10-*/* . && rm -r maccms10-* && rm maccms10.zip
      cd /home/web/html/$yuming/template/ && wget https://github.com/kejilion/Website_source_code/raw/main/DYXS2.zip && unzip DYXS2.zip && rm /home/web/html/$yuming/template/DYXS2.zip
      cp /home/web/html/$yuming/template/DYXS2/asset/admin/Dyxs2.php /home/web/html/$yuming/application/admin/controller
      cp /home/web/html/$yuming/template/DYXS2/asset/admin/dycms.html /home/web/html/$yuming/application/admin/view/system
      mv /home/web/html/$yuming/admin.php /home/web/html/$yuming/vip.php && wget -O /home/web/html/$yuming/application/extra/maccms.php https://raw.githubusercontent.com/kejilion/Website_source_code/main/maccms.php

      restart_ldnmp


      ldnmp_web_on
      echo "数据库地址: mysql"
      echo "数据库端口: 3306"
      echo "数据库名: $dbname"
      echo "用户名: $dbuse"
      echo "密码: $dbusepasswd"
      echo "数据库前缀: mac_"
      echo "------------------------"
      echo "安装成功后登录后台地址"
      echo "https://$yuming/vip.php"
      nginx_status
        ;;

      6)
      clear
      # 独脚数卡
      webname="独脚数卡"
      ldnmp_install_status
      add_yuming
      install_ssltls
      add_db

      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/dujiaoka.com.conf

      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

      cd /home/web/html
      mkdir $yuming
      cd $yuming
      wget https://github.com/assimon/dujiaoka/releases/download/2.0.6/2.0.6-antibody.tar.gz && tar -zxvf 2.0.6-antibody.tar.gz && rm 2.0.6-antibody.tar.gz

      restart_ldnmp


      ldnmp_web_on
      echo "数据库地址: mysql"
      echo "数据库端口: 3306"
      echo "数据库名: $dbname"
      echo "用户名: $dbuse"
      echo "密码: $dbusepasswd"
      echo ""
      echo "redis地址: redis"
      echo "redis密码: 默认不填写"
      echo "redis端口: 6379"
      echo ""
      echo "网站url: https://$yuming"
      echo "后台登录路径: /admin"
      echo "------------------------"
      echo "用户名: admin"
      echo "密码: admin"
      echo "------------------------"
      echo "登录时右上角如果出现红色error0请使用如下命令: "
      echo "我也很气愤独角数卡为啥这么麻烦，会有这样的问题！"
      echo "sed -i 's/ADMIN_HTTPS=false/ADMIN_HTTPS=true/g' /home/web/html/$yuming/dujiaoka/.env"
      nginx_status
        ;;

      7)
      clear
      # flarum论坛
      webname="flarum论坛"
      ldnmp_install_status
      add_yuming
      install_ssltls
      add_db

      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/flarum.com.conf
      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

      cd /home/web/html
      mkdir $yuming
      cd $yuming

      docker exec php sh -c "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\""
      docker exec php sh -c "php composer-setup.php"
      docker exec php sh -c "php -r \"unlink('composer-setup.php');\""
      docker exec php sh -c "mv composer.phar /usr/local/bin/composer"

      docker exec php composer create-project flarum/flarum /var/www/html/$yuming
      docker exec php sh -c "cd /var/www/html/$yuming && composer require flarum-lang/chinese-simplified"
      docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/polls"

      restart_ldnmp


      ldnmp_web_on
      echo "数据库地址: mysql"
      echo "数据库名: $dbname"
      echo "用户名: $dbuse"
      echo "密码: $dbusepasswd"
      echo "表前缀: flarum_"
      echo "管理员信息自行设置"
      nginx_status
        ;;

      8)
      clear
      # typecho
      webname="typecho"
      ldnmp_install_status
      add_yuming
      install_ssltls
      add_db

      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/typecho.com.conf
      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

      cd /home/web/html
      mkdir $yuming
      cd $yuming
      wget -O latest.zip https://github.com/typecho/typecho/releases/latest/download/typecho.zip
      unzip latest.zip
      rm latest.zip

      restart_ldnmp


      clear
      ldnmp_web_on
      echo "数据库前缀: typecho_"
      echo "数据库地址: mysql"
      echo "用户名: $dbuse"
      echo "密码: $dbusepasswd"
      echo "数据库名: $dbname"
      nginx_status
        ;;


      21)
      check_port
      install_dependency
      install_docker
      install_certbot

      cd /home && mkdir -p web/html web/mysql web/certs web/conf.d web/redis web/log/nginx && touch web/docker-compose.yml

      wget -O /home/web/nginx.conf https://raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf
      wget -O /home/web/conf.d/default.conf https://raw.githubusercontent.com/kejilion/nginx/main/default10.conf
      default_server_ssl
      docker rm -f nginx >/dev/null 2>&1
      docker rmi nginx nginx:alpine >/dev/null 2>&1
      docker run -d --name nginx --restart always -p 80:80 -p 443:443 -p 443:443/udp -v /home/web/nginx.conf:/etc/nginx/nginx.conf -v /home/web/conf.d:/etc/nginx/conf.d -v /home/web/certs:/etc/nginx/certs -v /home/web/html:/var/www/html -v /home/web/log/nginx:/var/log/nginx nginx:alpine

      clear
      nginx_version=$(docker exec nginx nginx -v 2>&1)
      nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
      echo "nginx已安装完成"
      echo "当前版本: v$nginx_version"
      echo ""
        ;;

      22)
        echo "------------------------"
        echo "1. 自动申请证书                 2. 自备证书"
        read -p "请输入你的选择: " sub_choice  
        case $sub_choice in
            1)    
                clear
                ip_address
                add_yuming
                read -p "请输入跳转域名: " reverseproxy

                install_ssltls

                wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/rewrite.conf
                sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
                sed -i "s/baidu.com/$reverseproxy/g" /home/web/conf.d/$yuming.conf

                docker restart nginx

                clear
                echo "您的重定向网站做好了！"
                echo "https://$yuming"
                nginx_status

                ;;
             2)   
                clear
                echo "请在操作前先将证书与密钥放在/home/web/certs/新域名_key.pem与/home/web/certs/新域名_cert.pem"
                echo "文件名分别为：新域名_cert.pem与新域名_key.pem"
                ip_address
                add_yuming
                read -p "请输入跳转域名: " reverseproxy


                wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/rewrite.conf
                sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
                sed -i "s/baidu.com/$reverseproxy/g" /home/web/conf.d/$yuming.conf

                docker restart nginx

                clear
                echo "您的重定向网站做好了！"
                echo "https://$yuming"
                nginx_status

                ;;             
        esac
        ;;
      23)
        echo "------------------------"
        echo "1. 自动申请证书                 2. 自备证书"
        read -p "请输入你的选择: " sub_choice  
        case $sub_choice in
            1)    
                clear
                ip_address
                add_yuming
                read -p "请输入你的反代IP: " reverseproxy
                read -p "请输入你的反代端口: " port

                install_ssltls

                wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
                sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
                sed -i "s/0.0.0.0/$reverseproxy/g" /home/web/conf.d/$yuming.conf
                sed -i "s/0000/$port/g" /home/web/conf.d/$yuming.conf

                docker restart nginx

                clear
                echo "您的反向代理网站做好了！"
                echo "https://$yuming"
                nginx_status
                ;;
             2)   
                clear
                echo "请在操作前先将证书与密钥放在/home/web/certs/新域名_key.pem与/home/web/certs/新域名_cert.pem"
                echo "文件名分别为：新域名_cert.pem与新域名_key.pem"                
                ip_address
                add_yuming
                read -p "请输入你的反代IP: " reverseproxy
                read -p "请输入你的反代端口: " port
                

                wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
                sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
                sed -i "s/0.0.0.0/$reverseproxy/g" /home/web/conf.d/$yuming.conf
                sed -i "s/0000/$port/g" /home/web/conf.d/$yuming.conf

                docker restart nginx

                clear
                echo "您的反向代理网站做好了！"
                echo "https://$yuming"
                nginx_status
                ;;       
        esac
        ;;        
      24)
      clear
      webname="静态站点"
      nginx_install_status
      add_yuming
      install_ssltls

      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/html.conf
      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

      cd /home/web/html
      mkdir $yuming
      cd $yuming

      install lrzsz
      clear
      echo -e "目前只允许上传\033[33mindex.html\033[0m文件，请提前准备好，按任意键继续..."
      read -n 1 -s -r -p ""
      rz -y

      docker exec nginx chmod -R 777 /var/www/html
      docker restart nginx

      nginx_web_on
      nginx_status
        ;;

      25)
      clear
      webname="Bitwarden"
      nginx_install_status
      add_yuming
      install_ssltls

      docker run -d \
        --name bitwarden \
        --restart always \
        -p 3280:80 \
        -v /home/web/html/$yuming/bitwarden/data:/data \
        vaultwarden/server
      duankou=3280
      reverse_proxy

      nginx_web_on
      nginx_status
        ;;

      26)
      clear
      webname="halo"
      nginx_install_status
      add_yuming
      install_ssltls

      docker run -d --name halo --restart always --network web_default -p 8010:8090 -v /home/web/html/$yuming/.halo2:/root/.halo2 halohub/halo:2
      duankou=8010
      reverse_proxy

      nginx_web_on
      nginx_status
        ;;



    31)
    while true; do
        clear
        echo "LDNMP环境"
        echo "------------------------"
        # 获取nginx版本
        nginx_version=$(docker exec nginx nginx -v 2>&1)
        nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
        echo -n "nginx : v$nginx_version"
        # 获取mysql版本
        dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
        mysql_version=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)
        echo -n "            mysql : v$mysql_version"
        # 获取php版本
        php_version=$(docker exec php php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")
        echo -n "            php : v$php_version"
        # 获取redis版本
        redis_version=$(docker exec redis redis-server -v 2>&1 | grep -oP "v=+\K[0-9]+\.[0-9]+")
        echo "            redis : v$redis_version"
        echo "------------------------"
        echo ""


        # ls -t /home/web/conf.d | sed 's/\.[^.]*$//'
        echo "站点信息                      证书到期时间"
        echo "------------------------"
        for cert_file in /home/web/certs/*_cert.pem; do
          domain=$(basename "$cert_file" | sed 's/_cert.pem//')
          if [ -n "$domain" ]; then
            expire_date=$(openssl x509 -noout -enddate -in "$cert_file" | awk -F'=' '{print $2}')
            formatted_date=$(date -d "$expire_date" '+%Y-%m-%d')
            printf "%-30s%s\n" "$domain" "$formatted_date"
          fi
        done

        echo "------------------------"
        echo ""
        echo "数据库信息"
        echo "------------------------"
        dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
        docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SHOW DATABASES;" 2> /dev/null | grep -Ev "Database|information_schema|mysql|performance_schema|sys"

        echo "------------------------"
        echo ""
        echo "站点目录"
        echo "------------------------"
        echo -e "数据 \e[37m/home/web/html\e[0m     证书 \e[37m/home/web/certs\e[0m     配置 \e[37m/home/web/conf.d\e[0m"
        echo "------------------------"
        echo ""
        echo "操作"
        echo "------------------------"
        echo "1. 申请/更新域名证书               2. 更换站点域名"
        echo "3. 清理站点缓存                    4. 查看站点分析报告"
        echo "------------------------"
        echo "7. 删除指定站点                    8. 删除指定数据库"
        echo "------------------------"
        echo "0. 返回上一级选单"
        echo "------------------------"
        read -p "请输入你的选择: " sub_choice
        case $sub_choice in
            1)
                read -p "请输入你的域名: " yuming
                install_ssltls

                ;;

            2)
                echo "------------------------"
                echo "1. 自动申请证书                 2. 自备证书"
                read -p "请输入你的选择: " sub_choice


                case $sub_choice in
                    1)
                        read -p "请输入旧域名: " oddyuming
                        read -p "请输入新域名: " yuming
                        install_ssltls
                        mv /home/web/conf.d/$oddyuming.conf /home/web/conf.d/$yuming.conf
                        sed -i "s/$oddyuming/$yuming/g" /home/web/conf.d/$yuming.conf
                        mv /home/web/html/$oddyuming /home/web/html/$yuming

                        rm /home/web/certs/${oddyuming}_key.pem
                        rm /home/web/certs/${oddyuming}_cert.pem

                        docker restart nginx


                        ;;
                    2)
                        echo "请在操作前先将证书与密钥放在/home/web/certs/新域名_key.pem与/home/web/certs/新域名_cert.pem"
                        echo "文件名分别为：新域名_cert.pem与新域名_key.pem"
                        read -p "请输入旧域名: " oddyuming
                        read -p "请输入新域名: " yuming
                        mv /home/web/conf.d/$oddyuming.conf /home/web/conf.d/$yuming.conf
                        sed -i "s/$oddyuming/$yuming/g" /home/web/conf.d/$yuming.conf
                        mv /home/web/html/$oddyuming /home/web/html/$yuming

                        rm /home/web/certs/${oddyuming}_key.pem
                        rm /home/web/certs/${oddyuming}_cert.pem

                        docker restart nginx
                        ;;
                esac
                ;;


            3)
                docker exec -it nginx rm -rf /var/cache/nginx
                docker restart nginx
                docker exec php php -r 'opcache_reset();'
                docker restart php
                docker exec php74 php -r 'opcache_reset();'
                docker restart php74
                ;;
            4)
                install goaccess
                goaccess --log-format=COMBINED /home/web/log/nginx/access.log

                ;;

            7)
                read -p "请输入你的域名: " yuming
                rm -r /home/web/html/$yuming
                rm /home/web/conf.d/$yuming.conf
                rm /home/web/certs/${yuming}_key.pem
                rm /home/web/certs/${yuming}_cert.pem
                docker restart nginx
                ;;
            8)
                read -p "请输入数据库名: " shujuku
                dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
                docker exec mysql mysql -u root -p"$dbrootpasswd" -e "DROP DATABASE $shujuku;" 2> /dev/null
                ;;
            0)
                break  # 跳出循环，退出菜单
                ;;
            *)
                break  # 跳出循环，退出菜单
                ;;
        esac
    done

      ;;


    32)
      clear
      cd /home/ && tar czvf web_$(date +"%Y%m%d%H%M%S").tar.gz web

      while true; do
        clear
        read -p "要传送文件到远程服务器吗？(Y/N): " choice
        case "$choice" in
          [Yy])
            read -p "请输入远端服务器IP:  " remote_ip
            if [ -z "$remote_ip" ]; then
              echo "错误: 请输入远端服务器IP。"
              continue
            fi
            latest_tar=$(ls -t /home/*.tar.gz | head -1)
            if [ -n "$latest_tar" ]; then
              ssh-keygen -f "/root/.ssh/known_hosts" -R "$remote_ip"
              sleep 2  # 添加等待时间
              scp -o StrictHostKeyChecking=no "$latest_tar" "root@$remote_ip:/home/"
              echo "文件已传送至远程服务器home目录。"
            else
              echo "未找到要传送的文件。"
            fi
            break
            ;;
          [Nn])
            break
            ;;
          *)
            echo "无效的选择，请输入 Y 或 N。"
            ;;
        esac
      done
      ;;

    33)
      clear
      read -p "输入远程服务器IP: " useip
      read -p "输入远程服务器密码: " usepasswd

      cd ~
      wget -O ${useip}_beifen.sh https://raw.githubusercontent.com/kejilion/sh/main/beifen.sh > /dev/null 2>&1
      chmod +x ${useip}_beifen.sh

      sed -i "s/0.0.0.0/$useip/g" ${useip}_beifen.sh
      sed -i "s/123456/$usepasswd/g" ${useip}_beifen.sh

      echo "------------------------"
      echo "1. 每周备份                 2. 每天备份"
      read -p "请输入你的选择: " dingshi

      case $dingshi in
          1)
              read -p "选择每周备份的星期几 (0-6，0代表星期日): " weekday
              (crontab -l ; echo "0 0 * * $weekday ./${useip}_beifen.sh") | crontab - > /dev/null 2>&1
              ;;
          2)
              read -p "选择每天备份的时间（小时，0-23）: " hour
              (crontab -l ; echo "0 $hour * * * ./${useip}_beifen.sh") | crontab - > /dev/null 2>&1
              ;;
          *)
              break  # 跳出
              ;;
      esac

      install sshpass

      ;;

    34)
      clear
      cd /home/ && ls -t /home/*.tar.gz | head -1 | xargs -I {} tar -xzf {}
      check_port
      install_dependency
      install_docker
      install_certbot

      install_ldnmp

      ;;

    35)

        if docker inspect fail2ban &>/dev/null ; then
          while true; do
              clear
              echo "服务器防御程序已启动"
              echo "------------------------"
              echo "1. 开启SSH防暴力破解              2. 关闭SSH防暴力破解"
              echo "3. 开启网站保护                   4. 关闭网站保护"
              echo "------------------------"
              echo "5. 查看SSH拦截记录                6. 查看网站拦截记录"
              echo "7. 查看防御规则列表               8. 查看日志实时监控"
              echo "------------------------"
              echo "11. 配置拦截参数"
              echo "------------------------"
              echo "21. cloudflare模式"
              echo "------------------------"
              echo "9. 卸载防御程序"
              echo "------------------------"
              echo "0. 退出"
              echo "------------------------"
              read -p "请输入你的选择: " sub_choice
              case $sub_choice in
                  1)
                      sed -i 's/false/true/g' /path/to/fail2ban/config/fail2ban/jail.d/alpine-ssh.conf
                      sed -i 's/false/true/g' /path/to/fail2ban/config/fail2ban/jail.d/linux-ssh.conf
                      sed -i 's/false/true/g' /path/to/fail2ban/config/fail2ban/jail.d/centos-ssh.conf
                      f2b_status
                      ;;
                  2)
                      sed -i 's/true/false/g' /path/to/fail2ban/config/fail2ban/jail.d/alpine-ssh.conf
                      sed -i 's/true/false/g' /path/to/fail2ban/config/fail2ban/jail.d/linux-ssh.conf
                      sed -i 's/true/false/g' /path/to/fail2ban/config/fail2ban/jail.d/centos-ssh.conf
                      f2b_status
                      ;;
                  3)
                      sed -i 's/false/true/g' /path/to/fail2ban/config/fail2ban/jail.d/nginx-docker-cc.conf
                      f2b_status
                      ;;
                  4)
                      sed -i 's/true/false/g' /path/to/fail2ban/config/fail2ban/jail.d/nginx-docker-cc.conf
                      f2b_status
                      ;;
                  5)
                      echo "------------------------"
                      f2b_sshd
                      echo "------------------------"
                      ;;
                  6)

                      echo "------------------------"
                      xxx=fail2ban-nginx-cc
                      f2b_status_xxx
                      echo "------------------------"
                      xxx=docker-nginx-bad-request
                      f2b_status_xxx
                      echo "------------------------"
                      xxx=docker-nginx-botsearch
                      f2b_status_xxx
                      echo "------------------------"
                      xxx=docker-nginx-http-auth
                      f2b_status_xxx
                      echo "------------------------"
                      xxx=docker-nginx-limit-req
                      f2b_status_xxx
                      echo "------------------------"
                      xxx=docker-php-url-fopen
                      f2b_status_xxx
                      echo "------------------------"

                      ;;

                  7)
                      docker exec -it fail2ban fail2ban-client status
                      ;;
                  8)
                      tail -f /path/to/fail2ban/config/log/fail2ban/fail2ban.log

                      ;;
                  9)
                      docker rm -f fail2ban
                      rm -rf /path/to/fail2ban
                      echo "Fail2Ban防御程序已卸载"
                      break
                      ;;

                  11)
                      install nano
                      nano /path/to/fail2ban/config/fail2ban/jail.d/nginx-docker-cc.conf
                      f2b_status

                      break
                      ;;
                  21)
                      echo "到cf后台右上角我的个人资料，选择左侧API令牌，获取Global API Key"
                      echo "https://dash.cloudflare.com/login"
                      read -p "输入CF的账号: " cfuser
                      read -p "输入CF的Global API Key: " cftoken

                      wget -O /home/web/conf.d/default.conf https://raw.githubusercontent.com/kejilion/nginx/main/default11.conf
                      docker restart nginx

                      cd /path/to/fail2ban/config/fail2ban/jail.d/
                      curl -sS -O https://raw.githubusercontent.com/kejilion/config/main/fail2ban/nginx-docker-cc.conf

                      cd /path/to/fail2ban/config/fail2ban/action.d
                      curl -sS -O https://raw.githubusercontent.com/kejilion/config/main/fail2ban/cloudflare-docker.conf

                      sed -i "s/kejilion@outlook.com/$cfuser/g" /path/to/fail2ban/config/fail2ban/action.d/cloudflare-docker.conf
                      sed -i "s/APIKEY00000/$cftoken/g" /path/to/fail2ban/config/fail2ban/action.d/cloudflare-docker.conf
                      f2b_status

                      echo "已配置cloudflare模式，可在cf后台，站点-安全性-事件中查看拦截记录"
                      ;;

                  0)
                      break
                      ;;
                  *)
                      echo "无效的选择，请重新输入。"
                      ;;
              esac
              break_end

          done

      elif [ -x "$(command -v fail2ban-client)" ] ; then
          clear
          echo "卸载旧版fail2ban"
          read -p "确定继续吗？(Y/N): " choice
          case "$choice" in
            [Yy])
              remove fail2ban
              rm -rf /etc/fail2ban
              echo "Fail2Ban防御程序已卸载"
              ;;
            [Nn])
              echo "已取消"
              ;;
            *)
              echo "无效的选择，请输入 Y 或 N。"
              ;;
          esac

      else
          clear
          install_docker

          docker rm -f nginx
          wget -O /home/web/nginx.conf https://raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf
          wget -O /home/web/conf.d/default.conf https://raw.githubusercontent.com/kejilion/nginx/main/default10.conf
          default_server_ssl
          docker run -d --name nginx --restart always --network web_default -p 80:80 -p 443:443 -p 443:443/udp -v /home/web/nginx.conf:/etc/nginx/nginx.conf -v /home/web/conf.d:/etc/nginx/conf.d -v /home/web/certs:/etc/nginx/certs -v /home/web/html:/var/www/html -v /home/web/log/nginx:/var/log/nginx nginx:alpine
          docker exec -it nginx chmod -R 777 /var/www/html

          f2b_install_sshd

          cd /path/to/fail2ban/config/fail2ban/filter.d
          curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/fail2ban-nginx-cc.conf
          cd /path/to/fail2ban/config/fail2ban/jail.d/
          curl -sS -O https://raw.githubusercontent.com/kejilion/config/main/fail2ban/nginx-docker-cc.conf
          sed -i "/cloudflare/d" /path/to/fail2ban/config/fail2ban/jail.d/nginx-docker-cc.conf

          cd ~
          f2b_status

          echo "防御程序已开启"
      fi

        ;;

    36)
          while true; do
              clear
              echo "优化LDNMP环境"
              echo "------------------------"
              echo "1. 标准模式              2. 高性能模式 (推荐2H2G以上)"
              echo "------------------------"
              echo "0. 退出"
              echo "------------------------"
              read -p "请输入你的选择: " sub_choice
              case $sub_choice in
                  1)
                  # nginx调优
                  sed -i 's/worker_connections.*/worker_connections 1024;/' /home/web/nginx.conf

                  # php调优
                  wget -O /home/optimized_php.ini https://raw.githubusercontent.com/kejilion/sh/main/optimized_php.ini
                  docker cp /home/optimized_php.ini php:/usr/local/etc/php/conf.d/optimized_php.ini
                  docker cp /home/optimized_php.ini php74:/usr/local/etc/php/conf.d/optimized_php.ini
                  rm -rf /home/optimized_php.ini

                  # php调优
                  wget -O /home/www.conf https://raw.githubusercontent.com/kejilion/sh/main/www-1.conf
                  docker cp /home/www.conf php:/usr/local/etc/php-fpm.d/www.conf
                  docker cp /home/www.conf php74:/usr/local/etc/php-fpm.d/www.conf
                  rm -rf /home/www.conf

                  # mysql调优
                  wget -O /home/custom_mysql_config.cnf https://raw.githubusercontent.com/kejilion/sh/main/custom_mysql_config-1.cnf
                  docker cp /home/custom_mysql_config.cnf mysql:/etc/mysql/conf.d/
                  rm -rf /home/custom_mysql_config.cnf

                  docker restart nginx
                  docker restart php
                  docker restart php74
                  docker restart mysql

                  echo "LDNMP环境已设置成 标准模式"

                      ;;
                  2)

                  # nginx调优
                  sed -i 's/worker_connections.*/worker_connections 10240;/' /home/web/nginx.conf

                  # php调优
                  wget -O /home/www.conf https://raw.githubusercontent.com/kejilion/sh/main/www.conf
                  docker cp /home/www.conf php:/usr/local/etc/php-fpm.d/www.conf
                  docker cp /home/www.conf php74:/usr/local/etc/php-fpm.d/www.conf
                  rm -rf /home/www.conf

                  # mysql调优
                  wget -O /home/custom_mysql_config.cnf https://raw.githubusercontent.com/kejilion/sh/main/custom_mysql_config.cnf
                  docker cp /home/custom_mysql_config.cnf mysql:/etc/mysql/conf.d/
                  rm -rf /home/custom_mysql_config.cnf

                  docker restart nginx
                  docker restart php
                  docker restart php74
                  docker restart mysql

                  echo "LDNMP环境已设置成 高性能模式"

                      ;;
                  0)
                      break
                      ;;
                  *)
                      echo "无效的选择，请重新输入。"
                      ;;
              esac
              break_end

          done
        ;;


    37)
      clear
      docker rm -f nginx php php74 mysql redis
      docker rmi nginx nginx:alpine php:fpm php:fpm-alpine php:7.4.33-fpm php:7.4-fpm-alpine mysql redis redis:alpine

      check_port
      install_dependency
      install_docker
      install_ldnmp
      ;;



    38)
        clear
        read -p "强烈建议先备份全部网站数据，再卸载LDNMP环境。确定删除所有网站数据吗？(Y/N): " choice
        case "$choice" in
          [Yy])
            docker rm -f nginx php php74 mysql redis
            docker rmi nginx nginx:alpine php:fpm php:fpm-alpine php:7.4.33-fpm php:7.4-fpm-alpine mysql redis redis:alpine
            rm -rf /home/web
            ;;
          [Nn])

            ;;
          *)
            echo "无效的选择，请输入 Y 或 N。"
            ;;
        esac
        ;;


    0)  
        eco
        clear
        exit
      ;;   

    *)
        echo "无效的输入!"
    esac
    break_end

  done

