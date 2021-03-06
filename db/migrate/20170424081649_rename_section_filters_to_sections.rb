class RenameSectionFiltersToSections < ActiveRecord::Migration[4.2]
  def change
    rename_table :section_filters, :sections
    rename_table :categories_section_filters, :categories_sections
    rename_column :categories_sections, :section_filter_id, :section_id
    rename_column :divisions, :section_filter_id, :section_id
    rename_column :filters, :section_filter_id, :section_id
    rename_column :offers, :section_filter_id, :section_id

    add_index :categories_sections, :category_id
    add_index :categories_sections, :section_id
    add_index :divisions, :section_id
    add_index :offers, :section_id
  end
end
