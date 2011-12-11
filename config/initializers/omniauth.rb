Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "3svARFoOWB2BK5m8Aiw5ug", "tb0skqupVv7mLeOFCioiBqwGUNEusM6Suzhc2IYt0" 
  provider :github, "17d564cb5975e018dd77", "e98387e2eb75b7a52f970d91e7e7f053220dc9e6"
end

