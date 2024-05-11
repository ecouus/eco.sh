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
    echo -e "\033[33m▶ 99.系统工具 \033[0m"
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

    99)
  while true; do
    clear
    echo "▶ 系统工具"
    echo "------------------------"
    echo "1. 设置脚本启动快捷键"
    echo "------------------------"
    echo "2. 修改ROOT密码"
    echo "3. 开启ROOT密码登录模式"
    echo "4. 安装Python最新版"
    echo "5. 开放所有端口"
    echo "6. 修改SSH连接端口"
    echo "7. 优化DNS地址"
    echo "8. 一键重装系统"
    echo "9. 禁用ROOT账户创建新账户"
    echo "10. 切换优先ipv4/ipv6"
    echo "11. 查看端口占用状态"
    echo "12. 修改虚拟内存大小"
    echo "13. 用户管理"
    echo "14. 用户/密码生成器"
    echo "15. 系统时区调整"
    echo "16. 设置BBR3加速"
    echo "17. 防火墙高级管理器"
    echo "18. 修改主机名"
    echo "19. 切换系统更新源"
    echo "20. 定时任务管理"
    echo "21. 本机host解析"
    echo "22. fail2banSSH防御程序"
    echo "23. 限流自动关机"
    echo "------------------------"
    echo "31. 留言板"
    echo "------------------------"
    echo "99. 重启服务器"
    echo "------------------------"
    echo "0. 返回主菜单"
    echo "------------------------"
    read -p "请输入你的选择: " sub_choice

    case $sub_choice in
        1)
            clear
            read -p "请输入你的快捷按键: " kuaijiejian
            echo "alias $kuaijiejian='~/kejilion.sh'" >> ~/.bashrc
            source ~/.bashrc
            echo "快捷键已设置"
            ;;

        2)
            clear
            echo "设置你的ROOT密码"
            passwd
            ;;
        3)
            clear
            echo "设置你的ROOT密码"
            passwd
            sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
            sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
            service sshd restart
            echo "ROOT登录设置完毕！"
            server_reboot

            ;;

        4)
          clear

          RED="\033[31m"
          GREEN="\033[32m"
          YELLOW="\033[33m"
          NC="\033[0m"

          # 系统检测
          OS=$(cat /etc/os-release | grep -o -E "Debian|Ubuntu|CentOS" | head -n 1)

          if [[ $OS == "Debian" || $OS == "Ubuntu" || $OS == "CentOS" ]]; then
              echo -e "检测到你的系统是 ${YELLOW}${OS}${NC}"
          else
              echo -e "${RED}很抱歉，你的系统不受支持！${NC}"
              exit 1
          fi

          # 检测安装Python3的版本
          VERSION=$(python3 -V 2>&1 | awk '{print $2}')

          # 获取最新Python3版本
          PY_VERSION=$(curl -s https://www.python.org/ | grep "downloads/release" | grep -o 'Python [0-9.]*' | grep -o '[0-9.]*')

          # 卸载Python3旧版本
          if [[ $VERSION == "3"* ]]; then
              echo -e "${YELLOW}你的Python3版本是${NC}${RED}${VERSION}${NC}，${YELLOW}最新版本是${NC}${RED}${PY_VERSION}${NC}"
              read -p "是否确认升级最新版Python3？默认不升级 [y/N]: " CONFIRM
              if [[ $CONFIRM == "y" ]]; then
                  if [[ $OS == "CentOS" ]]; then
                      echo ""
                      rm-rf /usr/local/python3* >/dev/null 2>&1
                  else
                      apt --purge remove python3 python3-pip -y
                      rm-rf /usr/local/python3*
                  fi
              else
                  echo -e "${YELLOW}已取消升级Python3${NC}"
                  exit 1
              fi
          else
              echo -e "${RED}检测到没有安装Python3。${NC}"
              read -p "是否确认安装最新版Python3？默认安装 [Y/n]: " CONFIRM
              if [[ $CONFIRM != "n" ]]; then
                  echo -e "${GREEN}开始安装最新版Python3...${NC}"
              else
                  echo -e "${YELLOW}已取消安装Python3${NC}"
                  exit 1
              fi
          fi

          # 安装相关依赖
          if [[ $OS == "CentOS" ]]; then
              yum update
              yum groupinstall -y "development tools"
              yum install wget openssl-devel bzip2-devel libffi-devel zlib-devel -y
          else
              apt update
              apt install wget build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev -y
          fi

          # 安装python3
          cd /root/
          wget https://www.python.org/ftp/python/${PY_VERSION}/Python-"$PY_VERSION".tgz
          tar -zxf Python-${PY_VERSION}.tgz
          cd Python-${PY_VERSION}
          ./configure --prefix=/usr/local/python3
          make -j $(nproc)
          make install
          if [ $? -eq 0 ];then
              rm -f /usr/local/bin/python3*
              rm -f /usr/local/bin/pip3*
              ln -sf /usr/local/python3/bin/python3 /usr/bin/python3
              ln -sf /usr/local/python3/bin/pip3 /usr/bin/pip3
              clear
              echo -e "${YELLOW}Python3安装${GREEN}成功，${NC}版本为: ${NC}${GREEN}${PY_VERSION}${NC}"
          else
              clear
              echo -e "${RED}Python3安装失败！${NC}"
              exit 1
          fi
          cd /root/ && rm -rf Python-${PY_VERSION}.tgz && rm -rf Python-${PY_VERSION}
            ;;

        5)
            clear
            iptables_open
            remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1
            echo "端口已全部开放"

            ;;
        6)
            clear

            # 去掉 #Port 的注释
            sed -i 's/#Port/Port/' /etc/ssh/sshd_config

            # 读取当前的 SSH 端口号
            current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

            # 打印当前的 SSH 端口号
            echo "当前的 SSH 端口号是: $current_port"

            echo "------------------------"

            # 提示用户输入新的 SSH 端口号
            read -p "请输入新的 SSH 端口号: " new_port

            # 备份 SSH 配置文件
            cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

            # 替换 SSH 配置文件中的端口号
            sed -i "s/Port [0-9]\+/Port $new_port/g" /etc/ssh/sshd_config

            # 重启 SSH 服务
            service sshd restart

            echo "SSH 端口已修改为: $new_port"

            clear
            iptables_open
            remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1

            ;;


        7)
          clear
          echo "当前DNS地址"
          echo "------------------------"
          cat /etc/resolv.conf
          echo "------------------------"
          echo ""
          # 询问用户是否要优化DNS设置
          read -p "是否要设置为Cloudflare和Google的DNS地址？(y/n): " choice

          if [ "$choice" == "y" ]; then
              # 定义DNS地址
              cloudflare_ipv4="1.1.1.1"
              google_ipv4="8.8.8.8"
              cloudflare_ipv6="2606:4700:4700::1111"
              google_ipv6="2001:4860:4860::8888"

              # 检查机器是否有IPv6地址
              ipv6_available=0
              if [[ $(ip -6 addr | grep -c "inet6") -gt 0 ]]; then
                  ipv6_available=1
              fi

              # 设置DNS地址为Cloudflare和Google（IPv4和IPv6）
              echo "设置DNS为Cloudflare和Google"

              # 设置IPv4地址
              echo "nameserver $cloudflare_ipv4" > /etc/resolv.conf
              echo "nameserver $google_ipv4" >> /etc/resolv.conf

              # 如果有IPv6地址，则设置IPv6地址
              if [[ $ipv6_available -eq 1 ]]; then
                  echo "nameserver $cloudflare_ipv6" >> /etc/resolv.conf
                  echo "nameserver $google_ipv6" >> /etc/resolv.conf
              fi

              echo "DNS地址已更新"
              echo "------------------------"
              cat /etc/resolv.conf
              echo "------------------------"
          else
              echo "DNS设置未更改"
          fi

            ;;

        8)

        dd_xitong_2() {
          echo "任意键继续，重装后初始用户名: root  初始密码: LeitboGi0ro  初始端口: 22"
          read -n 1 -s -r -p ""
          install wget
          wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
        }

        dd_xitong_3() {
          echo "任意键继续，重装后初始用户名: Administrator  初始密码: Teddysun.com  初始端口: 3389"
          read -n 1 -s -r -p ""
          install wget
          wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
        }

        clear
        echo "请备份数据，将为你重装系统，预计花费15分钟。"
        echo -e "\e[37m感谢MollyLau的脚本支持！\e[0m "
        read -p "确定继续吗？(Y/N): " choice

        case "$choice" in
          [Yy])
            while true; do

              echo "------------------------"
              echo "1. Debian 12"
              echo "2. Debian 11"
              echo "3. Debian 10"
              echo "4. Debian 9"
              echo "------------------------"
              echo "11. Ubuntu 24.04"
              echo "12. Ubuntu 22.04"
              echo "13. Ubuntu 20.04"
              echo "14. Ubuntu 18.04"
              echo "------------------------"
              echo "21. CentOS 9"
              echo "22. CentOS 8"
              echo "23. CentOS 7"
              echo "------------------------"
              echo "31. Alpine 3.19"
              echo "------------------------"
              echo "41. Windows 11"
              echo "42. Windows 10"
              echo "43. Windows Server 2022"
              echo "44. Windows Server 2019"
              echo "44. Windows Server 2016"
              echo "------------------------"
              read -p "请选择要重装的系统: " sys_choice

              case "$sys_choice" in
                1)
                  dd_xitong_2
                  bash InstallNET.sh -debian 12
                  reboot
                  exit
                  ;;

                2)
                  dd_xitong_2
                  bash InstallNET.sh -debian 11
                  reboot
                  exit
                  ;;

                3)
                  dd_xitong_2
                  bash InstallNET.sh -debian 10
                  reboot
                  exit
                  ;;
                4)
                  dd_xitong_2
                  bash InstallNET.sh -debian 9
                  reboot
                  exit
                  ;;

                11)
                  dd_xitong_2
                  bash InstallNET.sh -ubuntu 24.04
                  reboot
                  exit
                  ;;
                12)
                  dd_xitong_2
                  bash InstallNET.sh -ubuntu 22.04
                  reboot
                  exit
                  ;;

                13)
                  dd_xitong_2
                  bash InstallNET.sh -ubuntu 20.04
                  reboot
                  exit
                  ;;
                14)
                  dd_xitong_2
                  bash InstallNET.sh -ubuntu 18.04
                  reboot
                  exit
                  ;;


                21)
                  dd_xitong_2
                  bash InstallNET.sh -centos 9
                  reboot
                  exit
                  ;;


                22)
                  dd_xitong_2
                  bash InstallNET.sh -centos 8
                  reboot
                  exit
                  ;;

                23)
                  dd_xitong_2
                  bash InstallNET.sh -centos 7
                  reboot
                  exit
                  ;;

                31)
                  dd_xitong_2
                  bash InstallNET.sh -alpine
                  reboot
                  exit
                  ;;

                41)
                  dd_xitong_3
                  bash InstallNET.sh -windows 11 -lang "cn"
                  reboot
                  exit
                  ;;

                42)
                  dd_xitong_3
                  bash InstallNET.sh -windows 10 -lang "cn"
                  reboot
                  exit
                  ;;

                43)
                  dd_xitong_3
                  bash InstallNET.sh -windows 2022 -lang "cn"
                  reboot
                  exit
                  ;;

                44)
                  dd_xitong_3
                  bash InstallNET.sh -windows 2019 -lang "cn"
                  reboot
                  exit
                  ;;

                45)
                  dd_xitong_3
                  bash InstallNET.sh -windows 2016 -lang "cn"
                  reboot
                  exit
                  ;;


                *)
                  echo "无效的选择，请重新输入。"
                  ;;
              esac
            done
            ;;
          [Nn])
            echo "已取消"
            ;;
          *)
            echo "无效的选择，请输入 Y 或 N。"
            ;;
        esac
            ;;

        9)
          clear
          install sudo

          # 提示用户输入新用户名
          read -p "请输入新用户名: " new_username

          # 创建新用户并设置密码
          sudo useradd -m -s /bin/bash "$new_username"
          sudo passwd "$new_username"

          # 赋予新用户sudo权限
          echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

          # 禁用ROOT用户登录
          sudo passwd -l root

          echo "操作已完成。"
          ;;


        10)
          clear
          ipv6_disabled=$(sysctl -n net.ipv6.conf.all.disable_ipv6)

          echo ""
          if [ "$ipv6_disabled" -eq 1 ]; then
              echo "当前网络优先级设置: IPv4 优先"
          else
              echo "当前网络优先级设置: IPv6 优先"
          fi
          echo "------------------------"

          echo ""
          echo "切换的网络优先级"
          echo "------------------------"
          echo "1. IPv4 优先          2. IPv6 优先"
          echo "------------------------"
          read -p "选择优先的网络: " choice

          case $choice in
              1)
                  sysctl -w net.ipv6.conf.all.disable_ipv6=1 > /dev/null 2>&1
                  echo "已切换为 IPv4 优先"
                  ;;
              2)
                  sysctl -w net.ipv6.conf.all.disable_ipv6=0 > /dev/null 2>&1
                  echo "已切换为 IPv6 优先"
                  ;;
              *)
                  echo "无效的选择"
                  ;;

          esac
          ;;

        11)
          clear
          ss -tulnape
          ;;

        12)


          clear
          # 获取当前交换空间信息
          swap_used=$(free -m | awk 'NR==3{print $3}')
          swap_total=$(free -m | awk 'NR==3{print $2}')

          if [ "$swap_total" -eq 0 ]; then
            swap_percentage=0
          else
            swap_percentage=$((swap_used * 100 / swap_total))
          fi

          swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

          echo "当前虚拟内存: $swap_info"

          read -p "是否调整大小?(Y/N): " choice

          case "$choice" in
            [Yy])
              # 输入新的虚拟内存大小
              read -p "请输入虚拟内存大小MB: " new_swap
              add_swap

              ;;
            [Nn])
              echo "已取消"
              ;;
            *)
              echo "无效的选择，请输入 Y 或 N。"
              ;;
          esac
          ;;

        13)
            while true; do
              clear
              install sudo
              clear
              # 显示所有用户、用户权限、用户组和是否在sudoers中
              echo "用户列表"
              echo "----------------------------------------------------------------------------"
              printf "%-24s %-34s %-20s %-10s\n" "用户名" "用户权限" "用户组" "sudo权限"
              while IFS=: read -r username _ userid groupid _ _ homedir shell; do
                  groups=$(groups "$username" | cut -d : -f 2)
                  sudo_status=$(sudo -n -lU "$username" 2>/dev/null | grep -q '(ALL : ALL)' && echo "Yes" || echo "No")
                  printf "%-20s %-30s %-20s %-10s\n" "$username" "$homedir" "$groups" "$sudo_status"
              done < /etc/passwd


                echo ""
                echo "账户操作"
                echo "------------------------"
                echo "1. 创建普通账户             2. 创建高级账户"
                echo "------------------------"
                echo "3. 赋予最高权限             4. 取消最高权限"
                echo "------------------------"
                echo "5. 删除账号"
                echo "------------------------"
                echo "0. 返回上一级选单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)
                      # 提示用户输入新用户名
                      read -p "请输入新用户名: " new_username

                      # 创建新用户并设置密码
                      sudo useradd -m -s /bin/bash "$new_username"
                      sudo passwd "$new_username"

                      echo "操作已完成。"
                        ;;

                    2)
                      # 提示用户输入新用户名
                      read -p "请输入新用户名: " new_username

                      # 创建新用户并设置密码
                      sudo useradd -m -s /bin/bash "$new_username"
                      sudo passwd "$new_username"

                      # 赋予新用户sudo权限
                      echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

                      echo "操作已完成。"

                        ;;
                    3)
                      read -p "请输入用户名: " username
                      # 赋予新用户sudo权限
                      echo "$username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
                        ;;
                    4)
                      read -p "请输入用户名: " username
                      # 从sudoers文件中移除用户的sudo权限
                      sudo sed -i "/^$username\sALL=(ALL:ALL)\sALL/d" /etc/sudoers

                        ;;
                    5)
                      read -p "请输入要删除的用户名: " username
                      # 删除用户及其主目录
                      sudo userdel -r "$username"
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

        14)
          clear

          echo "随机用户名"
          echo "------------------------"
          for i in {1..5}; do
              username="user$(< /dev/urandom tr -dc _a-z0-9 | head -c6)"
              echo "随机用户名 $i: $username"
          done

          echo ""
          echo "随机姓名"
          echo "------------------------"
          first_names=("John" "Jane" "Michael" "Emily" "David" "Sophia" "William" "Olivia" "James" "Emma" "Ava" "Liam" "Mia" "Noah" "Isabella")
          last_names=("Smith" "Johnson" "Brown" "Davis" "Wilson" "Miller" "Jones" "Garcia" "Martinez" "Williams" "Lee" "Gonzalez" "Rodriguez" "Hernandez")

          # 生成5个随机用户姓名
          for i in {1..5}; do
              first_name_index=$((RANDOM % ${#first_names[@]}))
              last_name_index=$((RANDOM % ${#last_names[@]}))
              user_name="${first_names[$first_name_index]} ${last_names[$last_name_index]}"
              echo "随机用户姓名 $i: $user_name"
          done

          echo ""
          echo "随机UUID"
          echo "------------------------"
          for i in {1..5}; do
              uuid=$(cat /proc/sys/kernel/random/uuid)
              echo "随机UUID $i: $uuid"
          done

          echo ""
          echo "16位随机密码"
          echo "------------------------"
          for i in {1..5}; do
              password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)
              echo "随机密码 $i: $password"
          done

          echo ""
          echo "32位随机密码"
          echo "------------------------"
          for i in {1..5}; do
              password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)
              echo "随机密码 $i: $password"
          done
          echo ""

            ;;

        15)
          while true; do
              clear
              echo "系统时间信息"

              # 获取当前系统时区
              current_timezone=$(timedatectl show --property=Timezone --value)

              # 获取当前系统时间
              current_time=$(date +"%Y-%m-%d %H:%M:%S")

              # 显示时区和时间
              echo "当前系统时区：$current_timezone"
              echo "当前系统时间：$current_time"

              echo ""
              echo "时区切换"
              echo "亚洲------------------------"
              echo "1. 中国上海时间              2. 中国香港时间"
              echo "3. 日本东京时间              4. 韩国首尔时间"
              echo "5. 新加坡时间                6. 印度加尔各答时间"
              echo "7. 阿联酋迪拜时间            8. 澳大利亚悉尼时间"
              echo "欧洲------------------------"
              echo "11. 英国伦敦时间             12. 法国巴黎时间"
              echo "13. 德国柏林时间             14. 俄罗斯莫斯科时间"
              echo "15. 荷兰尤特赖赫特时间       16. 西班牙马德里时间"
              echo "美洲------------------------"
              echo "21. 美国西部时间             22. 美国东部时间"
              echo "23. 加拿大时间               24. 墨西哥时间"
              echo "25. 巴西时间                 26. 阿根廷时间"
              echo "------------------------"
              echo "0. 返回上一级选单"
              echo "------------------------"
              read -p "请输入你的选择: " sub_choice

              case $sub_choice in
                  1) timedatectl set-timezone Asia/Shanghai ;;
                  2) timedatectl set-timezone Asia/Hong_Kong ;;
                  3) timedatectl set-timezone Asia/Tokyo ;;
                  4) timedatectl set-timezone Asia/Seoul ;;
                  5) timedatectl set-timezone Asia/Singapore ;;
                  6) timedatectl set-timezone Asia/Kolkata ;;
                  7) timedatectl set-timezone Asia/Dubai ;;
                  8) timedatectl set-timezone Australia/Sydney ;;
                  11) timedatectl set-timezone Europe/London ;;
                  12) timedatectl set-timezone Europe/Paris ;;
                  13) timedatectl set-timezone Europe/Berlin ;;
                  14) timedatectl set-timezone Europe/Moscow ;;
                  15) timedatectl set-timezone Europe/Amsterdam ;;
                  16) timedatectl set-timezone Europe/Madrid ;;
                  21) timedatectl set-timezone America/Los_Angeles ;;
                  22) timedatectl set-timezone America/New_York ;;
                  23) timedatectl set-timezone America/Vancouver ;;
                  24) timedatectl set-timezone America/Mexico_City ;;
                  25) timedatectl set-timezone America/Sao_Paulo ;;
                  26) timedatectl set-timezone America/Argentina/Buenos_Aires ;;
                  0) break ;; # 跳出循环，退出菜单
                  *) break ;; # 跳出循环，退出菜单
              esac
          done
            ;;

        16)
        if dpkg -l | grep -q 'linux-xanmod'; then
          while true; do
                clear
                kernel_version=$(uname -r)
                echo "您已安装xanmod的BBRv3内核"
                echo "当前内核版本: $kernel_version"

                echo ""
                echo "内核管理"
                echo "------------------------"
                echo "1. 更新BBRv3内核              2. 卸载BBRv3内核"
                echo "------------------------"
                echo "0. 返回上一级选单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)
                      apt purge -y 'linux-*xanmod1*'
                      update-grub

                      # wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
                      wget -qO - https://raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

                      # 步骤3：添加存储库
                      echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

                      # version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
                      version=$(wget -q https://raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

                      apt update -y
                      apt install -y linux-xanmod-x64v$version

                      echo "XanMod内核已更新。重启后生效"
                      rm -f /etc/apt/sources.list.d/xanmod-release.list
                      rm -f check_x86-64_psabi.sh*

                      server_reboot

                        ;;
                    2)
                      apt purge -y 'linux-*xanmod1*'
                      update-grub
                      echo "XanMod内核已卸载。重启后生效"
                      server_reboot
                        ;;
                    0)
                        break  # 跳出循环，退出菜单
                        ;;

                    *)
                        break  # 跳出循环，退出菜单
                        ;;

                esac
          done
      else

        clear
        echo "请备份数据，将为你升级Linux内核开启BBR3"
        echo "官网介绍: https://xanmod.org/"
        echo "------------------------------------------------"
        echo "仅支持Debian/Ubuntu 仅支持x86_64架构"
        echo "VPS是512M内存的，请提前添加1G虚拟内存，防止因内存不足失联！"
        echo "------------------------------------------------"
        read -p "确定继续吗？(Y/N): " choice

        case "$choice" in
          [Yy])
          if [ -r /etc/os-release ]; then
              . /etc/os-release
              if [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
                  echo "当前环境不支持，仅支持Debian和Ubuntu系统"
                  break
              fi
          else
              echo "无法确定操作系统类型"
              break
          fi

          # 检查系统架构
          arch=$(dpkg --print-architecture)
          if [ "$arch" != "amd64" ]; then
            echo "当前环境不支持，仅支持x86_64架构"
            break
          fi

          new_swap=1024
          add_swap
          install wget gnupg

          # wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
          wget -qO - https://raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

          # 步骤3：添加存储库
          echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

          # version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
          version=$(wget -q https://raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

          apt update -y
          apt install -y linux-xanmod-x64v$version

          # 步骤5：启用BBR3
          cat > /etc/sysctl.conf << EOF
net.core.default_qdisc=fq_pie
net.ipv4.tcp_congestion_control=bbr
EOF
          sysctl -p
          echo "XanMod内核安装并BBR3启用成功。重启后生效"
          rm -f /etc/apt/sources.list.d/xanmod-release.list
          rm -f check_x86-64_psabi.sh*
          server_reboot

            ;;
          [Nn])
            echo "已取消"
            ;;
          *)
            echo "无效的选择，请输入 Y 或 N。"
            ;;
        esac
      fi
            ;;

        17)
        if dpkg -l | grep -q iptables-persistent; then
          while true; do
                clear
                echo "防火墙已安装"
                echo "------------------------"
                iptables -L INPUT

                echo ""
                echo "防火墙管理"
                echo "------------------------"
                echo "1. 开放指定端口              2. 关闭指定端口"
                echo "3. 开放所有端口              4. 关闭所有端口"
                echo "------------------------"
                echo "5. IP白名单                  6. IP黑名单"
                echo "7. 清除指定IP"
                echo "------------------------"
                echo "9. 卸载防火墙"
                echo "------------------------"
                echo "0. 返回上一级选单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)
                    read -p "请输入开放的端口号: " o_port
                    sed -i "/COMMIT/i -A INPUT -p tcp --dport $o_port -j ACCEPT" /etc/iptables/rules.v4
                    sed -i "/COMMIT/i -A INPUT -p udp --dport $o_port -j ACCEPT" /etc/iptables/rules.v4
                    iptables-restore < /etc/iptables/rules.v4

                        ;;
                    2)
                    read -p "请输入关闭的端口号: " c_port
                    sed -i "/--dport $c_port/d" /etc/iptables/rules.v4
                    iptables-restore < /etc/iptables/rules.v4
                      ;;

                    3)
                    current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

                    cat > /etc/iptables/rules.v4 << EOF
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A FORWARD -i lo -j ACCEPT
-A INPUT -p tcp --dport $current_port -j ACCEPT
COMMIT
EOF
                    iptables-restore < /etc/iptables/rules.v4

                        ;;
                    4)
                    current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

                    cat > /etc/iptables/rules.v4 << EOF
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A FORWARD -i lo -j ACCEPT
-A INPUT -p tcp --dport $current_port -j ACCEPT
COMMIT
EOF
                    iptables-restore < /etc/iptables/rules.v4

                        ;;

                    5)
                    read -p "请输入放行的IP: " o_ip
                    sed -i "/COMMIT/i -A INPUT -s $o_ip -j ACCEPT" /etc/iptables/rules.v4
                    iptables-restore < /etc/iptables/rules.v4

                        ;;

                    6)
                    read -p "请输入封锁的IP: " c_ip
                    sed -i "/COMMIT/i -A INPUT -s $c_ip -j DROP" /etc/iptables/rules.v4
                    iptables-restore < /etc/iptables/rules.v4
                        ;;

                    7)
                    read -p "请输入清除的IP: " d_ip
                    sed -i "/-A INPUT -s $d_ip/d" /etc/iptables/rules.v4
                    iptables-restore < /etc/iptables/rules.v4
                        ;;

                    9)
                    remove iptables-persistent
                    rm /etc/iptables/rules.v4
                    break
                        ;;

                    0)
                        break  # 跳出循环，退出菜单
                        ;;

                    *)
                        break  # 跳出循环，退出菜单
                        ;;

                esac
          done
      else

        clear
        echo "将为你安装防火墙，该防火墙仅支持Debian/Ubuntu"
        echo "------------------------------------------------"
        read -p "确定继续吗？(Y/N): " choice

        case "$choice" in
          [Yy])
          if [ -r /etc/os-release ]; then
              . /etc/os-release
              if [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
                  echo "当前环境不支持，仅支持Debian和Ubuntu系统"
                  break
              fi
          else
              echo "无法确定操作系统类型"
              break
          fi

        clear
        iptables_open
        remove iptables-persistent ufw
        rm /etc/iptables/rules.v4

        apt update -y && apt install -y iptables-persistent

        current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

        cat > /etc/iptables/rules.v4 << EOF
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A FORWARD -i lo -j ACCEPT
-A INPUT -p tcp --dport $current_port -j ACCEPT
COMMIT
EOF

        iptables-restore < /etc/iptables/rules.v4
        systemctl enable netfilter-persistent
        echo "防火墙安装完成"


            ;;
          [Nn])
            echo "已取消"
            ;;
          *)
            echo "无效的选择，请输入 Y 或 N。"
            ;;
        esac
      fi
            ;;

        18)
        clear
        current_hostname=$(hostname)
        echo "当前主机名: $current_hostname"
        read -p "是否要更改主机名？(y/n): " answer
        if [ "$answer" == "y" ]; then
            # 获取新的主机名
            read -p "请输入新的主机名: " new_hostname
            if [ -n "$new_hostname" ]; then
                if [ -f /etc/alpine-release ]; then
                    # Alpine
                    echo "$new_hostname" > /etc/hostname
                    hostname "$new_hostname"
                else
                    # 其他系统，如 Debian, Ubuntu, CentOS 等
                    hostnamectl set-hostname "$new_hostname"
                    sed -i "s/$current_hostname/$new_hostname/g" /etc/hostname
                    systemctl restart systemd-hostnamed
                fi
                echo "主机名已更改为: $new_hostname"
            else
                echo "无效的主机名。未更改主机名。"
                exit 1
            fi
        else
            echo "未更改主机名。"
        fi
            ;;

        19)

        # 获取系统信息
        source /etc/os-release

        # 定义 Ubuntu 更新源
        aliyun_ubuntu_source="http://mirrors.aliyun.com/ubuntu/"
        official_ubuntu_source="http://archive.ubuntu.com/ubuntu/"
        initial_ubuntu_source=""

        # 定义 Debian 更新源
        aliyun_debian_source="http://mirrors.aliyun.com/debian/"
        official_debian_source="http://deb.debian.org/debian/"
        initial_debian_source=""

        # 定义 CentOS 更新源
        aliyun_centos_source="http://mirrors.aliyun.com/centos/"
        official_centos_source="http://mirror.centos.org/centos/"
        initial_centos_source=""

        # 获取当前更新源并设置初始源
        case "$ID" in
            ubuntu)
                initial_ubuntu_source=$(grep -E '^deb ' /etc/apt/sources.list | head -n 1 | awk '{print $2}')
                ;;
            debian)
                initial_debian_source=$(grep -E '^deb ' /etc/apt/sources.list | head -n 1 | awk '{print $2}')
                ;;
            centos)
                initial_centos_source=$(awk -F= '/^baseurl=/ {print $2}' /etc/yum.repos.d/CentOS-Base.repo | head -n 1 | tr -d ' ')
                ;;
            *)
                echo "未知系统，无法执行切换源脚本"
                exit 1
                ;;
        esac

        # 备份当前源
        backup_sources() {
            case "$ID" in
                ubuntu)
                    cp /etc/apt/sources.list /etc/apt/sources.list.bak
                    ;;
                debian)
                    cp /etc/apt/sources.list /etc/apt/sources.list.bak
                    ;;
                centos)
                    if [ ! -f /etc/yum.repos.d/CentOS-Base.repo.bak ]; then
                        cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
                    else
                        echo "备份已存在，无需重复备份"
                    fi
                    ;;
                *)
                    echo "未知系统，无法执行备份操作"
                    exit 1
                    ;;
            esac
            echo "已备份当前更新源为 /etc/apt/sources.list.bak 或 /etc/yum.repos.d/CentOS-Base.repo.bak"
        }

        # 还原初始更新源
        restore_initial_source() {
            case "$ID" in
                ubuntu)
                    cp /etc/apt/sources.list.bak /etc/apt/sources.list
                    ;;
                debian)
                    cp /etc/apt/sources.list.bak /etc/apt/sources.list
                    ;;
                centos)
                    cp /etc/yum.repos.d/CentOS-Base.repo.bak /etc/yum.repos.d/CentOS-Base.repo
                    ;;
                *)
                    echo "未知系统，无法执行还原操作"
                    exit 1
                    ;;
            esac
            echo "已还原初始更新源"
        }

        # 函数：切换更新源
        switch_source() {
            case "$ID" in
                ubuntu)
                    sed -i 's|'"$initial_ubuntu_source"'|'"$1"'|g' /etc/apt/sources.list
                    ;;
                debian)
                    sed -i 's|'"$initial_debian_source"'|'"$1"'|g' /etc/apt/sources.list
                    ;;
                centos)
                    sed -i "s|^baseurl=.*$|baseurl=$1|g" /etc/yum.repos.d/CentOS-Base.repo
                    ;;
                *)
                    echo "未知系统，无法执行切换操作"
                    exit 1
                    ;;
            esac
        }

        # 主菜单
        while true; do
            clear
            case "$ID" in
                ubuntu)
                    echo "Ubuntu 更新源切换脚本"
                    echo "------------------------"
                    ;;
                debian)
                    echo "Debian 更新源切换脚本"
                    echo "------------------------"
                    ;;
                centos)
                    echo "CentOS 更新源切换脚本"
                    echo "------------------------"
                    ;;
                *)
                    echo "未知系统，无法执行脚本"
                    exit 1
                    ;;
            esac

            echo "1. 切换到阿里云源"
            echo "2. 切换到官方源"
            echo "------------------------"
            echo "3. 备份当前更新源"
            echo "4. 还原初始更新源"
            echo "------------------------"
            echo "0. 返回上一级"
            echo "------------------------"
            read -p "请选择操作: " choice

            case $choice in
                1)
                    backup_sources
                    case "$ID" in
                        ubuntu)
                            switch_source $aliyun_ubuntu_source
                            ;;
                        debian)
                            switch_source $aliyun_debian_source
                            ;;
                        centos)
                            switch_source $aliyun_centos_source
                            ;;
                        *)
                            echo "未知系统，无法执行切换操作"
                            exit 1
                            ;;
                    esac
                    echo "已切换到阿里云源"
                    ;;
                2)
                    backup_sources
                    case "$ID" in
                        ubuntu)
                            switch_source $official_ubuntu_source
                            ;;
                        debian)
                            switch_source $official_debian_source
                            ;;
                        centos)
                            switch_source $official_centos_source
                            ;;
                        *)
                            echo "未知系统，无法执行切换操作"
                            exit 1
                            ;;
                    esac
                    echo "已切换到官方源"
                    ;;
                3)
                    backup_sources
                    case "$ID" in
                        ubuntu)
                            switch_source $initial_ubuntu_source
                            ;;
                        debian)
                            switch_source $initial_debian_source
                            ;;
                        centos)
                            switch_source $initial_centos_source
                            ;;
                        *)
                            echo "未知系统，无法执行切换操作"
                            exit 1
                            ;;
                    esac
                    echo "已切换到初始更新源"
                    ;;
                4)
                    restore_initial_source
                    ;;
                0)
                    break
                    ;;
                *)
                    echo "无效的选择，请重新输入"
                    ;;
            esac
            break_end

        done

            ;;

        20)

            while true; do
                clear
                echo "定时任务列表"
                crontab -l
                echo ""
                echo "操作"
                echo "------------------------"
                echo "1. 添加定时任务              2. 删除定时任务"
                echo "------------------------"
                echo "0. 返回上一级选单"
                echo "------------------------"
                read -p "请输入你的选择: " sub_choice

                case $sub_choice in
                    1)
                        read -p "请输入新任务的执行命令: " newquest
                        echo "------------------------"
                        echo "1. 每周任务                 2. 每天任务"
                        read -p "请输入你的选择: " dingshi

                        case $dingshi in
                            1)
                                read -p "选择周几执行任务？ (0-6，0代表星期日): " weekday
                                (crontab -l ; echo "0 0 * * $weekday $newquest") | crontab - > /dev/null 2>&1
                                ;;
                            2)
                                read -p "选择每天几点执行任务？（小时，0-23）: " hour
                                (crontab -l ; echo "0 $hour * * * $newquest") | crontab - > /dev/null 2>&1
                                ;;
                            *)
                                break  # 跳出
                                ;;
                        esac
                        ;;
                    2)
                        read -p "请输入需要删除任务的关键字: " kquest
                        crontab -l | grep -v "$kquest" | crontab -
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

        21)

            while true; do
                clear
                echo "本机host解析列表"
                echo "如果你在这里添加解析匹配，将不再使用动态解析了"
                cat /etc/hosts
                echo ""
                echo "操作"
                echo "------------------------"
                echo "1. 添加新的解析              2. 删除解析地址"
                echo "------------------------"
                echo "0. 返回上一级选单"
                echo "------------------------"
                read -p "请输入你的选择: " host_dns

                case $host_dns in
                    1)
                        read -p "请输入新的解析记录 格式: 110.25.5.33 kejilion.pro : " addhost
                        echo "$addhost" >> /etc/hosts

                        ;;
                    2)
                        read -p "请输入需要删除的解析内容关键字: " delhost
                        sed -i "/$delhost/d" /etc/hosts
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

        22)
          if docker inspect fail2ban &>/dev/null ; then
              while true; do
                  clear
                  echo "SSH防御程序已启动"
                  echo "------------------------"
                  echo "1. 查看SSH拦截记录"
                  echo "2. 日志实时监控"
                  echo "------------------------"
                  echo "9. 卸载防御程序"
                  echo "------------------------"
                  echo "0. 退出"
                  echo "------------------------"
                  read -p "请输入你的选择: " sub_choice
                  case $sub_choice in

                      1)
                          echo "------------------------"
                          f2b_sshd
                          echo "------------------------"
                          ;;
                      2)
                          tail -f /path/to/fail2ban/config/log/fail2ban/fail2ban.log
                          break
                          ;;
                      9)
                          docker rm -f fail2ban
                          rm -rf /path/to/fail2ban
                          echo "Fail2Ban防御程序已卸载"

                          break
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
            echo "fail2ban是一个SSH防止暴力破解工具"
            echo "官网介绍: https://github.com/fail2ban/fail2ban"
            echo "------------------------------------------------"
            echo "工作原理：研判非法IP恶意高频访问SSH端口，自动进行IP封锁"
            echo "------------------------------------------------"
            read -p "确定继续吗？(Y/N): " choice

            case "$choice" in
              [Yy])
                clear
                install_docker
                f2b_install_sshd

                cd ~
                f2b_status
                echo "Fail2Ban防御程序已开启"

                ;;
              [Nn])
                echo "已取消"
                ;;
              *)
                echo "无效的选择，请输入 Y 或 N。"
                ;;
            esac
          fi
            ;;


        23)
          clear
          echo "当前流量使用情况，重启服务器流量计算会清零！"
          output_status
          echo "$output"

          # 检查是否存在 Limiting_Shut_down.sh 文件
          if [ -f ~/Limiting_Shut_down.sh ]; then
              # 获取 threshold_gb 的值
              threshold_gb=$(grep -oP 'threshold_gb=\K\d+' ~/Limiting_Shut_down.sh)
              echo "当前设置的限流阈值为 ${threshold_gb}GB"
          else
              echo "当前未启用限流关机功能"
          fi

          echo
          echo "------------------------------------------------"
          echo "系统每分钟会检测实际流量是否到达阈值，到达后会自动关闭服务器！每月1日重置流量重启服务器。"
          read -p "1. 开启限流关机功能    2. 停用限流关机功能    0. 退出  : " Limiting

          case "$Limiting" in
            1)
              # 输入新的虚拟内存大小
              echo "如果实际服务器就100G流量，可设置阈值为95G，提前关机，以免出现流量误差或溢出."
              read -p "请输入流量阈值（单位为GB）: " threshold_gb
              cd ~
              curl -Ss -O https://raw.githubusercontent.com/kejilion/sh/main/Limiting_Shut_down.sh
              chmod +x ~/Limiting_Shut_down.sh
              sed -i "s/110/$threshold_gb/g" ~/Limiting_Shut_down.sh
              crontab -l | grep -v '~/Limiting_Shut_down.sh' | crontab -
              (crontab -l ; echo "* * * * * ~/Limiting_Shut_down.sh") | crontab - > /dev/null 2>&1
              crontab -l | grep -v 'reboot' | crontab -
              (crontab -l ; echo "0 1 1 * * reboot") | crontab - > /dev/null 2>&1
              echo "限流关机已设置"

              ;;
            0)
              echo "已取消"
              ;;
            2)
              crontab -l | grep -v '~/Limiting_Shut_down.sh' | crontab -
              crontab -l | grep -v 'reboot' | crontab -
              rm ~/Limiting_Shut_down.sh
              echo "已关闭限流关机功能"
              ;;
            *)
              echo "无效的选择，请输入 Y 或 N。"
              ;;
          esac

            ;;


        31)
          clear
          install sshpass

          remote_ip="66.42.61.110"
          remote_user="liaotian123"
          remote_file="/home/liaotian123/liaotian.txt"
          password="kejilionYYDS"  # 替换为您的密码

          clear
          echo "科技lion留言板"
          echo "------------------------"
          # 显示已有的留言内容
          sshpass -p "${password}" ssh -o StrictHostKeyChecking=no "${remote_user}@${remote_ip}" "cat '${remote_file}'"
          echo ""
          echo "------------------------"

          # 判断是否要留言
          read -p "是否要留言？(y/n): " leave_message

          if [ "$leave_message" == "y" ] || [ "$leave_message" == "Y" ]; then
              # 输入新的留言内容
              read -p "输入你的昵称: " nicheng
              read -p "输入你的聊天内容: " neirong

              # 添加新留言到远程文件
              sshpass -p "${password}" ssh -o StrictHostKeyChecking=no "${remote_user}@${remote_ip}" "echo -e '${nicheng}: ${neirong}' >> '${remote_file}'"
              echo "已添加留言: "
              echo "${nicheng}: ${neirong}"
              echo ""
          else
              echo "您选择了不留言。"
          fi

          echo "留言板操作完成。"

            ;;

        99)
            clear
            server_reboot
            ;;
        0)  
            eco
            clear
            exit
          ;;  
        *)
            echo "无效的输入!"
            ;;
    esac
    break_end

  done
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
