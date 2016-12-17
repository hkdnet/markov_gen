name = ARGV.first
unless name
  STDERR.puts "USAGE: ruby create_dict.rb NAME"
  exit 1
end
def path_of(name)
  "source/#{name}.txt"
end

def normalize(name)
  filepath = path_of(name)
  txt = File.read(filepath)
  txt = txt.tr('　', ' ').tr("\n", ' ')
  File.write(filepath, txt + "\n")
end

normalize(name)

`
  rm -f source/#{name}.parsed.txt;
  mecab -d $(mecab-config --dicdir)/mecab-ipadic-neologd < source/#{name}.txt > source/#{name}.parsed.txt
`

class DictionaryFactory
  class << self
    def create(name)
      words = File.read("source/#{name}.parsed.txt").split("\n").map do |line|
        next if line == "EOS"
        line.split("\t").first
      end
      words.compact!
      words.push(nil)
      words.each_cons(3).to_a
    end
  end
end

dict = DictionaryFactory.create(name)
txt = dict.map { |e| e.join(",") }.join("\n")
File.write("source/#{name}.dict", txt)
