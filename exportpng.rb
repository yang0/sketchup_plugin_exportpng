
#作者：旺德福  137962@qq.com

def extractPng(inFile, width, height)
	folder = File.dirname(inFile)
	fileName = File.basename(inFile, ".skp")
	outFile = "#{folder}/#{fileName}_#{width}X#{height}.jpeg"

	 keys = {
	   :filename => outFile,
	   :width => width,
	   :height => height,
	   :antialias => false,
	   :compression => 0.9,
	   :transparent => true
	 }
	 model = Sketchup.active_model
	 view = model.active_view
	 view.write_image keys
end


def skp2png(inFile)
	print "skp2png start\n"
	result = true



	result = Sketchup.open_file(inFile)
	
	

	#model = Sketchup.active_model
	#result = model.import inFile, true
	if result
		print "file opened\n"
		extractPng(inFile, 1280, 800)
		extractPng(inFile, 1000, 1000)
	else
		print "file not open\n"
	end
	#Sketchup.quit
 	#status = model.close_active
 	#model.entities.clear!
end



#define a recursive function that will traverse the directory tree
def recurFolder(folder)
	pattern = /.+\.skp$/
  #we keep track of the directories, to be used in the second, recursive part of this function
  directories=[]
  Dir["#{folder}/*"].sort.each do |name|
  	print "\n==================================\n"
  	print name

  	name = name.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')

    if name[pattern]
    	if File.file?(name)
	    	print "expand_path start\n"
	    	file = File.expand_path(name)
	    	print file
	    	skp2png(file)
	    else
	    	print "\n模式匹配但是非文件\n"
	    end
    elsif File.directory?(name)
    	print "dir\n"
    	directories << name
    else
    	print "\n not skp file or dir\n"
    end
  end
  directories.each do |name|
    #don't descend into . or .. on linux
    Dir.chdir(name){recurFolder(name)} if !Dir.pwd[File.expand_path(name)]
  end
end


def exportPng()
	folders = UI.inputbox(["模型目录："])
	folder = folders[0]
	folder = folder.gsub('\\', "/")


	recurFolder(folder)
end



sn = File.basename(__FILE__)
unless file_loaded?(sn)
   UI.menu("Plugins").add_item("批量导出缩略图") { exportPng }
   file_loaded(sn)
end

