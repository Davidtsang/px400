class Attachment < ActiveRecord::Base
  belongs_to :work

  has_attached_file :media, :styles => {:thumb => ["100x75>", :png] }

  validates_attachment :media,
                       :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png","application/postscript","application/zip","application/pdf","image/vnd.adobe.photoshop"] },size: { in: 0..5000.kilobytes }

  before_post_process :skip_unimage_file

  validates :media, presence: true

  validates_associated :work, :message => "该作品附件数量已经达到上限！"
  private

  def skip_unimage_file
    !(media.content_type =~ /^image.*/).nil?
    #! %w(application/zip application/x-zip application/pdf application/postscript).include?()
  end

end
