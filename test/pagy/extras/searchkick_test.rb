# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/searchkick'
require 'pagy/extras/overflow'

describe 'pagy/extras/searchkick' do

  describe 'model#pagy_search' do
    it 'extends the class with #pagy_search' do
      _(MockSearchkick::Model).must_respond_to :pagy_search
    end
    it 'returns class and arguments' do
      _(MockSearchkick::Model.pagy_search('a', b:2)).must_equal [MockSearchkick::Model, 'a', {b: 2}, nil]
      args  = MockSearchkick::Model.pagy_search('a', b:2) { |a| a*2 }
      block = args[-1]
      _(args).must_equal [MockSearchkick::Model, 'a', {b: 2}, block]
    end
    it 'allows the term argument to be optional' do
      _(MockSearchkick::Model.pagy_search(b:2)).must_equal [MockSearchkick::Model, '*', {b: 2}, nil]
      args  = MockSearchkick::Model.pagy_search(b:2) { |a| a*2 }
      block = args[-1]
      _(args).must_equal [MockSearchkick::Model, '*', {b: 2}, block]
    end
    it 'adds an empty option hash' do
      _(MockSearchkick::Model.pagy_search('a')).must_equal [MockSearchkick::Model, 'a', {}, nil]
      args  = MockSearchkick::Model.pagy_search('a') { |a| a*2 }
      block = args[-1]
      _(args).must_equal [MockSearchkick::Model, 'a', {}, block]
    end
    it 'adds the caller and arguments' do
      _(MockSearchkick::Model.pagy_search('a', b:2).results).must_equal [MockSearchkick::Model, 'a', {b: 2}, nil, :results]
      _(MockSearchkick::Model.pagy_search('a', b:2).a('b', 2)).must_equal [MockSearchkick::Model, 'a', {b: 2}, nil, :a, 'b', 2]
    end
  end

  describe 'controller_methods' do
    let(:controller) { MockController.new }

    describe '#pagy_searchkick' do
      before do
        @collection = MockCollection.new
      end
      it 'paginates response with defaults' do
        pagy, response = controller.send(:pagy_searchkick, MockSearchkick::Model.pagy_search('a'){'B-'})
        results = response.results
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal Pagy::VARS[:items]
        _(pagy.page).must_equal controller.params[:page]
        _(results.count).must_equal Pagy::VARS[:items]
        _(results).must_rematch
      end
      it 'paginates results with defaults' do
        pagy, results = controller.send(:pagy_searchkick, MockSearchkick::Model.pagy_search('a').results)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal Pagy::VARS[:items]
        _(pagy.page).must_equal controller.params[:page]
        _(results.count).must_equal Pagy::VARS[:items]
        _(results).must_rematch
      end
      it 'paginates with vars' do
        pagy, results = controller.send(:pagy_searchkick, MockSearchkick::Model.pagy_search('b').results, page: 2, items: 10, link_extra: 'X')
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 2
        _(pagy.vars[:link_extra]).must_equal 'X'
        _(results.count).must_equal 10
        _(results).must_rematch
      end
      it 'paginates with overflow' do
        pagy, results = controller.send(:pagy_searchkick, MockSearchkick::Model.pagy_search('b').results, page: 200, items: 10, link_extra: 'X', overflow: :last_page)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 100
        _(pagy.vars[:link_extra]).must_equal 'X'
        _(results.count).must_equal 10
        _(results).must_rematch
      end
    end

    describe '#pagy_searchkick_get_vars' do
      it 'gets defaults' do
        vars   = {}
        merged = controller.send :pagy_searchkick_get_vars, nil, vars
        _(merged.keys).must_include :page
        _(merged.keys).must_include :items
        _(merged[:page]).must_equal 3
        _(merged[:items]).must_equal 20
      end
      it 'gets vars' do
        vars   = {page: 2, items: 10, link_extra: 'X'}
        merged = controller.send :pagy_searchkick_get_vars, nil, vars
        _(merged.keys).must_include :page
        _(merged.keys).must_include :items
        _(merged.keys).must_include :link_extra
        _(merged[:page]).must_equal 2
        _(merged[:items]).must_equal 10
        _(merged[:link_extra]).must_equal 'X'
      end
    end

    describe 'Pagy.new_from_searchkick' do
      it 'paginates results with defaults' do
        results = MockSearchkick::Model.search('a')
        pagy    = Pagy.new_from_searchkick(results)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 1000
        _(pagy.page).must_equal 1
      end
      it 'paginates results with vars' do
        results = MockSearchkick::Model.search('b', page: 2, per_page: 15)
        pagy    = Pagy.new_from_searchkick(results, link_extra: 'X')
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 15
        _(pagy.page).must_equal 2
        _(pagy.vars[:link_extra]).must_equal 'X'
      end
    end
  end
end
