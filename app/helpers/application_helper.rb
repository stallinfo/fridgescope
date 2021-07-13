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

    def density_calculation(imageFile)
        empty_model = ENV['EMPTY_STRING']
        full_model = ENV['FULL_STRING']
        auth = 'Basic ' + Base64.strict_encode64( "#{empty_model}:#{full_model}" ).chomp
        response = RestClient.post ENV['IEEE_DOC_7474063'], { :image => File.new(imageFile, 'rb') }, { :Authorization => auth }
        density = 0
        response = JSON.parse(response)
        response["result"]["tags"].each do |item|
            if item["tag"]["en"] == "food"
                density += item["confidence"]
            end
            if item["tag"]["en"] == "fruit"
                density += item["confidence"]
            end
            if item["tag"]["en"] == "vegetable"
                density += item["confidence"]
            end
        end
        if density > 100
            return 100
        else
            return density
        end
    end

end
