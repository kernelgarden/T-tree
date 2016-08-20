# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
	# user 생성 

 	User.create(email:"win1ter@naver.com", password:"ilovee")
 	#Team.create(name:"Team1")

 	User.first.join(Team.first)

 	# 해당하는 유저의 work 생성 
 	User.first.works.create(name:"work1")

 	# 해당하는 work의 branch 생성 

 	Work.first.branches.create(name: "branch1")

	9.times do |n|
		currentbranch=Branch.find_by(id:(n+1))
		name="branch"+(n+2).to_s
 		currentbranch.children.create(name: name, work_id:currentbranch.work_id)
	end

	20.times do |n|
 		title="page"+(n+1).to_s
 		currentbranch=Branch.find_by(id:(n/2+1))
 		currentbranch.pages.create(title: title)
	end

 	#Branch.first.connect(Branch.second)
 	#Branch.first.connect(Branch.third)

 	#Branch.second.connect(Branch.fourth)
 	#Branch.second.connect(Branch.fifth)
