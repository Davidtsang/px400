class VisitTrack < ActiveRecord::Base
  MAX_RECORDS = 1000000

  TIME_GAP = 6.hours

  def self.effective_pv?(visit_path, ip, user_id = nil)

    is_effective_pv = false

    # if user_id
    #   #name user visit
    #   is_effective_pv = self.path_need_track?(visit_path,ip, user_id)
    # else
    #   #noname guset visit
    #   is_effective_pv =  self.path_ip_need_track?(visit_path, ip)
    #
    # end

    if self.path_need_track?(visit_path, ip, user_id)

      is_effective_pv = true

      VisitTrack.track(visit_path, ip, user_id)
    end

    is_effective_pv

  end

  def self.track(visit_path, ip, user_id)
    #find old teack
    ot = VisitTrack.where(visit_path: visit_path,ip: ip, user_id: user_id).order("visit_time DESC").limit(1)

    if ot.any?
      #update track
      ot = ot.first
      ot.visit_time = Time.now
      ot.save

    else
      #count totle record
      if VisitTrack.count < MAX_RECORDS
        #CREATE NEW ONE
        puts "new ip count!"
        VisitTrack.create(visit_path: visit_path, ip: ip, user_id: user_id, visit_time: Time.now)

      else
        #ELSE REWHRITE FISRT TIME RECORE
        old_vs = VisitTrack.order("updated_at").last

        old_vs.update(visit_path: visit_path, ip: ip, user_id: user_id, visit_time: Time.now)

      end
    end


  end


  private

  def self.path_need_track?(pathname, ip, user_id)
    vs = VisitTrack.where(visit_path: pathname, ip: ip, user_id: user_id).first
    is_can_add_count = false
    if vs #yes, check data if > 6 h , is new visit
      if vs.visit_time < (Time.now - TIME_GAP)
        is_can_add_count = true
      end
    else # if no record?
      is_can_add_count = true
    end

    is_can_add_count

  end
  #
  # def self.path_user_need_track?(pathname, user_id)
  #   is_can_add_count = false
  #   #2user visit this page?
  #   vs = VisitTrack.where(visit_path: pathname, user_id: user_id).first
  #
  #
  #   if vs #yes, check data if > 6 h , is new visit
  #     if vs.visit_time < (Time.now - TIME_GAP)
  #       is_can_add_count = true
  #     end
  #   else # if no record?
  #     is_can_add_count = true
  #   end
  #
  #   is_can_add_count
  # end

end
