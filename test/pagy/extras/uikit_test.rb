# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/uikit'

require_relative '../../mock_helpers/view'

describe 'pagy/extras/uikit' do
  let(:view) { MockView.new }

  describe '#pagy_uikit_nav' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_uikit_nav(pagy)).must_rematch
      _(view.pagy_uikit_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_uikit_nav(pagy)).must_rematch
      _(view.pagy_uikit_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_uikit_nav(pagy)).must_rematch
      _(view.pagy_uikit_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
  end

  describe '#pagy_uikit_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_uikit_nav_js(pagy)).must_rematch
      _(view.pagy_uikit_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                     steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_uikit_nav_js(pagy)).must_rematch
      _(view.pagy_uikit_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                     steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_uikit_nav_js(pagy)).must_rematch
      _(view.pagy_uikit_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                     steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => [1, 2, 2, 1], 500 => [2, 3, 3, 2] })
      _(view.pagy_uikit_nav_js(pagy)).must_rematch
      _(view.pagy_uikit_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                     steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
  end

  describe '#pagy_uikit_combo_nav' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_uikit_combo_nav_js(pagy)).must_rematch
      _(view.pagy_uikit_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_uikit_combo_nav_js(pagy)).must_rematch
      _(view.pagy_uikit_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_uikit_combo_nav_js(pagy)).must_rematch
      _(view.pagy_uikit_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
  end
end
