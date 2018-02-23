require "rails_helper"

RSpec.feature "Showing an article" do
  before do
    @john = User.create(email: "john@example.com", password: "password")
    @fred = User.create(email: "fred@example.com", password: "password")
    @article = Article.create(title: "The first article", body: "Lorem ipsum dolor sit amet, consectetur.", user: @john)
  end

  scenario "Hide edit and delete buttons from non-signed in user" do
    visit "/"
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "Hide edit and delete buttons from non-owner" do
    login_as(@fred)
    visit "/"
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "Show edit and delete buttons to owner" do
    login_as(@john)
    visit "/"
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))

    expect(page).to have_link("Edit Article")
    expect(page).to have_link("Delete Article")
  end
end
