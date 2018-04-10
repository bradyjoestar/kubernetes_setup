# Ubuntu下nginx文件服务器

### 403 forbidden 问题

在192.168.1.160上搭建了nginx文件服务器，可以用作公用的服务器。

在启动过程中会报403 forbidden的错误。

解决方案：

/etc/nginx/sites-available/的default文件，需要修改为上述的代码，才能够不出现访问nginx时出现的403forbidden情况。

然后可以通过service nginx restart 启动nginx服务器，访问192.168.1.160:8082 可获得文件列表。


```
root /data/file;

# Add index.php to the list if you are using PHP
# index index.html index.htm index.nginx-debian.html;

server_name _;

location / {
    autoindex       on;
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    try_files $uri $uri/ =404;
}

```



```
docker run -itd -p 8082:80 -v /data/nginx/file/:/data/file 192.168.1.160:5000/nginxfileserver /bin/bash
```

在nginx中将/data/file 挂载到目录上，实际映射目录为宿主机上的/data/nginx/file。

这样的好处在于当容器死掉后，数据仍然存在宿主机上。并且上传文件可以通过scp直接传入到宿主机的/data/nginx/file中。

当容器死亡的时候，通过
```
docker run -itd -p 8082:80 -v /data/nginx/file/:/data/file 192.168.1.160:5000/nginxfileserver /bin/bash
```
重启容器，并通过：
```
docker exec -it "container id" /bin/bash
```
进入到容器中，执行
```
service nginx start
```
重启。
