require 'bundler'
#require 'sinatra'
require 'mechanize'
require 'rss'
require 'time'

#get '/' do
  url = 'http://fuchino.ddo.jp/obanoyama.html'
  agent = Mechanize.new
  if agent.get(url).code == '200'
    rss = RSS::Maker.make("2.0") do |maker|
      maker.channel.author = '渕野 昌 (Sakaé Fuchino)'
      maker.channel.link = 'http://www.evernew.co.jp/outdoor/yamanoi/'
      maker.channel.about = 'http://yamanoi-signal.heroku.com/'
      maker.channel.title = '伯母野山日記 Obanoyama-Tagebuch'
      maker.channel.description = '※ この page の内容（html file のコードを含む）の GNU Free Documentation License に準拠した引用／利用は歓迎しますが， 盗作／データ改竄やそれに類する行為には 天罰が下ります． 絶対にやめてください． ただし，ここで書いたことの一部は， 後で，本や雑誌記事などとして発表する作文の素材として再利用する可能性もあります． その際，再利用されたテキストに関しては， 諸事情から GNU Free Documentation License に準拠した扱いができなくなることもありますので， その場合にはご諒承ください．'
      agent.page.parser.xpath('//a[@name]').each do |start_of_entry|
        next if start_of_entry.attributes['name'].to_s == 'first'
        item = maker.items.new_item
        header = start_of_entry.next_sibling
        created_on = nil
        updated_on = nil
        related_entries = []
        puts start_of_entry.text
        begin
          next if header.name == 'br'
          break if header.name == 'hr'
          key, value = header.text.to_s.split(':', 2).map { |i| i.gsub(/^\n*(.+)\n*$/m, '\1') }
          case key
          when 'created on'
            created_on = value
          when 'updated on'
            updated_on = value
          when /関連する.*（かもしれない）.*他のエントリー/
            related = header.next_sibling
            until related.name == 'hr'
              if related.name == 'a'
                puts related
              end
              related = related.next_sibling
            end
          end
        end while header = header.next_sibling
=begin
        title_link = entry.at('div.title h2 a')
        item.title = title_link.text
        item.link = title_link.attributes['href']
        item.date = Time.parse(entry.at('div.title span.byline abbr').attributes['title'])
        item.description = entry.at('div.title').next_sibling.text.to_s.gsub(/^\n*(.+)\n*$/m, '\1')
=end
      end
      maker.items.do_sort = true
    end
    rss.to_s
  else
    '?'
  end
#end

