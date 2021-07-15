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
alias Kalda.Accounts.ReferralLink
alias Kalda.Forums.Post
alias Kalda.Forums.Comment
alias Kalda.Forums.CommentReaction
alias Kalda.Forums.ReplyReaction
alias Kalda.Forums.Reply
alias Kalda.Forums.Report
alias Kalda.Events.TherapySession
alias Kalda.Waitlist.Signup

user =
  Kalda.Repo.insert!(%User{
    username: "KaldaSquid",
    email: "demo@kalda.co",
    password: "thisisademopassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisademopassword"),
    is_admin: true,
    confirmed_at: NaiveDateTime.local_now(),
    has_free_subscription: true
  })

user2 =
  Kalda.Repo.insert!(%User{
    username: "Puppy_queen",
    email: "user@kalda.co",
    password: "thisisatestpassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisatestpassword"),
    confirmed_at: NaiveDateTime.local_now(),
    has_free_subscription: false
  })

user3 =
  Kalda.Repo.insert!(%User{
    username: "Billy_Idol",
    email: "idol@kalda.co",
    password: "thisisatestpassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisatestpassword"),
    is_admin: false,
    confirmed_at: NaiveDateTime.local_now(),
    has_free_subscription: true
  })

user4 =
  Kalda.Repo.insert!(%User{
    username: "Janelle_M",
    email: "janem@kalda.co",
    password: "thisisatestpassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisatestpassword")
  })

user5 =
  Kalda.Repo.insert!(%User{
    username: "Elliot_P",
    email: "page@example.com",
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

_comment_reaction =
  Kalda.Repo.insert!(%CommentReaction{
    comment_id: comment.id,
    author_id: user2.id,
    relate: true
  })

_comment_reaction =
  Kalda.Repo.insert!(%CommentReaction{
    comment_id: comment.id,
    author_id: user3.id,
    send_love: true
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

_reply_reaction =
  Kalda.Repo.insert!(%ReplyReaction{
    reply_id: reply.id,
    author_id: user.id,
    send_love: true
  })

_reply_reaction =
  Kalda.Repo.insert!(%ReplyReaction{
    reply_id: reply.id,
    author_id: user2.id,
    relate: true
  })

_reply_reaction =
  Kalda.Repo.insert!(%ReplyReaction{
    reply_id: reply.id,
    author_id: user3.id,
    send_love: true
  })

_reply_reaction =
  Kalda.Repo.insert!(%ReplyReaction{
    reply_id: reply.id,
    author_id: user4.id,
    relate: true
  })

_reply_reaction =
  Kalda.Repo.insert!(%ReplyReaction{
    reply_id: reply.id,
    author_id: user5.id,
    send_love: true
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

_therapy_session_past =
  Kalda.Repo.insert!(%TherapySession{
    title: "Mindfulness",
    description: "How to get still and present and reduce anxiety",
    therapist: "Al Dee",
    credentials: "FreeMind hypnotherapist and mindfulness coach",
    starts_at: NaiveDateTime.new!(~D[2020-01-01], ~T[18:30:00]),
    link: "https://us02web.zoom.us/j/9367762569"
  })

_therapy_session_future =
  Kalda.Repo.insert!(%TherapySession{
    title: "Mindfulness",
    description: "How to get still and present and reduce anxiety",
    therapist: "Al Dee",
    credentials: "FreeMind hypnotherapist and mindfulness coach",
    starts_at: NaiveDateTime.new!(~D[2030-01-01], ~T[18:30:00]),
    link: "https://us02web.zoom.us/j/9367762569"
  })

_therapy_session_future =
  Kalda.Repo.insert!(%TherapySession{
    starts_at: NaiveDateTime.new!(~D[2022-02-01], ~T[18:30:00]),
    link: "https://us02web.zoom.us/j/9367762569"
  })

%{token: token, changeset: invite_changeset} = Invite.build_invite("invite@example.com")

_invite = Kalda.Repo.insert!(invite_changeset)

referral_link =
  Kalda.Repo.insert!(%ReferralLink{
    name: "squids123",
    owner_id: user.id,
    expires_at: ~N[2100-01-01 00:00:00]
  })

_userx =
  Kalda.Repo.insert!(%User{
    username: "KateBush",
    email: "wuthering@example.com",
    password: "thisisatestpassword",
    hashed_password: Bcrypt.hash_pwd_salt("thisisatestpassword"),
    referred_by: referral_link.id
  })

_signup1 =
  Kalda.Repo.insert!(%Signup{
    email: "al666@example.com"
  })

_signup2 =
  Kalda.Repo.insert!(%Signup{
    email: "al777@example.com"
  })

_subscription_event =
  Kalda.Repo.insert!(%Kalda.Payments.SubscriptionEvent{
    user_id: user.id,
    event: :subscription_created
  })

IO.puts("""
You can test the invite route with:
localhost:4000/invites/#{token}

You can test the referral_link route with:
localhost:4000/get/#{referral_link.name}


You can now log in as admin with these credentials:
email:    demo@kalda.co
password: thisisademopassword
""")
