class CreateContracts < ActiveRecord::Migration[7.1]
  def change
    create_table :contracts do |t|
      t.string :status
      t.jsonb :analysis

      t.timestamps
    end
  end
end
