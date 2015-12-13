module ApplicationHelper

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def signed_user_but_not_self?(user_id)

    result  = false
    if current_user &&  (current_user.id != user_id)
       result = true
    end
    result
  end

  def current_user?(user_id)
    result = false

    if current_user && current_user.id == user_id
      result = true
    end
    return result
  end

  def uncheck_notify_count
    result = ""
    if current_user
      notifys = Notification.uncheck_notify_by_user_id(current_user.id)
      if notifys.count > 0
        result ="<span class='badge'>#{notifys.count}</span>"
      end
    end
    result
  end

  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end

  def pm_count
    result = ""


    messages = Message.where(is_read: false , to_user_id: current_user.id ).count

    if messages > 0
      result ="<span class='badge'>#{messages}</span>".html_safe
    end
    result
  end

  def markdown(text)
    render_options = {
        # will remove from the output HTML tags inputted by user
        filter_html:     true,
        # will insert <br /> tags in paragraphs where are newlines
        # (ignored by default)
        hard_wrap:       true,
        # hash for extra link options, for example 'nofollow'
        link_attributes: { rel: 'nofollow' },
        # more
        # will remove <img> tags from output
        no_images: true,
        # will remove <a> tags from output
        # no_links: true
        # will remove <style> tags from output
         no_styles: true
        # generate links for only safe protocols
        # safe_links_only: true
        # and more ... (prettify, with_toc_data, xhtml)
    }
    renderer = Redcarpet::Render::HTML.new(render_options)

    extensions = {
        #will parse links without need of enclosing them
        autolink:           true,
        # blocks delimited with 3 ` or ~ will be considered as code block.
        # No need to indent.  You can provide language name too.
        # ```ruby
        # block of code
        # ```
        fenced_code_blocks: true,
        # will ignore standard require for empty lines surrounding HTML blocks
        lax_spacing:        true,
        # will not generate emphasis inside of words, for example no_emph_no
        no_intra_emphasis:  true,
        # will parse strikethrough from ~~, for example: ~~bad~~
        strikethrough:      true,
        # will parse superscript after ^, you can wrap superscript in ()
        superscript:        true
        # will require a space after # in defining headers
        # space_after_headers: true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end

end
