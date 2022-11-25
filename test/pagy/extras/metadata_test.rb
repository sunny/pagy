# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/shared'       # include :sequels in VARS[:metadata]
require 'pagy/extras/countless'
require 'pagy/extras/metadata'
require_relative '../../mock_helpers/controller'
require_relative '../../mock_helpers/collection'


describe 'pagy/extras/metadata' do

  describe '#pagy_metadata' do
    before do
      @controller = MockController.new
      @collection = MockCollection.new
    end
    it 'defines all metadata' do
      _(Pagy::VARS[:metadata]).must_rematch
    end
    it 'returns the full pagy metadata' do
      pagy, _records = @controller.send(:pagy, @collection)
      _(@controller.send(:pagy_metadata, pagy)).must_rematch
    end
    it 'checks for unknown metadata' do
      pagy, _records = @controller.send(:pagy, @collection, metadata: %i[page unknown_key])
      _(proc { @controller.send(:pagy_metadata, pagy)}).must_raise Pagy::VariableError
    end
    it 'returns only specific metadata' do
      pagy, _records = @controller.send(:pagy, @collection, metadata: %i[scaffold_url page count prev next pages])
      _(@controller.send(:pagy_metadata, pagy)).must_rematch
    end
  end

end

__END__
-{:scaffold_url=>"/foo?page=__pagy_page__", :first_url=>"/foo?page=1", :prev_url=>"/foo?page=2", :page_url=>"/foo?page=3", :next_url=>"/foo?page=4", :last_url=>"/foo?page=50", :count=>1000, :page=>3, :items=>20, :vars=>{:page=>3, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :fragment=>"", :link_extra=>"", :i18n_key=>"pagy.item_name", :cycle=>false, :steps=>false, :metadata=>[:scaffold_url, :first_url, :prev_url, :page_url, :next_url, :last_url, :count, :page, :items, :vars, :pages, :last, :in, :from, :to, :prev, :next, :series, :sequels], :count=>1000}, :pages=>50, :last=>50, :in=>20, :from=>41, :to=>60, :prev=>2, :next=>4, :series=>[1, 2, "3", 4, 5, 6, 7, :gap, 50], :sequels=>{"0"=>[1, 2, "3", 4, 5, 6, 7, :gap, 50]}}
+{:scaffold_url=>"/foo?page=__pagy_page__", :first_url=>"/foo?page=1", :prev_url=>"/foo?page=2", :page_url=>"/foo?page=3", :next_url=>"/foo?page=4", :last_url=>"/foo?page=50", :count=>1000, :page=>3, :items=>20, :vars=>{:page=>3, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :fragment=>"", :link_extra=>"", :i18n_key=>"pagy.item_name", :cycle=>false, :steps=>false, :metadata=>[:scaffold_url, :first_url, :prev_url, :page_url, :next_url, :last_url, :count, :page, :items, :vars, :pages, :last, :in, :from, :to, :prev, :next, :series, :sequels], :count=>1000}, :pages=>50, :last=>50, :in=>20, :from=>41, :to=>60, :prev=>2, :next=>4, :series=>[1, 2, "3", 4, 5, 6, 7, :gap, 50], :sequels=>{"0"=>[1, 2, "3", 4, 5, 6, 7, :gap, 50]}}
