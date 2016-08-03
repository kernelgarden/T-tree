# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
	# user 생성 

 	User.create(email:"win1ter@naver.com", password:"ilovee")

 	# 해당하는 유저의 work 생성 
 	User.first.works.create(name:"work1")

 	# 해당하는 work의 branch 생성 

 	99.times do |n|
 		name="branch"+(n+1).to_s
 		Work.first.branches.create(name: name)
	end

	98.times do |n|
		currentbranch=Branch.find_by(id:(n+1))
		nextbranch=Branch.find_by(id:(n+2))
 		currentbranch.connect(nextbranch)
	end

 	#Branch.first.connect(Branch.second)
 	#Branch.first.connect(Branch.third)

 	#Branch.second.connect(Branch.fourth)
 	#Branch.second.connect(Branch.fifth)


 	Branch.first.pages.create(name:"page1")
 	Branch.first.pages.create(name:"page2")

 	Branch.second.pages.create(name:"page3")
 	Branch.second.pages.create(name:"page4")

 	Branch.third.pages.create(name:"page5")
 	Branch.third.pages.create(name:"page6")

 	Branch.fourth.pages.create(name:"page7")
 	Branch.fourth.pages.create(name:"page8")