module Jekyll
  # 自动从文件内容提取元信息的插件
  class AutoMetaGenerator < Generator
    safe true
    priority :high

    def generate(site)
      site.posts.docs.each do |post|
        filename = File.basename(post.path, '.md')
        content = post.content
        
        Jekyll.logger.info "Auto Meta:", "正在处理 #{filename}"
        Jekyll.logger.info "Auto Meta:", "原始标题: #{post.data['title'] || 'nil'}"
        
        # 基础设置
        post.data['layout'] = 'post'
        post.data['categories'] = ['ai-briefing']
        
        # 从文件名提取日期
        if filename.match(/^(\d{4}-\d{2}-\d{2})/)
          post.data['date'] = Time.parse($1)
          Jekyll.logger.info "Auto Meta:", "设置日期: #{post.data['date']}"
        end
        
        # 从内容第一行提取标题
        title_match = content.match(/^#\s+(.+?)(?:\n|$)/)
        if title_match
          extracted_title = title_match[1].strip
          post.data['title'] = extracted_title
          Jekyll.logger.info "Auto Meta:", "提取标题: #{extracted_title}"
        else
          post.data['title'] = "AI 简报"
          Jekyll.logger.info "Auto Meta:", "使用默认标题"
        end        # 智能提取标签
        tags = ['简报']
        tags << 'LLM' if content.include?('LLM') || content.include?('大语言模型')
        tags << 'AI-Agent' if content.include?('Agent') || content.include?('代理')
        tags << 'Hacker-News' if content.include?('Hacker News')
        tags << 'Reddit' if content.include?('Reddit')
        tags << 'OpenAI' if content.include?('OpenAI')
        tags << 'Anthropic' if content.include?('Claude') || content.include?('Anthropic')
        
        post.data['tags'] = tags.uniq
        Jekyll.logger.info "Auto Meta:", "设置标签: #{tags}"
        
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
        
        post.data['excerpt'] = excerpt_text
        Jekyll.logger.info "Auto Meta:", "生成摘要: #{excerpt_text[0..50]}..."
        
        Jekyll.logger.info "Auto Meta:", "完成处理 #{filename}"
      end
    end
  end
end
