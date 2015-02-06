# Html2mobi

##将在线html页面转换成mobi格式并自动发送至你的kindle，当前支持：

1、搜狐读书频道 http://lz.book.sohu.com

2、csdn博客 http://blog.csdn.net

##说明

1、依赖KindleGen、kindler、mail，nokogiri

2、电子书生成后自动发送到邮件，请添加配置文件 ~/.html2mobi/config.json

    {
        "server":"your kindle sync smtp server",
        "port":465,
        "user_name":"your name",
        "password":"your password",
        "ssl":"true",
        "to":"who send to"
    }

3、支持下载失败重试，按照提示复制重试命令并执行

4、下载电子书示例 html2mobi http://lz.book.sohu.com/book-13200.html

5、生成的电子书会在本地存储一份，目录是 ~/.html2mobi，你也可以指定一个目录


## 安装

    $ git clone https://github.com/youly/html2mobi.git
    $ cd html2mobi
    $ gem build html2mobi.gemspec
    $ sudo gem install html2mobi-1.0.0.gem -V

## 使用

html2mobi url [path]

## Contributing

1. Fork it ( https://github.com/youly/html2mobi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
