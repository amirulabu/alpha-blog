require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest

	def setup
		@user = User.create(username: "john", email: "john@example.com", password: "password", admin: true)
	end


	test "get new article form and create article" do 
		sign_in_as(@user, "password")
		get new_article_path
		assert_template 'articles/new'
		assert_difference 'Article.count', 1 do
			post_via_redirect articles_path, article: {title: "Title", description: "this is test blog article" }
		end
		assert_template 'articles/show'
		assert_match "Title", response.body
	end

	test "invalid article submission results in failure" do
		sign_in_as(@user, "password")
		get new_article_path
		assert_template 'articles/new'
		assert_no_difference 'Article.count' do
			post_via_redirect articles_path, article: {title: "T", description: "t" }
		end
		assert_template 'articles/new'
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end


end
