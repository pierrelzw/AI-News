require 'time'

module Jekyll
  # 自动从文件内容提取元信息的插件
  class AutoMetaGenerator < Generator
    safe true
    priority :high

    def generate(site)
      site.posts.docs.each do |post|
        filename = File.basename(post.path, '.md')
        content = post.content
        
        if ENV['JEKYLL_ENV'] != 'production'
          Jekyll.logger.info "Auto Meta:", "正在处理 #{filename}"
          Jekyll.logger.info "Auto Meta:", "原始标题: #{post.data['title'] || 'nil'}"
        end
        
        # 基础设置（仅在缺失时设置）
        post.data['layout'] ||= 'post'
        post.data['categories'] ||= ['ai-briefing']
        
        # 从文件名提取日期
        if filename.match(/^(\d{4}-\d{2}-\d{2})/)
          post.data['date'] ||= Time.parse($1)
          Jekyll.logger.info "Auto Meta:", "设置日期: #{post.data['date']}" if ENV['JEKYLL_ENV'] != 'production'
        end
        
        # 从内容第一行提取标题
        title_match = content.match(/^#\s+(.+?)(?:\n|$)/)
        if title_match && (post.data['title'].nil? || post.data['title'].to_s.strip.empty?)
          extracted_title = title_match[1].strip
          post.data['title'] = extracted_title
          Jekyll.logger.info "Auto Meta:", "提取标题: #{extracted_title}" if ENV['JEKYLL_ENV'] != 'production'
        end

        # 规范化标题：若缺失或为占位（如 “ai-briefing”），设为“YYYY-MM-DD-AI 简报”
        current_title = (post.data['title'] || '').to_s.strip
        placeholder = current_title.downcase
        if current_title.empty? || placeholder == 'ai-briefing'
          date_for_title = post.data['date'].is_a?(Time) ? post.data['date'] : Time.parse(filename[/^(\d{4}-\d{2}-\d{2})/, 1] || Time.now.strftime('%Y-%m-%d'))
          post.data['title'] = date_for_title.strftime('%Y-%m-%d') + '-AI 简报'
          Jekyll.logger.info "Auto Meta:", "规范标题: #{post.data['title']}" if ENV['JEKYLL_ENV'] != 'production'
        end

        # 智能提取标签（大小写不敏感，仅补充不覆盖）
        tags = (post.data['tags'] || []).dup
        normalized = content.downcase
        tags << '简报'
        tags << 'LLM' if normalized.include?('llm') || normalized.include?('大语言模型')
        tags << 'AI-Agent' if normalized.include?('agent') || normalized.include?('代理')
        tags << 'Hacker-News' if normalized.include?('hacker news')
        tags << 'Reddit' if normalized.include?('reddit')
        tags << 'OpenAI' if normalized.include?('openai')
        tags << 'Anthropic' if normalized.include?('claude') || normalized.include?('anthropic')
        
        post.data['tags'] = tags.uniq
        Jekyll.logger.info "Auto Meta:", "设置标签: #{tags}" if ENV['JEKYLL_ENV'] != 'production'
        
        # 智能生成摘要
        # 提取主要内容段落，跳过标题和链接
        clean_content = content
          .gsub(/^#+\s+.+$/m, '')  # 移除标题
          .gsub(/\[.+?\]\(.+?\)/, '')  # 移除链接
          .gsub(/\*\*(.+?)\*\*/, '\1')  # 移除粗体标记
          .gsub(/^\s*-\s+/, '')  # 移除列表标记
          .strip
        
        # 取前150字符作为摘要
        excerpt_text = clean_content[0..150]
        if clean_content.length > 150
          excerpt_text = excerpt_text.gsub(/\s\S*$/, '') + '...'
        end
        
        post.data['excerpt'] ||= excerpt_text
        Jekyll.logger.info "Auto Meta:", "生成摘要: #{excerpt_text[0..50]}..." if ENV['JEKYLL_ENV'] != 'production'
        
        Jekyll.logger.info "Auto Meta:", "完成处理 #{filename}" if ENV['JEKYLL_ENV'] != 'production'
      end
    end
  end
end
