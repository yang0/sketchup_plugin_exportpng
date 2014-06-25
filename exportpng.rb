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
	result = true



	result = Sketchup.open_file(inFile)
	
	

	#model = Sketchup.active_model
	#result = model.import inFile, true
	if result
		extractPng(inFile, 1280, 800)
		extractPng(inFile, 1000, 1000)
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
  	print name
    if File.file?(name) and name[pattern]
    	file = File.expand_path(name)
    	print file
    	skp2png(file)
    elsif File.directory?(name)
    	directories << name
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

