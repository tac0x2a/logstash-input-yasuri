# encoding: utf-8
require "logstash/inputs/base"
require "logstash/namespace"
require "socket" # for Socket.gethostname
require "mechanize"
require "yasuri"

class LogStash::Inputs::Yasuri < LogStash::Inputs::Base
  config_name "yasuri"

  default :codec, "plain"

  # Parse tree as JSON.
  # Read https://github.com/tac0x2a/yasuri/blob/master/USAGE.md#construct-parse-tree
  config :parse_tree, :validate => :string

  # Target web page url.
  config :url, :validate => :string

  # Split each results to individual events (struct or pages)
  config :split, :default => false

  config :interval, :validate => :number, :default => 60

  public
  def register
    @host = Socket.gethostname
    @agent = Mechanize.new
    @tree  = Yasuri.json2tree(@parse_tree)
  end # def register

  def run(queue)
    # we can abort the loop if stop? becomes true
    while !stop?
      # because the sleep interval can be big, when shutdown happens
      # we want to be able to abort the sleep
      # Stud.stoppable_sleep will frequently evaluate the given block
      # and abort the sleep(@interval) if the return value is true
      inner_run(queue)
      Stud.stoppable_sleep(@interval) { stop? }
    end # loop
  end # def run

  def stop
    # nothing to do in this case so it is not necessary to define stop
    # examples of common "stop" tasks:
    #  * close sockets (unblocking blocking reads/accepts)
    #  * cleanup temporary files
    #  * terminate spawned threads
  end

  def inner_run(queue)
    parsed = scrape()
    elements =  if @split
                  parsed.flatten
                else
                  [parsed]
                end

    elements.each do |e|
      event = LogStash::Event.new("parsed" => e, "host" => @host, "url" => @url)
      decorate(event)
      queue << event
    end
  end

  def scrape()
    page = @agent.get(@url)
    @tree.inject(@agent, page)
  end
end # class LogStash::Inputs::Example
