# frozen_string_literal: true

class UpdatePostBodyIndex < ActiveRecord::Migration[7.1]
  def up
    # The "pg_trgm" module provides functions and operators for determining the similarity of
    # ASCII alphanumeric text based on trigram matching, as well as index operator classes that
    # support fast searching for similar strings.
    enable_extension("pg_trgm")

    remove_index :posts, :body, if_exists: true

    # GIN (Generalized Inverted Index) indexes are the perfect choice for "composite values"
    # where you perform a query that looks for an element within such "composite" columns like
    # 'jsonb', 'array' or 'hstore' data structures and full-text search documents.
    add_index :posts, :body, using: :gin, opclass: :gin_trgm_ops
  end

  def down
    remove_index :posts, :body
    disable_extension("pg_trgm")
  end
end
