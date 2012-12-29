namespace :backfill  do
  desc 'normalize all link_record urls'
  task :normalize_urls => :environment do
    LinkRecord.all.each do |link|
      link.update_attributes(:url => Link.normalize(link.url))
    end
  end

  desc "save link_record.author_id based on first codemark.user"
  task :author_id => :environment do
    target_link_records = LinkRecord.find(:all, :conditions => {:author_id => nil})
    codemarks = CodemarkRecord.find(:all, :conditions => {:link_record_id => [target_link_records.collect(&:id)]})

    firsts = {}
    codemarks.each do |codemark|
      lr_id = codemark.link_record_id
      first = firsts[lr_id]
      if first && first.created_at < codemark.created_at
        firsts[lr_id] = first
      else
        firsts[lr_id] = codemark
      end
    end

    p firsts.keys.count
    p codemarks.count

    authors = {}
    firsts.each do |link_record_id, first_codemark|
      authors[link_record_id] = first_codemark.user
      LinkRecord.find(link_record_id).update_attributes(:author => first_codemark.user)
    end

    p authors

  end
end

