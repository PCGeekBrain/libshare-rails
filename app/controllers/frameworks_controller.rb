class FrameworksController < ApplicationController
    before_action :load_framework, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, :except => [:show, :index]

    def index
        @frameworks = Framework.most_recent
    end

    def show
    end

    def new
        @framework = Framework.new
    end
    
    def edit
    end

    def create
        @framework = Framework.new(post_params)
        @framework.save ? redirect_to(framework_path(@framework)) : render(:new)
    end
    
    def update
        @framework.update(post_params)
        @framework.valid? ? redirect_to(framework_path(@framework)) : render(:edit)
    end
    
    def destroy
        @framework.destroy
        redirect_to frameworks_path
    end
    

    private 
    def load_framework
        @framework = Framework.find(params[:id])
        authorize @framework
    end

    def post_params
        params.require(:framework).permit(:name, :description)
    end
    
end
