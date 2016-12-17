name = ARGV.first
unless name
  STDERR.puts "USAGE: ruby create_dict.rb NAME"
  exit 1
end
def path_of(name)
  "lyrics/#{name}.txt"
end

def normalize(name)
  filepath = path_of(name)
  txt = File.read(filepath)
  txt = txt.tr('　', ' ').tr("\n", ' ')
  File.write(filepath, txt + "\n")
end

normalize(name)

`
  rm -f lyrics/#{name}.parsed.txt;
  mecab -d /usr/local/lib/mecab/dic/mecab-ipadic-neologd < lyrics/#{name}.txt > lyrics/#{name}.parsed.txt
`

class DictionaryFactory
  class << self
    def create(name)
      words = File.read("lyrics/#{name}.parsed.txt").split("\n").map do |line|
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
File.write("lyrics/#{name}.dict", txt)
