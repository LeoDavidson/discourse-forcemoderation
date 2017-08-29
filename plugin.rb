# name: discourse-forcemoderation
# about: Force posts from specified usernames to go through moderation.
# version: 0.2
# authors: Leo Davidson
# url: https://github.com/leodavidson/discourse-forcemoderation

enabled_site_setting :force_moderation_enabled

after_initialize do

  module ::DiscourseForceModeration
    def post_needs_approval?(manager)
      superResult = super
      return superResult if ((!(SiteSetting.force_moderation_enabled)) || superResult)

      if SiteSetting.force_moderation_users.is_a? String
        userName = manager.user.username.downcase
        userArray = SiteSetting.force_moderation_users.downcase.split("|")
        return true if (userArray.include? userName)
      end

      return false
    end
  end

  NewPostManager.singleton_class.prepend ::DiscourseForceModeration

end
