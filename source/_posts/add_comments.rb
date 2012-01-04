
def replace(filepath)
   content=[]
   f = File.open(filepath,'r')
   f.each do |line|
     if line.downcase=~/^categories:.*/
       content << "comments: true"
     end
     content<<line
   end
   f.close
   File.open(filepath, 'w') do |file|
     content.each do |line|
        file.puts line
     end
   end
end

files = Dir.glob("*.markdown")
files.each do |f|
  replace f 
end

