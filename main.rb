def read_dict(name)
  txt = File.read("lyrics/#{name}.dict")
  txt.split("\n").map { |e| e.split(",") }
end

class LyricsFactory
  class << self
    def create(*dicts)
      n = dicts.sample.first
      ret = [n[0], n[1]]
      loop do
        candidates = create_candidates(dicts, n[0], n[1])
        break if candidates.empty?
        tmp = candidates.sample
        break unless tmp[2]
        ret << tmp[2]
        n = [tmp[1], tmp[2]]
      end
      ret
    end

    def create_candidates(dicts, a, b)
      dicts.flat_map do |dict|
        dict.select { |x, y, _| x == a && y == b }
      end
    end
  end
end
dicts = ARGV.map { |e| read_dict(e) }
words = LyricsFactory.create(*dicts)
puts words.join(" ")
