ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Asapp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Asapp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Asapp.Repo)

