module ApplicationHelper

    #Returns the full title on a per-page basis.
    def full_title(page_title = '')
        base_title = "Fridge scope"
        if page_title.empty?
            base_title 
        else
            base_title + " | " + base_title
        end
    end

end
