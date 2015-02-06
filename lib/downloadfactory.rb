require 'download'
require 'download_sohu'
require 'download_csdn'

module Html2mobi
    class Downloadfactory
        def self.create(url, path)
            if Download_sohu.support? url
                Download_sohu.new(url, path)
            else
            	puts '抱歉，还不支持这个网站'
            	exit(1)
            end
        end
    end
end
