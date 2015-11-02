class VisitTrack < ActiveRecord::Base
  MAX_RECORDS = 1000000


  def self.renew(visit_path ,ip,user_id )
    #count totle record
    if VisitTrack.count < MAX_RECORDS
      #CREATE NEW ONE
      VisitTrack.create(visit_path: visit_path, ip: ip, user_id: user_id, visit_time: Time.now)

    else
      #ELSE REWHRITE FISRT TIME RECORE
      old_vs = VisitTrack.order("updated_at").last

      old_vs.update(visit_path: visit_path, ip: ip, user_id: user_id, visit_count: 0, visit_time: Time.now)

    end


  end


end
