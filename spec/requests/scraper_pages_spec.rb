require 'spec_helper'

describe "ScraperPages" do
  subject { page }
  
  describe "test page" do
    before { visit test_path }
    
    it { should have_content('Scraper Test') }
    it { should have_title(full_title('Scraper Test')) }
  end
end
