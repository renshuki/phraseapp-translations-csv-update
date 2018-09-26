# Require the gem
require 'phraseapp-ruby'
require 'csv'
require './config.rb'

# Setup Authentication Credentials and Client
credentials = PhraseApp::Auth::Credentials.new(token: PhraseAppConfig::PHRASEAPP_TOKEN)
client = PhraseApp::Client.new(credentials)

CSV.foreach(PhraseAppConfig::CSV_FILE_PATH) do |key, value|
  rsp, err = client.keys_list(PhraseAppConfig::PROJECT_ID, 1, 1, PhraseApp::RequestParams::KeysListParams.new(q: "name:#{key}"))
  rsp_key = rsp.first
  
  translations, err = client.translations_by_key(PhraseAppConfig::PROJECT_ID, rsp_key.id, page=1, per_page=100, PhraseApp::RequestParams::TranslationsByKeyParams.new)
  
 	translations.each do |translation|
 		if translation['locale']['id'] == PhraseAppConfig::LOCALE_ID
 			rsp, err = client.translation_update(PhraseAppConfig::PROJECT_ID, translation.id, PhraseApp::RequestParams::TranslationUpdateParams.new(content: value))
		  if err
		    raise err.inspect
		  else
		  	puts "Translation #{value} updated!"
		  end
 		end
 	end
end
