#encoding: utf-8

if User.count == 0
  User.create!(email: 'admin@sleede.com', password: 'kikoulol', password_confirmation: 'kikoulol')
end