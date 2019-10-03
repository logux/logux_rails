# frozen_string_literal: true

module Actions
  class Post < Logux::ActionController
    def rename
      post = FactoryBot.create(:post)
      post.update(title: 'new title')
      respond :processed
    end

    def touch
      post = FactoryBot.create(:post)
      post.update(updated_at: Time.now)
      respond :processed
    end
  end
end
