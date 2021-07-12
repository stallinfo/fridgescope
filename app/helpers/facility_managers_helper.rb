module FacilityManagersHelper
    # Returns the Gravatar for the given user.
    def gravatar_for(facility_manager, size: 80)
        gravatar_id = Digest::MD5::hexdigest(facility_manager.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: facility_manager.name, class: "gravatar")
    end
end
