require 'nokogiri'
class BaseRenderer < Nokogiri::XML::SAX::Document

  PLACEHOLDER_REGEX = /\{(?<action>[\w_]*)\}/
  
  def self.root
    Rails.root
  end
  
  def self.template template
    if template
      path_to_template File.expand_path( template, root )
    end
  end
  
  def self.path_to_template path_to_template = nil
    if path_to_template
      @_path_to_template = path_to_template
    end
    @_path_to_template
  end
  
  def render
    reset
    render_template
    after_render_template
    document.to_s
  end

  private
  
  def reset
    @output   = nil
    @document = nil
  end
  
  def template_output
    @template_output ||= StringIO.new
  end
  
  def document
    @document ||= Nokogiri::HTML( template_output.string )
  end
  
  def render_template
    parser  = Nokogiri::XML::SAX::Parser.new self
    parser.parse File.open(path_to_template)
  end
  
  # allows subclassed renderers to do any other processing
  # after the initial template parsing is done.
  def after_render_template
  end
  
  def path_to_template
    self.class.path_to_template
  end
    
  def has_placeholder? string
    string.match PLACEHOLDER_REGEX
  end
  
  #
  # SAX Parser Methods
  #
  def start_element name, attrs = []
    start_tag name, attrs
  end
  
  def end_element name
    end_tag name
  end
  
  def characters string
    if has_placeholder? string
      add_content_for_placeholder string
    else
      add_content string
    end
  end
  
  #
  # Update Output Methods
  #
  def start_tag name, attrs = []
    template_output.write "<#{name.downcase}"
    unless attrs.empty?
      attributes = attrs.collect do |name,value|
        "#{name}=\"#{value}\""
      end.join(" ")
      template_output.write " #{attributes}"
    end
    template_output.write ">"
  end
  
  def end_tag name
    template_output.write "</#{name.downcase}>"
  end
  
  def add_content string
    template_output.write string
  end
  
  def add_content_for_placeholder string
    placeholder = string.match PLACEHOLDER_REGEX
    action      = placeholder[:action]
    if action && respond_to?( action )     
      add_content send(action)
    else
      add_content string
    end
  end
  
end