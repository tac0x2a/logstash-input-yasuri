# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/inputs/yasuri"

describe LogStash::Inputs::Yasuri do

  let(:input) {
    input = LogStash::Plugin.lookup("input", "yasuri").new(
      "split" => true,
      "url" => "https://news.ycombinator.com/",
      "parse_tree" => %Q|
        {
          "node": "struct",
          "name": "titles",
          "path": "//td[@class='title'][not(@align)]",
          "children": [
            {
              "node": "text",
              "name": "title",
              "path": "./a"
            },
            {
              "node": "text",
              "name": "url",
              "path": "./a/@href"
            }
          ]
        }
      | # end of "parse_tree"
    )
  }

  let(:input_from_parse_tree_file) {
    input_from_parse_tree_file = LogStash::Plugin.lookup("input", "yasuri").new(
      "split" => true,
      "url" => "https://news.ycombinator.com/",
      "parse_tree_path" => "spec/inputs/res/parse_tree.json"
    )
  }

  it "should register" do
    # register will try to load jars and raise if it cannot find jars or if org.apache.log4j.spi.LoggingEvent class is not present
    expect {input.register}.to_not raise_error
  end

  let(:queue) { [] }
  it "enqueues some events" do
    input.register
    input.inner_run(queue)
    expect(queue.size).not_to be_zero
  end

  it "enqueues some events from input_from_parse_tree_file" do
    input_from_parse_tree_file.register
    input_from_parse_tree_file.inner_run(queue)
    expect(queue.size).not_to be_zero
  end
end
