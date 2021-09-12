User.create(name:"test1",
    password:"password",
    password_confirmation:"password")
User.create(name:"test2",
    password:"password",
    password_confirmation:"password")
Relationship.create(
    followed_id: 1,
    following_id: 2)