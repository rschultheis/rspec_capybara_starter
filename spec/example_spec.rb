describe "searching Google.com" do

  before(:each) do
    visit('/')
  end

  #this test should pass
  it "should allow me to search for 'green cheese'", tag('Smoke') do
    fill_in('q', with: 'green cheese')
    page.should have_content('Green cheese is a term for a fresh cheese, one that has not thoroughly dried yet, nor been aged, which is white in colour and usually round in shape')
  end

  #this test should fail
  it "should show 'five stars' if I put five astericks into search box", tag('XFail') do
    fill_in('q', with: '*****')
    page.should have_content('five stars')
  end

end
