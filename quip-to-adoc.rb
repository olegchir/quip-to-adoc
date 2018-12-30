#!/usr/bin/env ruby

require 'rationalist'
require 'httparty'
require 'kramdown'
require 'json'
require 'kramdown-asciidoc'
require 'asciidoctor'
require 'reverse_markdown'

$★ = Rationalist.parse(ARGV)
token = $★[:token]
thread_id = $★[:id]
output_file = $★[:adoc]
output_html_file = $★[:html]
output_md_file = $★[:md]
output_quip_file = $★[:quip]

http_debug = $★[:http_debug]
http_debug ||= false

class QuipThread
  include HTTParty

  base_uri 'https://platform.quip.com'

  def initialize(token, thread_id, http_debug)
    if http_debug.to_s.downcase == "true"
      self.class.debug_output $stdout
    end

    @token = token
    @thread_id = thread_id
    @auth = "Bearer " + @token
    @options = { query: { ids: @thread_id }, :headers => { "Authorization" => @auth} }
  end

  def data
    self.class.get("/1/threads/", @options)
  end

  def body
    JSON.parse(self.data.body)[@thread_id]
  end

  def html
    self.body['html']
  end
end

class Array
  def purge
    self.reject{|i| i.nil? || i.empty? }
  end
end

def string_to_file(src, dest)
  if src.nil?
    nil
  else
    File.delete(dest) if File.exist?(dest)
    File.open(dest, "w") do |f|
      f.write(src)
    end
    dest
  end
end

def save_string_to_file_hash(hash)
   hash.select { |filename, content|  string_to_file(content, filename) }
       .collect{|filename, content| "#{filename}"}.join(", ")
end

html = QuipThread.new(token, thread_id, http_debug).html
markdown = ReverseMarkdown.convert(html, unknown_tags: :pass_through, github_flavored: true)
asciidoc = Kramdoc.convert markdown
html_for_validation = Asciidoctor.convert asciidoc, header_footer: true, safe: :safe

# We can convert from HTML to Markdown natively with Kramdown,
# but sorry to say, Kramdown really suck in reversing HTML, and it's very important
# when it comes to multi-level lists, that we use in Quip
# kdoc = Kramdown::Document.new(html, :html_to_native => true)
# markdown = kdoc.to_kramdown

if output_file.nil?
  print asciidoc
end

files = {
    output_file => asciidoc,
    output_html_file => html_for_validation,
    output_md_file => markdown,
    output_quip_file => html
}

saved = save_string_to_file_hash(files)
unless output_file.nil?
  print saved
end
