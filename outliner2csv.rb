#读取大纲

module Outliner2csv
   def self.o2t(ents)
      for e in ents do
	 if e.typename == "ComponentInstance"
	    @file.print @sep * @indent
	    @file.puts "[Ci] #{e.definition.name}"
	    @indent += @in
	    o2t(e.definition.entities)
	    @indent -= @in
	 end
	 if e.typename == "Group"
	    @file.print @sep * @indent
	    @file.puts "[Gr] #{e.name}"
	    @indent += @in
	    o2t(e.entities)
	    @indent -= @in
	 end
      end
   end

   def self.main
      @indent = 0
      @in = 1
      @sep = ","
      file = UI.savepanel "Save Outliner", "", "outliner.csv"
      @file= File.open(file, "w")
      o2t Sketchup.active_model.entities
      @file.flush
      @file.close
   end

end
sn = File.basename(__FILE__)
unless file_loaded?(sn)
   UI.menu("Plugins").add_item("Outliner2cvs") { Outliner2csv.main }
   file_loaded(sn)
end
