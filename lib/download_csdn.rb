require 'nokogiri'
require 'open-uri'
require 'uri'
require 'download'
require 'kindler'

module Html2mobi
    class Download_sohu < Download

    	UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36"
    	def self.support?(url)
    		url.include? 'blog.csdn.net'
    	end

    	def download_index
    		begin
                unless File.exist? index_path
                    data = open(@url, "User-Agent" => UA)
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

    	def get_book_name
            book_index = Nokogiri::HTML(File.open(index_path))
            h = book_index.css('div[id="blog_title"] h2 a')
            if h[0].text.strip! == ''
                puts "exit because book name empty!"
                exit(1)
            end
            h[0].text
        end

        def get_book_cover_img
            book_index = Nokogiri::HTML(File.open(index_path))
            a = book_index.css('div[id="blog_userface"] img')
            a[0]['src']
        end

        def get_book_author
            book_index = Nokogiri::HTML(File.open(index_path))
            a = book_index.css('div[id="blog_userface"] a[class="user_name"]')
            if a[0].text.strip! == ''
                puts "exit because book author empty!"
                exit(1)
            end
            a[0].text
        end

        def chapter_url(path)
            @uri.scheme + '://' + @uri.host + path
        end

        def get_next_page(curPage)
        	pageLinks = curPage.css('div[id="papelist"] a')
        	pageLinks.each do |a|
        		if a.text.strip == '下一页'
        			begin
        				return Nokogiri::HTML(open(chapter_url(a['href']), "User-Agent" => UA))
        			rescue Exception => e
        				puts e.to_s
        				#下载出错，需重新下载
        				File.delete chapter_dinfo_path
        				exit(1)
        			end
        		end
        	end
        	nil
        end

        def generate_chapter_dinfo
            unless File.exist? index_path
                puts 'exit because ' + index_path + 'not exists!'
                exit(1)
            end

            unless File.exist? chapter_dinfo_path
                page = Nokogiri::HTML(File.open(index_path))
                f = File.open(chapter_dinfo_path, 'w')
                while (!page.nil?) do
	                page.css('div[id="article_list"] h1 a').each do |chapter|
	                	index = chapter['href'].match /\d+/
	                	line = index.to_s + '|' + chapter_url(chapter['href']) + "|no\r\n"
	                	f.write(line)
	                	puts chapter_url(chapter['href']) + " " + chapter.text.strip!
	                end
	                page = get_next_page(page)
                end
                f.close
            end
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

            f = File.open(chapter_dinfo_path, 'r')
            f.each_line do |line|
                strArr = line.split('|')
                index = strArr[0]
                article = Nokogiri::HTML(File.open(chapter_path(index)))
                title = article.css('div[id="article_details"] h1 a')[0].text.strip
                book.add_page({
                    :title => title,
                    :author => author,
                    :content => article.css('div[id="article_content"]')[0].inner_html
                })
                #puts title
            end
            f.close
            book.generate
        end
    end
end