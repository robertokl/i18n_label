require File.dirname(__FILE__) + '/spec_helper'

# give a model to play with
class Reply < ActiveRecord::Base
  attr_accessor :title
end

class FieldTester
  include ActionView::Helpers::FormHelper
  
  def fields_for_test(model, &block)
    fields_for(model, &block)
  end
end

describe ActionView::Helpers do

  it "label should make a call to human_attribute_name" do
    I18n.should_receive(:t).with("activerecord.labels.title").and_return("translation missing: en, activerecord, labels, title")
    Reply.should_receive(:human_attribute_name).with('title', {}).and_return("translated title")
    reply = mock_model(Reply)
    FieldTester.new.fields_for_test(reply) do |f|
      f.label(:title).should == "<label for=\"reply_title\">translated title</label>"
    end
  end
  
  it "should use the more generic if specific not defined" do
    I18n.should_receive(:t).with("activerecord.labels.title").and_return("generic translated title")
    Reply.should_receive(:human_attribute_name).with('title', {:default => "generic translated title"}).and_return("generic translated title")
    reply = mock_model(Reply)
    FieldTester.new.fields_for_test(reply) do |f|
      f.label(:title).should == "<label for=\"reply_title\">generic translated title</label>"
    end
  end
end
