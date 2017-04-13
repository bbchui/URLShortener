puts "Please enter your email."

prompt = gets.chomp

user = User.find_by(email: prompt)

puts "Enter new url or select old url (enter/select)"

prompt2 = gets.chomp

if prompt2 == 'select'
  puts "Available options: "
  link_list = user.submitted_urls
  link_list.each_with_index {|url, i| puts "#{i} #{url.short_url}"}

  puts "Choose link # to access:"
  prompt4 = gets.chomp.to_i

  Launchy.open( link_list[prompt4].long_url )

elsif prompt2 == 'enter'
  puts "Enter url to be shortened"
  prompt3 = gets.chomp
  user.generate_short_url(prompt3)
  puts ShortenedUrl.last.short_url
end
