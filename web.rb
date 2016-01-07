require 'bundler'
require 'sinatra'
require 'mechanize'
require 'erb'
require 'rss'
require 'time'

TIMEZONE_ABBR_TO_OFFSET = {
  ACDT: '+10:30',
  ACST: '+09:30',
  ACT: '−05:00',
  ACT: '+08:00',
  ADT: '−03:00',
  AEDT: '+11:00',
  AEST: '+10:00',
  AFT: '+04:30',
  AKDT: '−08:00',
  AKST: '−09:00',
  AMST: '−03:00',
  AMT: '−04:00',
  AMT: '+04:00',
  ART: '−03:00',
  AST: '+03:00',
  AST: '−04:00',
  AWDT: '+09:00',
  AWST: '+08:00',
  AZOST: '−01:00',
  AZT: '+04:00',
  BDT: '+08:00',
  BDT: '+06:00',
  BIOT: '+06:00',
  BIT: '−12:00',
  BOT: '−04:00',
  BRST: '−02:00',
  BRT: '−03:00',
  BST: '+06:00',
  BST: '+11:00',
  BST: '+01:00',
  BTT: '+06:00',
  CAT: '+02:00',
  CCT: '+06:30',
  CDT: '−05:00',
  CDT: '−04:00',
  CEDT: '+02:00',
  CEST: '+02:00',
  CET: '+01:00',
  CHADT: '+13:45',
  CHAST: '+12:45',
  CHOT: '+08:00',
  ChST: '+10:00',
  CHUT: '+10:00',
  CIST: '−08:00',
  CIT: '+08:00',
  CKT: '−10:00',
  CLST: '−03:00',
  CLT: '−04:00',
  COST: '−04:00',
  COT: '−05:00',
  CST: '−06:00',
  CST: '+08:00',
  CST: '+09:30',
  CST: '+10:30',
  CST: '−05:00',
  CT: '+08:00',
  CVT: '−01:00',
  CWST: '+08:45',
  CXT: '+07:00',
  DAVT: '+07:00',
  DDUT: '+10:00',
  DFT: '+01:00',
  EASST: '−05:00',
  EAST: '−06:00',
  EAT: '+03:00',
  ECT: '−04:00',
  ECT: '−05:00',
  EDT: '−04:00',
  EEDT: '+03:00',
  EEST: '+03:00',
  EET: '+02:00',
  EGST: '+00:00',
  EGT: '−01:00',
  EIT: '+09:00',
  EST: '−05:00',
  EST: '+10:00',
  FET: '+03:00',
  FJT: '+12:00',
  FKST: '−03:00',
  FKST: '−03:00',
  FKT: '−04:00',
  FNT: '−02:00',
  GALT: '−06:00',
  GAMT: '−09:00',
  GET: '+04:00',
  GFT: '−03:00',
  GILT: '+12:00',
  GIT: '−09:00',
  GMT: nil,
  GST: '−02:00',
  GST: '+04:00',
  GYT: '−04:00',
  HADT: '−09:00',
  HAEC: '+02:00',
  HAST: '−10:00',
  HKT: '+08:00',
  HMT: '+05:00',
  HOVT: '+07:00',
  HST: '−10:00',
  IBST: nil,
  ICT: '+07:00',
  IDT: '+03:00',
  IOT: '+03:00',
  IRDT: '+04:30',
  IRKT: '+08:00',
  IRST: '+03:30',
  IST: '+05:30',
  IST: '+01:00',
  IST: '+02:00',
  JST: '+09:00',
  KGT: '+06:00',
  KOST: '+11:00',
  KRAT: '+07:00',
  KST: '+09:00',
  LHST: '+10:30',
  LHST: '+11:00',
  LINT: '+14:00',
  MAGT: '+12:00',
  MART: '−09:30',
  MAWT: '+05:00',
  MDT: '−06:00',
  MET: '+01:00',
  MEST: '+02:00',
  MHT: '+12:00',
  MIST: '+11:00',
  MIT: '−09:30',
  MMT: '+06:30',
  MSK: '+03:00',
  MST: '+08:00',
  MST: '−07:00',
  MST: '+06:30',
  MUT: '+04:00',
  MVT: '+05:00',
  MYT: '+08:00',
  NCT: '+11:00',
  NDT: '−02:30',
  NFT: '+11:00',
  NPT: '+05:45',
  NST: '−03:30',
  NT: '−03:30',
  NUT: '−11:00',
  NZDT: '+13:00',
  NZST: '+12:00',
  OMST: '+06:00',
  ORAT: '+05:00',
  PDT: '−07:00',
  PET: '−05:00',
  PETT: '+12:00',
  PGT: '+10:00',
  PHOT: '+13:00',
  PKT: '+05:00',
  PMDT: '−02:00',
  PMST: '−03:00',
  PONT: '+11:00',
  PST: '−08:00',
  PST: '+08:00',
  PYST: '−03:00',
  PYT: '−04:00',
  RET: '+04:00',
  ROTT: '−03:00',
  SAKT: '+11:00',
  SAMT: '+04:00',
  SAST: '+02:00',
  SBT: '+11:00',
  SCT: '+04:00',
  SGT: '+08:00',
  SLST: '+05:30',
  SRET: '+11:00',
  SRT: '−03:00',
  SST: '−11:00',
  SST: '+08:00',
  SYOT: '+03:00',
  TAHT: '−10:00',
  THA: '+07:00',
  TFT: '+05:00',
  TJT: '+05:00',
  TKT: '+13:00',
  TLT: '+09:00',
  TMT: '+05:00',
  TOT: '+13:00',
  TVT: '+12:00',
  UCT: nil,
  ULAT: '+08:00',
  USZ1: '+02:00',
  UTC: nil,
  UYST: '−02:00',
  UYT: '−03:00',
  UZT: '+05:00',
  VET: '−04:30',
  VLAT: '+10:00',
  VOLT: '+04:00',
  VOST: '+06:00',
  VUT: '+11:00',
  WAKT: '+12:00',
  WAST: '+02:00',
  WAT: '+01:00',
  WEDT: '+01:00',
  WEST: '+01:00',
  WET: nil,
  WIT: '+07:00',
  WST: '+08:00',
  YAKT: '+09:00',
  YEKT: '+05:00',
  Z: nil
}

get '/' do
  url = 'http://fuchino.ddo.jp/obanoyama.html'
  agent = Mechanize.new
  if agent.get(url).code == '200'
    rss = RSS::Maker.make("2.0") do |maker|
      maker.channel.author = '渕野 昌 (Sakaé Fuchino)'
      maker.channel.link = 'http://www.evernew.co.jp/outdoor/yamanoi/'
      maker.channel.about = 'http://yamanoi-signal.heroku.com/'
      maker.channel.title = '伯母野山日記 Obanoyama-Tagebuch'
      maker.channel.description = <<EOF
※ この page の内容（html file のコードを含む）の 
GNU Free Documentation License
に準拠した引用／利用は歓迎しますが，
盗作／データ改竄やそれに類する行為には天罰が下ります． 絶対にやめてください．
ただし，ここで書いたことの一部は，
後で，本や雑誌記事などとして発表する作文の素材として再利用する可能性もあります．
その際，再利用されたテキストに関しては，
諸事情から GNU Free Documentation License に準拠した扱いができなくなることもありますので，
その場合にはご諒承ください．
EOF
      agent.page.parser.xpath('//a[@name]').each do |start_of_entry|
        next if start_of_entry.attributes['name'].to_s == 'first'
        header = start_of_entry.next_sibling
        created_on = nil
        updated_on = nil
        related_entries = []
        title = start_of_entry.text
        link = start_of_entry.attributes['name'].to_s
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
                related_entries << { anchor: related.attributes['href'].to_s[1..-1], title: related.text }
              end
              related = related.next_sibling
            end
          end
        end while header = header.next_sibling
        if link.match(/(\d{2})\.(\d{2})\.(\d{2})\(.+(\d{2}):(\d{2})\(([A-Z]{3,4})\)\)/)
          year, month, day, hour, minute, offset = [2000 + $1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, TIMEZONE_ABBR_TO_OFFSET[$6]]
        elsif link.match(/(\d{2})\.(\d{2})\.(\d{2})\(.+(\d{2}):(\d{2})\(UTC([+-])(\d+)\)\)/)
          year, month, day, hour, minute, offset = [2000 + $1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, "#{$6}0#{$7}:00"]
        elsif link.match(/(\d{2})\.(\d{2})\.(\d{2})-(\d{2}):(\d{2})/)
          year, month, day, hour, minute, offset = [2000 + $1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, "+09:00"]
        else
          next
        end
        item = maker.items.new_item
        item.title = title
        item.link = "http://fuchino.ddo.jp/obanoyama.html##{ERB::Util.url_encode(link)}"
        item.date = Time.new(year, month, day, hour, minute, 0, offset)
      end
      maker.items.do_sort = true
    end
    rss.to_s
  else
    '?'
  end
end

