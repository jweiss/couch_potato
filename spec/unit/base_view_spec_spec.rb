require 'spec_helper'

describe CouchPotato::View::BaseViewSpec, 'initialize' do
  describe "view parameters" do
    before(:each) do
      CouchPotato::Config.split_design_documents_per_view = false
    end

    it "should raise an error when passing invalid view parameters" do
      lambda {
        CouchPotato::View::BaseViewSpec.new Object, 'all', {}, {:start_key => '1'}
      }.should raise_error(ArgumentError, "invalid view parameter: start_key")
    end

    it "should not raise an error when passing valid view parameters" do
      lambda {
        CouchPotato::View::BaseViewSpec.new Object, 'all', {}, {
          :key => 'keyvalue',
          :startkey => 'keyvalue',
          :startkey_docid => 'docid',
          :endkey => 'keyvalue',
          :endkey_docid => 'docid',
          :limit => 3,
          :stale => 'ok',
          :descending => true,
          :skip => 1,
          :group => true,
          :group_level => 1,
          :reduce => false,
          :include_docs => true,
          :inclusive_end => true
        }
      }.should_not raise_error
    end

    it "should convert a range passed as key into startkey and endkey" do
      spec = CouchPotato::View::BaseViewSpec.new Object, 'all', {}, {:key => '1'..'2'}
      spec.view_parameters.should == {:startkey => '1', :endkey => '2'}
    end

    it "should convert a plain value to a hash with a key" do
      spec = CouchPotato::View::BaseViewSpec.new Object, 'all', {}, '2'
      spec.view_parameters.should == {:key => '2'}
    end

    it "generates the design document path by snake_casing the class name but keeping double colons" do
      spec = CouchPotato::View::BaseViewSpec.new 'Foo::BarBaz', '', {}, ''
      spec.design_document.should == 'foo::bar_baz'
    end

    it "should generate the design document independent of the view name by default" do
      CouchPotato::Config.split_design_documents_per_view = false
      spec = CouchPotato::View::BaseViewSpec.new 'User', 'by_login_and_email', {}, ''
      spec.design_document.should == 'user'
    end

    it "should generate the design document per view if configured to" do
      CouchPotato::Config.split_design_documents_per_view = true
      spec = CouchPotato::View::BaseViewSpec.new 'User', 'by_login_and_email', {}, ''
      spec.design_document.should == 'user_view_by_login_and_email'
    end

  end

end


