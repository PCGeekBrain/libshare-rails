class LibrariesController < ApplicationController
    before_action :load_library, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, :except => [:show, :index, :most_popular, :next]
    
    def index
        @libraries = Library.most_recent
        if params[:framework_id]
            @libraries = Framework.find(params[:framework_id]).libraries
            respond_to do |f|
                f.html {redirect_to libraries_path}
                f.json {render json: @libraries, each_serializer: LiLibrarySerializer}
            end
        end
    end

    def most_popular
        @libraries =  Library.most_popular
        @most_popular = true
        render(:index)
    end

    def show
        @comment = @library.reviews.build
    end

    def next
        @library = Library.find(params[:id])
        if @library.next.nil?
            return respond_to do |format|
                format.html {render :show}
                format.json {render json: {"error": "no next library was found"}}
            end
        else
            @library = @library.next
        end
        respond_to do |format|
            format.html {
                @comment = @library.reviews.build
                render :show
            }
            format.json
        end
    end

    def new
        @library = Library.new
        authorize @library
    end
    
    def edit
    end

    def create
        @library = Library.create(post_params)
        @library.valid? ? redirect_to(library_path(@library)) : render(:new)
    end
    
    def update
        @library.update(post_params)
        @library.valid? ? redirect_to(library_path(@library)) : render(:edit)
    end
    
    private
    def load_library
        @library = Library.find(params[:id])
        authorize @library
    end

    def post_params
        params.require(:library).permit(:name, :version, :description, :documentation_url, :library_url, :language_id, :framework_id, :reviews_attributes => [:rating, :comment])
    end
    
end
