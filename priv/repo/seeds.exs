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
alias Kalda.Accounts.Invite
alias Kalda.Forums.Post
alias Kalda.Forums.Comment
alias Kalda.Forums.Reply
alias Kalda.Forums.Report
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

user2 =
  Kalda.Repo.insert!(%User{
    username: "Puppy_queen",
    email: "user@example.com",
    password: "thisisatestpassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisatestpassword")
  })

user3 =
  Kalda.Repo.insert!(%User{
    username: "Billy_Idol",
    email: "idol@example.com",
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

post3 =
  Kalda.Repo.insert!(%Post{
    forum: :will_pool,
    content: "Will Pool! What do you need to get done today?",
    author_id: user.id
  })

post4 =
  Kalda.Repo.insert!(%Post{
    forum: :community,
    content: "I'm starting an exercising thread, post your workouts below.",
    author_id: user2.id
  })

post5 =
  Kalda.Repo.insert!(%Post{
    forum: :co_working,
    content: "WFH co-working session here today from 1pm",
    author_id: user2.id
  })

_post6 =
  Kalda.Repo.insert!(%Post{
    content: "Future scheduled daily reflection",
    author_id: user2.id,
    published_at: NaiveDateTime.new!(~D[2030-01-13], ~T[23:00:07])
  })

comment =
  Kalda.Repo.insert!(%Comment{
    content: "I feel quite powerful",
    author_id: user.id,
    post_id: post.id
  })

_comment =
  Kalda.Repo.insert!(%Comment{
    content: "I really need to go to the Post Office",
    author_id: user.id,
    post_id: post3.id
  })

_comment =
  Kalda.Repo.insert!(%Comment{
    content: "I danced around my room to The Clash, London Calling for 40 minutes today",
    author_id: user3.id,
    post_id: post4.id
  })

_comment =
  Kalda.Repo.insert!(%Comment{
    content: "I'm going to join co-working but not until 2pm",
    author_id: user3.id,
    post_id: post5.id
  })

_comment2 =
  Kalda.Repo.insert!(%Comment{
    content: "I'm proud of my seeds",
    author_id: user.id,
    post_id: post.id
  })

reply =
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

_report =
  Kalda.Repo.insert!(%Report{
    reported_content: reply.content,
    reporter_reason: "My name is not fred anymore",
    reporter_id: user2.id,
    author_id: user.id,
    reply_id: reply.id
  })

_report22 =
  Kalda.Repo.insert!(%Report{
    reported_content: comment.content,
    reporter_reason: "Powerful is a scary word",
    reporter_id: user2.id,
    author_id: user.id,
    comment_id: comment.id
  })

{token, invite} = Invite.build_invite("invite@example.com")

_invite =
  Kalda.Repo.insert!(%Invite{
    invitee_email: invite.invitee_email,
    token: invite.token
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
You can test the invite route with:
localhost:4000/invites/#{token}

You can now log in as admin with these credentials:
email:    demo@kalda.co
password: thisisademopassword
""")
