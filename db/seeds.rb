# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(first_name: 'Yubin', last_name: 'Kim', school: 'Yale University', class_year: '2019', major: 'Econ', email: 'yubiny16@gmail.com', encrypted_password: "123123")
User.create(first_name: 'YuJung', last_name: 'Seo', school: 'Yonsei University', class_year: '2018', major: 'Computer Science')
