class CreateVerticesVerticesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :vertex_edges, id: false, created_at: false, updated_at: false do |t|
      t.bigint :from_vertex_id, null: false
      t.bigint :to_vertex_id, null: false
    end
  end
end
