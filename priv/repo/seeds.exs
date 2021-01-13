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

_user =
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

IO.puts("""
You can now log in with these credentials:
email:    demo@kalda.co
password: thisisademopassword
""")
