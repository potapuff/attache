module ItemsHelper

  MIME_TYPES_ICON ={'image'=>'file-image-o','text'=>'file-text-o','application'=>'file-o'}

  def icon_by_mime(mime)
    raw = mime.raw_media_type
    ico = MIME_TYPES_ICON[raw]|| MIME_TYPES_ICON['application']
    fa_icon ico
  end

end
