%w(rubygems sequel fileutils yaml active_support/inflector).each{|g| require g}

require File.join(File.dirname(__FILE__), "downmark_it")

module WordPress
  def self.import(database, user, password, table_prefix = "wp", host = 'localhost')
    db = Sequel.mysql(database, :user => user, :password => password, :host => host, :encoding => 'latin1')

    %w(source/_posts images/posts/featured).each{|folder| FileUtils.mkdir_p folder}

    query = <<-EOS

      SELECT 	post_title, post_name, post_date, post_content, post_excerpt, ID, guid, post_status, post_type, post_status, 
      		 (	SELECT 	guid 
      			FROM 	#{table_prefix}_posts
      			WHERE 	ID = (	SELECT 	meta_value 
      							FROM	#{table_prefix}_postmeta
      							WHERE 	post_id = post.ID AND meta_key = "_thumbnail_id") ) AS post_image

      FROM #{table_prefix}_posts AS post
      WHERE  post_type = 'post' AND post_status='publish'

    EOS
    
    categories_and_tags_query = <<-EOS

      SELECT 		  t.taxonomy, term.name, term.slug
      FROM 		    #{table_prefix}_term_relationships AS tr
      INNER JOIN	#{table_prefix}_term_taxonomy AS t ON t.term_taxonomy_id = tr.term_taxonomy_id
      INNER JOIN 	#{table_prefix}_terms AS term ON term.term_id = t.term_id
      WHERE		    tr.object_id = %d
      ORDER BY	  tr.term_order
    
    EOS


    tags_query = <<-EOS

      SELECT              t.tag
      FROM                  #{table_prefix}_tags AS t
      INNER JOIN        #{table_prefix}_post2tag AS pt ON t.tag_id = pt.tag_id
      WHERE                 pt.post_id = %d
      ORDER BY    t.tag

    EOS

    db[query].each do |post|
      puts post[:post_content]
      title      = post[:post_title]
      slug       = post[:post_name]
      date       = post[:post_date]
      content    = DownmarkIt.to_markdown post[:post_content]
      status     = post[:post_status]
      name       = "%02d-%02d-%02d-%s.markdown" % [date.year, date.month, date.day, slug]
      image      = File.basename(post[:post_image]) rescue ""
      categories = []
      post_tags  = []
      
      puts title
      
      #`wget -O "images/posts/featured/#{image}" "#{post[:post_image]}"` unless File::exists?("images/posts/featured/#{image}") || post[:post_image].nil?
      
      db[categories_and_tags_query % post[:ID]].each do |category_or_tag|
        eval(category_or_tag[:taxonomy].pluralize) <<  category_or_tag[:name].downcase.gsub(" ", "-")
      end

      db[tags_query % post[:ID]].each do |tag|
        post_tags << tag[:tag] 
      end


      data = {
         'layout'        => 'post',
         'title'         => title.to_s,
         'excerpt'       => post[:post_excerpt].to_s,
         'image'         => image,
         'wordpress_id'  => post[:ID],
         'wordpress_url' => post[:guid],
         'categories'    => categories,
         'tags'          => post_tags
       }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

      File.open("#{status == 'publish' ? 'source/_posts' : 'source/_drafts'}/#{name}", "w") do |f|
        f.puts data
        f.puts "---"
        f.puts content
      end
    end
  end
end