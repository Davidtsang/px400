require 'test_helper'

class VisitTrackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "renew should be right behave" do

    # 1.new need tarck
    assert VisitTrack.effective_pv?("/","1.1.1.1", 1)

    # 2. vs track it
    assert_equal 1, VisitTrack.where(:visit_path => "/", :ip => "1.1.1.1", :user_id => 1).count

    # 3. repeat visit not track
    assert_not  VisitTrack.effective_pv?("/","1.1.1.1", 1)

    # 4.
    assert_equal 1, VisitTrack.where(:visit_path => "/", :ip => "1.1.1.1", :user_id => 1).count
    assert_equal 1, VisitTrack.count

    #just ip
    assert VisitTrack.effective_pv?("/","1.1.1.1")

    assert_equal 1, VisitTrack.where(:visit_path => "/", :ip => "1.1.1.1", user_id: nil ).count

    assert_equal 2, VisitTrack.count

    #ip visit again, no
    assert_not  VisitTrack.effective_pv?("/","1.1.1.1")

    assert_equal 1, VisitTrack.where(:visit_path => "/", :ip => "1.1.1.1", user_id: nil ).count

    # > 6.hours , should be effective pv
    #fake update time
    vs = VisitTrack.where(:visit_path => "/", :ip => "1.1.1.1", user_id: nil ).first
    vs.visit_time = Time.now - 7.hours
    vs.save

    assert VisitTrack.effective_pv?("/","1.1.1.1")
    assert_not  VisitTrack.effective_pv?("/","1.1.1.1")

    # test limit

  end

  test "MAX_RECORDS should be work will " do
    VisitTrack::MAX_RECORDS =4
    assert  VisitTrack.effective_pv?("/","1.1.1.1", 1)
    assert_equal 1, VisitTrack.all.count

    assert VisitTrack.effective_pv?("/","1.1.1.2", 1)
    assert_not  VisitTrack.effective_pv?("/","1.1.1.2", 1)

    assert VisitTrack.effective_pv?("/","1.1.1.3", 1)
    assert_not  VisitTrack.effective_pv?("/","1.1.1.3", 1)

    assert VisitTrack.effective_pv?("/","1.1.1.4")
    assert_not  VisitTrack.effective_pv?("/","1.1.1.4" )



    #fake update time
    vs = VisitTrack.where(:visit_path => "/", :ip => "1.1.1.1", user_id: 1 ).first
    vs.visit_time = Time.now - 7.hours
    vs.save
    assert  VisitTrack.effective_pv?("/","1.1.1.1", 1)

    assert_equal 4, VisitTrack.all.count
  end
end
