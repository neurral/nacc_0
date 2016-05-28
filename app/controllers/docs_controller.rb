class DocsController < ApplicationController

def get_file
    path = Dir[Rails.root.join("doc", params[:file_or_folder])]
    if path.length > 0
        # check if root directory
        path_str = path[0]
        if path_str =~ /\/docs\/?\z/
            path_str += "/index.html"
        end
        render :file => path_str
    else
        render :text => "File Not Found"
    end

end

end
