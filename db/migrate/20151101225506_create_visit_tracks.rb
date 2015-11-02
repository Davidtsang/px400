class CreateVisitTracks < ActiveRecord::Migration



  def change
    create_table :visit_tracks do |t|
      t.string :visit_path
      t.datetime :visit_time
      t.string :ip
      t.integer :user_id
      t.integer :visit_count, default: 0

      t.timestamps null: false
    end
    add_index :visit_tracks, :visit_path
    add_index :visit_tracks, :ip

  end
end
