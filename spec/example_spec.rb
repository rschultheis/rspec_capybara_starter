describe 'searching Google.com' do
  before(:each) do
    visit('/')
  end

  # this test should pass
  it "should allow me to search for 'green cheese'", tag('Smoke') do
    fill_in('q', with: "green cheese")
    send_keys Selenium::WebDriver::Keys[:return]
    expect(page).to have_content('Green cheese is a fresh cheese')
  end

  # this test should fail
  it "should show 'five stars' if I put five astericks into search box", tag('XFail') do
    fill_in('q', with: '*****')
    expect(page).to have_content('five stars')
  end
end
