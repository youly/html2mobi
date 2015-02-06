module Html2mobi
	class Environment
		
		def self.basedir
			File.expand_path('~') + '/.html2mobi'
		end

		def self.setup
			base_dir = basedir
			unless File.directory? base_dir
    			puts '创建配置目录：' + base_dir
    			Dir.mkdir(base_dir)
			end
		end
	end
end