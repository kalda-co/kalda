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
alias Kalda.Waitlist.Signup

user =
  Kalda.Repo.insert!(%User{
    email: "demo@kalda.co",
    password: "thisisademopassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisademopassword")
  })

_user2 =
  Kalda.Repo.insert!(%User{
    email: "user@example.com",
    password: "thisisatestpassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisatestpassword")
  })

_post =
  Kalda.Repo.insert!(%Post{
    content: "This is your very first Daily Reflection - does it feel powerful?",
    author_id: user.id
  })

_post2 =
  Kalda.Repo.insert!(%Post{
    content: "What have you done today to make you feel proud?",
    author_id: user.id
  })

_comment =
  Kalda.Repo.insert!(%Comment{
    content: "This is your very first Daily Reflection - does it feel powerful?",
    author_id: user.id
  })

_comment2 =
  Kalda.Repo.insert!(%Comment{
    content: "What have you done today to make you feel proud?",
    author_id: user.id
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
