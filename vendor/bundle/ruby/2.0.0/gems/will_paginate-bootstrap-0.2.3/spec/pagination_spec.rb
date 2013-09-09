require 'minitest/autorun'
require 'nokogiri'
require 'will_paginate/array'
require 'will_paginate/view_helpers/link_renderer'
require 'bootstrap_pagination/bootstrap_renderer'

include WillPaginate::ViewHelpers

# Renderer class that's not tied to any web framework.
class MockRenderer < WillPaginate::ViewHelpers::LinkRenderer
  include BootstrapPagination::BootstrapRenderer

  HASH = '#'

  def url(args)
    HASH
  end
end

describe "Bootstrap Renderer" do
  # Render pagination for the middle page so that we can test for the presence of
  # start, prev and next links. We should also be able to test for test for the
  # presence of a "gap" item if the collection size is large enough.
  let(:collection_size) { 15 }
  let(:page) { (collection_size / 2.0).to_i }
  let(:collection) { 1.upto(collection_size).to_a }

  let(:output) do
    will_paginate(
      collection.paginate(:page => page, :per_page => 1),
      :renderer => MockRenderer
    )
  end

  let(:html) { Nokogiri::HTML.fragment(output) }

  it "returns a string" do
    output.must_be_kind_of String
  end

  it "returns a string containing HTML" do
    html.must_be_kind_of Nokogiri::HTML::DocumentFragment
  end

  it "has an outer pagination div" do
    html.at_css('div.pagination').wont_be_nil
  end

  it "has an unordered list within the pagination div" do
    html.at_css('div.pagination ul').wont_be_nil
  end

  it "has an active list item" do
    html.at_css('ul li.active').wont_be_nil
  end

  it "has a gap item with class disabled" do
    html.at_css('ul li.disabled').wont_be_nil
  end

  it "has one item with rel start value" do
    html.css('[rel~=start]').size.must_equal 1
  end

  it "has two items with rel prev value" do
    html.css('[rel~=prev]').size.must_equal 2
  end

  it "has two items with rel next value" do
    html.css('[rel~=next]').size.must_equal 2
  end

  it "has an anchor within each non-active list item" do
    html.css('ul li:not(.active)').each { |li| li.at_css('a').wont_be_nil }
  end

  it "uses a span element for the active page" do
    html.at_css('ul li.active span').wont_be_nil
  end
end