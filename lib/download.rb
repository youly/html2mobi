require 'uri'
require 'open-uri'
require 'json'
require 'mail'

module Html2mobi
    class Download
        
        UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36"

        def initialize(url, save_path)
            @home = File.expand_path('~') + '/.html2mobi'
            unless File.directory? @home
                Dir.mkdir @home
            end
            @uri = URI.parse(url)
            @url = url
            @save_path = save_path
            @config = nil
            load_config
        end

        def load_config
            file = @home + '/config.json'
            if !File.exist? file
                puts '配置文件不存在，请创建你的配置文件：' + file
            else
                @config = JSON.load(File.new(file))
            end
        end

        #下载目录
        def download_index
            puts 'exit because not implemented'
            exit(1)
        end

        #下载章节，支持网络失败重新执行
        def download_chapters
            
            unless File.exist? chapter_dinfo_path
                puts 'exit because ' + chapter_dinfo_path + 'not exists!'
                exit(1)
            end

            lines = []
            download_error = false
            dinfo = File.open(chapter_dinfo_path, 'r')
            
            dinfo.each_line do |line|
                strArr = line.split('|')
                begin
                    if (strArr[2].strip == 'no')
                        data = open(strArr[1], "User-Agent" => UA)
                        File.open(chapter_path(strArr[0]), 'w') do |f|
                            f.write(data.read)
                            f.close
                            line = strArr[0] + '|' + strArr[1] + '|' + "yes\r\n"
                            puts 'download success:' + line
                        end
                    end
                rescue Exception => e
                    puts 'download error:' + e.to_s
                    download_error = true
                end
                lines << line
            end
            dinfo.close

            File.open(chapter_dinfo_path, 'w') do |f|
                lines.each do |line|
                    f.write(line)
                end
                f.close
            end

            if download_error
                puts 'exit becase download error, please retry: html2mobi ' + @url + ' ' + @save_path
                exit(1)
            end
        end

        #生成章节下载信息
        def generate_chapter_dinfo
            puts 'exit because not implemented'
            exit(1)
        end

        #获取目录索引存储路径
        def index_path
            @save_path + '/book'
        end

        #获取章节下载信息存储路径
        def chapter_dinfo_path
            @save_path + '/url'
        end

        #获取章节存储路径
        def chapter_path(chapter)
            chapter_dir = @save_path + '/chapter'
            Dir.mkdir(chapter_dir) unless File.directory? chapter_dir
            chapter_dir + '/' + chapter
        end

        def kindle_output_path
            output_path = @save_path + '/kindle'
            Dir.mkdir(output_path) unless File.directory? output_path
            output_path
        end

        def kindle_mobi
            kindle_output_path + '/' + get_book_name + '.mobi'
        end

        def mail_to
            if @config.nil?
                puts '配置文件不存在，邮件没有发送'
                exit(1)
            end
            puts '将电子书发送至：' + @config['to']
            config = {
                :address => @config['server'],
                :port => @config['port'],
                :domain => @config['server'],
                :user_name => @config['user_name'],
                :password => @config['password'],
                :ssl => @config['ssl']
            }
            Mail.defaults { delivery_method :smtp, config }
            mail = Mail.new
            mail.charset = 'UTF-8'
            mail.from @config['user_name']
            mail.to @config['to']
            mail.subject get_book_name
            mail.body 'this is a auto_generated mobi:' + get_book_name

            mail.convert_to_multipart
            filename = get_book_name + '.mobi'
            mail.attachments[filename] = File.open(kindle_mobi, 'rb') { |f| f.read }
            mail.deliver!
        end

        #获取书籍下载url
        def chapter_url(path)
            puts 'exit because not implemented'
            exit(1)
        end

        def get_book_name
            puts 'exit because not implemented'
            exit(1)
        end

        def get_book_cover_img
            puts 'exit because not implemented'
            exit(1)
        end

        def get_book_author
            puts 'exit because not implemented'
            exit(1)
        end

        def generate_mobi_book
            puts 'exit because not implemented'
            exit(1)
        end
    end
end
