# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kalda.Repo.insert!(%Kalda.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Kalda.Accounts.User
alias Kalda.Forums.Post
alias Kalda.Forums.Comment
alias Kalda.Forums.Reply
alias Kalda.Waitlist.Signup

user =
  Kalda.Repo.insert!(%User{
    is_admin: true,
    username: "KaldaSquid",
    email: "demo@kalda.co",
    password: "thisisademopassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisademopassword"),
    confirmed_at: NaiveDateTime.local_now()
  })

_user2 =
  Kalda.Repo.insert!(%User{
    username: "Puppy_queen",
    email: "user@example.com",
    password: "thisisatestpassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisatestpassword")
  })

post =
  Kalda.Repo.insert!(%Post{
    content: "This is your very first Daily Reflection - does it feel powerful?",
    author_id: user.id
  })

_post2 =
  Kalda.Repo.insert!(%Post{
    content: "What have you done today to make you feel proud?",
    author_id: user.id
  })

comment =
  Kalda.Repo.insert!(%Comment{
    content: "I feel quite powerful",
    author_id: user.id,
    post_id: post.id
  })

_comment2 =
  Kalda.Repo.insert!(%Comment{
    content: "I'm proud of my seeds",
    author_id: user.id,
    post_id: post.id
  })

_reply =
  Kalda.Repo.insert!(%Reply{
    content: "I feel quite powerful today too, Fred",
    author_id: user.id,
    comment_id: comment.id
  })

_reply1 =
  Kalda.Repo.insert!(%Reply{
    content: "I do not feel powerful I feel a bit B minus",
    author_id: user.id,
    comment_id: comment.id
  })

_signup1 =
  Kalda.Repo.insert!(%Signup{
    email: "al666@example.com"
  })

_signup2 =
  Kalda.Repo.insert!(%Signup{
    email: "al777@example.com"
  })

IO.puts("""
You can now log in with these credentials:
email:    demo@kalda.co
password: thisisademopassword
""")
