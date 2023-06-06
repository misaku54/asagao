class ChangeMenbersToMembers < ActiveRecord::Migration[5.2]
  def change
    rename_table :menbers,:members
  end
end
