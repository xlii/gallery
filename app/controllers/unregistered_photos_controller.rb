class UnregisteredPhotosController < ApplicationController
  def new    
    load_vars
  end

  def create
    unregistered_photo = params[:unregistered_photo]
        if unregistered_photo[:new_gallery] == "true"      
      if unregistered_photo[:event] == "Outros"
        title = unregistered_photo[:title]
      else
        title = "#{unregistered_photo[:event]}" 
        title += " de #{unregistered_photo[:member]}" unless unregistered_photo[:member].blank?
      end

      unless title.blank?
        date = "#{unregistered_photo['date(1i)']}-#{unregistered_photo['date(2i)']}-#{unregistered_photo['date(3i)']}".to_date

        galleries = Gallery.where(:title => title, :date => date).all
        
        if galleries.count == 0
          @gallery = Gallery.create :title => title, :date => date
        else
          @gallery = galleries.first
        end
      end
    else      
      @gallery = Gallery.find unregistered_photo[:gallery_id]
    end

    if @gallery.nil?
      flash[:notice] = "Um álbum precisa ser selecionado."
    else
      new_photo_file = get_image(unregistered_photo[:image])
      unless new_photo_file.nil?
        @photo = Photo.create :label => unregistered_photo[:label], :gallery => @gallery, :image => File.new(new_photo_file)
        File.delete(new_photo_file) unless @photo.image.url.blank?
      end      
      flash[:notice] = "Successfully created photo."
    end
    load_vars
    render :action => 'new'
  end

  def get_image(name=nil)
    if name.nil? 
      image = Dir.glob("public/system/unregistered_photos/*").first
      unless image.nil?
        image_array = image.split("/")
        image = image_array.last
      end
    else
      image = Dir.glob("public/system/unregistered_photos/#{name}").first
      puts 'image'+image.inspect
    end
    image
  end

  def load_vars
    @image = get_image()
    @events = %w(Aniversário Batizado Casamento Formatura Gravidez Nascimento Noivado Outros)
    @members = %w(Adriana Celso Junior Lucia Vânia)
  end
end
