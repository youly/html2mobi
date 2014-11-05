require 'uri'
require 'open-uri'

module Html2mobi
    class Download
        def initialize(url, save_path)
            @uri = URI.parse(url)
            @url = url
            @save_path = save_path
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
                        data = open(strArr[1])
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
                puts 'exit becase download error, please retry!'
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
