# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Listapp.Repo.insert!(%Listapp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
Listapp.Accounts.create_user(%{
  username: "dean", 
  name: "Dean", 
  credential: %{
    password: "starwars", 
    email: "deza604@gmail.com"
  }
})
