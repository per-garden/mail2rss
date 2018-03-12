xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Mail2Rss"
    xml.description ""
    xml.link root_url

    xml.item do
      xml.title @message.subject
      xml.author @message.from
      xml.pubDate @message.updated_at.to_s(:rfc822)
      xml.description @message.body
    end
  end
end
