class AddIsAllowNoticeMailToUsers < ActiveRecord::Migration
  def change

    add_column :users, :is_allow_notice_mail, :boolean, default: true

  end

end
