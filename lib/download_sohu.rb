require 'nokogiri'
require 'open-uri'
require 'uri'
require 'download'
require 'kindler'

module Html2mobi
    class Download_sohu < Download
        def download_index
            begin
                unless File.exist? index_path
                    data = open(@url)
                    File.open(index_path, 'w') do |f|
                        f.write(data.read)
                        f.close
                    end
                end
            rescue Exception => e
                puts e.to_s
                exit(1)
            end
        end

        def generate_chapter_dinfo
            unless File.exist? index_path
                puts 'exit because ' + index_path + 'not exists!'
                exit(1)
            end

            unless File.exist? chapter_dinfo_path
                book_index = Nokogiri::HTML(File.open(index_path))
                f = File.open(chapter_dinfo_path, 'w')
                book_index.css('div[class="lc_con1"] li').each do |chapter|
                    url = chapter_url(chapter.css('a')[0]['href'])
                    index = url.match /\d+/
                    line = index.to_s + '|' + url + "|no\r\n"
                    f.write(line)
                end
                f.close
            end
        end
            
        def chapter_url(path)
            @uri.scheme + '://' + @uri.host + path
        end

        def get_book_name
            book_index = Nokogiri::HTML(File.open(index_path))
            h = book_index.css('div[class="rc"] h2')
            if h[0].text.strip! == ''
                puts "exit because book name empty!"
                exit(1)
            end
            h[0].text
        end

        def get_book_cover_img
            book_index = Nokogiri::HTML(File.open(index_path))
            a = book_index.css('div[class="lc"] img')
            a[0]['src']
        end

        def get_book_author
            book_index = Nokogiri::HTML(File.open(index_path))
            a = book_index.css('div[class="rc"] p a')
            if a[0].text.strip! == ''
                puts "exit because book author empty!"
                exit(1)
            end
            a[0].text
        end

        def generate_mobi_book
            puts '下载目录…'
            download_index
            puts '书名：' + get_book_name
            puts '作者：' + get_book_author
            puts '封面图片：' + get_book_cover_img
            puts '生成章节下载信息…'
            generate_chapter_dinfo
            puts '下载章节…'
            download_chapters
            do_generage
            mail_to
        end

        def do_generage

            title = get_book_name
            author = get_book_author

            book_options = {
                :title => title,
                :author => author,
                :silent => false,
                :debug => false,
                :output_dir => kindle_output_path
            }

            book = Kindler::Book.new book_options

            book.add_page({
                :title => title,
                :author => author,
                :content => '<img src="' + get_book_cover_img + '" />'
            })

            page = Nokogiri::HTML(File.open(index_path))
            page.css('div[class="lc_con1"]').each do |part|
                
                book.add_page({
                    :title => part.css('h2').text,
                    :author => author,
                    :content => part.css('p').text
                })

                part.css('li').each do |chapter|
                    url = chapter_url(chapter.css('a')[0]['href'])
                    index = url.match(/\d+/).to_s
                    content = Nokogiri::HTML(File.open(chapter_path(index)))
                    #puts chapter.css('a')[0].text
                    #puts content.css('div[class="book_con"]')[0].inner_html

                book.add_page({
                    :title => chapter.css('a')[0].text,
                    :author => author,
                    :content => content.css('div[class="book_con"]')[0].inner_html
                })
                end
            end
            book.generate
        end
    end

end
